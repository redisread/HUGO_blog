---
title: "UE游戏、渲染线程"
date: 2020-06-03T9:42:11+08:00
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





研究tick函数：

```c++
void FEngineLoop::Tick()
{
    // make sure to catch any FMemStack uses outside of UWorld::Tick
    FMemMark MemStackMark(FMemStack::Get());
#if !UE_BUILD_SHIPPING && !UE_BUILD_TEST && MALLOC_GT_HOOKS
	FScopedSampleMallocChurn ChurnTracker;
#endif
	// let the low level mem tracker pump once a frame to update states
	LLM(FLowLevelMemTracker::Get().UpdateStatsPerFrame());
	LLM_SCOPE(ELLMTag::EngineMisc);
	// Send a heartbeat for the diagnostics thread
	FThreadHeartBeat::Get().HeartBeat(true);
	FGameThreadHitchHeartBeat::Get().FrameStart();
	FPlatformMisc::TickHotfixables();
	// Make sure something is ticking the rendering tickables in -onethread mode to avoid leaks/bugs.
	if (!GUseThreadedRendering && !GIsRenderingThreadSuspended.Load(EMemoryOrder::Relaxed))
	{
		TickRenderingTickables();
	}
	// Ensure we aren't starting a frame while loading or playing a loading movie
	ensure(GetMoviePlayer()->IsLoadingFinished() && !GetMoviePlayer()->IsMovieCurrentlyPlaying());

#if UE_EXTERNAL_PROFILING_ENABLED
	FExternalProfiler* ActiveProfiler = FActiveExternalProfilerBase::GetActiveProfiler();
	if (ActiveProfiler)
	{
		ActiveProfiler->FrameSync();
	}
#endif		// UE_EXTERNAL_PROFILING_ENABLED

	FPlatformMisc::BeginNamedEventFrame();
	uint64 CurrentFrameCounter = GFrameCounter;
	TCHAR IndexedFrameString[32] = { 0 };
	const TCHAR* FrameString = nullptr;
	if (UE_TRACE_CHANNELEXPR_IS_ENABLED(CpuChannel))
	{
		FrameString = TEXT("FEngineLoop");
	}
	else
	{
#if PLATFORM_LIMIT_PROFILER_UNIQUE_NAMED_EVENTS
		FrameString = TEXT("FEngineLoop");
#else
		FCString::Snprintf(IndexedFrameString, 32, TEXT("Frame %d"), CurrentFrameCounter);
		FrameString = IndexedFrameString;
#endif
	}
	SCOPED_NAMED_EVENT_TCHAR(FrameString, FColor::Red);

	// execute callbacks for cvar changes
	{
		QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_CallAllConsoleVariableSinks);
		IConsoleManager::Get().CallAllConsoleVariableSinks();
	}

	{
		TRACE_BEGIN_FRAME(TraceFrameType_Game);
		SCOPE_CYCLE_COUNTER(STAT_FrameTime);
		#if WITH_PROFILEGPU && !UE_BUILD_SHIPPING
			// Issue the measurement of the execution time of a basic LongGPUTask unit on the very first frame
			// The results will be retrived on the first call of IssueScalableLongGPUTask
			if (GFrameCounter == 0 && IsFeatureLevelSupported(GMaxRHIShaderPlatform, ERHIFeatureLevel::SM5) && FApp::CanEverRender())
			{
				FlushRenderingCommands();

				ENQUEUE_RENDER_COMMAND(MeasureLongGPUTaskExecutionTimeCmd)(
					[](FRHICommandListImmediate& RHICmdList)
					{
						MeasureLongGPUTaskExecutionTime(RHICmdList);
					});
			}
		#endif

		FCoreDelegates::OnBeginFrame.Broadcast();

		// flush debug output which has been buffered by other threads
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_FlushThreadedLogs); 
			GLog->FlushThreadedLogs();
		}

		// exit if frame limit is reached in benchmark mode, or if time limit is reached
		if ((FApp::IsBenchmarking() && MaxFrameCounter && (GFrameCounter > MaxFrameCounter)) ||
			(MaxTickTime && (TotalTickTime > MaxTickTime)))
		{
			FPlatformMisc::RequestExit(0);
		}

		// set FApp::CurrentTime, FApp::DeltaTime and potentially wait to enforce max tick rate
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_UpdateTimeAndHandleMaxTickRate);
			GEngine->UpdateTimeAndHandleMaxTickRate();
		}

		for (const FWorldContext& Context : GEngine->GetWorldContexts())
		{
			UWorld* CurrentWorld = Context.World();
			if (CurrentWorld)
			{
				FSceneInterface* Scene = CurrentWorld->Scene;
				ENQUEUE_RENDER_COMMAND(UpdateScenePrimitives)(
					[Scene](FRHICommandListImmediate& RHICmdList)
				{
					Scene->UpdateAllPrimitiveSceneInfos(RHICmdList);
				});
			}
		}

		// beginning of RHI frame
		ENQUEUE_RENDER_COMMAND(BeginFrame)([CurrentFrameCounter](FRHICommandListImmediate& RHICmdList)
		{
			BeginFrameRenderThread(RHICmdList, CurrentFrameCounter);
		});

		for (const FWorldContext& Context : GEngine->GetWorldContexts())
		{
			UWorld* CurrentWorld = Context.World();
			if (CurrentWorld)
			{
				FSceneInterface* Scene = CurrentWorld->Scene;

				ENQUEUE_RENDER_COMMAND(SceneStartFrame)([Scene](FRHICommandListImmediate& RHICmdList)
				{
					Scene->StartFrame();
				});
			}
		}

#if !UE_SERVER && WITH_ENGINE
		if (!GIsEditor && GEngine->GameViewport && GEngine->GameViewport->GetWorld() && GEngine->GameViewport->GetWorld()->IsCameraMoveable())
		{
			// When not in editor, we emit dynamic resolution's begin frame right after RHI's.
			GEngine->EmitDynamicResolutionEvent(EDynamicResolutionStateEvent::BeginFrame);
		}
		#endif

		// tick performance monitoring
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_TickFPSChart);
			GEngine->TickPerformanceMonitoring( FApp::GetDeltaTime() );

			extern COREUOBJECT_API void ResetAsyncLoadingStats();
			ResetAsyncLoadingStats();
		}

		// update memory allocator stats
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Malloc_UpdateStats);
			GMalloc->UpdateStats();
		}
	}

	FStats::AdvanceFrame( false, FStats::FOnAdvanceRenderingThreadStats::CreateStatic( &AdvanceRenderingThreadStatsGT ) );

	{
		SCOPE_CYCLE_COUNTER( STAT_FrameTime );

		// Calculates average FPS/MS (outside STATS on purpose)
		CalculateFPSTimings();

		// Note the start of a new frame
		MALLOC_PROFILER(GMalloc->Exec(nullptr, *FString::Printf(TEXT("SNAPSHOTMEMORYFRAME")),*GLog));

		// handle some per-frame tasks on the rendering thread
		ENQUEUE_RENDER_COMMAND(ResetDeferredUpdates)(
			[](FRHICommandList& RHICmdList)
			{
				FDeferredUpdateResource::ResetNeedsUpdate();
				FlushPendingDeleteRHIResources_RenderThread();
			});

		{
			SCOPE_CYCLE_COUNTER(STAT_PumpMessages);
			FPlatformApplicationMisc::PumpMessages(true);
		}

		bool bIdleMode;
		{

			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Idle);

			// Idle mode prevents ticking and rendering completely
			bIdleMode = ShouldUseIdleMode();
			if (bIdleMode)
			{
				// Yield CPU time
				FPlatformProcess::Sleep(.1f);
			}
		}

		// @todo vreditor urgent: Temporary hack to allow world-to-meters to be set before
		// input is polled for motion controller devices each frame.
		extern ENGINE_API float GNewWorldToMetersScale;
		if( GNewWorldToMetersScale != 0.0f  )
		{
#if WITH_ENGINE
			UWorld* WorldToScale = GWorld;

#if WITH_EDITOR
			if( GIsEditor && GEditor->PlayWorld != nullptr && GEditor->bIsSimulatingInEditor )
			{
				WorldToScale = GEditor->PlayWorld;
			}
#endif //WITH_EDITOR

			if( WorldToScale != nullptr )
		{
				if( GNewWorldToMetersScale != WorldToScale->GetWorldSettings()->WorldToMeters )
			{
					WorldToScale->GetWorldSettings()->WorldToMeters = GNewWorldToMetersScale;
			}
		}

			GNewWorldToMetersScale = 0.0f;
		}
#endif //WITH_ENGINE

		// tick active platform files
		FPlatformFileManager::Get().TickActivePlatformFile();

		// Roughly track the time when the input was sampled
		FCoreDelegates::OnSamplingInput.Broadcast();

		// process accumulated Slate input
		if (FSlateApplication::IsInitialized() && !bIdleMode)
		{
			CSV_SCOPED_TIMING_STAT_EXCLUSIVE(Input);
			SCOPE_TIME_GUARD(TEXT("SlateInput"));
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_SlateInput);
			LLM_SCOPE(ELLMTag::UI);

			FSlateApplication& SlateApp = FSlateApplication::Get();
            {
                QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_PollGameDeviceState);
                SlateApp.PollGameDeviceState();
            }
			// Gives widgets a chance to process any accumulated input
            {
                QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_FinishedInputThisFrame);
                SlateApp.FinishedInputThisFrame();
            }
		}

#if !UE_SERVER
		// tick media framework
		static const FName MediaModuleName(TEXT("Media"));
		IMediaModule* MediaModule = FModuleManager::LoadModulePtr<IMediaModule>(MediaModuleName);

		if (MediaModule != nullptr)
		{
			MediaModule->TickPreEngine();
		}
#endif

		// main game engine tick (world, game objects, etc.)
		GEngine->Tick(FApp::GetDeltaTime(), bIdleMode);

		// If a movie that is blocking the game thread has been playing,
		// wait for it to finish before we continue to tick or tick again
		// We do this right after GEngine->Tick() because that is where user code would initiate a load / movie.
		{
            if (FPreLoadScreenManager::Get())
            {
                if (FPreLoadScreenManager::Get()->HasRegisteredPreLoadScreenType(EPreLoadScreenTypes::EngineLoadingScreen))
                {
                    //Wait for any Engine Loading Screen to stop
                    if (FPreLoadScreenManager::Get()->HasActivePreLoadScreenType(EPreLoadScreenTypes::EngineLoadingScreen))
                    {
                        FPreLoadScreenManager::Get()->WaitForEngineLoadingScreenToFinish();
                    }

                    //Switch Game Window Back
                    UGameEngine* GameEngine = Cast<UGameEngine>(GEngine);
                    if (GameEngine)
                    {
                        GameEngine->SwitchGameWindowToUseGameViewport();
                    }
                }
                
                //Destroy / Clean Up PreLoadScreenManager as we are now done
                FPreLoadScreenManager::Destroy();
            }
			else
			{
				QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_WaitForMovieToFinish);
				GetMoviePlayer()->WaitForMovieToFinish(true);
			}
		}

		if (GShaderCompilingManager)
		{
			// Process any asynchronous shader compile results that are ready, limit execution time
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_GShaderCompilingManager);
			GShaderCompilingManager->ProcessAsyncResults(true, false);
		}

		if (GDistanceFieldAsyncQueue)
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_GDistanceFieldAsyncQueue);
			GDistanceFieldAsyncQueue->ProcessAsyncTasks();
		}

#if !UE_SERVER
		// tick media framework
		if (MediaModule != nullptr)
		{
			MediaModule->TickPreSlate();
		}
#endif

#if WITH_ENGINE
		// process concurrent Slate tasks
		FGraphEventRef ConcurrentTask;
		const bool bDoConcurrentSlateTick = GEngine->ShouldDoAsyncEndOfFrameTasks();

		const UGameViewportClient* const GameViewport = GEngine->GameViewport;
		const UWorld* const GameViewportWorld = GameViewport ? GameViewport->GetWorld() : nullptr;
		UDemoNetDriver* const CurrentDemoNetDriver = GameViewportWorld ? GameViewportWorld->DemoNetDriver : nullptr;

		// Optionally validate that Slate has not modified any replicated properties for client replay recording.
		FDemoSavedPropertyState PreSlateObjectStates;
		const bool bValidateReplicatedProperties = CurrentDemoNetDriver && CVarDoAsyncEndOfFrameTasksValidateReplicatedProperties.GetValueOnGameThread() != 0;
		if (bValidateReplicatedProperties)
		{
			PreSlateObjectStates = CurrentDemoNetDriver->SavePropertyState();
		}

		if (bDoConcurrentSlateTick)
		{
			const float DeltaSeconds = FApp::GetDeltaTime();

			if (CurrentDemoNetDriver && CurrentDemoNetDriver->ShouldTickFlushAsyncEndOfFrame())
			{
				ConcurrentTask = TGraphTask<FExecuteConcurrentWithSlateTickTask>::CreateTask(nullptr, ENamedThreads::GameThread).ConstructAndDispatchWhenReady(
					[CurrentDemoNetDriver, DeltaSeconds]()
				{
					if (CVarDoAsyncEndOfFrameTasksRandomize.GetValueOnAnyThread(true) > 0)
					{
						FPlatformProcess::Sleep(FMath::RandRange(0.0f, .003f)); // this shakes up the threading to find race conditions
					}

					if (CurrentDemoNetDriver != nullptr)
					{
						CurrentDemoNetDriver->TickFlushAsyncEndOfFrame(DeltaSeconds);
					}
				});
			}
		}
#endif

		// tick Slate application
		if (FSlateApplication::IsInitialized() && !bIdleMode)
		{
			{
				QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_ProcessPlayerControllersSlateOperations);
				check(!IsRunningDedicatedServer());

				// Process slate operations accumulated in the world ticks.
				ProcessLocalPlayerSlateOperations();
			}

			FSlateApplication::Get().Tick();
		}

#if WITH_ENGINE
		if (bValidateReplicatedProperties)
		{
			const bool bReplicatedPropertiesDifferent = CurrentDemoNetDriver->ComparePropertyState(PreSlateObjectStates);
			if (bReplicatedPropertiesDifferent)
			{
				UE_LOG(LogInit, Log, TEXT("Replicated properties changed during Slate tick!"));
			}
		}

		if (ConcurrentTask.GetReference())
		{
			CSV_SCOPED_TIMING_STAT(Basic, ConcurrentWithSlateTickTasks_Wait);

			QUICK_SCOPE_CYCLE_COUNTER(STAT_ConcurrentWithSlateTickTasks_Wait);
			FTaskGraphInterface::Get().WaitUntilTaskCompletes(ConcurrentTask);
			ConcurrentTask = nullptr;
		}
		{
			ENQUEUE_RENDER_COMMAND(WaitForOutstandingTasksOnly_for_DelaySceneRenderCompletion)(
				[](FRHICommandList& RHICmdList)
				{
					QUICK_SCOPE_CYCLE_COUNTER(STAT_DelaySceneRenderCompletion_TaskWait);
					FRHICommandListExecutor::GetImmediateCommandList().ImmediateFlush(EImmediateFlushType::WaitForOutstandingTasksOnly);
				});
		}
#endif

#if STATS
		// Clear any stat group notifications we have pending just in case they weren't claimed during FSlateApplication::Get().Tick
		extern CORE_API void ClearPendingStatGroups();
		ClearPendingStatGroups();
#endif

#if WITH_EDITOR && !UE_BUILD_SHIPPING
		// tick automation controller (Editor only)
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_AutomationController);
			static FName AutomationController("AutomationController");
			if (FModuleManager::Get().IsModuleLoaded(AutomationController))
			{
				FModuleManager::GetModuleChecked<IAutomationControllerModule>(AutomationController).Tick();
			}
		}
#endif

#if WITH_ENGINE && WITH_AUTOMATION_WORKER
		// tick automation worker
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_Tick_AutomationWorker);
			static const FName AutomationWorkerModuleName = TEXT("AutomationWorker");
			if (FModuleManager::Get().IsModuleLoaded(AutomationWorkerModuleName))
			{
				FModuleManager::GetModuleChecked<IAutomationWorkerModule>(AutomationWorkerModuleName).Tick();
			}
		}
#endif

		// tick render hardware interface
		{			
			SCOPE_CYCLE_COUNTER(STAT_RHITickTime);
			RHITick( FApp::GetDeltaTime() ); // Update RHI.
		}

		// Increment global frame counter. Once for each engine tick.
		GFrameCounter++;

		// Disregard first few ticks for total tick time as it includes loading and such.
		if (GFrameCounter > 6)
		{
			TotalTickTime += FApp::GetDeltaTime();
		}

		// Find the objects which need to be cleaned up the next frame.
		FPendingCleanupObjects* PreviousPendingCleanupObjects = PendingCleanupObjects;
		PendingCleanupObjects = GetPendingCleanupObjects();

		{
			SCOPE_CYCLE_COUNTER(STAT_FrameSyncTime);
			// this could be perhaps moved down to get greater parallelism
			// Sync game and render thread. Either total sync or allowing one frame lag.
			static FFrameEndSync FrameEndSync;
			static auto CVarAllowOneFrameThreadLag = IConsoleManager::Get().FindTConsoleVariableDataInt(TEXT("r.OneFrameThreadLag"));
			FrameEndSync.Sync( CVarAllowOneFrameThreadLag->GetValueOnGameThread() != 0 );
		}

		// tick core ticker, threads & deferred commands
		{
			SCOPE_CYCLE_COUNTER(STAT_DeferredTickTime);
			CSV_SCOPED_TIMING_STAT_EXCLUSIVE(DeferredTickTime);
			// Delete the objects which were enqueued for deferred cleanup before the previous frame.
			delete PreviousPendingCleanupObjects;

#if WITH_COREUOBJECT
			DeleteLoaders(); // destroy all linkers pending delete
#endif

			FTicker::GetCoreTicker().Tick(FApp::GetDeltaTime());
			FThreadManager::Get().Tick();
			GEngine->TickDeferredCommands();		
		}

#if !UE_SERVER
		// tick media framework
		if (MediaModule != nullptr)
		{
			QUICK_SCOPE_CYCLE_COUNTER(STAT_FEngineLoop_MediaTickPostRender);
			MediaModule->TickPostRender();
		}
#endif

		FCoreDelegates::OnEndFrame.Broadcast();

		#if !UE_SERVER && WITH_ENGINE
		{
			// We emit dynamic resolution's end frame right before RHI's. GEngine is going to ignore it if no BeginFrame was done.
			GEngine->EmitDynamicResolutionEvent(EDynamicResolutionStateEvent::EndFrame);
		}
		#endif

		// end of RHI frame
		ENQUEUE_RENDER_COMMAND(EndFrame)(
			[](FRHICommandListImmediate& RHICmdList)
			{
				EndFrameRenderThread(RHICmdList);
			});

		// Set CPU utilization stats.
		const FCPUTime CPUTime = FPlatformTime::GetCPUTime();
		SET_FLOAT_STAT( STAT_CPUTimePct, CPUTime.CPUTimePct );
		SET_FLOAT_STAT( STAT_CPUTimePctRelative, CPUTime.CPUTimePctRelative );

		// Set the UObject count stat
#if UE_GC_TRACK_OBJ_AVAILABLE
		SET_DWORD_STAT(STAT_Hash_NumObjects, GUObjectArray.GetObjectArrayNumMinusAvailable());
#endif
		TRACE_END_FRAME(TraceFrameType_Game);
	}

#if BUILD_EMBEDDED_APP
	static double LastSleepTime = FPlatformTime::Seconds();
	double TimeNow = FPlatformTime::Seconds();
	if (LastSleepTime > 0 && TimeNow - LastSleepTime >= CVarSecondsBeforeEmbeddedAppSleeps.GetValueOnAnyThread())
	{
		LastSleepTime = 0;
		FEmbeddedCommunication::AllowSleep(TEXT("FirstTicks"));
	}
#endif
}
```







