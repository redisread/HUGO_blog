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





> ***Java中的Future代表了什么？***
>
> `Future`是Java的接口，类似于容器保存了`Callable`的返回结果。我们把子任务放入线程池之后，直接返回，进行其他处理，然后再调用`Future`的get方法来获取结果，`Future`还可以控制子任务的执行。



### 多线程的问题

线程任务是实现了`Runnable`接口，或者直接写个类继承`Thread`,但是这两种方法只能通过共享对象或者文件来得到返回的结果，无法直接返回。并且`Runnable`接口中的`run`方法无法抛出异常。





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
        // Future.get() blocks until the result is available
        String result = future.get();
        System.out.println(result);

        executorService.shutdown();
    }

}
```





































### CompletableFuture能够解决什么问题？

CompletableFuture是**Java8引入的**，在Java8之前一般通过Future实现异步。





### CompletableFuture具备什么功能？

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













### 原理

CompletableFuture使用的是一种观察者模式进行实现的。













---

***Reference***:

1. [彻底理解Java的Future模式 - 大诚挚 - 博客园](https://www.cnblogs.com/cz123/p/7693064.html)
2. [CompletableFuture的原理与实践-记外卖商家端API的异步化](https://km.sankuai.com/page/947271480)
3. [Java 8 CompletableFuture 教程 - SegmentFault 思否](https://segmentfault.com/a/1190000014479792)
4. [关于实现Runnable接口不能抛异常只能捕获异常原因_小林子的博客-CSDN博客](https://blog.csdn.net/qq_26106607/article/details/79145882#:~:text=%E5%8E%9F%E5%9B%A0%EF%BC%9A%20%E5%9C%A8java%E4%B8%AD%E6%9C%89,%E7%9A%84%E5%BC%82%E5%B8%B8%EF%BC%89%EF%BC%8C%E5%9B%A0%E4%B8%BA%E5%9C%A8Runnable&text=%E7%94%B1%E4%BA%8EJava%E7%BA%BF%E7%A8%8B%E7%9A%84%E6%9C%AC%E8%B4%A8,%E5%8F%AF%E4%BB%A5%E4%BD%BF%E7%94%A8try%2Dcatch%E5%9D%97%E3%80%82)
5. [Java Callable and Future Tutorial | CalliCoder ~ Java可调用和未来教程 | CalliCoder](https://www.callicoder.com/java-callable-and-future-tutorial/)

