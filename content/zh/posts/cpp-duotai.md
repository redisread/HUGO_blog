---
title: "C++动态与静态"
date: 2020-04-05T15:05:37+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://gitee.com/wujiahong1998/MyBed/raw/master/img/c.png
libraries:
- katex
- mathjax
tags:
- C++
- 多态
series:
-
categories:
-
---



C++特性之多态:mushroom:

<!--more-->

## 静态类型

是指不需要考虑表达式的执行期语义，仅分析程序文本而决定的表达式类型。

## 动态类型

是指由一个左值表达式表示的左值所引用的最终派生对象的类型。



## 动态绑定与静态绑定

**静态绑定：**编译时绑定，通过对象调用

**动态绑定：**运行时绑定，通过地址实现



何时使用动态绑定?

* 只有采用“指针->函数()”或“引用变量.函数()”的方式调用C++类中的**虚函数**才会执行动态绑定。
* 对于C++中的非虚函数，因为其不具备动态绑定的特征，所以不管采用什么样的方式调用，都不会执行动态绑定。

> 总的来所,动态绑定执行的函数只针对虚函数,执行虚函数会动态执行,而非虚函数就直接执行基类类型的函数,也就是说指针类型是什么，就会调用该类型相应的函数。

例如下面的代码:

```C++
#include <iostream>
using namespace std;
class Base
{
public:
    void func()
    {
        cout << "func() in Base." << endl;
    }
    virtual void test()
    {
        cout << "test() in Base." << endl;
    }
};

class Derived : public Base
{
    void func()
    {
        cout << "func() in Derived." << endl;
    }
    virtual void test()
    {
        cout << "test() in Derived." << endl;
    }
};

int main()
{
    Base *b;
    b = new Derived();
    b->func();
    b->test();
}
```

输出为:

```
func() in Base.
test() in Derived.
```

再例如下面的代码:

```c++
class A
{
public:
    virtual void func(int val = 1)
    { std::cout<<"A->"<<val <<std::endl;}
    virtual void test()
    { func();}
};
class B : public A
{
public:
    void func(int val=0)
{std::cout<<"B->"<<val <<std::endl;}
};
int main(int argc ,char* argv[])
{
    B*p = new B;
    p->test();
return 0;
}
```

输出为: `B->1`

> test()是虚函数,`p->test()`会动态调用B类中的`test()`函数,并且,还需要记住一个结论:**virtual 函数是动态绑定，而缺省参数值却是静态绑定**,**绝不重新定义继承而来的缺省参数值！**

## 虚函数、动态绑定、运行时多态之间的关系

要触发动态绑定，需满足两个条件：

1.  只有虚函数才能进行动态绑定，非虚函数不进行动态绑定。

2. 必须通过基类类型的引用或指针进行函数调用。

**简单地说，虚函数是动态绑定的基础；动态绑定是实现运行时多态的基础。**

---

1. [https://blog.csdn.net/iicy266/article/details/11906509](https://blog.csdn.net/iicy266/article/details/11906509) C++中的动态类型与动态绑定、虚函数、运行时多态的实现

