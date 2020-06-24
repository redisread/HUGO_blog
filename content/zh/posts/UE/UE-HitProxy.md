---
title: "UE4游戏模式使用HitProxy"
date: 2020-06-15T21:20:11+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/06/15/ivEDkwYhIQ5xVn7.png
libraries:
- katex
- mathjax
tags:
- C++
- UE4
- Game
series:
- Game
categories:
-
---









在UE4游戏模式使用HitProxy。

<!--more-->





![intro](https://i.loli.net/2020/06/15/FNnV1gW3hOykSZr.jpg)

在UE4编辑器中，点击屏幕某处，如果光标在可拾取对象上，即可高亮选中目标。

调用堆栈：

![调用hit堆栈](https://i.loli.net/2020/06/15/4KjSlXNkEDFQTZu.png)

调用过程：GetCursor -> GetHitProxy -> GetHitProxyMap -> GetRawHitProxyData -> **Draw**

## UE4的拾取流程

基于物理射线检查的方法，需要遍历面片一个个去检验，反过来将，我们可以在渲染的贴图中，添加专门给光标拾取用的信息（UE4命名为HHitProxyId），**只要知道光标在贴图上的坐标，即可获得HHitProxyId，在渲染期间，HHitProxyId和渲染对象已经建立起了映射，映射获得HHitProxyId即可知道当前光标的指向对象了**。其流程如下：

![流程](https://i.loli.net/2020/06/15/vkiqSIlowEdcyXC.png)

在UE4中，需要渲染的可点击对象(即图中的Render Object)，会生成一个HitProxy数据，HHitProxy是一个基类，具体派生实现和不同类型有关（比如普通模型、编辑器中的旋转移动轴等）。**HHitProxy对象包含一个INT32类型的唯一识别码HHitProxyId**，渲染时，UE4会将HHitProxyId转化成颜色信息写入到一张贴图中，因为贴图无法直接访问，需要缓存一份至内存（HitProxyMap），**HitProxyMap中即保存了一份宽高和屏幕像素大小相同的数组**。当光标移动时，访问HitProxyMap即可得到对应的HitProxyID（索引值为屏幕X,Y坐标），再以HitProxyID为Key即可获取HitProxy数据。

## Hit Proxy的生成

> UE4下是通过在渲染每个网格对象的时候生成一个HitProxy的类，这个类里反向记录当前的Component对象等信息。然后将该HitProxy存入到数组中，根据数组索引生成唯一的索引ID。然后UE4根据条件来触发通过渲染Canvas，将所所有的网格对象的HitProxy的Id渲染到屏幕大小的贴图中。后续Cursor查询P(x，y)的时候在贴图上取出像素转换成HitProxy的Id，读取对应的信息。

每个ActorComponent的基类中都有一个FPrimitiveSceneProxy类来记录一些渲染信息，以及HitProxy信息。在Coponent的创建过程中会为每个Component生成一个动态的HitProxy，并加入到全局的Array中。

路径 ：`Engine\Source\Runtime\Renderer\Private\PrimitiveSceneInfo.cpp`

`FPrimitiveSceneInfo`的构造函数中

```c++
// Only create hit proxies in the Editor as that's where they are used.
	if (GIsEditor)
	{
		// Create a dynamic hit proxy for the primitive. 
        // 创建每一个对象的HitProxy
		DefaultDynamicHitProxy = Proxy->CreateHitProxies(InComponent,HitProxies);
		if( DefaultDynamicHitProxy )
		{
			DefaultDynamicHitProxyId = DefaultDynamicHitProxy->Id;
		}
	}
```

上面的代码只要打开编辑器模式就会自动生成`HitProxy`

## Hit Proxy的查询

Cursor Query触发时，首先会调用

```c++
HHitProxy* FViewport ::GetHitProxy (int32 X ,int32 Y )；
```

实际上UE4并没有只使用X，Y坐标，实际用户在编辑器中操作时，点击未必是像素级精准的，UE4的对应方案是，获取屏幕点击坐标P(x,y),以FViewport::HitProxySize为半边长（比如取长度为5），生成一个以P为中心的正方形区域R，经过和视口区域的校正，截除无效区域后（矩形可能包含超出屏幕范围的区域），生成一个查询用矩形区域（FIntRect类型），作为GetRawHitProxyData的传入参数。

![HitProxy查询](https://i.loli.net/2020/06/15/i6eO87bgJMYuU1h.png)

因为缓存数据未必每帧都需要更新，当光标查询，最终调用函数

```C++
const TArray<FColor>& FViewport::GetRawHitProxyData(FIntRect InRect)；
```

此时检查HitProxyMap是否需要已就绪，绘制完成后，会把数据回读至内存中：

```c++
......
//Resolve surface to texture.
ENQUEUE_UNIQUE_RENDER_COMMAND_ONEPARAMETER(
UpdateHitProxyRTCommand,
FHitProxyMap*, HitProxyMap, &HitProxyMap,
{
     // Copy (resolve) the rendered thumbnail from the render target to its texture
     RHICmdList.CopyToResolveTarget(HitProxyMap->GetRenderTargetTexture(), HitProxyMap->GetHitProxyTexture(), false, FResolveParams());
     RHICmdList.CopyToResolveTarget(HitProxyMap->GetRenderTargetTexture(), HitProxyMap->GetHitProxyCPUTexture(), false, FResolveParams());
});
 
.....
```

至此，查询数据已准备就绪。

## Hit Proxy数据获取

整个拾取流程中，最重要的数据结构就是HitProxy。UE4中实现的该类名为HHitProxy，HHitProxyId其实是内存中分配的地址，以此保证了id的唯一性。另一方面，INT32长度刚好和RGBA8888长度是一致，UE4渲染时，以FColor方式读取HHitProxyId，查看代码可以发现，高8位不需要纳入考虑：

```c++
FColor FHitProxyId::GetColor() const
{ // 根据HitProxy获取ID
   return FColor(
   ((Index >> 16) & 0xff),
   ((Index >> 8) & 0xff),
   ((Index >> 0) & 0xff),
   0);
}
```

如之前所说，HitProxyMap保存的HHitProxyID，这只是一个Key，那从HitProxy数据保存在哪里呢？

答案是保存在全局静态类型FHitProxyArray中，只是UE4为保持HitProxyId类的封装，该全局类是通过友元函数来访问的：

```c++
friend ENGINE_API class HHitProxy* GetHitProxyById(FHitProxyId Id);
```

如之前所说，FHitProxyArray其实是FHitProxyId（本质是内存地址）作为Key，HHitProxy作为Value，HHitProxy构造时，会像FHitProxyArray注册自身信息：

```c++
void HHitProxy::InitHitProxy()
{
    // Allocate an entry in the global hit proxy array for this hit proxy, and use the index as the hit proxy's ID.
    Id = FHitProxyId(FHitProxyArray::Get().Add(this));
}
```

这里的ID也不是HHitProxy指针本身的地址，而是 FHitProxyArray内部储存指针副本后的地址，以此避免了多个HHitProxy共用的问题。





## UE编辑器下模拟使用HitProxy

### 需要从 UGameViewportClient 类继承

修改返回值为`true`,路径：`\Source\Runtime\Engine\Private\GameViewportClient.h`

```c++
virtual bool RequiresHitProxyStorage() override { return true; }
```

### 在FViewportClient类中新建DrawHitProxy函数

文件`UnrealClient.h`

![DrawHitProxy](https://i.loli.net/2020/06/22/KRtGXzvkAian4me.png)

### 在GameViewportClient类中声明并且实现

声明：`\Source\Runtime\Engine\Private\GameViewportClient.h`

![声明](https://i.loli.net/2020/06/22/3D84rt6TeIjWx1F.png)

将`GameViewportClient`类中的函数`Draw()`内容复制到该函数`DrawHitProxy`，修改下面的的地方：

![修改](https://i.loli.net/2020/06/22/qi93OJSarCGkyhI.png)



### 修改FViewport类中的GetRawHitProxyData函数

在`GetRawHitProxyData`函数中进行以下的修改：`Engine\Source\Runtime\Engine\Private\UnrealClient.cpp`

![修改](https://i.loli.net/2020/06/24/d5QIToUrGFPYv6g.png)



## 调用--获取屏幕坐标Hitproxy

![use](https://i.loli.net/2020/06/22/QzmroPdVKHn35i1.png)





## 相关类型

**HHitProxy**：用于检测用户界面命中的基类

**FHitProxyMap**：从2D坐标到缓存命中代理的地图。

---

参考：

1. [How to select an actor in-game using GetHitProxy?](https://forums.unrealengine.com/development-discussion/c-gameplay-programming/37946-how-to-select-an-actor-in-game-using-gethitproxy)
2. [UE4 编辑器的光标拾取](http://www.acros.me/c/unreal-engine-4-%e7%bc%96%e8%be%91%e5%99%a8%e7%9a%84%e5%85%89%e6%a0%87%e6%8b%be%e5%8f%96%ef%bc%88cursor-query%ef%bc%89%e5%8a%9f%e8%83%bd%e5%b0%8f%e8%ae%b0/)
3. [编辑器Viewport窗口中的鼠标拾取原理](https://arenas0.com/2019/04/20/UE4_Learn_HitProxy/)
4. [场景基本对象](https://blog.csdn.net/jiangdengc/article/details/59486288)
5. [渲染总流程](https://blue2rgb.sydneyzh.com/ue4-deferred-shading-pipeline.html)
6. https://docs.unrealengine.com/zh-CN/Programming/Rendering/MeshDrawingPipeline/index.html
7. [Unreal Mesh Drawing源码分析](https://papalqi.cn/index.php/2019/11/10/unreal-mesh-drawing%E6%BA%90%E7%A0%81%E5%88%86%E6%9E%90/)
8. [白袍笑道](https://www.cnblogs.com/BaiPao-XD/p/9863580.html)

---


