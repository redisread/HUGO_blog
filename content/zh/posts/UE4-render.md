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





UDrawFrustumComponent







