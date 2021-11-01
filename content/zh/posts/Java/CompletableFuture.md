---
title: CompletableFuture的使用
date: 2021-10-19T17:38:53+08:00
description:
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image:
plantuml: true
libraries:
- katex
- mathjax
tags:
-
series:
-
categories:
-
---



### 多线程的问题

线程任务是实现了`Runnable`接口，或者直接写个类继承`Thread`,但是这两种方法只能通过共享对象或者文件来得到返回的结果，无法直接返回。并且`Runnable`接口中的`run`方法无法抛出异常。



> ***Java中的Future代表了什么？***
>
> `Future`是Java的接口，类似于容器保存了`Callable`的返回结果。我们把子任务放入线程池之后，直接返回，进行其他处理，然后再调用`Future`的get方法来获取结果，`Future`还可以控制子任务的执行。

### Future

> 我们使用`Runnable`对象来定义在线程内执行的任务。虽然定义任务使用`Runnable`很方便，但受限于任务不能返回结果。

Java 提供了一个`Callable`接口来定义返回结果的任务。`Callable`类似于`Runnable`并且它可以返回结果并抛出异常。

`Callable `接口有一个简单的方法`call()` 用于包含由线程执行的代码。简单的例子：

```java
Callable<String> callable = new Callable<String>() {
    @Override
    public String call() throws Exception {
        // Perform some computation
        Thread.sleep(2000);
        return "Return some result";
    }
};
```

> 请注意，使用`Callable`，您不需要`Thread.sleep()`被 try/catch 块包围，因为与 Runnable 不同，Callable 可以抛出checked异常。

更方便的定义一个Callable，使用Lambda表达式：

```java
Callable<String> callable = () -> {
    // Perform some computation
    Thread.sleep(2000);
    return "Return some result";
};
```

Callable的定义如下：

```java
@FunctionalInterface
public interface Callable<V> {
    /**
     * Computes a result, or throws an exception if unable to do so.
     *
     * @return computed result
     * @throws Exception if unable to compute a result
     */
    V call() throws Exception;
}
```

可以发现它是可以带返回值的，并且能够抛出异常。

Runnable接口：

```java
@FunctionalInterface
public interface Runnable {
    /**
     * When an object implementing interface <code>Runnable</code> is used
     * to create a thread, starting the thread causes the object's
     * <code>run</code> method to be called in that separately executing
     * thread.
     * <p>
     * The general contract of the method <code>run</code> is that it may
     * take any action whatsoever.
     *
     * @see     java.lang.Thread#run()
     */
    public abstract void run();
}
```

> Runnable接口是没有返回值，也不能抛出异常的。因为run()方法是Runnable接口里面的方法,而Runnable接口在定义run()方法的时候没有抛出任何异常,所以子类在重写run()方法的时候要小于或等于父类(Runnable)的run()方法的异常,所以父类没有抛出异常,子类不能抛出异常。

Thread类中的run方法定义如下：

```java
@Override
public void run() {
  if (target != null) {
  	target.run();
  }
}
```

同理，继承Thread的线程子类也不能够抛出异常，因为如果父类或者接口的方法中，没有异常抛出，那么子类在覆盖方法时，也不可以抛出异常。发生异常必须进行try处理。

#### 使用（Callable结合Future）

像Runnable一样，你可以submit一个Callable给executor service去执行。executor service的 `submit()` 方法 会将任务提交给线程执行。但是，它不知道提交的任务什么时候结束。因此，它返回一种称为 `Future` 的特殊类型的值，可用于在可用时获取任务的结果。

Future 的概念类似于 Javascript 等其他语言中的 Promise。它表示将在以后的某个时间点完成的计算结果。

```java
import java.util.concurrent.*;

public class FutureAndCallableExample {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executorService = Executors.newSingleThreadExecutor();

        Callable<String> callable = () -> {
            // Perform some computation
            System.out.println("Entered Callable");
            Thread.sleep(2000);
            return "Hello from Callable";
        };

        System.out.println("Submitting Callable");
        Future<String> future = executorService.submit(callable);

        // This line executes immediately
        System.out.println("Do something else while callable is getting executed");

        System.out.println("Retrieve the result of the future");
        // Future.get() 会阻塞知道Future中得到了返回的结果
        String result = future.get();
        System.out.println(result);

        executorService.shutdown();
    }

}
```

