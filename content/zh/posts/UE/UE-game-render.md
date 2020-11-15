---
title: "UE游戏、渲染线程"
date: 2020-06-03T9:42:11+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: outer
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









探索UE4游戏线程的进入

<!--more-->

# 游戏线程 & 渲染线程

## UE4游戏线程启动

游戏线程每一帧更新所有内容。

![Engine-tick](https://i.loli.net/2020/06/03/6G8g1SuDJYdNUvj.png)

这个tick是哪里打开的？

头文件：`Engine\Source\Runtime\Launch\Private\Launch.cpp`

![image-20200603204559269](https://i.loli.net/2020/06/03/aUNMnRZjwWKtG9D.png)

`Lauch.cpp`定义了一个全局的变量`FEngineLoop GEngineLoop;`

![image-20200603204743789](https://i.loli.net/2020/06/03/iTmBd3hLfEpAlSj.png)

该类路径：`Engine\Source\Runtime\Launch\Public\LaunchEngineLoop.h`，继承一个接口类`IEngineLoop`，定义如下：

```c++
/**
 * Implements the main engine loop.	
 */
class FEngineLoop
#if WITH_ENGINE
	: public IEngineLoop
#endif
{
public:
	/** Default constructor. */
	FEngineLoop();
	virtual ~FEngineLoop() { }
public:
	/**
	 * Pre-Initialize the main loop, and generates the commandline from standard ArgC/ArgV from main().
	 *
	 * @param ArgC The number of strings in ArgV.
	 * @param ArgV The command line parameters (ArgV[0] is expected to be the executable name).
	 * @param AdditionalCommandLine Optional string to append to the command line (after ArgV is put together).
	 * @return Returns the error level, 0 if successful and > 0 if there were errors.
	 */ 
	int32 PreInit(int32 ArgC, TCHAR* ArgV[], const TCHAR* AdditionalCommandline = nullptr);

	/**
	 * Pre-Initialize the main loop - parse command line, sets up GIsEditor, etc.
	 *
	 * @param CmdLine The command line.
	 * @return The error level; 0 if successful, > 0 if there were errors.
	 */ 
	int32 PreInit(const TCHAR* CmdLine);
	
	/** First part of PreInit. */
	int32 PreInitPreStartupScreen(const TCHAR* CmdLine);

	/** Second part of PreInit. */
	int32 PreInitPostStartupScreen(const TCHAR* CmdLine);

	/** Load all modules needed before Init. */ 
	void LoadPreInitModules();

	/** Load core modules. */
	bool LoadCoreModules();

	/** Clean up PreInit context. */
	void CleanupPreInitContext();

#if WITH_ENGINE
	
	/** Load all core modules needed at startup time. */
	bool LoadStartupCoreModules();
	
	/** Load all modules needed at startup time. */
	bool LoadStartupModules();

	/**
	 * Initialize the main loop (the rest of the initialization).
	 *
	 * @return The error level; 0 if successful, > 0 if there were errors.
	 */ 
	virtual int32 Init() override;

	/** Initialize the timing options from the command line. */ 
	void InitTime();

	/** Performs shut down. */
	void Exit();

	/** Whether the engine should operate in an idle mode that uses no CPU or GPU time. */
	bool ShouldUseIdleMode() const;

	// Advances the main loop.推进主循环
	virtual void Tick() override;

	/** Removes references to any objects pending cleanup by deleting them. */
	virtual void ClearPendingCleanupObjects() override;

#endif // WITH_ENGINE

	/** RHI post-init initialization */
	static void PostInitRHI();

	/** Pre-init HMD device (if necessary). */
	static void PreInitHMDDevice();

public:

	/** Initializes the application. */
	static bool AppInit();

	/**
	 * Prepares the application for shutdown.
	 *
	 * This function is called from within guarded exit code, only during non-error exits.
	 */
	static void AppPreExit();

	/**
	 * Shuts down the application.
	 *
	 * This function called outside guarded exit code, during all exits (including error exits).
	 */
	static void AppExit();

private:

	/** Utility function that processes Slate operations. */
	void ProcessLocalPlayerSlateOperations() const;

protected:

	/** Holds a dynamically expanding array of frame times in milliseconds (if FApp::IsBenchmarking() is set). */
	TArray<float> FrameTimes;

	/** Holds the total time spent ticking engine. */
	double TotalTickTime;
	
	/** Holds the maximum number of seconds engine should be ticked. */
	double MaxTickTime;
	
	/** Holds the maximum number of frames to render in benchmarking mode. */
	uint64 MaxFrameCounter;
	
	/** Holds the number of cycles in the last frame. */
	uint32 LastFrameCycles;

#if WITH_ENGINE

	/** Holds the objects which need to be cleaned up when the rendering thread finishes the previous frame. */
	FPendingCleanupObjects* PendingCleanupObjects;

#endif //WITH_ENGINE

private:

#if WITH_ENGINE

	/** Holds the engine service. */
	FEngineService* EngineService;

	/** Holds the application session service. */
	TSharedPtr<ISessionService> SessionService;

#endif // WITH_ENGINE
	FPreInitContext PreInitContext;
};
```

> 该文件只需`#include "CoreMinimal.h"`，最多加上`#include "UnrealEngine.h"`

接口类，位于路径`Engine\Source\Runtime\Engine\Public\UnrealEngine.h`：

```c++
/** Public interface to FEngineLoop so we can call it from editor or editor code */
class IEngineLoop
{
public:
	virtual int32 Init() = 0;
	virtual void Tick() = 0;
	/** Removes references to any objects pending cleanup by deleting them. */
	virtual void ClearPendingCleanupObjects() = 0;
};
```

开启Tick函数之前需要初始化，初始化函数在`Launch.cpp`这个文件中：

```c++
/* Inits the engine loop */
int32 EngineInit()
{
	int32 ErrorLevel = GEngineLoop.Init();
	return( ErrorLevel );
}
```

`GEngineLoop.Init()`函数：

![image-20200603212333812](https://i.loli.net/2020/06/03/rwpz7L14h9xPnZ8.png)

其中会判断是进入那种引擎模式，分为Game模式与Editor模式。



结束引擎的函数为：

```c++
/**
 * Shuts down the engine
 */
void EngineExit( void )
{
	// Make sure this is set
	RequestEngineExit(TEXT("EngineExit() was called"));

	GEngineLoop.Exit();
}
```

也在`Launch.cpp`

`Launch.cpp`中的函数多次使用`GEngine`这个外部变量，这个变量在上面的初始化函数会自定设置为相应的引擎，即Game引擎或者Editor引擎：

> 所在文件`Engine.h`

![image-20200603212911727](https://i.loli.net/2020/06/03/zRKn8ihmTPvtJHX.png)

在`FEngineLoop::Tick()`函数会调用`GEngine`的Tick函数：

![image-20200603213738709](https://i.loli.net/2020/06/03/oJxdiA2URfC8rqH.png)

也就是本文开始的那个`Tick`函数。


