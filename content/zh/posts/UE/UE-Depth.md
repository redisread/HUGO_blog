---
title: "UE4获取深度值"
date: 2020-06-15T9:42:11+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
image: https://i.loli.net/2020/06/15/ivEDkwYhIQ5xVn7.png
libraries:
- katex
- mathjax
tags:
- c++
- UE4
- 游戏引擎
series:
categories:
- UE4开发
---





在UE4中获取深度缓存，调用渲染命令读取。

<!--more-->

# 获取深度缓存

## 深度像素格式

![DepthPixel](https://i.loli.net/2020/06/15/G3emJyTbYv5Zx4H.png)



键入命令vis scenedepthz uv0以查看实际使用的深度缓冲区。UE4对场景使用“反向”深度缓冲区。



## Way1：直接使用ENQUEUE_RENDER_COMMAND命令获取(效率较低)



在任意`tick`函数或者其他函数添加以下的命令：

```c++
struct DepthPixel	//定义深度像素结构体
	{
		float depth;
		char stencil;
		char unused1;
		char unused2;
		char unused3;
	};

	float* cpuDataPtr;	// Texture深度值数组首地址
	TArray<DepthPixel> mydata;	//最终获取色深度值数据
	FIntPoint buffsize;	//深度长宽大小X和Y

	ENQUEUE_RENDER_COMMAND(ReadSurfaceFloatCommand)(	// 将读取深度数据的命令推给渲染线程进行执行
		[&cpuDataPtr, &mydata, &buffsize](FRHICommandListImmediate& RHICmdList) //&cpuDataPtr, &mydata, &buffsize为传入的外部参数
	{
		FSceneRenderTargets::Get(RHICmdList).AdjustGBufferRefCount(RHICmdList, 1);
		FTexture2DRHIRef uTex2DRes = FSceneRenderTargets::Get(RHICmdList).GetSceneDepthSurface();	
		buffsize = uTex2DRes->GetSizeXY();
         uint32 sx = buffsize.X;
		uint32 sy = buffsize.Y;
         mydata.AddUninitialized(sx * sy);
         uint32 Lolstrid = 0;
		cpuDataPtr = (float*)RHILockTexture2D(uTex2DRes,0,RLM_ReadOnly,Lolstrid,true);	// 加锁 获取可读depth Texture深度值数组首地址
		memcpy(mydata.GetData(), cpuDataPtr, sx * sy * sizeof(DepthPixel));		//复制深度数据
		RHIUnlockTexture2D(uTex2DRes, 0, true);	//解锁
		FSceneRenderTargets::Get(RHICmdList).AdjustGBufferRefCount(RHICmdList, -1);	

	});
	FlushRenderingCommands();	//等待渲染线程执行

	mydata; 	//最终获取深度数据
```

最终返回的`mydata`数据就是最终的深度值数组，其中每个深度值的结构是`DepthPixel`，其中一个成员为`depth`，另外四个不不使用。其中使用上面的几个命令需要添加"`RHI.h`"头文件

## Way2：写个请求类读取
UML图：
![depth_UML](https://i.loli.net/2020/06/29/BrpD1iKkXm3P2Qn.png)
流程图：
![depth-flowchat](https://i.loli.net/2020/06/29/JRovQn1dOH9hL7I.png)

### 1. 首先在项目的build.cs文件添加：

添加引擎源码地址

```c#
        // 添加引擎源码地址
        string EnginePath = "C:/Program Files (x86)/UE4+VS2017/UnrealEngine/";
        PrivateIncludePaths.AddRange(
            new string[] {
               EnginePath + "Source/Runtime/Renderer/Private",
               EnginePath + "Source/Runtime/Renderer/Private/CompositionLighting",
               EnginePath + "Source/Runtime/Renderer/Private/PostProcess"
                }
            );

```

添加引依赖项

![依赖项](https://i.loli.net/2020/06/14/16zcGinV2vbgt8d.png)

### 2. 类实现

将下面类代码复制到`PostProcessing.h`文件任意位置：

```c++
/*****************************************Get Depth Class*******************************************************/

/*	存储一个像素的缓存
	depth   深度缓存
	stencil （抠图缓存）*/
struct DepthPixel
{
	float depth;
	char stencil;
	char unused1;
	char unused2;
	char unused3;
};

/*	存储整个视窗的缓存
	data			像素缓存数组
	bufferSizeX		缓存大小X
	bufferSizeY		缓存大小Y
	pixelSizeBytes	像素缓存字节数*/
struct DepthResult
{
	TArray<DepthPixel> data;
	int bufferSizeX;
	int bufferSizeY;
	int pixelSizeBytes;
};

/*	获取深度缓存的类	 */
class RENDERER_API DepthCapture
{
public:
	/*	静态成员，当用户发出一个获取深度缓存的请求后，waitForCapture长度加1，新增DepthResult内容为空
				当系统完成一个深度缓存的请求后，waitForCapture长度减一 */
	static TQueue<DepthResult *, EQueueMode::Mpsc> waitForCapture;
	/*	静态成员，当系统完成一个深度缓存的请求后，finishedCapture长度加1，
				新增DepthResult含有深度缓存信息	*/
	static TQueue<DepthResult *, EQueueMode::Mpsc> finishedCapture;

public:
	/*用户发出一个获取深度缓存的请求时调用*/
	static void AddCapture()
	{
		waitForCapture.Enqueue(new DepthResult());
	}
	/*系统完成一个深度缓存请求后调用*/
	static void FinishedCapture(DepthResult *result)
	{
		finishedCapture.Enqueue(result);
	}
	/*返回是否存在已经完成的请求*/
	static bool HasFinishedCapture()
	{
		return !finishedCapture.IsEmpty();
	}
	/*如果存在已完成的请求，返回一个深度结果*/
	static DepthResult* GetIfExistFinished()
	{
		DepthResult* result = NULL;
		if (!finishedCapture.IsEmpty())
		{
			finishedCapture.Dequeue(result);
		}
		return result;
	}
	/*返回是否存在等待系统执行的请求*/
	static bool HasCaptureRequest()
	{
		return !waitForCapture.IsEmpty();
	}
	/*如果存在待完成的请求，返回一个深度结果（为空）*/
	static DepthResult* GetIfExistRequest()
	{
		DepthResult* result = NULL;
		if (!waitForCapture.IsEmpty())
		{
			waitForCapture.Dequeue(result);
		}
		return result;
	}
	//friend void AddPostProcessingPasses(FRDGBuilder& GraphBuilder, const FViewInfo& View, const FPostProcessingInputs& Inputs);
};

/*****************************************end******************************************************/
```

将下面类中静态成员初始化和添加执行获取代码代码复制到`PostProcessing.cpp`文件任意位置：

```c++
/*类静态成员的定义*/
TQueue<DepthResult *, EQueueMode::Mpsc> DepthCapture::waitForCapture;
TQueue< DepthResult *, EQueueMode::Mpsc> DepthCapture::finishedCapture;

/*获取深度缓存*/
void AddDepthInspectorPass(FRDGBuilder& GraphBuilder, const FViewInfo& View, DepthResult* result)
{

	RDG_EVENT_SCOPE(GraphBuilder, "DepthInspector");
	{
		// 获取渲染对象
		FSceneRenderTargets& renderTargets = FSceneRenderTargets::Get(GRHICommandList.GetImmediateCommandList());

		// 定义拷贝参数
		uint32 striped = 0;
		FIntPoint size = renderTargets.GetBufferSizeXY();
		result->bufferSizeX = size.X;
		result->bufferSizeY = size.Y;
		result->data.AddUninitialized(size.X * size.Y);

		// 获取视窗某一帧的深度缓存对象
		FRHITexture2D* depthTexture = (FRHITexture2D *)renderTargets.SceneDepthZ->GetRenderTargetItem().TargetableTexture.GetReference();

		// 执行拷贝深度缓存操作，将GPU显存中的缓存信息拷贝到CPU内存中，返回指向这块CPU内存的首地址
		void* buffer = RHILockTexture2D(depthTexture, 0, EResourceLockMode::RLM_ReadOnly, striped, true);

		// 将缓存结果拷贝到result，用于输出
		memcpy(result->data.GetData(), buffer, size.X * size.Y * 8);

		// 必须执行解锁语句，否则被锁住的GPU缓存信息将不能释放
		RHIUnlockTexture2D(depthTexture, 0, true);

		// 拷贝结果入队
		DepthCapture::FinishedCapture(result);
	}
}
////////////////////////////////////////
```

`PostProcessing.cpp`中该位置添加以下代码：

![添加代码](https://i.loli.net/2020/06/15/w7NKxStlWrdGyBZ.png)

代码如下：

```c++
	// Capture depth buffer，otherwise the buffer will be changed
	if (DepthCapture::HasCaptureRequest())
	{
		DepthResult *reuslt;
		reuslt = DepthCapture::GetIfExistRequest();
		if (reuslt)
		{
			AddDepthInspectorPass(GraphBuilder, View, reuslt);
		}
	}
```

### 3. 调用

使用以下的代码可以获取深度值，获取的结果为`result`：

```c++
int tickcount = 0;
// Called every frame
void ATestPawn::Tick(float DeltaTime)
{
 tickcount++;
 if (tickcount % 2 == 0)	// 设计几帧调用
  DepthCapture::AddCapture();  // 定时发出获取深度缓存的请求

 // 如果存在已完成的深度缓存请求
 if (DepthCapture::HasFinishedCapture())
 {
  DepthResult *result;
  // 获取已完成的深度缓存结果
  result = DepthCapture::GetIfExistFinished();
  if (result)
  {
   int n = result->data.Num();
   //this is test
   GEngine->AddOnScreenDebugMessage(-1, -1, FColor::Blue, FString::Printf(TEXT("Get Depth Size: %d "), n));
  }
 }
}
```