或者可以使用这个例子进行测试：

```java
mport java.util.concurrent.*;

public class FutureIsDoneExample {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executorService = Executors.newSingleThreadExecutor();

        Future<String> future = executorService.submit(() -> {
            Thread.sleep(2000);
            return "Hello from Callable";
        });

        while(!future.isDone()) {
            System.out.println("Task is still not done...");
            Thread.sleep(200);
        }

        System.out.println("Task completed! Retrieving the result");
        String result = future.get();
        System.out.println(result);

        executorService.shutdown();
    }
}
```

输出结果如下：

```
# Output
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task completed! Retrieving the result
Hello from Callable
```

在没有得到结果的时候，`isDone()`的返回值都是false，这将导致阻塞。



#### 取消Future

你可以使用`Future.cancel()`方法取消一个Future。它试图取消任务的执行，如果成功取消则返回true，否则返回false。

您可以使用` isCancelled() `方法来检查任务是否被取消。此外，取消任务后，`isDone()` 将始终为真。

```java
import java.util.concurrent.*;

public class FutureCancelExample {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executorService = Executors.newSingleThreadExecutor();

        long startTime = System.nanoTime();
        Future<String> future = executorService.submit(() -> {
            Thread.sleep(2000);
            return "Hello from Callable";
        });

        while(!future.isDone()) {
            System.out.println("Task is still not done...");
            Thread.sleep(200);
            double elapsedTimeInSec = (System.nanoTime() - startTime)/1000000000.0;

            if(elapsedTimeInSec > 1) {
                future.cancel(true);
            }
        }

        System.out.println("Task completed! Retrieving the result");
        String result = future.get();
        System.out.println(result);

        executorService.shutdown();
    }
}
```

跑上面的代码将会抛出异常，因为已经取消了Future，然后又实用`get()`方法获取Future的值。

```
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task is still not done...
Task completed! Retrieving the result
Exception in thread "main" java.util.concurrent.CancellationException
	at java.util.concurrent.FutureTask.report(FutureTask.java:121)
	at java.util.concurrent.FutureTask.get(FutureTask.java:192)
	at com.sankuai.stafftraining.wujiahong.demo.springdemo.concurrency.MainApp.test3(MainApp.java:79)
	at com.sankuai.stafftraining.wujiahong.demo.springdemo.concurrency.MainApp.main(MainApp.java:12)
```

最好是通过下面这种方法进行判断：

```java
if(!future.isCancelled()) {
    System.out.println("Task completed! Retrieving the result");
    String result = future.get();
    System.out.println(result);
} else {
    System.out.println("Task was cancelled");
}
```



#### invokeAll方法

*提交多个任务并等待所有任务完成。*

你可以通过向`invokeAll()`方法传递一个Callables的集合来执行多个任务。`invokeAll()`返回一个Futures的列表。任何对`future.get()`的调用都会被阻止，直到所有的Futures都完成。

例子：

```java
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.*;

public class InvokeAllExample {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executorService = Executors.newFixedThreadPool(5);

        Callable<String> task1 = () -> {
            Thread.sleep(2000);
            return "Result of Task1";
        };

        Callable<String> task2 = () -> {
            Thread.sleep(1000);
            return "Result of Task2";
        };

        Callable<String> task3 = () -> {
            Thread.sleep(5000);
            return "Result of Task3";
        };

        List<Callable<String>> taskList = Arrays.asList(task1, task2, task3);

        List<Future<String>> futures = executorService.invokeAll(taskList);

        for(Future<String> future: futures) {
            // The result is printed only after all the futures are complete. (i.e. after 5 seconds)
            System.out.println(future.get());
        }

        executorService.shutdown();
    }
}
```

