---
title: "UE4 Problems"
date: 2020-05-30T20:00:19+08:00
description: 虚幻引擎相关问题
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/05/30/ozvN8LMnpmk1JTQ.png
libraries:
- 
tags:
-
series:
-
categories:
-
---





# UE4问题汇总




1. UE4光照构建失败:warning:

   https://blog.csdn.net/earlyAutumnOfRain/article/details/80863561

2. UE4导入灰度图

   https://www.cnblogs.com/gucheng/p/10116857.html

3. 详解UE4静态库与动态库的导入与使用

   https://gameinstitute.qq.com/community/detail/121551

4. Ue4_序列化浅析_

   https://blog.csdn.net/mohuak/article/details/83027211

5. UE快捷键

   https://www.unrealengine.com/zh-CN/tech-blog/designer-s-guide-to-unreal-engine-keyboard-shortcuts

6. UE4资源加载（一）从StaticLoadObject开始

   http://suo.im/6v7hUc

7. Unreal Cookbook：创建对象的的几种姿势（C++）

   https://blog.csdn.net/Neil3D/article/details/51488401

8. Aery的UE4 C++游戏开发之旅（1）基础对象模型

   https://www.cnblogs.com/KillerAery/p/11986316.html

9. 目录结构

   https://docs.unrealengine.com/zh-CN/Engine/Basics/DirectoryStructure/index.html

10. 引擎世界

    https://www.engineworld.cn/

11. 《InsideUE4》GamePlay架构（一）Actor和Component

    https://zhuanlan.zhihu.com/p/22833151

12. 实时渲染中的坐标系变换（5）：投影变换-3

    https://zhuanlan.zhihu.com/p/115395322

13. UE4 屏幕坐标转换到世界坐标

    https://blog.csdn.net/weixin_36412907/article/details/77306212

14. UE4必读文章列表_个人整理

    https://zhuanlan.zhihu.com/p/126611976

15. OpenGL 学习系列---投影矩阵

    https://juejin.im/post/5b0ec5fef265da092a2b79b1

16. Alpha Test

    http://geekfaner.com/shineengine/blog13_OpenGLESv2_12.html

17. Rendoc使用

    https://www.cnblogs.com/kekec/p/11760288.html

18. [多视图几何] - 逆透视变换

    https://blog.csdn.net/chishuideyu/article/details/79136903

19. UE4必读文章列表_个人整理

    https://zhuanlan.zhihu.com/p/126611976
    
20. UE4中的Tone Mapping

    https://www.dingshukai.com/blog/ue4-tone-mapping.html

21. UE4 渲染流程

    https://blog.csdn.net/or_7r_ccl/article/details/81102771



# UE4文件系统



> 模块是UE4的构建块。引擎是以大量模块的集合形式实现的，游戏提供自己的模块来扩充自己。每个模块都封装了一组功能，并且可以提供公共接口和编译环境（包括宏、路径等）供其他模块使用。

.build.cs文件的典型结构如下。

```c#
using UnrealBuildTool;
using System.Collections.Generic;
public class MyModule : ModuleRules
{
    public MyModule(ReadOnlyTargetRules Target) : base(Target)
    {
        // Settings go here
    }
}
```



