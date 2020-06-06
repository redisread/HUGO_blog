---
title: "UE4渲染过程"
date: 2020-05-29T9:42:11+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/05/29/yO1bzGwBSflsVYj.png
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











# 渲染相关类

[如何在C ++中从UTexture2D读取数据](https://stackoverflow.com/questions/37578939/how-to-read-data-from-a-utexture2d-in-c)

https://forums.unrealengine.com/development-discussion/c-gameplay-programming/1422920-casting-converting-frhitexture-to-utexture

[Unreal渲染相关的缓冲区](https://my.oschina.net/u/4362845/blog/3636853)

## Texture2D



## UTexture2D

复合纹理,可以根据法线贴图变化(主要是来自 mip 贴图)来定义修改粗糙度。

## FTexture2D

Windows. MacOS. Linux. 继承层次结构

## FRHITexture2D

# UE4渲染过程

### 延迟渲染

所谓延迟渲染，是指将一个场景的几何体（3D模型、多边形）的光照、阴影、质感搁置到一旁，先着手于绘画，然后在后半段再对光照、阴影、质感进行处理的处理方式。即给人一种把原本的多边形先绘制出来的印象，实际上不仅要绘制多边形，前者的参数还需要配合后面光照和阴影的处理。其输出目标，在成为复数缓冲时具有普遍性，但是这里的缓冲我们称之为"物理缓冲"。物体缓冲是指使用后照明和后处理特效的中间过渡环节



## Z Pre Pass

UE4的渲染管道，是在Bass Pass的物体缓冲写出来之前，在仅预处理深度值（Z值）之后，运行Z预阶段。

事先预处理深度值的目的，是将最终影像和同一深度缓冲的内容结果，在透视前获得。Z预阶段之后的Base Pass则是，参考预先得出的深度值缓冲进行Z预测试，因此通过在最终的画面里不留下像素痕迹（即编写后又被消去的像素），以回避像素着色器的运行。

## Base Pass

使用Base Pass输出物体缓冲需要注意的两点：

1. 不绘制没进入视线的对象

   这种"投影剔除"（Frustum Culling），一般是通过CPU端来处理；为了整体覆盖被称为"包围球"（Bounding sphere）的各个3D对象，对象是否在视野内的判定标准，是通过预先设定的包围球来实行的。

   > 什么程度的剔除会成功，可以通过Stat初始视图（Stat InitViews）指令的"视锥体裁剪基元（Frustum Culled Primitives）"进行确认。

2. 不计算多余的像素

   在图像处理的流程中，使用像素着色器实际处理前，会有运行深度测试（Z 测试）的"Pre Z 测试"这一步骤。从这里着手处理的像素，会因为被某个东西所遮挡而无法绘制出来，这时可以进行撤销处理。

   > 但是，像半透明对象这种会伴随α测试的绘制、视差遮蔽映射这种像素着色器处理后会重新编写深度值的情况，就不进行Pre Z测试，而通过处理实行分路迂回。

## UE4 绘制策略DrawingPolicy

绘制策略在UE4渲染中使用很多， 中文也不好翻译。 其实就是根据策略 使用了哪些 着色器 。



## Render模块

调用Render()函数在Render模块`RendererModule.h`中，以下函数：

```c++
class FRendererModule : public IRendererModule
{
    // 开始渲染视图族
    virtual void BeginRenderingViewFamily(FCanvas* Canvas,FSceneViewFamily* ViewFamily) override;
}
```



==谁最终调用了Render？==

![调用Render](https://i.loli.net/2020/06/02/FyKugnqzODMvslW.png)



https://answers.unrealengine.com/questions/17862/access-color-and-depth-buffer-of-each-frame.html

https://segmentfault.com/a/1190000012737548







<img src="https://i.loli.net/2020/05/30/P6KEDtS1HkOg9fF.jpg" alt="preview" style="zoom: 200%;" />

## 相关术语

**RHI**

渲染硬件接口，是为不同平台抽象出不同图形API的一层。所有渲染命令均通过RHI层传递，以转换为适用的渲染器。

**延迟渲染**

虚幻引擎4中的默认渲染器。它因将照明/阴影计算推迟到全屏过程而不是绘制每个网格时而得名。

**顶点工厂**

顶点工厂是封装顶点数据源并链接到顶点着色器上的输入的类。静态网格物体，骨架网格物体和过程网格组件均使用不同的顶点工厂。

**着色器**

在虚幻引擎中，着色器是HLSL代码（以.ush / .usf文件的形式）和材质图的内容的组合。在Unreal中创建材质时，它会根据设置（如着色模式）和用法来编译多个着色器排列。



## 实时渲染流程：

![1](https://i.loli.net/2020/05/30/qU8vN2WZVbt9hkF.jpg)

2

![2](https://i.loli.net/2020/05/30/3trKVpOMU5sTQfB.jpg)

[Gbuff数据](https://zhuanlan.zhihu.com/p/36840778)：

![img](https://i.loli.net/2020/05/30/LFU1RtqDN5gvdSm.jpg)





## 渲染流程：

首先，虚幻的渲染由三个线程共同完成。分别是CPU线程，DRAW线程，和GPU线程。

知乎：https://zhuanlan.zhihu.com/p/57158725

![渲染流水线](https://i.loli.net/2020/05/30/YZuyDGO7c3mRXfd.jpg)

**遮挡处理**

遮挡处理部分主要运行在Draw线程，前面说过，它决定了哪些对象最终会参与渲染。

虚幻主要有4种遮挡处理方案。分别是距离剔除，视锥剔除，预计算可见性和遮挡剔除。这四种剔除方案要按照性能消耗从小到大的顺序执行，这四种剔除方案要按照性能消耗从小到大的顺序执行。

原图：

![SceneView.png](https://i.loli.net/2020/05/30/1WhCoPUJBHsqMOG.jpg)

剔除：

![场景视图](https://i.loli.net/2020/05/30/soT4dgIb5eqhkCr.jpg)

视锥体剔除：

![ViewFrustumDiagram.png](https://i.loli.net/2020/05/30/q6s3kzjgxPlS1DV.jpg)

1. **近端裁切平面（Near Clipping Plane）** 是能够看到对象的最接近摄像机的点。
2. **摄像机视锥（Camera Frustum）** 是近端和远端裁切平面之间的可视查看区域的金字塔形状表示。
3. **远端裁切平面（Far Clipping Plane）** 是能够看到对象的离摄像机最远的点。

> 在关卡视口中编辑时，选择 显示（Show）>高级（Advanced） 并启用 摄像机视锥（Camera Frustum），可以显示视图视锥。



**几何体渲染**

进入实际渲染，我觉得是在DrawCall线程执行的`Prepass/Early Z Pass`

> 在渲染几何体之前，我们会面临一个问题，我们已经知道了哪些对象要参与渲染，但是我们不知道该以什么样的顺序来渲染这些对象，也不知道哪个对象在哪个对象的前面。

Prepass/Early Z Pass

虚幻引擎针对这一问题，会在实际渲染前执行一个Prepass或EarlyZPass进行优化。你可以把这个玩意简单理解为一种预渲染，这个预渲染干的事情很简单，就是进行一个比较轻量的渲染计算，得出哪个对象在哪个的前面，并把那种明知会被后来渲染的对象所挡住的像素区域给遮住（maskout）。

Drawcall

DrawCall是会被渲染的单一元素，每渲染一个DrawCall就是一次绘制调用。

> 共享相同属性的一组多边形就是一个DrawCall，每一个材质也是一个DrawCall（一个模型拥有10个材质，那就是10个DrawCall）。DrawCall越多，绘制调用越多，性能越低。



图示预渲染(`PrePass`)

![渲染图片](https://i.loli.net/2020/05/30/u6bz1W8oG2DdP4r.jpg)

（按照从左到右的顺序）

![presspass](https://i.loli.net/2020/05/30/69WCi3JRAj8gXZm.jpg)









## UE4渲染一帧

![img](https://interplayoflight.files.wordpress.com/2017/10/image2.png?w=515&h=708)

### ParticleSimulation

**粒子模拟**



### Z-Prepass

会有一系列的culling过程剔除掉不需要的像素或者几何体,将所有不透明的网格渲染到R24G8深度缓冲区：

> 值得注意的是，当渲染到深度缓冲区时，虚幻使用[反向Z](https://developer.nvidia.com/content/depth-precision-visualized)，这意味着将近平面映射为1，将远平面映射为0。这可以在深度范围内提供更好的精度，并减少对远距离网格物体的Z角对抗。 。

### BeginOcclusionTests

**测试咬合**,处理框架中的所有遮挡测试.虚幻引擎默认使用硬件遮挡查询进行遮挡测试



**RenderPrePass**

```c++
bool FDeferredShadingSceneRenderer::RenderPrePass(FRHICommandListImmediate& RHICmdList, TFunctionRef<void()> AfterTasksAreStarted)
{
	check(RHICmdList.IsOutsideRenderPass());	// 检查

	SCOPED_NAMED_EVENT(FDeferredShadingSceneRenderer_RenderPrePass, FColor::Emerald);
	bool bDepthWasCleared = false;

	extern const TCHAR* GetDepthPassReason(bool bDitheredLODTransitionsUseStencil, EShaderPlatform ShaderPlatform);
	SCOPED_DRAW_EVENTF(RHICmdList, PrePass, TEXT("PrePass %s %s"), GetDepthDrawingModeString(EarlyZPassMode), GetDepthPassReason(bDitheredLODTransitionsUseStencil, ShaderPlatform));

	SCOPE_CYCLE_COUNTER(STAT_DepthDrawTime);
	CSV_SCOPED_TIMING_STAT_EXCLUSIVE(RenderPrePass);
	SCOPED_GPU_STAT(RHICmdList, Prepass);

	bool bDidPrePre = false;
	FSceneRenderTargets& SceneContext = FSceneRenderTargets::Get(RHICmdList);

	bool bParallel = GRHICommandList.UseParallelAlgorithms() && CVarParallelPrePass.GetValueOnRenderThread();

	if (!bParallel)
	{
		// nothing to be gained by delaying this.
		AfterTasksAreStarted();
		// Note: the depth buffer will be cleared under PreRenderPrePass.
		bDepthWasCleared = PreRenderPrePass(RHICmdList);
		bDidPrePre = true;

		// PreRenderPrePass will end up clearing the depth buffer so do not clear it again.
		SceneContext.BeginRenderingPrePass(RHICmdList, false);
	}
	else
	{
		SceneContext.GetSceneDepthSurface(); // this probably isn't needed, but if there was some lazy allocation of the depth surface going on, we want it allocated now before we go wide. We may not have called BeginRenderingPrePass yet if bDoFXPrerender is true
	}

	// Draw a depth pass to avoid overdraw in the other passes.
	if(EarlyZPassMode != DDM_None)
	{
		const bool bWaitForTasks = bParallel && (CVarRHICmdFlushRenderThreadTasksPrePass.GetValueOnRenderThread() > 0 || CVarRHICmdFlushRenderThreadTasks.GetValueOnRenderThread() > 0);
		FScopedCommandListWaitForTasks Flusher(bWaitForTasks, RHICmdList);

		for(int32 ViewIndex = 0;ViewIndex < Views.Num();ViewIndex++)
		{
			const FViewInfo& View = Views[ViewIndex];

			SCOPED_GPU_MASK(RHICmdList, !View.IsInstancedStereoPass() ? View.GPUMask : (Views[0].GPUMask | Views[1].GPUMask));
			SCOPED_CONDITIONAL_DRAW_EVENTF(RHICmdList, EventView, Views.Num() > 1, TEXT("View%d"), ViewIndex);

			TUniformBufferRef<FSceneTexturesUniformParameters> PassUniformBuffer;
			
			CreateDepthPassUniformBuffer(RHICmdList, View, PassUniformBuffer);
			
			FMeshPassProcessorRenderState DrawRenderState(View, PassUniformBuffer);

			SetupDepthPassState(DrawRenderState);

			if (View.ShouldRenderView())
			{
				Scene->UniformBuffers.UpdateViewUniformBuffer(View);

				if (bParallel)
				{
					check(RHICmdList.IsOutsideRenderPass());
					bDepthWasCleared = RenderPrePassViewParallel(View, RHICmdList, DrawRenderState, AfterTasksAreStarted, !bDidPrePre) || bDepthWasCleared;
					bDidPrePre = true;
				}
				else
				{
					RenderPrePassView(RHICmdList, View, DrawRenderState);
				}
			}

			// Parallel rendering has self contained renderpasses so we need a new one for editor primitives.
			if (bParallel)
			{
				SceneContext.BeginRenderingPrePass(RHICmdList, false);
			}
			RenderPrePassEditorPrimitives(RHICmdList, View, DrawRenderState, EarlyZPassMode, true);
			if (bParallel)
			{
				RHICmdList.EndRenderPass();
			}
		}
	}
	if (!bDidPrePre)
	{
		// Only parallel rendering with all views marked as not-to-be-rendered will get here.
		// For some reason we haven't done this yet. Best do it now for consistency with the old code.
		AfterTasksAreStarted();
		bDepthWasCleared = PreRenderPrePass(RHICmdList);
		bDidPrePre = true;
	}

	if (bParallel)
	{
		// In parallel mode there will be no renderpass here. Need to restart.
		SceneContext.BeginRenderingPrePass(RHICmdList, false);
	}

	// Dithered transition stencil mask clear, accounting for all active viewports
	if (bDitheredLODTransitionsUseStencil)
	{
		if (Views.Num() > 1)
		{
			FIntRect FullViewRect = Views[0].ViewRect;
			for (int32 ViewIndex = 1; ViewIndex < Views.Num(); ++ViewIndex)
			{
				FullViewRect.Union(Views[ViewIndex].ViewRect);
			}
			RHICmdList.SetViewport(FullViewRect.Min.X, FullViewRect.Min.Y, 0, FullViewRect.Max.X, FullViewRect.Max.Y, 1);
		}
		DrawClearQuad(RHICmdList, false, FLinearColor::Transparent, false, 0, true, 0);
	}

	// Now we are finally finished.
	SceneContext.FinishRenderingPrePass(RHICmdList);

	return bDepthWasCleared;
}
```







# 渲染系统概述

![img](https://img-blog.csdnimg.cn/2018120510265318.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xlb253ZWk=,size_16,color_FFFFFF,t_70)

# 读取纹理GBuffer





UDrawFrustumComponent

# Q:

`C:\Program Files (x86)\UE4+VS2017\UnrealEngine\Engine\Source\Runtime\Renderer\Private\PostProcess\SceneRenderTargets.h`

![image-20200601155736466](https://i.loli.net/2020/06/01/Sc6NuwBxzQ84prZ.png)



`C:\Program Files (x86)\UE4+VS2017\UnrealEngine\Engine\Source\Runtime\Renderer\Private\SceneRendering.cpp`

![image-20200601161909214](https://i.loli.net/2020/06/01/V2QCnEDZplhgmko.png)





```c++
ENQUEUE_UNIQUE_RENDER_COMMAND_ONEPARAMETER(
DZRenderSutioBP_InterceptSceneBaseColor,
UTexture2D*, vTextureAsset, TextureAsset,
{
/*if (!IsInRenderingThread())
return;*/
FRHICommandListImmediate& RHICmdList = GRHICommandList.GetImmediateCommandList();
//计数加一避免Render完成后直接清空了GBuffer,但会慢一帧，你猜
FSceneRenderTargets::Get(RHICmdList).AdjustGBufferRefCount(RHICmdList, 1);
static const FString ScrollingMessage(TEXT("Hello World: "));
GEngine->AddOnScreenDebugMessage(-1, 0.2f, FColor::Red, ScrollingMessage);
FSceneRenderTargets& SceneContext = FSceneRenderTargets::Get(RHICmdList);
if (SceneContext.GBufferA)
{
FTexture2DRHIRef vTextTarget = SceneContext.GetGBufferATexture();
FString vSiceStr = FString::Printf(TEXT("FSceneRenderTargets GBufferA Size = %d*%d"), vTextTarget->GetSizeX(), vTextTarget->GetSizeY());

GEngine->AddOnScreenDebugMessage(-1, 0.2f, FColor::Red, vSiceStr);
}
//移除
FSceneRenderTargets::Get(RHICmdList).AdjustGBufferRefCount(RHICmdList, -1);
}
);
```

键入命令vis scenedepthz uv0以查看实际使用的深度缓冲区。UE4对场景使用“反向”深度缓冲区。

![image-20200602195954138](https://i.loli.net/2020/06/02/P91kUEFIcplvNru.png)





## 渲染函数Render

路径：`Engine \ Source \ Runtime \ Renderer \ Private \ DeferredShadingRenderer.cpp（660）`

函数：`FDeferredShadingSceneRenderer :: Render（）`渲染路径

| 全局系统纹理初始化                                           | DeferredShadingRenderer.cpp（677） GSystemTextures.InitializeTextures（） |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 保护 必要的渲染目标您是否已确保可以保护的最大目标数目？      | DeferredShadingRenderer.cpp（680） GSceneRenderTargets.Allocate（） |
| 初始化每个视口 设置视口显示的对象，选择使用动态阴影时显示的对象，对半透明对象进行排序 | DeferredShadingRenderer.cpp（683） InitViews()（）           |
| FXSystem预处理 GPU粒子正在被仿真                             | DeferredShadingRenderer.cpp（758） FXSystem-> PreRender（）  |
| 启用Z Pre-Pass时执行的早期Z绘制 不绘制Tile渲染的硬件（移动设备，Android或iOS）对于 PC或PS4，将生成深度缓冲区和HiZ，因此后续绘制速度很快成为？ | DeferredShadingRenderer.cpp（768） RenderPrePass（）         |
| 安全GBuffer                                                  | DeferredShadingRenderer.cpp（774） GSceneRenderTargets.AllocGBufferTargets（） |
| 透明光传播量                                                 | DeferredShadingRenderer.cpp（779） ClearLPVs（）             |
| 使用DBuffer时绘制延期贴图[单击此处](http://monsho.blog63.fc2.com/blog-entry-139.html)获取 DBuffer和延期贴图 | DeferredShadingRenderer.cpp（796） GCompositionLighting.ProcessBeforeBasePass（） |
| 如有必要，请 在绘制线框图时清除GBuffer透明颜色缓冲区， 有些游戏在发行游戏时无法清除GBuffer或屏幕。 | DeferredShadingRenderer.cpp（805） SetAndClearViewGBuffer（）  DeferredShadingRenderer.cpp（816） RHICmdList.Clear（） |
| 渲染不透明的对象渲染 项目，这些项目根据它们是Masked还是Default，是否有LightMap等按每种排序顺序进行了精细分类 | DeferredShadingRenderer.cpp（828） RenderBasePass（）        |
| 清除 GBuffer 的未绘制部分如果事先清除GBuffer，则不必要。     | DeferredShadingRenderer.cpp（851） ClearGBufferAtMaxZ（）    |
| 绘制 自定义深度请参见[此处](http://monsho.blog63.fc2.com/blog-entry-138.html)以获取自定义深度 | DeferredShadingRenderer.cpp（860） RenderCustomDepthPass（） |
| 在这里再次模拟GPU粒子除了在这里 处理使用深度缓冲区执行碰撞检测的 粒子外，还对GPU粒子进行排序 | DeferredShadingRenderer.cpp（865） 场景-> FXSystem-> PostRenderOpaque（） |
| 为SceneDepthTexture创建一个半分辨率（每个方面为1/4分辨率）的缓冲区 | DeferredShadingRenderer.cpp（875） UpdateDownsampledDepthSurface（） |
| 执行阻塞测试 HZB的构建，执行提交 的HZB [Attotempkinder](https://twitter.com/tempkinder)的[这篇文章](http://darakemonodarake.hatenablog.jp/entry/2014/12/17/000422)指 | DeferredShadingRenderer.cpp（881） BeginOcclusionTests（）   |
| 开始写 因为有点复杂，所以要写一些细节                        | DeferredShadingRenderer.cpp（890）                           |
| 不使用DBuffer绘制延迟的贴图                                  | CompositionLighting.cpp（293） AddDeferredDecalsBeforeLighting（） |
| 在屏幕空间中绘制环境光遮挡                                   | CompositionLighting.cpp（300） AddPostProcessingAmbientOcclusion（） |
| 后期处理环境立方体贴图                                       | CompositionLighting.cpp（305） AddPostProcessingAmbientCubemap（） |
| 到这里为止的一系列处理                                       | DeferredShadingRenderer.cpp（904） GCompositionLighting.ProcessAfterBasePass（） |
| 透明的体积光缓冲液可提高透明度                               | DeferredShadingRenderer.cpp（908） ClearTranslucentVolumeLighting（） |
| 从此处开始的主要照明设备 收集要绘制的灯光并将其排序 不要投影，不使用灯光功能的灯光将使用“ 基于图块” 绘制（如果可能）如果不能使用“ 基于图块”关于延迟渲染，[这](https://sites.google.com/site/monshonosuana/directxno-hanashi-1/directx-125)是味o，但请参见[此处](https://sites.google.com/site/monshonosuana/directxno-hanashi-1/directx-125) | LightRendering.cpp（312-348）  LightRendering.cpp（423） RenderTiledDeferredLighting（）  LightRendering.cpp（429） RenderSimpleLightsStandardDeferred（） |
| 它不会阴影，也不会使用灯光功能，但是似乎无法使用TBDR绘制的灯光 被称为标准延迟灯光。 | LightRendering.cpp（445） RenderLight（）                    |
| 如果用于半透明的体积光是有效的，则将每个光注入到体积光中 ，从而在3D纹理上绘制光效果。 | LightRendering.cpp（455） InjectTranslucentVolumeLightingArray（）  LightRendering.cpp（461） InjectSimpleTranslucentVolumeLightingArray（） |
| 使用灯光功能投射阴影的灯光将单独处理                         | LightRendering.cpp（468-552）                                |
| 首先，我在[投射](https://sites.google.com/site/monshonosuana/directxno-hanashi-1/directx-137)阴影时 绘制了一个阴影贴图；在这里我还绘制了一个 半透明的阴影贴图；我记得半透明的当然是[傅立叶不透明度贴图](https://sites.google.com/site/monshonosuana/directxno-hanashi-1/directx-137)。 | LightRendering.cpp（495） RenderTranslucentProjectedShadows（）  LightRendering.cpp（497） RenderProjectedShadows（） |
| 使用LPV时绘制[反射阴影贴图](http://d.hatena.ne.jp/hanecci/20100731/1280596856) | LightRendering.cpp（508） RenderReflectiveShadowMaps（）     |
| 灯光功能图 阴影指示器图                                      | LightRendering.cpp（515） RenderLightFunction（）  LightRendering.cpp（522） RenderPreviewShadowsIndicator（） |
| 衰减缓冲器中的分辨 光的衰减信息是否曾经被吸入另一个缓冲器中？ | LightRendering.cpp（534） GSceneRenderTargets.FinishRenderingLightAttenuation（） |
| 注入体积光以获得半透明                                       | LightRendering.cpp（541） InjectTranslucentVolumeLighting（） |
| 这 是使用光功能投射阴影的光处理的结束。                      | LightRendering.cpp（550） RenderLight（）                    |
| 这 是每个光的LPV 的主要注入照明过程的结尾                    | LightRendering.cpp（561-593） Lpv-> InjectLightDirect（）    |
| 注入体积光以实现环境立方体贴图的半透明                       | DeferredShadingRenderer.cpp（916） InjectAmbientCubemapTranslucentVolumeLighting（） |
| 过滤体积光以获得半透明                                       | DeferredShadingRenderer.cpp（919） FilterTranslucentVolumeLighting（） |
| LPV传输过程 此外，第921行的注释上写有“ copypimis”，例如“ Clear LPV buffer”。 | DeferredShadingRenderer.cpp（924） PropagateLPVs（）         |
| 动态天光绘图                                                 | DeferredShadingRenderer.cpp（928） RenderDynamicSkyLighting（） |
| 延迟的反射图形 捕获的反射图形而不是屏幕空间                  | DeferredShadingRenderer.cpp（931） RenderDeferredReflections（） |
| LPV的GI绘图                                                  | CompositionLighting.cpp（344） AddPostProcessingLpvIndirect（） |
| 屏幕空间次表面散射（SSSSS）的后处理                          | CompositionLighting.cpp（347-376）                           |
| 如果启用了“光轴”，则绘制“光轴遮挡”                           | DeferredShadingRenderer.cpp（953） RenderLightShaftOcclusion（） |
| [大气雾](https://docs.unrealengine.com/latest/INT/Engine/Actors/FogEffects/AtmosphericFog/index.html)图 | DeferredShadingRenderer.cpp（977） RenderAtmosphere（）      |
| 绘图雾 这是[高度](https://docs.unrealengine.com/latest/INT/Engine/Actors/FogEffects/HeightFog/index.html)雾吗？ | DeferredShadingRenderer.cpp（986） RenderFog（）             |
| 画一个半透明的物体 在这里也画一个单独的半透明的东西          | DeferredShadingRenderer.cpp（1000） RenderTranslucency（）   |
| 折射变形处理                                                 | DeferredShadingRenderer.cpp（1008） RenderDistortion（）     |
| 光轴的起霜处理                                               | DeferredShadingRenderer.cpp（1013） RenderLightShaftBloom（） |
| 距离场AO处理不能在 当前不支持多个视口 的分屏游戏中使用吗？   | DeferredShadingRenderer.cpp（1019） RenderDistanceFieldAOSurfaceCache（） |
| 它只是在查看网格的“距离场”的可视化处理结果吗？               | DeferredShadingRenderer.cpp（1024） RenderMeshDistanceFieldVisualization（） |
| 由于速度模糊而绘制运动对象的速度                             | DeferredShadingRenderer.cpp（1034） RenderVelocities（）     |
| 从这里到最后的发布过程， 这也很复杂而且很长                  | DeferredShadingRenderer.cpp（1047） GPostProcessing.Process（） |
| 使用BeforeTranslucency设置绘制后处理材料                     | PostProcessing.cpp（878） AddPostProcessMaterial（）         |
| 景深处理 通过高斯模糊进行DOF 处理之后，正在执行散焦处理（使用指定的光圈形状的纹理进行绘制）， 在此阶段似乎合并了单独的半透明缓冲区 | PostProcessing.cpp（888） AddPostProcessDepthOfFieldGaussian（）  PostProcessing.cpp（898） AddPostProcessDepthOfFieldBokeh（）  PostProcessing.cpp（905） FRCPassPostProcessBokehDOFRecombine （如果未启用模糊） |
| 使用BeforeTonemapping设置绘制后处理材料                      | PostProcessing.cpp（913） AddPostProcessMaterial（）         |
| 如果要使用TemporalAA ，请在此处绘制，如果使用FXAA，请稍后再绘制 | PostProcessing.cpp（921） AddTemporalAA（）  PostProcessing.cpp（928） AddTemporalAA（） （如果不使用速度缓冲区，请单击此处） |
| 运动模糊处理 设置，分辨率下采样，高斯模糊，运动模糊绘制，组合处理 | PostProcessing.cpp（932-994） FRCPassPostProcessMotionBlurSetup FRCPassPostProcessDownsample RenderGaussianBlur（） FRCPassPostProcessMotionBlur FRCPassPostProcessMotionBlurRecombine |
| SceneColor下采样                                             | PostProcessing.cpp（1000） FRCPassPostProcessDownsample      |
| 直方图                                                       | PostProcessing.cpp（1006-1040） FRCPassPostProcessHistogram FRCPassPostProcessHistogramReduce |
| 此处需要[眼睛适应](https://docs.unrealengine.com/latest/INT/Engine/Rendering/PostProcessEffects/AutomaticExposure/index.html)图直方图 | PostProcessing.cpp（1046） AddPostProcessEyeAdaptation（）   |
| 布卢姆绘图                                                   | PostProcessing.cpp（1057） AddBloom（）  PostProcessing.cpp（1060-1148） （对于移动设备，请单击此处） |
| 色调映射 仅替换ReplacecingTonemapper设置工程图的一种后处理材料，但是 如果存在该材料，则执行默认色调映射 | PostProcessing.cpp（1155） AddSinglePostProcessMaterial（）  PostProcessing.cpp（1171） AddTonemapper（） （默认色调映射） |
| 如果启用了FXAA，请在此处处理                                 | PostProcessing.cpp（1177） AddPostProcessAA（）              |
| 绘制一些编辑器（如选定的轮廓）， 然后使用AfterTonemapping设置绘制后期处理材料 | PostProcessing.cpp（1244） AddPostProcessMaterial（）        |
| 用于地下和GBuffer的可视化 调试                               | PostProcessing.cpp（1246-1254）                              |
| 用于HMD的后处理 Oculus或Morpheus                             | PostProcessing.cpp（1256-1277） FRCPassPostProcessHMD FRCPassPostProcessMorpheus |
| 之后，调试和高分辨率屏幕截图功能等。 之后，进行后处理并结束！ 谢谢！ | PostProcessing.cpp（1279-）                                  |


哦，很长。
可能很难阅读，但是如果您有兴趣，请过来。





如何使用ENQUEUE_RENDER_COMMAND代替ENQUEUE_UNIQUE_RENDER_COMMAND_ONEPARAMETER-虚幻引擎论坛

https://qiita.com/mechamogera/items/a0c369a3b853a3042cae

```c++
#include "ImageUtils.h"
#include "GenericPlatform/GenericPlatformProcess.h"

void HogeHoge::Convert(UTexture* Img, TArray<uint8>& ImgData)
{
    if (!Img || !Img->Resource || !Img->Resource->TextureRHI)
    {
        UE_LOG(LogTemp, Warning, TEXT("Upload Texture is invalid"));
        return;
    }

    FTexture2DRHIRef Texture2D = Img->Resource->TextureRHI->GetTexture2D();
    if (!Texture2D)
    {
        UE_LOG(LogTemp, Warning, TEXT("Upload Texture2D is invalid"));
        return;
    }

    TArray<FColor> OutPixels;
    struct FReadSurfaceContext
    {
        FTexture2DRHIRef Texture;
        TArray<FColor>* OutData;
        FIntRect Rect;
        FReadSurfaceDataFlags Flags;
    };

    FReadSurfaceContext ReadSurfaceContext =
    {
        Texture2D,
        &OutPixels,
        FIntRect(0, 0, Texture2D->GetSizeXY().X, Texture2D->GetSizeXY().Y),
        FReadSurfaceDataFlags(RCM_UNorm, CubeFace_MAX)
    };

    FReadSurfaceContext Context = ReadSurfaceContext;
    ENQUEUE_RENDER_COMMAND(ReadSurfaceCommand)(
        [Context](FRHICommandListImmediate& RHICmdList)
    {
        RHICmdList.ReadSurfaceData(
            Context.Texture,
            Context.Rect,
            *Context.OutData,
            Context.Flags
        );
    });

    FlushRenderingCommands();

    FImageUtils::CompressImageArray(Context.Rect.Width(), Context.Rect.Height(), OutPixels, ImgData);
}
```



