---
title: "UE4多线程"
date: 2020-06-02T20:00:46+08:00
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
- UE
- C++
series:
- UE
categories:
-
---









==通常的游戏引擎中游戏线程和渲染线程都是独立的，相互之间会存在一个同步的机制==

<!--more-->

# KeyWord:

## UMG

虚幻示意图形界面设计器（Unreal Motion Graphics UI Designer）(UMG) 是一个可视化的UI创作工具，可以用来创建UI元素，如游戏中的HUD、菜单或您希望呈现给用户的其他界面相关图形。UMG的核心是控件，这些控件是一系列预先制作的函数，可用于构建界面（如按钮、复选框、滑块、进度条等）。这些控件在专门的控件蓝图中编辑，该蓝图使用两个选项卡进行构造：设计器（Designer）选项卡允许界面和基本函数的可视化布局，而图表（Graph）选项卡提供所使用控件背后的功能。

## Slate

Slate 是完全自定义、与平台无关的用户界面框架，旨在让工具和应用程序（比如虚幻编辑器）的用户界面或游戏中用户界面的构建过程变得有趣、高效。它将声明性语法与轻松设计、布局和风格组件的功能相结合，允许在UI上轻松实现创建和迭代。

Slate UI解决方案使得为工具和应用程序组合图形用户界面和快速迭代这些界面变得极其简单。

## RHICmdList

这是一组独特的宏，用于将操作发送到渲染线程进行操作。

主要是对Texture之类的数据在GPU以及GPU相关的指令进行执行。

#  渲染线程的通信

参考链接：