1. \Engine\Source\ThirdParty目录

   存放第三方的库

   ![image-20200525100627766](https://i.loli.net/2020/05/30/4IPcUru7jpvfFn2.png)

2. F:\UnrealEngine4.14\Engine\Plugins目录(或者F:\UE4Project\项目名称\Plugins目录)

   保存插件的目录

![ue4目录](https://i.loli.net/2020/05/30/Bo67D9NmxsKZEWX.png)













UE创世，万物皆UObject，接着有Actor。

# Component和Actor



> UE4让Actor们轻装上阵，只提供一些通用的基本生存能力，而把众多的“技能”抽象成了一个个“Component”并提供组装的接口，让Actor随用随组装，把自己武装成一个个专业能手。

### 相关组件

### RootComponent

定义这个演员在世界上的变换(位置、旋转、缩放)的组件，所有其他组件必须以某种方式附加到这个组件

### 弹簧臂组件

弹簧臂组件用于自动控制摄像机受阻时的应对方式。



# UE文件存储的方式

UE 中使用统一的格式存储资源 (uasset， umap)，每个 uasset 对应一个包 (package)，存储一个 UPackage 对象时，会将该包下的所有对象都存到 uasset 中。



![img](https://i.loli.net/2020/05/30/SWXvRcZd2xFCh76.png)

> 一个资源在文件中对应uasset，在内存中对应为UPackage。



### uasset文件格式

- File Summary 文件头信息
- Name Table 包中对象的名字表
- Import Table 存放被该包中对象引用的其它包中的对象信息(路径名和类型)
- Export Table 该包中的对象信息(路径名和类型)
- Export Objects 所有Export Table中对象的实际数据。

![1](https://i.loli.net/2020/05/30/1LqtlzdiGnk6hOR.png)



### FlinkerLoad

FLinkerLoad是作为uasset和内存UPackage的中间桥梁。在加载内容生成UPackage的时候，UPackage会根据名字找到uasset文件，由FLinkerLoad来负责加载。

![2](https://i.loli.net/2020/05/30/G38Zu6gChSfXJkv.png)

FLinkerLoad主要内容如下：

- FArchive* Loader;	//Loader负责读取具体文件
- TArray ImportMap;   //将uasset的ImportTable加载到ImportMap中，FObjectImport是需要依赖（导入）的UObject
- TArray ExportMap;   //FObjectExport是这个UPackage所拥有的UObject（这些UObject都能提供给其他UPackage作为Import）

### StaticLoadObject加载

步骤：

1. 根据文件名字创建一个空的包（没有任何文件相关的数据）
2. 建立一个LinkerLoad去加载对应的uasset文件 序列化。
3. 优先加载ImportMap
4. 加载ExportMap（本身的数据）

![3](https://i.loli.net/2020/05/30/5c4mRj2MX8JSGUu.png)





1、建立一个UPackage



2、序列化uasset



3、加载ImportMap

![5](https://i.loli.net/2020/05/30/9CG5wlPa2er7SAE.png)







# Pawn默认组件

![image-20200526101017807](https://i.loli.net/2020/05/30/XTqrdPnGl8mtoO7.png)

![image-20200526163307216](https://i.loli.net/2020/05/30/gOHkXaiZtTqMSd7.png)

![image-20200526163749236](https://i.loli.net/2020/05/30/Ei5Cofh3RjKN1yl.png)



# UE相机



http://www.geodesic.games/2019/03/27/projection-matrices-in-unreal-engine/

* Firstly, Unreal inverses the perspective divide, applying 1 instead of -1 for the “W” value.（虚幻处理投影与 Unity 中使用的标准 OpenGL 透视矩阵不同。）
* Secondly, Unreal applies a matrix transposition to all their perspective matrices.（其次，Unreal 对所有的透视矩阵进行了矩阵移位。
* ![img](https://i.loli.net/2020/05/30/rFiyLJQz2d9XKVS.jpg)
* 缺省情况下，Unreal 提供了各种方便的透视矩阵构造函数。 有两种变体，一种是普通透视矩阵，另一种是逆向透视矩阵。



### 右手坐标系：

https://zhuanlan.zhihu.com/p/114729671

透视投影：

![image-20200528152403502](https://i.loli.net/2020/05/30/BWc7LS9AbgXJn8C.png)

归一化齐次坐标以后的结果是：

![image-20200528152429361](https://i.loli.net/2020/05/30/g2yARkj185caGWL.png)



> camera space 3D空间中，相同的x，z越大，投影变换以后的x分量越靠近0。"近大远小"的透视效果，就是这么算出来的。

> Unity的投影矩阵，是把视锥内的所有3D坐标，转换到 [-1,1] 范围之内。最后转化为Screen Space，范围为[0,1]

深度值是到近平面的距离：

![](https://i.loli.net/2020/05/30/nyuYrEqcQF69j2U.png)

正交投影：

![](https://i.loli.net/2020/05/30/57pLHqSfa91bZId.png)



![image-20200528152706914](https://i.loli.net/2020/05/30/gwJLAd59szaHicj.png)





> 透视投影变换，有"近大远小"的透视效果。3D空间中的两条平行线，在投影变换以后会相交于某个"灭点"。
> 正交投影变换，没有"近大远小"的透视效果。3D空间中的两条平行线，在投影变换以后，仍旧是平行的。



### Unreal

正交矩阵：

> UE4里的透视投影矩阵的计算方式，参见引擎源代码的OrthoMatrix.h文件。

![image-20200528160204890](https://i.loli.net/2020/05/30/57pLHqSfa91bZId.png)

![image-20200528160140066](https://i.loli.net/2020/05/30/bKfXOCyTcApZJmM.png)









代码1：

```c++
UGameplayStatics::DeprojectScreenToWorld(UGameplayStatics::GetPlayerController(GetWorld(), 0), forwardCursorPos, forwardWorldPos, forwardMoveDirection);
```

代码2：

```c++
FVector forwardMoveDirection;
GetWorld()->GetFirstPlayerController()->GetMousePosition(forwardCursorPos.X, forwardCursorPos.Y);
UGameplayStatics::DeprojectScreenToWorld(UGameplayStatics::GetPlayerController(GetWorld(), 0), forwardCursorPos, forwardWorldPos, forwardMoveDirection);
```



1.  `APlayerController` 玩家控制器被人类玩家用来控制棋子。[地址](https://docs.unrealengine.com/en-US/API/Runtime/Engine/GameFramework/APlayerController/index.html)
2. `ULocalPlayer` 当前客户端上的每个玩家都有一个LocalPlayer。[地址](https://docs.unrealengine.com/en-US/API/Runtime/Engine/Engine/ULocalPlayer/index.html)
3. `FViewportClient` 视窗客户端的抽象接口。[地址](https://docs.unrealengine.com/en-US/API/Runtime/Engine/FViewportClient/index.html)
4. `ViewportClient` 在玩家中包含此玩家视图的主视窗.。 [地址](https://docs.unrealengine.com/en-US/API/Runtime/Engine/Engine/ULocalPlayer/ViewportClient/index.html)
5. `ULocalPlayer::GetProjectionData` 用于导出投影所需的各种数据位的辅助函数。 [地址](https://docs.unrealengine.com/en-US/API/Runtime/Engine/Engine/ULocalPlayer/GetProjectionData/index.html)





bianxngjing:

https://v.qq.com/x/page/t0770a2b6f6.html

### API UGameplayStatics::DeprojectScreenToWorld

* [Unity 与 NGUI 坐标转换原理](https://blog.csdn.net/cp790621656/article/details/54698064)
* 

将给定的2D屏幕空间坐标转换为3D世界空间点和方向。

![c12](https://i.loli.net/2020/05/30/keNsVluDQbpT3f7.png)

![img](https://i.loli.net/2020/05/30/oh9pMPrU2O3afjQ.png)

API地址： https://docs.unrealengine.com/en-US/API/Runtime/Engine/Kismet/UGameplayStatics/DeprojectScreenToWorld/index.html

语法：

```c++
static bool DeprojectScreenToWorld
(
    APlayerController const * Player,	// 玩家视角
    const FVector2D & ScreenPosition,	// 2D点
    FVector & WorldPosition,			// 世界空间三维坐标 输出
    FVector & WorldDirection			// 在给定的2d点上远离相机的世界空间方向矢量。	输出
)
```

源码：

```c++
bool UGameplayStatics::DeprojectScreenToWorld(APlayerController const* Player, const FVector2D& ScreenPosition, FVector& WorldPosition, FVector& WorldDirection)
{
    // 获取LocalPlayer
	ULocalPlayer* const LP = Player ? Player->GetLocalPlayer() : nullptr;
	if (LP && LP->ViewportClient)
	{//ViewpoetClient 包含此玩家视图的主视窗。
		// get the projection data
		FSceneViewProjectionData ProjectionData;
        //立体渲染通过。FULL表示此过程中未启用立体渲染，eSSP_FULL
		if (LP->GetProjectionData(LP->ViewportClient->Viewport, eSSP_FULL, /*out*/ ProjectionData))
		{// 获取投影数据
			FMatrix const InvViewProjMatrix = ProjectionData.ComputeViewProjectionMatrix().InverseFast();
			FSceneView::DeprojectScreenToWorld(ScreenPosition, ProjectionData.GetConstrainedViewRect(), InvViewProjMatrix, /*out*/ WorldPosition, /*out*/ WorldDirection);
			return true;
		}
	}

	// something went wrong, zero things and return false，错误不管
	WorldPosition = FVector::ZeroVector;
	WorldDirection = FVector::ZeroVector;
	return false;
}
```



#### 逆透视变换







**投影矩阵**：

```c++
// Projection data for a FSceneView
struct FSceneViewProjectionData
{
	FVector ViewOrigin;		//源视图向量
	/** Rotation matrix transforming from world space to view space. */
	FMatrix ViewRotationMatrix;	// 从世界空间到视图空间的旋转矩阵转换。
	/** UE4 projection matrix projects such that clip space Z=1 is the near plane, and Z=0 is the infinite far plane. */
	FMatrix ProjectionMatrix;	// UE4投影矩阵投影使得剪辑空间Z=1是近平面，Z=0是无限远平面。
protected:
	//The unconstrained (no aspect ratio bars applied) view rectangle (also unscaled)
	FIntRect ViewRect;	// 无约束(未应用宽高比条)视图矩形(也未缩放)
	// The constrained view rectangle (identical to UnconstrainedUnscaledViewRect if aspect ratio is not constrained)
	FIntRect ConstrainedViewRect;	// 受约束的视图矩形(如果长宽比不受约束，则与UnconstrainedUnscaledViewRect相同)
public:
	void SetViewRectangle(const FIntRect& InViewRect)
	{
		ViewRect = InViewRect;
		ConstrainedViewRect = InViewRect;
	}
	void SetConstrainedViewRectangle(const FIntRect& InViewRect)
	{
		ConstrainedViewRect = InViewRect;
	}
    // 上面两个函数设置Rect窗口
    
	bool IsValidViewRectangle() const
	{//判断窗口是否有效
		return (ConstrainedViewRect.Min.X >= 0) &&
			(ConstrainedViewRect.Min.Y >= 0) &&
			(ConstrainedViewRect.Width() > 0) &&
			(ConstrainedViewRect.Height() > 0);
	}
	bool IsPerspectiveProjection() const
	{// 判断是不是透视投影矩阵
		return ProjectionMatrix.M[3][3] < 1.0f;
	}
	const FIntRect& GetViewRect() const { return ViewRect; }
	const FIntRect& GetConstrainedViewRect() const { return ConstrainedViewRect; }
	FMatrix ComputeViewProjectionMatrix() const
	{// 计算视图投影矩阵
		return FTranslationMatrix(-ViewOrigin) * ViewRotationMatrix * ProjectionMatrix;
	}
};
```

上面平移矩阵：

```c++
FORCEINLINE FTranslationMatrix::FTranslationMatrix(const FVector& Delta)	//基于给定向量的构造函数转换矩阵，//转置矩阵
	: FMatrix(
		FPlane(1.0f,	0.0f,	0.0f,	0.0f),
		FPlane(0.0f,	1.0f,	0.0f,	0.0f),
		FPlane(0.0f,	0.0f,	1.0f,	0.0f),
		FPlane(Delta.X,	Delta.Y,Delta.Z,1.0f)
	)
{ }
```



难点一：`GetProjectionData`函数

```c++
bool ULocalPlayer::GetProjectionData(FViewport* Viewport, EStereoscopicPass StereoPass, FSceneViewProjectionData& ProjectionData) const
{
	// If the actor
    //Size为分配给此玩家的主视口子区域的大小。0-1
    // Viewport->GetSizeXY()获取视端的X与Y
	if ((Viewport == NULL) || (PlayerController == NULL) || (Viewport->GetSizeXY().X == 0) || (Viewport->GetSizeXY().Y == 0) || (Size.X == 0) || (Size.Y == 0))
	{
		return false;
	}
	// 将浮点数转换为截断值接近零的整数。即向下取整
    // Origin为分配给该玩家的主视口子区域左上角的坐标。0-1
	int32 X = FMath::TruncToInt(Origin.X * Viewport->GetSizeXY().X);
	int32 Y = FMath::TruncToInt(Origin.Y * Viewport->GetSizeXY().Y);
	
    // 加上视端初始的坐标值
	X += Viewport->GetInitialPositionXY().X;
	Y += Viewport->GetInitialPositionXY().Y;
	
    //新的窗口大小
	uint32 SizeX = FMath::TruncToInt(Size.X * Viewport->GetSizeXY().X);
	uint32 SizeY = FMath::TruncToInt(Size.Y * Viewport->GetSizeXY().Y);
	
    //X=0,Y = 0
#if !(UE_BUILD_SHIPPING || UE_BUILD_TEST)

	// We expect some size to avoid problems with the view rect manipulation
	// 我们希望有一定的大小来避免view rect操作的问题
	if(SizeX > 50 && SizeY > 50)
	{
		int32 Value = CVarViewportTest.GetValueOnGameThread();	//根据value的值分类各种视端

		if(Value)
		{
			int InsetX = SizeX / 4;
			int InsetY = SizeY / 4;

			// this allows to test various typical view port situations (todo: split screen)
            // 这允许测试各种典型的视图端口情况(todo:分割屏幕)
			switch(Value)
			{
				case 1: X += InsetX; Y += InsetY; SizeX -= InsetX * 2; SizeY -= InsetY * 2;break;
				case 2: Y += InsetY; SizeY -= InsetY * 2; break;
				case 3: X += InsetX; SizeX -= InsetX * 2; break;
				case 4: SizeX /= 2; SizeY /= 2; break;
				case 5: SizeX /= 2; SizeY /= 2; X += SizeX;	break;
				case 6: SizeX /= 2; SizeY /= 2; Y += SizeY; break;
				case 7: SizeX /= 2; SizeY /= 2; X += SizeX; Y += SizeY; break;
			}
		}
	}
#endif
	// FIntRect为二维空间中整数矩形的结构。新的视端矩阵
	FIntRect UnconstrainedRectangle = FIntRect(X, Y, X+SizeX, Y+SizeY);//InMin(X,Y),InMax(X+SizeX,Y+SizeY)
	// 设置投影数据的窗口
	ProjectionData.SetViewRectangle(UnconstrainedRectangle);

	// Get the viewpoint.
    // 获得视点
	FMinimalViewInfo ViewInfo;
    //结构
    /**
        enum EStereoscopicPass
    {
        eSSP_FULL,
        eSSP_LEFT_EYE,
        eSSP_RIGHT_EYE,
        eSSP_LEFT_EYE_SIDE,
        eSSP_RIGHT_EYE_SIDE,
    }
    **/
	GetViewPoint(/*out*/ ViewInfo, StereoPass);	//检索该玩家的视点。

	// If stereo rendering is enabled, update the size and offset appropriately for this pass
    // 如果启用了立体渲染，请为此过程适当更新大小和偏移
	const bool bNeedStereo = IStereoRendering::IsStereoEyePass(StereoPass) && GEngine->IsStereoscopic3D();
	const bool bIsHeadTrackingAllowed = GEngine->XRSystem.IsValid() && GEngine->XRSystem->IsHeadTrackingAllowed();
	if (bNeedStereo)
	{
		GEngine->StereoRenderingDevice->AdjustViewRect(StereoPass, X, Y, SizeX, SizeY);
	}

	// scale distances for cull distance purposes by the ratio of our current FOV to the default FOV
    // 根据我们当前的FOV与默认FOV的比率，为选择距离的目的缩放距离
	PlayerController->LocalPlayerCachedLODDistanceFactor = ViewInfo.FOV / FMath::Max<float>(0.01f, (PlayerController->PlayerCameraManager != NULL) ? PlayerController->PlayerCameraManager->DefaultFOV : 90.f);

    FVector StereoViewLocation = ViewInfo.Location;
    // 加入立体渲染或者
    if (bNeedStereo || bIsHeadTrackingAllowed)
    {// 假如启用了立体渲染和头部追踪
		auto XRCamera = GEngine->XRSystem.IsValid() ? GEngine->XRSystem->GetXRCamera() : nullptr;	//虚拟现实相机
		if (XRCamera.IsValid())
		{
			AActor* ViewTarget = PlayerController->GetViewTarget();
			const bool bHasActiveCamera = ViewTarget && ViewTarget->HasActiveCameraComponent();
			XRCamera->UseImplicitHMDPosition(bHasActiveCamera);
		}

		if (GEngine->StereoRenderingDevice.IsValid())
		{
			GEngine->StereoRenderingDevice->CalculateStereoViewOffset(StereoPass, ViewInfo.Rotation, GetWorld()->GetWorldSettings()->WorldToMeters, StereoViewLocation);
		}
    }

	// Create the view matrix
    // 创建视图矩阵
    // FPlane 三维平面的结构。(X,Y,Z,W)
    // FMatrix 浮点值的4x4矩阵。
	ProjectionData.ViewOrigin = StereoViewLocation;
	ProjectionData.ViewRotationMatrix = FInverseRotationMatrix(ViewInfo.Rotation) * FMatrix(
		FPlane(0,	0,	1,	0),
		FPlane(1,	0,	0,	0),
		FPlane(0,	1,	0,	0),
		FPlane(0,	0,	0,	1));

	// @todo viewext this use case needs to be revisited
    // 重新考虑viewext
	if (!bNeedStereo)	//假如没有立体渲染
	{
		// Create the projection matrix (and possibly constrain the view rectangle)
        // 创建投影矩阵(并可能约束视图矩形)
        // ViewInfo视点
		FMinimalViewInfo::CalculateProjectionMatrixGivenView(ViewInfo, AspectRatioAxisConstraint, Viewport, /*inout*/ ProjectionData);//计算给定视图投影矩阵
		
        // 视图扩展对象可以在没有运动控制器组件的情况下保留在渲染线程上，大概是设置相关试图拓展的投影矩阵
		for (auto& ViewExt : GEngine->ViewExtensions->GatherActiveExtensions())
        {
			ViewExt->SetupViewProjectionMatrix(ProjectionData);
		};
	}
	else
	{	// 有三维渲染
		// Let the stereoscopic rendering device handle creating its own projection matrix, as needed
        // 让立体渲染设备根据需要处理创建自己的投影矩阵，调用一系列函数GetProjectMatrix
		ProjectionData.ProjectionMatrix = GEngine->StereoRenderingDevice->GetStereoProjectionMatrix(StereoPass);

		// calculate the out rect
		ProjectionData.SetViewRectangle(FIntRect(X, Y, X + SizeX, Y + SizeY));
	}

	return true;
}
```







难点：计算给定视图投影矩阵

```c++
void FMinimalViewInfo::CalculateProjectionMatrixGivenView(const FMinimalViewInfo& ViewInfo, TEnumAsByte<enum EAspectRatioAxisConstraint> AspectRatioAxisConstraint, FViewport* Viewport, FSceneViewProjectionData& InOutProjectionData)
{
	// Create the projection matrix (and possibly constrain the view rectangle)
    // 创建投影矩阵(并可能约束视图矩形)
	if (ViewInfo.bConstrainAspectRatio)
	{
		// Enforce a particular aspect ratio for the render of the scene. 
		// Results in black bars at top/bottom etc.
		InOutProjectionData.SetConstrainedViewRectangle(Viewport->CalculateViewExtents(ViewInfo.AspectRatio, InOutProjectionData.GetViewRect()));

		InOutProjectionData.ProjectionMatrix = ViewInfo.CalculateProjectionMatrix();
	}
	else
	{
		// Avoid divide by zero in the projection matrix calculation by clamping FOV
		float MatrixFOV = FMath::Max(0.001f, ViewInfo.FOV) * (float)PI / 360.0f;
		float XAxisMultiplier;
		float YAxisMultiplier;

		const FIntRect& ViewRect = InOutProjectionData.GetViewRect();
		const int32 SizeX = ViewRect.Width();
		const int32 SizeY = ViewRect.Height();

		// if x is bigger, and we're respecting x or major axis, AND mobile isn't forcing us to be Y axis aligned
		if (((SizeX > SizeY) && (AspectRatioAxisConstraint == AspectRatio_MajorAxisFOV)) || (AspectRatioAxisConstraint == AspectRatio_MaintainXFOV) || (ViewInfo.ProjectionMode == ECameraProjectionMode::Orthographic))
		{
			//if the viewport is wider than it is tall
			XAxisMultiplier = 1.0f;
			YAxisMultiplier = SizeX / (float)SizeY;
		}
		else
		{
			//if the viewport is taller than it is wide
			XAxisMultiplier = SizeY / (float)SizeX;
			YAxisMultiplier = 1.0f;
		}
	
		if (ViewInfo.ProjectionMode == ECameraProjectionMode::Orthographic)
		{	//判断投影模式
			const float OrthoWidth = ViewInfo.OrthoWidth / 2.0f * XAxisMultiplier;
			const float OrthoHeight = (ViewInfo.OrthoWidth / 2.0f) / YAxisMultiplier;

			const float NearPlane = ViewInfo.OrthoNearClipPlane;
			const float FarPlane = ViewInfo.OrthoFarClipPlane;

			const float ZScale = 1.0f / (FarPlane - NearPlane);
			const float ZOffset = -NearPlane;

			InOutProjectionData.ProjectionMatrix = FReversedZOrthoMatrix( // 计算反向Z正交矩阵
				OrthoWidth, 
				OrthoHeight,
				ZScale,
				ZOffset
				);		
		}
		else
		{
			InOutProjectionData.ProjectionMatrix = FReversedZPerspectiveMatrix(	// 反转Z透视矩阵
				MatrixFOV,
				MatrixFOV,
				XAxisMultiplier,
				YAxisMultiplier,
				GNearClippingPlane,
				GNearClippingPlane
				);
		}
	}

	if (!ViewInfo.OffCenterProjectionOffset.IsZero())
	{
		const float Left = -1.0f + ViewInfo.OffCenterProjectionOffset.X;
		const float Right = Left + 2.0f;
		const float Bottom = -1.0f + ViewInfo.OffCenterProjectionOffset.Y;
		const float Top = Bottom + 2.0f;
		InOutProjectionData.ProjectionMatrix.M[2][0] = (Left + Right) / (Left - Right);
		InOutProjectionData.ProjectionMatrix.M[2][1] = (Bottom + Top) / (Bottom - Top);
	}
}
```



反向Z正交：

```c++
FORCEINLINE FReversedZOrthoMatrix::FReversedZOrthoMatrix(float Width,float Height,float ZScale,float ZOffset)
	: FMatrix(
		FPlane((Width != 0.0f) ? (1.0f / Width) : 1.0f, 0.0f, 0.0f, 0.0f),
		FPlane(0.0f, (Height != 0.0f) ? (1.0f / Height) : 1.f, 0.0f, 0.0f),
		FPlane(0.0f, 0.0f, -ZScale, 0.0f),
		FPlane(0.0f, 0.0f, 1.0f - ZOffset * ZScale, 1.0f)
	)
{ }
```





难点2：

```c++
void FSceneView::DeprojectScreenToWorld(const FVector2D& ScreenPos, const FIntRect& ViewRect, const FMatrix& InvViewProjMatrix, FVector& out_WorldOrigin, FVector& out_WorldDirection)
{
	float PixelX = FMath::TruncToFloat(ScreenPos.X);
	float PixelY = FMath::TruncToFloat(ScreenPos.Y);

	// Get the eye position and direction of the mouse cursor in two stages (inverse transform projection, then inverse transform view).
    // //分两个阶段获取鼠标光标的眼睛位置和方向(逆变换投影，然后逆变换视图)。
    
	// This avoids the numerical instability that occurs when a view matrix with large translation is composed with a projection matrix
	// //这避免了当具有大平移的视图矩阵由投影矩阵组成时出现的数值不稳定性
    
	// Get the pixel coordinates into 0..1 normalized coordinates within the constrained view rectangle
    // 将像素坐标转换为0..1约束视图矩形内的标准化坐标
	const float NormalizedX = (PixelX - ViewRect.Min.X) / ((float)ViewRect.Width());
	const float NormalizedY = (PixelY - ViewRect.Min.Y) / ((float)ViewRect.Height());

	// Get the pixel coordinates into -1..1 projection space
    // 将像素坐标转换为-1..1投影空间
	const float ScreenSpaceX = (NormalizedX - 0.5f) * 2.0f;
	const float ScreenSpaceY = ((1.0f - NormalizedY) - 0.5f) * 2.0f;

	// The start of the ray trace is defined to be at mousex,mousey,1 in projection space (z=1 is near, z=0 is far - this gives us better precision)
    // //光线跟踪的开始被定义为在投影空间中mousex，mousey，1处(z = 1是近的，z=0是远的-这给了我们更好的精度)
	// To get the direction of the ray trace we need to use any z between the near and the far plane, so let's use (mousex, mousey, 0.5)
    // //为了得到光线轨迹的方向，我们需要使用近平面和远平面之间的任何z，所以让我们使用(mousex，mousey，0.5)
	const FVector4 RayStartProjectionSpace = FVector4(ScreenSpaceX, ScreenSpaceY, 1.0f, 1.0f);
	const FVector4 RayEndProjectionSpace = FVector4(ScreenSpaceX, ScreenSpaceY, 0.5f, 1.0f);

	// Projection (changing the W coordinate) is not handled by the FMatrix transforms that work with vectors, so multiplications
    // //投影(改变w坐标)不是由处理向量的矩阵变换来处理的，所以乘法
    
	// by the projection matrix should use homogeneous coordinates (i.e. FPlane).
    // 由投影矩阵应使用齐次坐标(即平面)。
	const FVector4 HGRayStartWorldSpace = InvViewProjMatrix.TransformFVector4(RayStartProjectionSpace);
	const FVector4 HGRayEndWorldSpace = InvViewProjMatrix.TransformFVector4(RayEndProjectionSpace);
	FVector RayStartWorldSpace(HGRayStartWorldSpace.X, HGRayStartWorldSpace.Y, HGRayStartWorldSpace.Z);
	FVector RayEndWorldSpace(HGRayEndWorldSpace.X, HGRayEndWorldSpace.Y, HGRayEndWorldSpace.Z);
	// divide vectors by W to undo any projection and get the 3-space coordinate
    // //将向量除以w以撤销任何投影并获得3-空间坐标
	if (HGRayStartWorldSpace.W != 0.0f)
	{
		RayStartWorldSpace /= HGRayStartWorldSpace.W;
	}
	if (HGRayEndWorldSpace.W != 0.0f)
	{
		RayEndWorldSpace /= HGRayEndWorldSpace.W;
	}
	const FVector RayDirWorldSpace = (RayEndWorldSpace - RayStartWorldSpace).GetSafeNormal();

	// Finally, store the results in the outputs
	out_WorldOrigin = RayStartWorldSpace;
	out_WorldDirection = RayDirWorldSpace;
}
```



FPlane:

![image-20200527171849104](https://i.loli.net/2020/05/30/n8XWuBra6s3IpTv.png)

FMatrix:

```C++
FORCEINLINE FMatrix::FMatrix(const FPlane& InX,const FPlane& InY,const FPlane& InZ,const FPlane& InW)
{
	M[0][0] = InX.X; M[0][1] = InX.Y;  M[0][2] = InX.Z;  M[0][3] = InX.W;
	M[1][0] = InY.X; M[1][1] = InY.Y;  M[1][2] = InY.Z;  M[1][3] = InY.W;
	M[2][0] = InZ.X; M[2][1] = InZ.Y;  M[2][2] = InZ.Z;  M[2][3] = InZ.W;
	M[3][0] = InW.X; M[3][1] = InW.Y;  M[3][2] = InW.Z;  M[3][3] = InW.W;
}

FORCEINLINE FMatrix::FMatrix(const FVector& InX,const FVector& InY,const FVector& InZ,const FVector& InW)
{
	M[0][0] = InX.X; M[0][1] = InX.Y;  M[0][2] = InX.Z;  M[0][3] = 0.0f;
	M[1][0] = InY.X; M[1][1] = InY.Y;  M[1][2] = InY.Z;  M[1][3] = 0.0f;
	M[2][0] = InZ.X; M[2][1] = InZ.Y;  M[2][2] = InZ.Z;  M[2][3] = 0.0f;
	M[3][0] = InW.X; M[3][1] = InW.Y;  M[3][2] = InW.Z;  M[3][3] = 1.0f;
}
```



step1:

![Camera](https://i.loli.net/2020/05/30/iDu86t3ewgBhp9x.png)

### API UGameplayStatics::ProjectWorldToScreen

将给定的3D世界空间点转换为其2D屏幕空间坐标。

![c1](https://i.loli.net/2020/05/30/y81kPdDXGxvQVfw.png)

API地址： https://docs.unrealengine.com/en-US/API/Runtime/Engine/Kismet/UGameplayStatics/ProjectWorldToScreen/index.html

语法：

```c++
static bool ProjectWorldToScreen
(
    APlayerController const * Player,
    const FVector & WorldPosition,
    FVector2D & ScreenPosition,
    bool bPlayerViewportRelative	//这是否应该与玩家视窗子区域相关(在分割屏幕中使用玩家附加的小部件时很有用)
)
```







![img](https://i.loli.net/2020/05/30/ivVjpJ7gxMwCLmd.png)











### Z-Buffer

用Renderdoc对UE4(PC，DX11）截帧，UE4的版本为4.18. 可以看到UE4一帧画面的渲染过程如下

![图片描述](https://i.loli.net/2020/05/30/XsihEuColdnvbVm.png)