* Inspectoreadpixel
* postprocessing
* 



C:\Program Files (x86)\UE4+VS2017\UnrealEngine\Engine\Source\Runtime\Renderer\Private\PostProcess\SceneRenderTargets.h



C:\Program Files (x86)\UE4+VS2017\UnrealEngine\Engine\Source\Runtime\Engine\Classes\Engine\World.h

C:\Program Files (x86)\UE4+VS2017\UnrealEngine\Engine\Source\Runtime\Renderer\Private\ScenePrivate.h



```c++
// Finish rendering for each view.
	if (ViewFamily.bResolveScene)
	{
		SCOPED_DRAW_EVENT(RHICmdList, PostProcessing);
		SCOPED_GPU_STAT(RHICmdList, Postprocessing);

		SCOPE_CYCLE_COUNTER(STAT_FinishRenderViewTargetTime);

		RHICmdList.SetCurrentStat(GET_STATID(STAT_CLM_PostProcessing));

		GRenderTargetPool.AddPhaseEvent(TEXT("PostProcessing"));

		FRDGBuilder GraphBuilder(RHICmdList);

		FSceneTextureParameters SceneTextures;
		SetupSceneTextureParameters(GraphBuilder, &SceneTextures);

		// Fallback to a black texture if no velocity.
		if (!SceneTextures.SceneVelocityBuffer)
		{
			SceneTextures.SceneVelocityBuffer = GSystemTextures.GetBlackDummy(GraphBuilder);
		}

		FPostProcessingInputs PostProcessingInputs;
		PostProcessingInputs.SceneTextures = &SceneTextures;
		PostProcessingInputs.ViewFamilyTexture = CreateViewFamilyTexture(GraphBuilder, ViewFamily);
		PostProcessingInputs.SceneColor = GraphBuilder.RegisterExternalTexture(SceneContext.GetSceneColor(), TEXT("SceneColor"));
		PostProcessingInputs.CustomDepth = GraphBuilder.TryRegisterExternalTexture(SceneContext.CustomDepth, TEXT("CustomDepth"));
		PostProcessingInputs.SeparateTranslucency = RegisterExternalTextureWithFallback(GraphBuilder, SceneContext.SeparateTranslucencyRT, SceneContext.GetSeparateTranslucencyDummy(), TEXT("SeparateTranslucency"));
		PostProcessingInputs.SeparateModulation = RegisterExternalTextureWithFallback(GraphBuilder, SceneContext.SeparateTranslucencyModulateRT, SceneContext.GetSeparateTranslucencyModulateDummy(), TEXT("SeparateModulate"));

		if (ViewFamily.UseDebugViewPS())
		{
			for (int32 ViewIndex = 0; ViewIndex < Views.Num(); ViewIndex++)
			{
				FViewInfo& View = Views[ViewIndex];

				SCOPED_GPU_MASK(RHICmdList, View.GPUMask);
				RDG_EVENT_SCOPE_CONDITIONAL(GraphBuilder, Views.Num() > 1, "View%d", ViewIndex);
				AddDebugPostProcessingPasses(GraphBuilder, View, PostProcessingInputs);
			}
		}
		else
		{
			for (int32 ViewIndex = 0; ViewIndex < Views.Num(); ViewIndex++)
			{
				FViewInfo& View = Views[ViewIndex];

				SCOPED_GPU_MASK(RHICmdList, View.GPUMask);
				RDG_EVENT_SCOPE_CONDITIONAL(GraphBuilder, Views.Num() > 1, "View%d", ViewIndex);
				AddPostProcessingPasses(GraphBuilder, View, PostProcessingInputs);
			}
		}

		SceneContext.FreeSeparateTranslucency();
		SceneContext.FreeSeparateTranslucencyModulate();
		SceneContext.SetSceneColor(nullptr);
		SceneContext.AdjustGBufferRefCount(GraphBuilder.RHICmdList, -1);

		GraphBuilder.Execute();

		GRenderTargetPool.AddPhaseEvent(TEXT("AfterPostprocessing"));

		// End of frame, we don't need it anymore.
		FSceneRenderTargets::Get(RHICmdList).FreeDownsampledTranslucencyDepth();
	}
	else
	{
		// Release the original reference on the scene render targets
		SceneContext.AdjustGBufferRefCount(RHICmdList, -1);
	}

	{
		SCOPED_DRAW_EVENT(RHICmdList, AfterPostProcessing);
		for (int32 ViewIndex = 0; ViewIndex < Views.Num(); ViewIndex++)
		{
			ShaderPrint::EndView(Views[ViewIndex]);
			ShaderDrawDebug::EndView(Views[ViewIndex]);
		}

#if WITH_MGPU
		DoCrossGPUTransfers(RHICmdList, RenderTargetGPUMask);
#endif

		//grab the new transform out of the proxies for next frame
		SceneContext.SceneVelocity.SafeRelease();

		// Invalidate the lighting channels
		SceneContext.LightingChannels.SafeRelease();


#if RHI_RAYTRACING
		// Release resources that were bound to the ray tracing scene to allow them to be immediately recycled.
		for (int32 ViewIndex = 0; ViewIndex < Views.Num(); ++ViewIndex)
		{
			FViewInfo& View = Views[ViewIndex];
			if (View.RayTracingScene.RayTracingSceneRHI)
			{
				RHICmdList.ClearRayTracingBindings(View.RayTracingScene.RayTracingSceneRHI);
				View.RayTracingScene.RayTracingSceneRHI.SafeRelease();
			}

			// Release common lighting resources
			View.RayTracingLightingDataSRV.SafeRelease();
			View.RayTracingSubSurfaceProfileSRV.SafeRelease();
			View.RayTracingSubSurfaceProfileTexture.SafeRelease();
			View.RayTracingLightingDataBuffer.SafeRelease();
			View.RayTracingLightingDataUniformBuffer.SafeRelease();
		}
#endif //  RHI_RAYTRACING
	}
	{
		SCOPE_CYCLE_COUNTER(STAT_FDeferredShadingSceneRenderer_RenderFinish);
		SCOPED_GPU_STAT(RHICmdList, FrameRenderFinish);
		RHICmdList.SetCurrentStat(GET_STATID(STAT_CLM_RenderFinish));
		RenderFinish(RHICmdList);
		RHICmdList.SetCurrentStat(GET_STATID(STAT_CLM_AfterFrame));
	}
	ServiceLocalQueue();
}
```

