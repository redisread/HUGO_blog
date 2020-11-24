---
title: "UE编辑器下模拟使用HitProxy"
date: 2020-06-15T9:43:11+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: inner
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



### 需要从 UGameViewportClient 类继承

修改返回值为`true`,路径：`\Source\Runtime\Engine\Private\GameViewportClient.h`

```cpp
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