在上面的程序中，第一次调用 `future.get() `语句会阻塞，直到所有的期货都完成。即结果将在 5 秒后打印。

输出的结果为：

```
Result of Task1
Result of Task2
Result of Task3
```

#### invokeAny方法

*提交多个任务并等待其中任何一个完成.*

`invokeAny() `方法接受一个 Callables 集合并返回最快的 **Callable 的结果**。请注意，它不会返回 Future。

例子：

```java
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.*;

public class InvokeAnyExample {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executorService = Executors.newFixedThreadPool(5);

        Callable<String> task1 = () -> {
            Thread.sleep(2000);
            return "Result of Task1";
        };

        Callable<String> task2 = () -> {
            Thread.sleep(1000);
            return "Result of Task2";
        };

        Callable<String> task3 = () -> {
            Thread.sleep(5000);
            return "Result of Task3";
        };

        // Returns the result of the fastest callable. (task2 in this case)
        String result = executorService.invokeAny(Arrays.asList(task1, task2, task3));

        System.out.println(result);

        executorService.shutdown();
    }
}
```

输出如下：

```
Result of Task2
```



### Future 的局限

1. 不能手动完成。（Future调用的任务失败了不能手动进行完成）
2. Future 的结果在非阻塞的情况下，不能执行更进一步的操作。（无法给 Future 植入一个回调函数）
3. 多个 Future 不能串联在一起组成链式调用。
4. 不能组合多个 Future 的结果。
5. 没有异常处理。



### CompletableFuture简介

#### CompletableFuture能够解决什么问题？

CompletableFuture是**Java8引入的**，在Java8之前一般通过Future实现异步。(但是是阻塞的)

> Future模式可以理解成：我有一个任务，提交给了Future，Future替我完成这个任务。期间我自己可以去做任何想做的事情。一段时间之后，我就便可以从Future那儿取出结果。



#### CompletableFuture具备什么功能？

1. 可组合。（提供thenCompose、thenCombine等各种then开头的方法）
2. 异步。



### 比较

CompletableFuture是**Java8引入的**，在Java8之前一般通过Future实现异步。

- Future用于表示异步计算的结果，只能通过阻塞或者轮询的方式获取结果，而且不支持设置回调方法，Java8之前若要设置回调一般会使用guava的ListenableFuture，回调的引入又会导致臭名昭著的“**回调地狱**”。

- CompletableFuture对Future进行了扩展，可以通过设置回调的方式处理计算结果，同时也支持组合操作，支持进一步的编排，同时一定程度解决了回调地狱的问题。



假设有三个操作存在依赖关系，step1 -> step2 -> step3需要前面步骤执行成功再执行后面步骤。

Future(ListenableFuture)的实现（回调地狱）如下：

```java
ExecutorService executor = Executors.newFixedThreadPool(5);
ListeningExecutorService guavaExecutor = MoreExecutors.listeningDecorator(executor);

ListenableFuture<Object> future1 = guavaExecutor.submit(() -> {
    //step 1
    System.out.println("执行step1");
    return true;
});

Futures.addCallback(future1, new FutureCallback<Object>() {
    @Override
    public void onSuccess(Object step1Result) {
        ListenableFuture<Object> future2 = guavaExecutor.submit(() -> {
            System.out.println("执行step 2");
            return true;
        });
        Futures.addCallback(future2, new FutureCallback<Object>() {
            @Override
            public void onSuccess(Object result) {
                ListenableFuture<Object> future3 = guavaExecutor.submit(() -> {
                    System.out.println("执行step 3");
                    return true;
                });
                Futures.addCallback(future3, new FutureCallback<Object>() {
                    @Override
                    public void onSuccess(Object result) {
                        System.out.println("这是step 3执行结果");
                    }

                    @Override
                    public void onFailure(Throwable t) {
                    }
                }, guavaExecutor);
            }

            @Override
            public void onFailure(Throwable t) {
            }
        }, guavaExecutor);

        System.out.println("执行step2");
    }
    @Override
    public void onFailure(Throwable throwable) {
    }
}, guavaExecutor);
```