1. [《Exploring in UE4》多线程机制详解[原理分析]](https://zhuanlan.zhihu.com/p/38881269)
2. [纹理和采样器](https://www.cnblogs.com/luming1979/p/3629746.html)
3. [虚幻4 Task Graph System 介绍](http://altdev.io/2016/11/24/intro-ue4-task-graph-system/)

## 预览

UE4引擎运行时的部分线程，在UE中，许多模块都使用多线程，如渲染模块、物理模块、网络通信、音频系统、IO：

![运行线程](https://i.loli.net/2020/06/01/D9HjVSpwuRzGkfx.jpg)



虽然UE4遵循C++11的标准，但是他并没有使用std::thread，而是自己实现了一套多线程机制（应该是从UE3时代就有了，未考证），用法上很像Java。

## 使用线程

在UE4里面，使用线程有三个方法：

1. 我们可以自己继承FRunnable接口创建单个线程
2. 直接创建AsyncTask来调用线程池里面空闲的线程
3. 通过TaskGraph系统来异步完成一些自定义任务。

### FRunnable

线索：

| 模块    | Core                                              |
| ------- | ------------------------------------------------- |
| .h      | /Engine/Source/Runtime/Core/Public/HAL/Runnable.h |
| include | #include "HAL/Runnable.h"                         |

> UE4中最基础的模型就是FRunnable和FRunnableThread，FRunnable抽象出一个可以执行在线程上的对象，而FRunnableThread是平台无关的线程对象的抽象。后面的篇幅会详细讨论这些基础设施。

创建一个继承于FRunnable的类，FRunnable声明如下：

> FRunnable就是一个很简单的类，里面只有5，6个函数接口，为了与真正的线程区分，我这里称FRunnable为“线程执行体”；**所谓真正的线程其实就是FRunnableThread，不同平台的线程都继承自他，如FRunnableThreadWin，里面会调用Windows平台的创建线程的API接口。**

```c++
class CORE_API FRunnable
{
public:

	/**
	 * Initializes the runnable object.
	 *
	 * This method is called in the context of the thread object that aggregates this, not the
	 * thread that passes this runnable to a new thread.
	 *
	 * @return True if initialization was successful, false otherwise
	 * @see Run, Stop, Exit
	 */
	virtual bool Init()
	{
		return true;
	}

	/**
	 * Runs the runnable object.
	 *
	 * This is where all per object thread work is done. This is only called if the initialization was successful.
	 *
	 * @return The exit code of the runnable object
	 * @see Init, Stop, Exit
	 */
	virtual uint32 Run() = 0;

	/**
	 * Stops the runnable object.
	 *
	 * This is called if a thread is requested to terminate early.
	 * @see Init, Run, Exit
	 */
	virtual void Stop() { }

	/**
	 * Exits the runnable object.
	 *
	 * Called in the context of the aggregating thread to perform any cleanup.
	 * @see Init, Run, Stop
	 */
	virtual void Exit() { }

	/**
	 * Gets single thread interface pointer used for ticking this runnable when multi-threading is disabled.
	 * If the interface is not implemented, this runnable will not be ticked when FPlatformProcess::SupportsMultithreading() is false.
	 *
	 * @return Pointer to the single thread interface or nullptr if not implemented.
	 */
	virtual class FSingleThreadRunnable* GetSingleThreadInterface( )
	{
		return nullptr;
	}

	/** Virtual destructor */
	virtual ~FRunnable() { }
};

```

FRunnable与线程之间的关系类图：

UE4中的多线程模型用一句话概括为: A FRunnable runs on a FRunnableThread.

![FRunnable线程关系](https://i.loli.net/2020/06/01/Tqi48FAgPJtlGb5.jpg)

> ### FQueuedThreadPool线程池
>
> | 模块 | Core                                                       |
> | ---- | ---------------------------------------------------------- |
> |      | /Engine/Source/Runtime/Core/Public/Misc/QueuedThreadPool.h |
> |      | \#include "Misc/QueuedThreadPool.h"                        |
>
> FQueuedThreadPool。和一般的线程池实现类似，线程池里面维护了多个线程FQueuedThread与多个任务队列IQueuedWork，线程是按照队列的方式来排列的。
>
> 在线程池里面所有的线程都是FQueuedThread类型，不过更确切的说FQueuedThread是继承自FRunnable的线程执行体，每个FQueuedThread里面包含一个FRunnableThread作为内部成员。
>
> 相比一般的线程，FQueuedThread里面多了一个成员FEvent* DoWorkEvent，也就是说FQueuedThread里面是有一个事件触发机制的。那么这个事件机制的作用是什么？一般情况下来说，就是在没有任务的时候挂起这个线程，在添加并分配给该线程任务的时候激活他，不过你可以灵活运用它，在你需要的时候去动态控制线程任务的执行与暂停。
>
> ![preview](https://i.loli.net/2020/06/02/1bjih75VW2MDmc8.jpg)

### AsyncTask系统

AsyncTask系统是一套基于线程池的异步任务处理系统。

FAsyncTask有几个特点：

1. FAsyncTask是一个模板类，真正的AsyncTask需要你自己写。通过DoWork提供你要执行的具体任务，然后把你的类作为模板参数传过去
2. 使用FAsyncTask就默认你要使用UE提供的线程池FQueuedThreadPool，前面代码里说明了在引擎PreInit的时候会初始化线程池并返回一个指针GThreadPool。在执行FAsyncTask任务时，如果你在执行StartBackgroundTask的时候会默认使用GThreadPool线程池，当然你也可以在参数里面指定自己创建的线程池
3. 创建FAsyncTask并不一定要使用新的线程，你可以调用函数StartSynchronousTask直接在当前线程上执行任务
4. FAsyncTask本身包含一个DoneEvent，任务执行完成的时候会激活该事件。当你想等待一个任务完成时再做其他操作，就可以调用EnsureCompletion函数，他可以从队列里面取出来还没被执行的任务放到当前线程来做，也可以挂起当前线程等待DoneEvent激活后再往下执行

![preview](https://i.loli.net/2020/06/02/2csrlOwGZ8dNvPu.jpg)

### Task Graph 系统

**Task Graph 系统是UE4一套抽象的异步任务处理系统，可以创建多个多线程任务，指定各个任务之间的依赖关系，按照该关系来依次处理任务。**

Tick函数

平时调试的时候，我们随便找个Tick断点一下都能看到类似下图这样的函数堆栈。如果你前面的章节都看懂的话，这个堆栈也能大概理解。World在执行Tick的时候，触发了FNamedTaskThread线程去执行任务（FTickFunctionTask），任务FTickFunctionTask具体的工作内容就是执行ACtorComponent的Tick函数。其实，这个堆栈也说明了所有Actor与Component的Tick都是通过TaskGraph系统来执行的（在TG_PrePhysics阶段）。

![preview](https://i.loli.net/2020/06/02/oShNK2wb5IHnDPU.jpg)



![taskgraphsystemuml](https://i.loli.net/2020/06/02/2UdeVt18hGn9pkI.png)

### Cconclusion

==对于消耗大的，复杂的任务不建议使用TaskGraph，一是因为TaskGraph如果被分配到游戏线程，就会阻塞整个游戏线程的执行，二是即使你不在那几个有名字的线程上执行，也可能会影响到游戏的其他逻辑。==



全家福：

![preview](https://pic2.zhimg.com/v2-9d28ba5e5b38bc739255a44852df3729_r.jpg)



## 线程同步

UE4对操作系统提供的线程同步相关接口进行了一定的封装。

### Atomics

......