CompletableFuture的实现如下：

```java
ExecutorService executor = Executors.newFixedThreadPool(5);
CompletableFuture
        .supplyAsync(() -> {
            System.out.println("执行step 1");
            return new Object();
        }, executor)
        .thenApply(result1 -> {
            System.out.println("执行step 2");
            return new Object();
        })
        .thenApply(result1 -> {
            System.out.println("执行step 3");
            return new Object();
        });
```

显然，CompletableFuture的实现要**更为简洁，可读性更好。**



### 使用

#### 简单使用

创建CompletableFuture：

```java
CompletableFuture<String> completableFuture = new CompletableFuture<String>();
```

表示创建了一个返回值为String的CompletableFuture的对象。

同样，类似Future，CompletableFuture也使用get方法获取返回结果，这也是阻塞的，当我们直接运行下面的语句：

```java
String result = completableFuture.get()
```

它将一直处于阻塞状态。

可以使用`CompletableFuture.complete()`手工的完成一个 Future:

```java
completableFuture.complete("Future's Result");
```

所有等待这个 Future 的客户端都将得到一个指定的结果，并且 `completableFuture.complete()` 之后的调用将被忽略。



####  **`runAsync()`** 

这个适用于无返回值的异步执行。

`CompletableFuture.runAsync()`方法，它持有一个[Runnable ](https://link.segmentfault.com/?enc=diQ%2BJHoBiSIWYNaXHiKF4A%3D%3D.S5Fvkk4QZR6KY5wH9EcIbnPDmc8i2VCBkVs5Cqx3vukZyVn28mZPwbng2KuzQ0lkL4Ec9wYiJDsOA7BYCe3dPUAIwp3R7vFXJEPLCk4xWyo%3D)对象，并返回 `CompletableFuture<Void>`。

```java
// Run a task specified by a Runnable Object asynchronously.
CompletableFuture<Void> future = CompletableFuture.runAsync(new Runnable() {
    @Override
    public void run() {
        // Simulate a long-running Job
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            throw new IllegalStateException(e);
        }
        System.out.println("I'll run in a separate thread than the main thread.");
    }
});

// Block and wait for the future to complete
future.get()
```

或者：

```java
// Using Lambda Expression
CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
    // Simulate a long-running Job   
    try {
        TimeUnit.SECONDS.sleep(1);
    } catch (InterruptedException e) {
        throw new IllegalStateException(e);
    }
    System.out.println("I'll run in a separate thread than the main thread.");
});
```



####  **`supplyAsync()`** 

适用于有返回值的异步计算。

`CompletableFuture.supplyAsync()` 持有`supplier<T>` 并且返回`CompletableFuture<T>`，`T` 是通过调用 传入的supplier取得的值的类型。

```java
// Run a task specified by a Supplier object asynchronously
CompletableFuture<String> future = CompletableFuture.supplyAsync(new Supplier<String>() {
    @Override
    public String get() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            throw new IllegalStateException(e);
        }
        return "Result of the asynchronous computation";
    }
});

// Block and get the result of the Future
String result = future.get();
System.out.println(result);
```

或者：

```java
// Run a task specified by a Supplier object asynchronously
CompletableFuture<String> future = CompletableFuture.supplyAsync(new Supplier<String>() {
    @Override
    public String get() {
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            throw new IllegalStateException(e);
        }
        return "Result of the asynchronous computation";
    }
});

// Block and get the result of the Future
String result = future.get();
System.out.println(result);
```



>最好加上一个线程池的参数，不然默认从全局的 [ForkJoinPool.commonPool()](https://link.segmentfault.com/?enc=Qd9vWzdcOLgn6elmJ00iVQ%3D%3D.LApXmjKLtsirreiCrpqOQc4f4p5%2BHLhiyQq1Ihks5BRqU0CmXfzgzL2fTP3RCOMq9bK60fr5j2OMkjILOwH%2F8WBE5VPrGL238qfryauapKSmv%2FA6GvlnA9BiDgsNFA7L)获得一个线程中执行这些任务。
>
>```
>// Variations of runAsync() and supplyAsync() methods
>static CompletableFuture<Void>  runAsync(Runnable runnable)
>static CompletableFuture<Void>  runAsync(Runnable runnable, Executor executor)
>static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier)
>static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier, Executor executor)
>```





上面的几个方法其实还是阻塞的。它会一直等到Future完成并且在完成后返回结果。这不是我们想要的，我们想要的是在它执行完成之后调用我们自己的逻辑。对于构建异步系统，我们应该附上一个回调给CompletableFuture，当Future完成的时候，自动的获取结果。

可以使用 `thenApply()`, `thenAccept()` 和`thenRun()`方法附上一个回调给CompletableFuture。

####  `thenApply()`

实现调用链。

使用 `thenApply()` 处理和改变CompletableFuture的结果。持有一个`Function<R,T>`作为参数。`Function<R,T>`是一个简单的函数式接口，接受一个T类型的参数，产出一个R类型的结果。

```java
// Create a CompletableFuture
CompletableFuture<String> whatsYourNameFuture = CompletableFuture.supplyAsync(() -> {
   try {
       TimeUnit.SECONDS.sleep(1);
   } catch (InterruptedException e) {
       throw new IllegalStateException(e);
   }
   return "Rajeev";
});

// Attach a callback to the Future using thenApply()
CompletableFuture<String> greetingFuture = whatsYourNameFuture.thenApply(name -> {
   return "Hello " + name;
});

// Block and get the result of the future.
System.out.println(greetingFuture.get()); // Hello Rajeev
```



#### `thenAccept() `和 `thenRun()`

如果你不想从你的回调函数中返回任何东西，仅仅想在Future完成后运行一些代码片段，你可以使用`thenAccept() `和 `thenRun()`方法，这些方法经常在调用链的最末端的最后一个回调函数中使用。
`CompletableFuture.thenAccept() `持有一个`Consumer<T> `，返回一个`CompletableFuture<Void>`。它可以访问`CompletableFuture`的结果：

```java
// thenAccept() example
CompletableFuture.supplyAsync(() -> {
    return ProductService.getProductDetail(productId);
}).thenAccept(product -> {
    System.out.println("Got product detail from remote service " + product.getName())
});
```

虽然`thenAccept()`可以访问CompletableFuture的结果，但`thenRun()`不能访Future的结果，它持有一个Runnable返回CompletableFuture<Void>：

```java
// thenRun() example
CompletableFuture.supplyAsync(() -> {
    // Run some computation  
}).thenRun(() -> {
    // Computation Finished.
});
```



####  `thenCompose()`-组合

组合两个**独立的future**。

原来假设想从一个远程API中获取一个用户的详细信息，一旦用户信息可用，你想从另外一个服务中获取他的贷方。代码是这样的：

```java
CompletableFuture<User> getUsersDetail(String userId) {
    return CompletableFuture.supplyAsync(() -> {
        UserService.getUserDetails(userId);
    });    
}

CompletableFuture<Double> getCreditRating(User user) {
    return CompletableFuture.supplyAsync(() -> {
        CreditRatingService.getCreditRating(user);
    });
}
```

使用了`thenApply()`可以进行异步调用，并且代码非常简洁：

```java
CompletableFuture<CompletableFuture<Double>> result = getUserDetail(userId)
.thenApply(user -> getCreditRating(user));
```

> 在更早的示例中，`Supplier`函数传入`thenApply`将返回一个简单的值，但是在本例中，将返回一个CompletableFuture。以上示例的最终结果是一个嵌套的CompletableFuture。
> 如果你想获取最终的结果给最顶层future，使用 `thenCompose()`方法代替
>
> ```java
> CompletableFuture<Double> result = getUserDetail(userId)
> .thenCompose(user -> getCreditRating(user));
> ```



#### `thenCombine()`-组合操作

虽然`thenCompose()`被用于当一个future依赖另外一个future的时候用来组合两个future。`thenCombine()`被用来当两个独立的`Future`都完成的时候，用来做一些事情。

例子：

```java
System.out.println("Retrieving weight.");
CompletableFuture<Double> weightInKgFuture = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(1);
    } catch (InterruptedException e) {
       throw new IllegalStateException(e);
    }
    return 65.0;
});

System.out.println("Retrieving height.");
CompletableFuture<Double> heightInCmFuture = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(1);
    } catch (InterruptedException e) {
       throw new IllegalStateException(e);
    }
    return 177.8;
});

System.out.println("Calculating BMI.");
CompletableFuture<Double> combinedFuture = weightInKgFuture
        .thenCombine(heightInCmFuture, (weightInKg, heightInCm) -> {
    Double heightInMeter = heightInCm/100;
    return weightInKg/(heightInMeter*heightInMeter);
});

System.out.println("Your BMI is - " + combinedFuture.get());
```

当两个Future都完成的时候，传给`thenCombine()`的回调函数将被调用。





前面都是组合两个的CompletableFuture方法，可以使用以下两个方法组合任意数量的CompletableFuture。

```java
static CompletableFuture<Void> allOf(CompletableFuture<?>... cfs)
static CompletableFuture<Object> anyOf(CompletableFuture<?>... cfs)
```



#### `CompletableFuture.allOf()`-组合多个（全部）

`CompletableFuture.allOf`的使用场景是当你一个列表的独立future，并且你想在它们都完成后并行的做一些事情。

一般是一次数据的请求需要调用多个服务进行查询，可以使用这种方法加快操作的速度。但是，对于同一个服务的循环差其实没有实质性的提高。

定义一个下载页面的方法:

```java
CompletableFuture<String> downloadWebPage(String pageLink) {
    return CompletableFuture.supplyAsync(() -> {
        // Code to download and return the web page's content
    });
} 
```

下载一个网站的100个不同的页面，使用allof方法：

```java
List<String> webPageLinks = Arrays.asList(...)    // A list of 100 web page links

// Download contents of all the web pages asynchronously
List<CompletableFuture<String>> pageContentFutures = webPageLinks.stream()
        .map(webPageLink -> downloadWebPage(webPageLink))
        .collect(Collectors.toList());


// Create a combined Future using allOf()
CompletableFuture<Void> allFutures = CompletableFuture.allOf(
        pageContentFutures.toArray(new CompletableFuture[pageContentFutures.size()])
);
```

使用`CompletableFuture.allOf()`的问题是它返回CompletableFuture<Void>。但是我们可以通过写一些额外的代码来获取所有封装的CompletableFuture结果。

```java
// When all the Futures are completed, call `future.join()` to get their results and collect the results in a list -
CompletableFuture<List<String>> allPageContentsFuture = allFutures.thenApply(v -> {
   return pageContentFutures.stream()
           .map(pageContentFuture -> pageContentFuture.join())
           .collect(Collectors.toList());
});
```

> 当所有future完成的时候，我们调用了`future.join()`，因此我们不会在任何地方阻塞。

`join()`方法和`get()`方法非常类似，这唯一不同的地方是如果最顶层的CompletableFuture完成的时候发生了异常，它会抛出一个未经检查的异常。

现在让我们计算包含关键字页面的数量。

```java
// Count the number of web pages having the "CompletableFuture" keyword.
CompletableFuture<Long> countFuture = allPageContentsFuture.thenApply(pageContents -> {
    return pageContents.stream()
            .filter(pageContent -> pageContent.contains("CompletableFuture"))
            .count();
});

System.out.println("Number of Web Pages having CompletableFuture keyword - " + 
        countFuture.get());
```



#### `CompletableFuture.anyOf()`-组合多个（任意）

`CompletableFuture.anyOf()`和其名字介绍的一样，当任何一个CompletableFuture完成的时候【相同的结果类型】，返回一个新的CompletableFuture。

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(2);
    } catch (InterruptedException e) {
       throw new IllegalStateException(e);
    }
    return "Result of Future 1";
});

CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(1);
    } catch (InterruptedException e) {
       throw new IllegalStateException(e);
    }
    return "Result of Future 2";
});

CompletableFuture<String> future3 = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(3);
    } catch (InterruptedException e) {
       throw new IllegalStateException(e);
    }
    return "Result of Future 3";
});

CompletableFuture<Object> anyOfFuture = CompletableFuture.anyOf(future1, future2, future3);

System.out.println(anyOfFuture.get()); // Result of Future 2
```

当三个中的任何一个CompletableFuture完成， `anyOfFuture`就会完成。因为`future2`的休眠时间最少，因此她最先完成，最终的结果将是`future2`的结果。

> `CompletableFuture.anyOf()`传入一个Future可变参数，返回CompletableFuture<Object>。`CompletableFuture.anyOf()`的问题是如果你的CompletableFuture返回的结果是不同类型的，这时候你讲会不知道你最终CompletableFuture是什么类型。



#### 异常处理



**1. 使用 exceptionally() 回调处理异常**

`exceptionally()`回调给你一个从原始Future中生成的错误恢复的机会。你可以在这里记录这个异常并返回一个默认值。

```java
Integer age = -1;

CompletableFuture<String> maturityFuture = CompletableFuture.supplyAsync(() -> {
    if(age < 0) {
        throw new IllegalArgumentException("Age can not be negative");
    }
    if(age > 18) {
        return "Adult";
    } else {
        return "Child";
    }
}).exceptionally(ex -> {
    System.out.println("Oops! We have an exception - " + ex.getMessage());
    return "Unknown!";
});

System.out.println("Maturity : " + maturityFuture.get()); 
```

**2. 使用 handle() 方法处理异常**

API提供了一个更通用的方法 - `handle()`从异常恢复，无论一个异常是否发生它都会被调用。

```java
Integer age = -1;

CompletableFuture<String> maturityFuture = CompletableFuture.supplyAsync(() -> {
    if(age < 0) {
        throw new IllegalArgumentException("Age can not be negative");
    }
    if(age > 18) {
        return "Adult";
    } else {
        return "Child";
    }
}).handle((res, ex) -> {
    if(ex != null) {
        System.out.println("Oops! We have an exception - " + ex.getMessage());
        return "Unknown!";
    }
    return res;
});

System.out.println("Maturity : " + maturityFuture.get());
```

如果异常发生，`res`参数将是 null，否则，`ex`将是 null。

### 原理

CompletableFuture使用的是一种观察者模式进行实现的。

使用CompletableFuture也是**构建依赖树**的过程，一个CompletableFuture的完成会触发另外一系列依赖它的CompletableFuture的执行：











---

***Reference***:

1. [彻底理解Java的Future模式 - 大诚挚 - 博客园](https://www.cnblogs.com/cz123/p/7693064.html)
2. [CompletableFuture的原理与实践-记外卖商家端API的异步化](https://km.sankuai.com/page/947271480)
3. [Java 8 CompletableFuture 教程 - SegmentFault 思否](https://segmentfault.com/a/1190000014479792)
4. [关于实现Runnable接口不能抛异常只能捕获异常原因_小林子的博客-CSDN博客](https://blog.csdn.net/qq_26106607/article/details/79145882#:~:text=%E5%8E%9F%E5%9B%A0%EF%BC%9A%20%E5%9C%A8java%E4%B8%AD%E6%9C%89,%E7%9A%84%E5%BC%82%E5%B8%B8%EF%BC%89%EF%BC%8C%E5%9B%A0%E4%B8%BA%E5%9C%A8Runnable&text=%E7%94%B1%E4%BA%8EJava%E7%BA%BF%E7%A8%8B%E7%9A%84%E6%9C%AC%E8%B4%A8,%E5%8F%AF%E4%BB%A5%E4%BD%BF%E7%94%A8try%2Dcatch%E5%9D%97%E3%80%82)
5. [Java Callable and Future Tutorial | CalliCoder ~ Java可调用和未来教程 | CalliCoder](https://www.callicoder.com/java-callable-and-future-tutorial/)

