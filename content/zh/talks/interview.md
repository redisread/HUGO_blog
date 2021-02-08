---
title: "interview"
date: 2020-07-28T00:04:50+09:00
publishDate: 2020-07-28
description:
enableToc: true
enableTocContent: false
tags:
-
series:
-
categories:
-
---


# C/C++



### :o:面向对象与面向过程

`Leetcode`对面向对象的理解：**面向对象的编程方式使得每一个类都只做一件事**。**面向过程会让一个类越来越全能，就像一个管家一样做了所有的事**。而面向对象像是雇佣了一群职员，每个人做一件小事，各司其职，最终合作共赢！

面向对象的特点是**可维护**、**可复用**、**可扩展**、**灵活性好**，它真正强大的地方在于：随着业务变得越来越复杂，面向对象依然能够使得程序结构良好，而面向过程却会导致程序越来越臃肿。

让面向对象保持结构良好的秘诀就是 **设计模式。**

### :heavy_plus_sign:C++程序设计模型

**程序模型(procedural model)**

**抽象数据模型(abstract data type model)**

例如`std::string`

**面向对象模型(object-oriented model)**



### :heavy_multiplication_x:多态

**多态如何实现？**

要实现C++中`OO`程序设计的多态性质，只有通过`point`或者`reference`的间接处理。

**多态用途？**

经由一个共同的接口来影响类型的封装，这个接口通常被定义在一个抽象的`base class`中。

**虚函数与纯虚函数**

引入虚函数是为了**动态绑定**,引入虚函数是为了动态绑定。

**基类需要虚析构函数的原因**

当derived class经由一个base class指针被删除而该base class的析构函数为non-virtual时，将发生未定义行为。通常将发生资源泄漏。
解决方法即为：为多态基类声明一个virtual 析构函数。



### :raised_hand_with_fingers_splayed: C++11新特性

![c++11新特性详解](https://i.loli.net/2020/10/20/SD17qsQ8IBo34NL.jpg)

1. 自动类型推断 auto
2. 匿名函数 Lambda
3. 智能指针
4. 显示重写(覆盖)override和final

### :card_index:const

关键字`const`出现在星号左边，表示被指物是常量；如果出现在星号右边，表示指针本身是常量；如果出现在两边，表示被指物和指针都是常量。

作用：

1. 修饰变量，说明该变量不可以被改变；
2. 修饰指针，分为指向常量的指针（pointer to const）和自身是常量的指针（常量指针，const pointer）；
3. 修饰引用，指向常量的引用（reference to const），用于形参类型，即避免了拷贝，又避免了函数对值的修改；
4. **修饰成员函数，说明该成员函数内不能修改成员变量。**

### :statue_of_liberty:Static

* 静态常量整数成员可以在类内进行初始化，其他需要在类外面进行初始化

  ```cpp
  #include <iostream>
  using namespace std;
  class A{
      public:
          static const int val = 5;
          static int GG;
  };
  int A::GG = 6;
  int main()
  {  
      cout << A::val << endl;
      cout << A::GG << endl;
      return 0;
  }
  ```

  ```
  5
  6
  ```



**C++支持重载，C不支持重载**



### :outbox_tray: extern "C"作用

extern "C"的主要作用就是**为了能够正确实现C++代码调用其他C语言代码**。加上extern "C"后，会指示编译器这部分代码按C语言（而不是C++）的方式进行编译。由于C++支持函数重载，因此编译器编译函数的过程中会将函数的参数类型也加到编译后的代码中，而不仅仅是函数名；而C语言并不支持函数重载，因此编译C语言代码的函数时不会带上函数的参数类型，一般只包括函数名。

这个功能十分有用处，因为在C++出现以前，很多代码都是C语言写的，而且很底层的库也是C语言写的，**为了更好的支持原来的C代码和已经写好的C语言库，需要在C++中尽可能的支持C，而extern "C"就是其中的一个策略。**

* 如果C++调用一个C语言编写的`.DLL`时，当包括`.DLL`的头文件或声明接口函数时，应加extern "C" {　}。

### :pushpin:inline内联函数 static静态函数 普通函数区别

面试时候一般只会问你区别，所有本文只说区别。

**内联函数和普通函数的区别**：

内联函数和普通函数最大的区别在于内部的实现方面，当普通函数在被调用时，系统首先跳跃到该函数的入口地址，执行函数体，执行完成后，再返回到函数调用的地方，**函数始终只有一个拷贝**； **而内联函数则不需要进行一个寻址的过程，当执行到内联函数时，此函数展开（很类似宏的使用）**，如果在 N处调用了此内联函数，则此函数就会有N个代码段的拷贝。



**静态函数和普通函数的区别**：

static函数和普通函数的最大的区别在于作用域方面，static函数限定在本源码文件中，不能被本源码文件以外的代码文件调用。而普通的函数，默认是extern的，也就是说，可以被其它代码文件调用该函数。**同时static函数在内存中只有一份，普通函数在每个被调用中维持一份拷贝。**





**inline与define的区别：**

内联函数和宏的区别在于，**宏是由预处理器对宏进行替代**，而**内联函数是通过编译器控制来实现的**。而且内联函数是真正的函数，只是在需要用到的时候，内联函数像宏一样的展开，所以**取消了函数的参数压栈，减少了调用的开销**。你可以象调用函数一样来调用内联函数，而不必担心会产生于处理宏的一些问题。内联函数与带参数的宏定义进行下比较，它们的代码效率是一样，但是内联欢函数要优于宏定义，因为内联函数遵循的类型和作用域规则，它与一般函数更相近，在一些编译器中，一旦关上内联扩展，将与一般函数一样进行调用，比较方便。



inline使用：

```cpp
// 声明1（加 inline，建议使用）
inline int functionName(int first, int second,...);

// 声明2（不加 inline）
int functionName(int first, int second,...);

// 定义
inline int functionName(int first, int second,...) {/****/};

// 类内定义，隐式内联
class A {
    int doA() { return 0; }         // 隐式内联
}

// 类外定义，需要显式内联
class A {
    int doA();
}
inline int A::doA() { return 0; }   // 需要显式内联
```



优缺点：

优点

1. 内联函数同宏函数一样将在被调用处进行代码展开，省去了参数压栈、栈帧开辟与回收，结果返回等，从而提高程序运行速度。
2. 内联函数相比宏函数来说，在代码展开时，会做安全检查或自动类型转换（同普通函数），而宏定义则不会。
3. 在类中声明同时定义的成员函数，自动转化为内联函数，因此内联函数可以访问类的成员变量，宏定义则不能。
4. **内联函数在运行时可调试，而宏定义不可以。**

缺点

1. **代码膨胀**。内联是以代码膨胀（复制）为代价，消除函数调用带来的开销。如果执行函数体内代码的时间，相比于函数调用的开销较大，那么效率的收获会很少。另一方面，每一处内联函数的调用都要复制代码，将使程序的总代码量增大，消耗更多的内存空间。
2. inline 函数无法随着函数库升级而升级。inline函数的改变需要**重新编译**，不像 non-inline 可以直接链接。
3. **是否内联，程序员不可控**。内联函数只是对编译器的建议，是否对函数内联，决定权在于编译器。

---

参考：

1. [inline内联函数 static静态函数 普通函数区别](https://blog.csdn.net/jigetage/article/details/86065114)
2. [C++ inline和#define宏的区别](https://www.cnblogs.com/yanwei-wang/p/4691146.html)

### :heart_decoration:C++内存布局

![内存分区](https://i.loli.net/2020/10/30/NcQjdHME1DUWV69.png)

1. 内核空间

2. 栈

   1、stack存放函数的临时变量、局部变量、函数参数和返回值
   2、由编译器自动分配和释放。

3. 动态链接库(共享映射区)

   调用的库文件，位于堆和栈之间

4. 堆

   heap用来动态分配内存，由程序员控制，交由程序自身决定开辟和释放。

5. 全局数据区

   `.bss`

   `bss`段用来存放没有被初始化和已经被初始化为0的全局变量

   `.data`

   `data`段用来存放已经被初始化为非0的全局变量

6. 常量区

   `.rodata`

   `rodata`段用来存放常量数据、被编译器自动存放来的字符串和加`const`关键字的常量数据。

7. 代码区

   `.text`

   `text`段用来存放代码和部分整数常量，该段是可执行的。



### :currency_exchange: C++空类产生哪些成员函数

**构造、拷贝构造、赋值、析构**、取地址、取地址const，

[C++ 空类默认产生的类成员函数](https://blog.csdn.net/makuiyu/article/details/8047340)



### :airplane: 指针常见错误

[面试题Getmemory](https://blog.csdn.net/wujiafei_njgcxy/article/details/77940793)

### :blue_car: C的内存结构

[C语言内存布局](https://blog.csdn.net/wujiafei_njgcxy/article/details/77777936)

![C内存结构](https://i.loli.net/2020/10/30/FmpXJ7UHBdkteTa.jpg)

### :dagger:程序运行时内存分配

**变量和函数占用的内存是系统在程序运行时为程序分配的，但并不是所有的变量和函数都被分配在同一块内存区域中**。对于一个C++程序来说，系统一般采用3种方式为程序分配内存，下面将分别介绍这3种方式。

1. **从静态存储区域分配**

   **这部分内存在程序编译的时候就已经分配好，并且这块内存在程序的整个运行期间都存在。例如在函数外定义的全局变量，以及在创建时使用static修饰符的变量。**在该区域存储的内容一般是全局变量，其中存储在数据段中的全局变量通常已经被初始化。

   

2. **在栈上进行内存分配**

   这部分区域被称为堆栈，但这只是一种习惯性说法，并不是堆和栈的统称。该部分存储的变量一般是在函数体中定义的局部变量（不包括static声明的变量，static意味着变量存放在数据段中），除此之外，经常在栈区出现的还有传递给函数的参数和函数的返回值等。栈区变量的生存周期是在入栈前（函数开始被调用）获得内存空间，而在出栈时（函数结束调用）释放内存空间。因此尽量不要将函数中的局部变量作为函数的返回值，因为在函数调用结束后，局部变量就不存在了，再使用此变量的值作为返回值，会使程序获取的返回值有可能为随机数。在执行函数时，函数体内的局部变量在栈上被自动创建，而在函数执行结束时，这些存储单元自动被释放。栈内存分配由操作系统完成而不需要程序员手动参与。因此其执行效率非常高。但是整个栈区可以被分配的内存容量有限。因此定义过多的未使用的局部变量会使程序执行变慢。

3. **从堆上分配**

   通常称为动态分配的内存，该部分内存区域的大小并不固定，当程序运行时有程序员用 malloc() 函数等内存分配函数来分配，或使用 new 操作符等系统提供的函数来分配。该内存的大小可以根据程序中的实际需要来指定。**该部分内存空间不会随着函数运行的结束而被自动回收，也不会被自动释放，需要程序员自己用 free() 函数或 delete 操作符进行内存的回收**。动态内存的生存期由程序员自行决定，但如果分配了空间，就必须对其回收，否则运行的程序会出现内存泄漏，并且频繁地分配和释放不同大小的堆空间将会产生堆内碎块，间接降低内存空间的使用率，严重时会产生大量内存碎片。

　（**内存碎片是一些分散的内存区域，大量内存碎片的存在会降低内存的使用率。**）



### :alien:struct字节对齐问题

```cpp
typedef struct
{
    char c1;
    short s;
    char c2;
    int i;
} T_FOO;
```

上面的结构体使用`sizeof`输出大小为12。（假设这个结构体的成员在内存中是紧凑排列的，且c1的起始地址是0，则s的地址就是1，c2的地址是3，i的地址是4）



**字节对齐**

现代计算机中，内存空间按照字节划分，理论上可以从任何起始地址访问任意类型的变量。但实际中在访问特定类型变量时经常在特定的内存地址访问，这就需要各种类型数据按照一定的规则在空间上排列，而不是顺序一个接一个地存放，这就是对齐。

**对齐的原因和作用**

- **不同硬件平台对存储空间的处理上存在很大的不同**。某些平台对特定类型的数据只能从特定地址开始存取，而不允许其在内存中任意存放。例如Motorola 68000 处理器不允许16位的字存放在奇地址，否则会触发异常，因此在这种架构下编程必须保证字节对齐。

- **但最常见的情况是，如果不按照平台要求对数据存放进行对齐，会带来存取效率上的损失**。比如32位的Intel处理器通过总线访问(包括读和写)内存数据。每个总线周期从偶地址开始访问32位内存数据，内存数据以字节为单位存放。如果一个32位的数据没有存放在4字节整除的内存地址处，那么处理器就需要2个总线周期对其进行访问，显然访问效率下降很多。

  因此，**通过合理的内存对齐可以提高访问效率。为使CPU能够对数据进行快速访问，数据的起始地址应具有“对齐”特性**。比如4字节数据的起始地址应位于4字节边界上，即起始地址能够被4整除

- **此外，合理利用字节对齐还可以有效地节省存储空间**。但要注意，在32位机中使用1字节或2字节对齐，反而会降低变量访问速度。因此需要考虑处理器类型。还应考虑编译器的类型。在VC/C++和GNU GCC中都是默认是4字节对齐。



**对齐准则**

1. `sizeof`的最终结果必然是结构内部最大成员的整数倍，不够补齐。

2. 结构内部各个成员的首地址必然是自身大小的整数倍。

   如果定义了`#pragma pack(n)`，则上述俩条规则可定义为：

   1、整个`sizeof`的最终结果必然是 `min[n,结构内部最大成员]` 的整数倍，不够补齐。

   2、结构内部各个成员的首地址必然是`min[n,自身大小]`的整数倍。

   > 由上述原则可知，在写结构体时，成员先后不要随意写哦，应遵循从大到小的原则，这样有助于节省空间。



使用四字节对齐：

```cpp
#pragma pack(push)
#pragma pack(4)
typedef struct
{
    char c1;
    short s;
    char c2;
    int i;
} T_FOO;
#pragma pack(pop)
```

对其使用`sizeof`得到的大小为12



不使用字节对齐，即使用1字节对齐：

```cpp
#pragma pack(push)
#pragma pack(1)
typedef struct
{
    char c1;
    short s;
    char c2;
    int i;
} T_FOO;
#pragma pack(pop)
```

大小为8



参考：[C语言字节对齐问题详解](https://www.cnblogs.com/clover-toeic/p/3853132.html)



### :m:malloc一次性最大能申请多大内存空间？



具体情况分析





### :large_orange_diamond:字节序了解吗？讲一下大端对齐和小端对齐

主机字节序又叫 CPU 字节序，其不是由操作系统决定的，而是由 CPU 指令集架构决定的。主机字节序分为两种：

- **大端字节序（Big Endian）**：高序字节存储在低位地址，低序字节存储在高位地址
- **小端字节序（Little Endian**）：高序字节存储在高位地址，低序字节存储在低位地址



32 位整数 `0x12345678` 是从起始位置为 `0x00` 的地址开始存放，则：

| 内存地址 | 0x00 | 0x01 | 0x02 | 0x03 |
| -------- | ---- | ---- | ---- | ---- |
| 大端     | 12   | 34   | 56   | 78   |
| 小端     | 78   | 56   | 34   | 12   |

![大端序](https://i.loli.net/2020/10/15/o2U3L1mwFnTX7gQ.png) ![小端序](https://i.loli.net/2020/10/15/62KchFkCYRTtHyb.png)



**判断大端小端**

```cpp
#include <iostream>
using namespace std;

int main()
{
    int i = 0x12345678;

    if (*((char*)&i) == 0x12)
        cout << "大端" << endl;
    else    
        cout << "小端" << endl;

    return 0;
}
```

网络字节顺序是 TCP/IP 中规定好的一种数据表示格式，它与具体的 CPU 类型、操作系统等无关，从而可以保证数据在不同主机之间传输时能够被正确解释。

**网络字节顺序采用：大端（Big Endian）排列方式。**





### :straight_ruler:字符串与字符串指针的大小



- `sizeof` 对数组，得到整个数组所占空间大小。
- `sizeof` 对指针，得到指针本身所占空间大小。



可以看看下面的例子：

```cpp
    char *a = "abcd";
    cout << "sizeof a = " << sizeof(a) << "  "
         << "strlen(a) = " << strlen(a) << endl;
    char b[] = "abcd";
    cout << "sizeof b = " << sizeof(b) << "  "
         << "strlen(b) = " << strlen(b) << endl;
    char c[10] = "abcd";
    cout << "sizeof c = " << sizeof(c) << "  "
         << "strlen(c) = " << strlen(c) << endl;
```

输出为：

```
sizeof a = 8  strlen(a) = 4
sizeof b = 5  strlen(b) = 4
sizeof c = 10  strlen(c) = 4
```



`strlen()`的结果都一样，返回的是字符串的长度(不计`\0`);但是`sizeof()`是返回类型的大小，假如是指针，返回当前操作系统地址指针的大小；假如是显示数组初始化的数组，就返回数组实际大小的字节数。





### :dancer:动态链接和静态链接的区别

https://www.cnblogs.com/tracylee/archive/2012/10/15/2723816.html

静态链接方式：在程序执行之前完成所有的组装工作，生成一个可执行的目标文件（EXE文件）。

动态链接方式：在程序已经为了执行被装入内存之后完成链接工作，并且在内存中一般只保留该编译单元的一份拷贝。



### :small_airplane:智能指针的多线程问题





### :circus_tent: 关于template的三个问题

1. template的声明。
2. 如何“实例化（instantiates）”class object、inline nonmember以及 member templatefunctions。**这些是“每一个编译单位都会拥有一份实例”的东西。**
3. 如何“实例化（instantiates）”nonmember、member template functions以及 static template class members。**这些都是“每一个可执行文件中只需要一份实例”的东西。这也就是一般而言 template所带来的问题。**

代码样例：

![code](https://i.loli.net/2020/10/18/BEU7oO2mvw9xNnA.png)

**首先，当编译器看到template class 声明时，它会做出什么反应？在实际程序中，什么反应也没有！**



**静态成员变量**

对于模板类里面的静态成员变量，当初始化它的时候，我们使用下面一条语句才能使用：

```cpp
Point< float >::freeList;
```

不能使用`Point::freeList;`，**此时会使其一份实例与 Point class 的 float instantiation在程序中产生关联。**

当我们再调用下面的语句时：

```cpp
Point< double >::freeList;
```

**就会出现第二个freeList实例，与Point class的double instantiation产生关联。**



**类对象实例**

所以，一个class object 的定义，不论是由编译器暗中地做（像稍早程序代码中出现过的temporary），或是由程序员像下面这样显式地做：

```cpp
const Point< float > origin;
```

都会导致template class的“实例化”，也就是说，float instantiation的真正对象布局会被产生出来。

> 回顾先前的 template 声明，我们看到 Point 有三个 nonstatic members，每一个的类型都是Type。Type现在被绑定为float，所以origin的配置空间必须足够容纳三个float成员。



**成员函数**

然而，member functions（至少对于那些未被使用过的）不应该被“实例化”。只有在memberfunctions被使用的时候，C++Standard才要求它们被“实例化”。

这些函数在什么时候“实例化”？目前流行两种策略：

- 在编译的时候。那么函数将“实例化”于 origin和 p存在的那个文件中。
- 在链接的时候。那么编译器会被一些辅助工具重新激活。template 函数实例可能被放在这一文件中、别的文件中或一个分离的存储位置。





模板错误报告：

cfront对template的处理是完全解析（parse）但不做类型检验；只有在每一个实例化操作（instantiation）发生时才做类型检验。所以在一个parsing策略之下，所有语汇（lexing）错误和解析（parsing）错误都会在处理template声明的过程中被标示出来。







### :exclamation:c++的异常处理机制	

欲支持exception handling，编译器的主要工作就是找出catch子句，以处理被抛出来的exception。



一般而言，exception handling机制需要与编译器所产生的数据结构以及执行期的一个exception library紧密合作。在程序大小和执行速度之间，编译器必须有所抉择：

- 为了维护执行速度，编译器可以在编译时期建立起用于支持的数据结构。这会使程序的大小发生膨胀，但编译器可以几乎忽略这些结构，直到有个 exception被抛出来。
- 为了维护程序大小，编译器可以在执行期建立起用于支持的数据结构。这会影响程序的执行速度，但意味着编译器只有在必要的时候才建立那些数据结构（并且可以抛弃之）。

C++的exception handling由三个主要的语汇组件构成：

1. 一个 throw 子句。它在程序某处发出一个 exception。被抛出去的exception可以是内建类型，也可以是使用者自定类型。
2. 一个或多个 catch子句。每一个 catch子句都是一个 exception handler。它用来表示说，这个子句准备处理某种类型的 exception，并且在封闭的大括号区段中提供实际的处理程序。
3. 一个 try区段。它被围绕以一系列的叙述句（statements），这些叙述句可能会引发 catch子句起作用。

当一个exception 被抛出去时，控制权会从函数调用中被释放出来，并寻找一个吻合的catch子句。如果都没有吻合者，那么默认的处理例程terminate（）会被调用。当控制权被放弃后，堆栈中的每一个函数调用也就被推离（popped up）。这个程序称为unwinding the stack。在每一个函数被推离堆栈之前，函数的local class objects的destructor会被调用。



### :running_man:执行期类型识别（Runtime Type Identification，RTTI）

1. 类型安全的向下转型，一个安全的向下转型需要在执行期可以对指针进行查询，确定可以正确且安全的向下转型。因为需要支持查询，则需要在转型时的空间和执行时间上的额外负担。额外负担有：

　　　　1) 额外空间以存储类型信息，通常为一个指向某类型信息节点的指针；

　　　　2) 额外时间以决定执行期的类型。

　　　　C++利用虚表，将类相关的RTTI对象地址(即type_info对象地址)放在虚表中(一般为第一个slot)，此时编译器在编译的时候设定vtpr和虚表即可，当需要向下转型时利用RTTI决定执行期类型等信息。

2. 类型安全的动态转换dynamic_cast可以确保转化合适的类型对象，若失败则返回空指针(当转化为指针类型时)或者抛出异常(当转化为引用类型时)。dynamic_cast的成本在于运行期的类型识别判断。

3. 使用typeid运算符获取对象的类型，即type_info，当然也可以通过typeid来确定是否满足某个类型，然后调用static_cast转化即可。即if(typeid(someObj) == typeid(someType) ) {someType &rf = static_cast<someType&>(someObj);}。此外RTTI不仅可用于多态类，也可以用于内置类型和非多态的用户自定义类型。

### :construction:C++构造函数

> 四种情况，造成“编译器会为未声明的constructor的classes合成一个default constructor

1. **带有Default Constructor 的Member Class Object**

   如果一个class没有任何constructor，但它内含一个member object，而后者 有default constructor，那么这个class的implicit default constructor 就是 “nontrivial”,编译器需要为此class合成出一个default constructor。不过这个 合成操作只有在constructor真正需要被调用时才会发生。

   例子：Bar会生成一个默认的构造函数

   ![带有默认构造函数的成员类对象](https://i.loli.net/2020/09/22/GS9Jnxq7oOI2cwU.png)

   > 提示：被合成的默认构造函数只是满足编译器的需要，而不是程序的需要。

2. **“带有 Default Constructor”的 Base Class**

   如果一个没有任何constructors的class派生自一个“带有default constructor”的base class,那么这个derived class的default constructor会被视为nontrivial，并因此需要被合成出来。它将调用上一层base classes的default constructor(根据它们的声明次序）。对一个后继派生的class而言，这个合成的constructor和一个“被明确提供的default constructor”没有什么差异。

3. **“带有一个 Virtual Function”的Class**

   构造函数的构建主要是为了初始化或者更新**虚函数指针**

   例子

   ![虚函数构造函数](https://i.loli.net/2020/09/22/B6neWJKNdSQg3bX.png)

4. **“带有一个Virtual Base Class”的Class**

   例子：

   ![虚基类](https://i.loli.net/2020/09/22/cd9vs2xjmb5FN7f.png)



在合成的default constructor中，只有base class subobjects和member classobjects会被初始化。所有其它的 nonstatic data member，如整数、整数指针、整数数组等等都不会被初始化。这些初始化操作对程序而言或许有需要，但对编译器则并非必要。如果程序需要一个“把某指针设为0”的default constructor,那么提供它的人应该是程序员。





### :cop:C++拷贝构造函数

有三种情况，会以一个object的内容作为另一个class object的初值:

1. 对一个object做明确的初始化操作，像这样：

   ```cpp
   class X{...};
   X x;
   //明确地以一个object的内容作为另一个class object的初值
   X xx = x;
   ```

2. 当object 被当作参数交给某个函数时,例如：

   ```cpp
   extern void foo(X x);
   
   void test(){
   	X xx;
   	foo(xx);	//以xx作为foo（）第一个参数的初值（不明显的初始化操作）
   }
   ```

3. 当函数传回一个class object时，例如：

   ```cpp
   X foo_bar(){
   	X xx;
   	return xx;
   }
   ```

   

#### Default Memberwise Initialization

如果函数并没有提供一个`explicit copy constructor`，那么其拷贝同类型对象的操作由`default memberwise initialization`完成，其执行策略为：对每一个内建或派生的`data member`的值，从某一个`object`拷贝到另一个`object`。不过它不会拷贝其中的`member class object`，而是实施递归式的`memberwise initialization`(对每一个对象依次执行`default memberwise initialization`）。

> Default constructors 和 copy constructors在必要的时候才由编译器产生出来。





#### Bitwise Copy Semantics(位逐次拷贝）

看看下面的程序段：

```cpp
#include"Word.h"
Word noun("book");
void foo()
{
	Word verb = noun; //...
}
```

我们不可能预测这个初始化操作的程序行为。如果class Word的设计者定义了一个copy constructor，verb的初始化操作会调用它。但如果该class 没有定义explicit copy constructor,那么是否会有一个编译器合成的实体被调用呢？这就得视该class 是否展现"bitwise copy semantics”而定。

举个例子，已知下面的class Word 声明：

```cpp
//以下声明展现了bitwise copy semantics
class Word{
public:
	Word(const char*);
	~Word(){ delete []str;} 	//..
private:
	int cnt;
	char *str;
}；
```

这种情况下并**不需要**合成出一个default copy constructor，因为上述声明展现了“default copy semantics”。

再如下面的例子：

```cpp
//以下声明并未展现出bitwise copy semantics
class Word{
public:
	Word(const String&);
	~Word(){ delete []str;} 	//..
private:
	int cnt;
	String str;
}；
```

其中String声明了一个显示的拷贝构造函数 

```cpp
class String{
    public:
        String(const char*);
        ~String();
        //...
};
```

在这个情况下，编译器必须合成出一个copy constructor 以便调用member class String object的 copy constructor:





**什么时候一个class不展现出“bitwise copy semantics”呢?有四种情况：**

1. 当class内含一个member object而后者的class声明有一个copy constructor时（不论是被class 设计者明确地声明，就像前面的String那样；或是被编译器合成，像class Word那样）。
2. 当class继承自一个base class而后者存在有一个copy constructor时（再次强调，不论是被明确声明或是被合成而得）。
3. 当class声明了一个或多个virtual functions时。
4. 当class派生自一个继承串链，其中有一个或多个virtual base classes时。

前两神情况中，编译器必须将member或base class的“copy constructors调用操作”安插到被合成的copy constructor中。





**虚函数指针**

编译时期有两个程序的扩张操作：

■ 增加一个virtual function table（vtbl)，内含每一个有作用的 virtual function的地址。
■ 将一个指向virtual function table的指针（vptr)，安插在每一个class object内。

很显然，如果编译器对于每一个新产生的`class object`的`vptr`不能成功而正确地设好其初值，将导致可怕的后果。因此，当编译器导入一个`vptr`到`class`之中时，该`class`就不再展现`bitwise semantics`了。现在，编译器需要合成出一个`copy constructor`，以求将`vptr`适当地初始化，下面是个例子。

以一个派生类对象作为其父类对象的初始值，编译器需要**”判断“**

![判断如何去拷贝构造](https://i.loli.net/2020/09/23/3EO2tFpdbJZc7WH.png)



### 程序转化语义

下面的程序：

```cpp
#include <iostream>

X foo(){
	X xx;
	// ...
	return xx;
}
```

可能会做出以下假设：

1. 每次`foo0`被调用，就传回xx的值。
2. 如果`class X`定义了一个`copy constructor`，那么当`foo0`被调用时，保证该`copy constructor` 也会被调用。

> 第一个假设的真实性，必须视`class X`如何定义而定。第二个假设的真实性，虽然也有部分必须视`class X`如何定义而定，但最主要还是视你的C++编译器所提供的进取性优化程度（degree of aggressive optimization)而定。你甚至可以假设在一个高品质的C++编译器中，上述两点对于class X的nontrivial definitions都不正确。



**显式初始化操作(Explicit Initialization)**

下面的例子是三种显示的拷贝构造操作：

```cpp
void test() {
  X x0;
  X x1(x0);     // 第一种显示拷贝构造
  X x2 = x0;    // 第二种显示拷贝构造
  X x3 = X(x0); // 第三种显示拷贝构造
}
```

上面的程序转化可能会有两个阶段：

1. 重写每一个定义，其中的初始化操作会被剥除。
2. class的copy constructor 调用操作会被安插进去。

可能会变成下面这样

```cpp
void test_Cpp()
{
    // ... x0的构造函数
    // 三个声明
    X x1,x2,x3;
    // 三个定义
    x1.X::X(x0);
    x2.X::X(x0);
    x3.X::X(x0);
}
```



**参数的初始化（Argument Initialization)**

C++标准说，把一个class object 当做参数传给一个函数，相当于一下形式的初始化操作：

(定义一个类X，作为test函数的参数)

```cpp
X xx;
test(xx);
```

其中test函数的声明如下：

```cpp
void test(X x0);
```

上面的参数xx这个变量作为参数传到函数test中，会产生一个临时对象，并且会调用拷贝构造函数将这个临时对象初始化，经过这些步骤这个参数才真正传入函数中进行使用。

所以上面的代码可能会转换为：

```cpp
X __temp;	// 临时对象产生
__temp.X::X(xx);	//编译器对拷贝构造函数的调用
test(__temp);		//重新改写函数的调用操作
```



然而上面的做法只完成了一般，因为函数xx的声明还是一个传值的参数，test的声明也也须被转化，形式参数必须从原先的一个class X object改变为一个class X reference,像这样：

```cpp
void test(X& x0)；
```



**返回值的初始化（Return Value Initialization)**

例如下面的例子：

```cpp
X test()
{
	X xx;
	return xx;
}
```



编译器可能会做如下`NRV`优化：

```cpp
X __result;
void test(X& __result)
{
    __result.X::X()；
    return;
}
```

**当类显示Bitwise的情况下，应该不去定义一个拷贝构造函数，使用编译器合成就非常高效和安全！**



---

**Data语义学**

---

### :minidisc:C++——data语义

每一个class object 因此必须有足够的大小以容纳它所有的 nonstatic datamembers。有时候其值可能令你吃惊（正如那位法国来信者），因为它可能比你想象的还大，原因是：

1. 由编译器自动加上的额外data members，用以支持某些语言特性（主要是各种virtual特性）.
2. 因为alignment（边界调整）的需要。



**Data Member的绑定**

看看下面这个例子：

```cpp
//某个foo.h头文件，从某处含入
extern float x;
//程序员的Point3d.h文件 
class Point3d{
public:
    Point3d(float,float,float); 
    //问题：被传回和被设定的x是哪一个x呢
    float X() const { return x;} 
    void X( float new x) const{x=new_x;} //..… 
private:
    float x,y,z; 
};
```

如果我问你`Point3d::X()`传回哪一个x？是class内部的那个x，还是外部（extern)的那个x？今天每个人都会回答我是内部那一个。这个答案是正确的，但并不是从过去以来一直都正确！

早期C++的两种防御性程序设计风格：

1. 把所有的`data members`放在`class`声明起头处，以确保正确的绑定：
2. 把所有的`inline functions`，不管大小都放在`class`声明之外：



这个语言规则被称为“member rewriting rule”，大意是“一个`inline`函数实体，在整个 `class`声明未被完全看见之前，是不会被评估求值（evaluated）的”。C++Standard 以“member scope resolution rules”来精炼这个“rewriting rule”，其效果是，如果一个`inline`函数在`class`声明之后立刻被定义的话，那么就还是对其评估求值（evaluate)。

然而，这对于member function的argument list 并不为真。Argument list中的名称还是会在它们第一次遭遇时被适当地决议（resolved）完成。因此在extern和nested type names之间的非直觉绑定操作还是会发生。例如在下面的程序片段中，length的类型在两个member function signatures中都决议（resolve)为global typedef,也就是int.当后续再有length的nested typedef 声明出现时，C+Standard 就把稍早的绑定标示为非法：

```cpp
typedef int length;
class Point3D{
    public:
    	// 1ength 被决议(resolved）为global
        void mumble(length val){_val = val;}
        length mumble() {return _val;}
    private:
        typedef float length;
    	// 1ength 被决议(resolved）为local
        length _val;
};
```

上述这种语言状况，仍然需要某种防御性程序风格：请始终把“nested type声明”放在class的起始处。在上述例子中，如果把length的nested typedef定义于“在class中被参考”之前，就可以确保非直觉绑定的正确性。

**Data Member的布局（Data Member Layout)**



**Data Member的存取**

我用它们来存取data members，像这样：

```cpp
origin.x=0.0;
pt->x=0.0;
```

通过origin存取和通过pt存取，有什么重大差异吗？



“从origin存取”和“从pt存取”有什么重大的差异？答案是“当`Point3d`是一个derived class，而在其继承结构中有一个virtual base class，并且被存取的member(如本例的x）是一个从该virtual base class继承而来的member时，就会有重大的差异”。这时候我们不能够说pt必然指向哪一种 class type（因此我们也就不知道编译时期这个member真正的offset位置），所以这个存取操作必须延迟至执行期，经由一个额外的间接导引，才能够解决。但如果使用origin，就不会有这些问题，其类型无疑是Point3d class，而即使它继承自 virtual baseclass，members的offset位置也在编译时期就固定了。一个积极进取的编译器甚至可以静态地经由 origin就解决掉对x的存取。“从origin存取”和“从pt存取”有什么重大的差异？答案是“当Point3d是一个derived class，而在其继承结构中有一个virtual base class，并且被存取的member(如本例的x）是一个从该virtual base class继承而来的member时，就会有重大的差异”。这时候我们不能够说pt必然指向哪一种 class type（因此我们也就不知道编译时期这个member真正的offset位置），`所以这个存取操作必须延迟至执行期`，经由一个额外的间接导引，才能够解决。但如果使用origin，就不会有这些问题，其类型无疑是Point3d class，而即使它继承自 virtual baseclass，members的offset位置也在编译时期就固定了。一个积极进取的编译器甚至可以静态地经由 origin就解决掉对x的存取。



静态数据成员

。。。

非静态数据成员

。。。



**继承与数据成员**





 **指向Data Members的指针（Pointer to Data Members）**

如果vptr放在对象的尾端，三个坐标值在对象布局中的offset分别是0，4，8。如果vptr放在对象的起头，三个坐标值在对象布局中的offset分别是4，8，12。然而你若去取data members的地址，传回的值总是多1，也就是1，5，9或5，9，13等等。你知道为什么Bjarne决定要这么做吗？

为了区分第一个数据成员与指向类对象的地址。





---

:fu: Function语义学

---



如果我有一个Point3d的指针和对象：

```cpp
Point3d obj;
Point3d *ptr = &obj;
```

当我这样做：

```cpp
obj.normalize();
ptr->normalize();
```

时，会发生什么事？其中的Point3d：：normalize（）定义如下：







**Member的各种调用方式**

非静态成员函数

C++的设计准则之一就是：nonstatic member function 至少必须和一般的nonmember function有相同的效率。

例如下面的两个函数：

```cpp
float magnitude(const Point3d *_this){...}
float Point3d::magnitude(){...}
```

选择member function不应该带来什么额外负担。这是因为编译器内部已将“member函数实例”转换为对等的“nonmember函数实例”。

下面是转化步骤：

1. 改写函数的 signature（译注：意指函数原型）以安插一个额外的参数到member function中，用以提供一个存取管道，使 class object得以将此函数调用。该额外参数被称为 this指针：

   ```cpp
   //non-const nonstatic member的扩张过程
   Point3d Point3d::magnitude(Point3d *const this)
   ```

   如果member function是const，则变成

   ```cpp
   //non-const nonstatic member的扩张过程
   Point3d Point3d::magnitude(const Point3d *const this)
   ```

2. 将每一个“对 nonstatic data member 的存取操作”改为经由 this指针来存取：

   ```cpp
   {
   	return sqrt(
   		this->_x * this->_x +
            this->_y * this->_y +
            this->_z * this->_z);
   }
   ```

3. 将 member function重新写成一个外部函数。将函数名称经过“mangling”处理，使它在程序中成为独一无二的语汇：

   ```cpp
   extern magnitude_7Point3dFv( register Point3d *const this );
   ```

名称的特殊处理

一般而言，member的名称前面会被加上class名称，形成独一无二的命名。例如下面的声明：

```cpp
class Bar {public:int ival;...};
```

其中的ival有可能变成这样：

```cpp
//member 经过name-mangling之后的可能结果之一
ival__3Bar
```





静态成员函数









### 关于typedef的用法总结

[https://www.cnblogs.com/csyisong/archive/2009/01/09/1372363.html](https://www.cnblogs.com/csyisong/archive/2009/01/09/1372363.html)



### :black_nib: 智能指针

#### unique_ptr

`std::unique_ptr` 是通过指针占有并管理另一对象，并在 `unique_ptr` 离开作用域时释放该对象的智能指针。在下列两者之一发生时用关联的删除器释放对象：

- 销毁了管理的 `unique_ptr` 对象
- 通过 `operator=` 或 `reset()` 赋值另一指针给管理的 `unique_ptr` 对象。



#### shared_ptr

`std::shared_ptr` 是通过指针保持对象共享所有权的智能指针。多个 `shared_ptr` 对象可占有同一对象。下列情况之一出现时销毁对象并解分配其内存：

- 最后剩下的占有对象的 `shared_ptr` 被销毁；
- 最后剩下的占有对象的 `shared_ptr` 被通过 `operator=` 或 `reset()` 赋值为另一指针。



每次创建类的新对象时，初始化指针并将引用计数置为1；当对象作为另一对象的副本而创建时，引用计数加1；对一个对象进行赋值时，赋值操作符减少左操作数所指对象的引用计数（如果引用计数为减至0，则删除对象），并增加右操作数所指对象的引用计数；调用析构函数时，构造函数减少引用计数（如果引用计数减至0，则删除基础对象）。

**shared_ptr**的内存模型：

![内存模型](https://i.loli.net/2020/09/10/FICeMdSV9NlLza8.png)

**下面是用类模板简单实现shared_ptr.**

```cpp
#include <iostream>
using namespace std;
 
template<typename T>
class SmartPointer {
private:
	T* p_;
	size_t* count_;
public:
	SmartPointer(T* ptr = nullptr) : p_(ptr) {
		if (p_) {
			count_ = new size_t(1);
		}
		else {
			count_ = new size_t(0);
		}
	}
 
	SmartPointer(const SmartPointer& ptr) {
		p_ = ptr.p_;
		count_ = ptr.count_;
		(*count_)++;
	}
 
	SmartPointer& operator=(const SmartPointer& ptr) {
		if (p_ == ptr.p_) {
			return *this;
		}
 
		if (p_) {
			if (--(*count_) == 0) {
				delete p_;
				delete count_;
			}
		}
 
		p_ = ptr.p_;
		count_ = ptr.count_;
		(*count_)++;
		return *this;
	}
 
	~SmartPointer() {
		if (--(*count_) == 0) {
			delete p_;
			delete count_;
		}
	}
 
	size_t use_count() {
		return *count_;
	}
};
 
int main() {
	SmartPointer<int> sp1(new int(10));
	SmartPointer<int> sp2(sp1);
	SmartPointer<int> sp3(new int(20));
	sp2 = sp3;
	std::cout << sp1.use_count() << std::endl;
	std::cout << sp3.use_count() << std::endl;
}
```

智能指针带来的性能影响:

1）`shared_ptr`的尺寸是裸指针的两倍。 

2）会带来控制块的开销。

3）引用计数的递增和递减是原子操作，原子操作一般都比非原子操作慢。



#### weak_ptr

`weak_ptr` 是一种不控制对象生命周期的智能指针, 它指向一个 `shared_ptr` 管理的对象. 进行该对象的内存管理的是那个强引用的 `shared_ptr`. `weak_ptr`只是提供了对管理对象的一个访问手段。`weak_ptr` 设计的目的是为配合 `shared_ptr` 而引入的一种智能指针来协助 `shared_ptr` 工作, 它只可以从一个 `shared_ptr` 或另一个 `weak_ptr` 对象构造, 它的构造和析构不会引起引用记数的增加或减少。`weak_ptr`是用来解决`shared_ptr`相互引用时的死锁问题,如果说两个`shared_ptr`相互引用,那么这两个指针的引用计数永远不可能下降为0,资源永远不会释放。它是对对象的一种弱引用，不会增加对象的引用计数，和`shared_ptr`之间可以相互转化，`shared_ptr`可以直接赋值给它，它可以通过调用lock函数来获得`shared_ptr`。

```cpp
#include <iostream>
#include <vector>
#include <memory>
using namespace std;
class B;
class A
{
public:
    weak_ptr<B> pb_;
    ~A()
    {
        cout << "A delete\n";
    }
};
class B
{
public:
    shared_ptr<A> pa_;
    ~B()
    {
        cout << "B delete\n";
    }
};

void fun()
{
    shared_ptr<B> pb(new B());
    shared_ptr<A> pa(new A());
    pb->pa_ = pa;
    pa->pb_ = pb;
    cout << pb.use_count() << endl;
    cout << pa.use_count() << endl;
}

int main()
{
    fun();
    return 0;
}
```

> 注意的是我们不能通过weak_ptr直接访问对象的方法，比如B对象中有一个方法print(),我们不能这样访问，pa->pb_->print(); 英文pb_是一个weak_ptr，应该先把它转化为shared_ptr,如：shared_ptr p = pa->pb_.lock(); p->print();







#### 多线程读写`shared_ptr`需要加锁

在现代C++中，通过使用`shared_ptr`这样的智能指针能够很好的降低内存泄漏的可能性，但是在多线程中无保护的读写`shared_ptr`则有可能带来race condition的情况。

> 竞争危害 (race hazard) 又名[竞态条件](https://baike.baidu.com/item/竞态条件/1321097) (race condition)。旨在描述一个系统或者进程的输出展现无法预测的、对事件间相对时间的排列顺序的致命相依性。







---

参考：

1. [C++11--智能指针详解及实现](https://blog.csdn.net/i_chaoren/article/details/82586456)
2. [多线程读写shared_ptr需要加锁](https://originlee.com/2015/05/22/read-write-in-mutithread-need-lock/)



**野指针**

野指针就是指向一个已删除的对象或者未申请访问受限内存区域的指针

# C++内存管理与程序内存分区

## C++内存分区

C++存在如下的内存分区

1）栈区（stack）：由编译器自动分配释放 ，存放函数的 参数值，局部变量的值等。其操作方式类似于数据结 构中的栈。

2）堆区（heap）：一般由程序员分配释放，若程序员不 释放，程序结束时可能由OS回收。注意它与数据结构 中的堆是两回事，分配方式倒是类似于链表。

3）全局/静态区(static）：全局变量和静态变量的存储是 放在一块的，在程序编译时分配

4）文字常量区：存放常量字符串

5）程序代码区：存放函数体（类的成员函数、全局函数） 的二进制代码



C语言中，内存分配有三种：

1. 静态区域分配：由编译器自动分配与释放，内存在编译的时候已经分配好，这块内存在整个程序的运行期间都存在直到程序结束时才被释放，如全局变量与static变量。
2. 栈分配：由编译器在程序运行时从栈上分配，函数栈退出时自动释放。栈分配的运算在处理器的指令集中，所以它的运行效率很高，但能分配的内容是有限的。
3. 堆分配：有程序员主动调用内存分配函数来申请内存，且使用完毕后由程序员自己释放，其使用非常灵活，但其分配方式是通过调用函数来实现，效率没栈高。`malloc`,`alloc`等



## 程序在内存中的分布

![程序内存分区](https://i.loli.net/2020/09/10/g2xFw8PycTqzplY.png)

中文版

![内存分区](eM8XiqRdGhFOnzb.jpg)

1. 内核空间

2. 栈

   1、stack存放函数的临时变量、局部变量、函数参数和返回值
   2、由编译器自动分配和释放。

3. 动态链接库(共享映射区)

   调用的库文件，位于堆和栈之间

4. 堆

   heap用来动态分配内存，由程序员控制，交由程序自身决定开辟和释放。

5. 全局数据区

   `.bss`

   `bss`段用来存放没有被初始化和已经被初始化为0的全局变量

   `.data`

   `data`段用来存放已经被初始化为非0的全局变量

6. 常量区

   `.rodata`

   `rodata`段用来存放常量数据、被编译器自动存放来的字符串和加`const`关键字的常量数据。

7. 代码区

   `.text`

   `text`段用来存放代码和部分整数常量，该段是可执行的。



### 堆与栈

栈是一种的“先进后出”的存储结构。

堆是一种完全二叉树。节点从左到右填满，最后一层的树叶都在最左边。（即如果一个节点没有左边儿子，那么它一定没有右边儿子），每个节点的值都小于（或者大于）其子节点的值（大顶堆、小顶堆）。它的特点是可以使用一维数组来表示。堆的操作也可通过数据元素交换的形式解决，非常适合内存空间线性的特点。



---

参考地址

1. [程序在内存中的分布](https://www.cnblogs.com/Lynn-Zhang/p/5449199.html)
2. http://baijiahao.baidu.com/s?id=1664957369973450228&wfr=spider&for=pc



# C++内存泄漏

> 系统资源泄露（Resource Leak）。主要指程序使用系统分配的资源比如 Bitmap,handle ,SOCKET等没有使用相应的函数释放掉，导致系统资源的浪费，严重可导致系统效能降低，系统运行不稳定。

## 内存泄漏

内存泄漏指由于疏忽或错误造成程序未能释放已经不再使用的内存的情况

### 检测内存泄漏的原理

主要还是运用二进制插桩，记录资源的申请和释放操作，然后对记录进行匹配剔除，最后就是剩下的泄漏的了。



## 检测方法

### 最简单的

**在每一处申请/释放内存的地方进行打点，然后匹对一下就知道哪里内存泄露了。**





## Windows平台下的内存泄漏检测

Windows平台下面Visual Studio 调试器和 C 运行时 (CRT) 库为我们提供了检测和识别内存泄漏的有效方法，原理大致如下：内存分配要通过CRT在运行时实现，只要在分配内存和释放内存时分别做好记录，程序结束时对比分配内存和释放内存的记录就可以确定是不是有内存泄漏。在vs中启用内存检测的方法如下：

1. 在程序中包括以下语句： （#include 语句必须采用上文所示顺序。 如果更改了顺序，所使用的函数可能无法正常工作。）

   ```c
   #define _CRTDBG_MAP_ALLOC
   #include <stdlib.h>
   #include <crtdbg.h>
   ```

   > 通过包括 crtdbg.h，将 [malloc](http://msdn.microsoft.com/zh-cn/library/6ewkz86d.aspx) 和 [free](http://msdn.microsoft.com/zh-cn/library/we1whae7.aspx) 函数映射到它们的调试版本，即 [_malloc_dbg](http://msdn.microsoft.com/zh-cn/library/faz3a37z.aspx) 和 [_free_dbg](http://msdn.microsoft.com/zh-cn/library/16swbsbc.aspx)，这两个函数将跟踪内存分配和释放。 此映射只在调试版本（在其中定义了**_DEBUG**）中发生。 发布版本使用普通的 **malloc** 和 **free** 函数。

   \#define 语句将 CRT 堆函数的基版本映射到对应的“Debug”版本。 并非绝对需要该语句；但如果没有该语句，内存泄漏转储包含的有用信息将较少。

2. 在添加了上述语句之后，可以通过在程序中包括以下语句（通常应恰好放在程序退出位置之前）来转储内存泄漏信息：

   ```c
   _CrtDumpMemoryLeaks();
   ```

   ![结果](https://i.loli.net/2020/09/08/2m8Vo4Cv9utNkYH.png)

   如果没有使用 #define _CRTDBG_MAP_ALLOC 语句，内存泄漏转储将如下所示

   ![image-20200908101606289](https://i.loli.net/2020/09/08/gN3w1bf8QrokKZa.png)

   > 未定义 _CRTDBG_MAP_ALLOC 时，所显示的会是：
   >
   > - 内存分配编号（在大括号内）。
   > - [块类型](http://msdn.microsoft.com/zh-cn/library/htdyz80k.aspx)（普通、客户端或 CRT）。

   

3. 定位到具体的位置



最终定位代码

```c
#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>
#include <crtdbg.h>
 
#include <iostream>
using namespace std;
 
_CrtMemState s1, s2, s3;
 
void GetMemory(char *p, int num)
{
    p = (char*)malloc(sizeof(char) * num);
}
 
int main(int argc,char** argv)
{
    _CrtMemCheckpoint( &s1 );
    char *str = NULL;
    GetMemory(str, 100);
    _CrtMemCheckpoint( &s2 );
    if ( _CrtMemDifference( &s3, &s1, &s2) )
        _CrtMemDumpStatistics( &s3 );
    cout<<"Memory leak test!"<<endl;
    _CrtDumpMemoryLeaks();
    return 0;
}
```



![image-20200908101909957](https://i.loli.net/2020/09/08/4qnMckJ8ydCVwoe.png)



### Linux平台下的内存泄漏检测

Valgrind是一套Linux下，开放源代码（GPL V2）的仿真调试工具的集合。Valgrind由内核（core）以及基于内核的其他调试工具组成。内核类似于一个框架（framework），它模拟了一个CPU环境，并提供服务给其他工具；而其他工具则类似于插件 (plug-in)，利用内核提供的服务完成各种特定的内存调试任务。Valgrind的体系结构如下图所示：

![img](https://i.loli.net/2020/09/08/MQ2pqTxZPFWjKvc.jpg)







---

参考链接：

1. [C/C++内存泄漏及检测](https://www.cnblogs.com/skynet/archive/2011/02/20/1959162.html)
2. 





# C++函数指针

函数指针是指向函数的指针变量。

`指向函数的指针变量`的一般定义形式为： 数据类型 (*指针变量名)(参数表);



参考：[C++函数指针详解](https://www.jianshu.com/p/405a81d8e7b4)



# malloc的原理

`Malloc`函数用于动态分配内存。为了减少内存碎片和系统调用的开销，`malloc`其采用内存池的方式，先申请大块内存作为堆区，然后将堆区分为多个内存块，以块作为内存管理的基本单位。当用户申请内存时，直接从堆区分配一块合适的空闲块。`Malloc`采用隐式链表结构将堆区分成连续的、大小不一的块，包含已分配块和未分配块；同时`malloc`采用显示链表结构来管理所有的空闲块，即使用一个双向链表将空闲块连接起来，每一个空闲块记录了一个连续的、未分配的地址。当进行内存分配时，`Malloc`会通过隐式链表遍历所有的空闲块，选择满足要求的块进行分配；当进行内存合并时，`malloc`采用边界标记法，根据每个块的前后块是否已经分配来决定是否进行块合并。

**`Malloc`在申请内存时，一般会通过`brk`或者`mmap`系统调用进行申请。其中当申请内存小于`128K`时，会使用系统函数`brk`在堆区中分配；而当申请内存大于`128K`时，会使用系统函数`mmap`在映射区分配。**



# C++模板

https://www.cnblogs.com/gw811/archive/2012/10/25/2738929.html

模板是一种对类型进行参数化的工具；通常有两种形式：函数模板和类模板；函数模板针对仅参数类型不同的函数；类模板针对仅数据成员和成员函数类型不同的类。

## 函数模板

#### 函数模板格式

```cpp
　template <class 形参名，class 形参名，......> 返回类型 函数名(参数列表)
　　　{
　　　　　　函数体
　　　}
```

> 其中**template**和**class**是关见字，**class**可以用**typename** 关见字代替，在这里**typename 和class没区别**

## 类模板

#### 类模板格式

```cpp
template<class  形参名，class 形参名，…>   class 类名
　　　　{ ... };
```

类模板对象的创建

比如一个模板类A，则使用类模板创建对象的方法为A<int> m;在类A后面跟上一个<>尖括号并在里面填上相应的类型，这样的话类A中凡是用到模板形参的地方都会被int 所代替。当类模板有两个模板形参时创建对象的方法为A<int, double> m;类型之间用逗号隔开。

在类模板外部定义成员函数的方法为：

```cpp
template<模板形参列表> 函数返回类型 类名<模板形参名>::函数名(参数列表){函数体}，
```

例如：

```cpp
template<class T1,class T2> void A<T1,T2>::h(){}。
```



# C++引用

引用限定符： & 与 && ，有const的话两个限定符均需要在const后面

**移动**

std::move()

**转发**

std::forward()

保持实参的源类型以及值



# 栈或者堆上面创建类

## 在堆上创建类对象

设置析构函数为私有：

```cpp
class HeapClass{
    public:
        HeapClass(){}

    private:
        ~HeapClass(){}
};
```



![r](https://i.loli.net/2020/08/08/pfFMmhwY3uiXENy.png)

## 在栈上创建类对象

重载new和delete运算符为私有

```cpp
class StackClass{
    public:
        StackClass(){}
        ~StackClass(){}
    private:
        void* operator new(size_t t){}
        void operator delete(void *ptr){}
};

```

![r](https://i.loli.net/2020/08/08/DfmtyWHO7Lgo1uK.png)



# 不使用第三个数交换两个数

## 加法

```cpp
void swap1(int &x,int &y)
{
    x = x + y;
    y = x - y;
    x = x - y;
}
```

## 异或

```cpp
void swap2(int &x,int &y)
{
    x = x ^ y;
    y = y ^ x;
    x = x ^ y;
}
```



#  回调函数与仿函数

**为什么使用仿函数？**

1. 迭代和计算逻辑分离
2. 参数可设置
3. 有状态
4. 性能(编译时期就能够确定调用的函数)





函数指针有缺点,最重要的是它无法持有自己的状态(所谓局部状态,localstates），也无法达到组件技术中的可适配性（adaptability）——也就是无法再将某些修饰条件加诸于其上而改变其状态。
为此，STL 算法的特殊版本所接受的所谓“条件”或 “策略”或 “一整组操作”，都以仿函数形式呈现。所谓仿函数（functor）就是使用起来像函数一样的东西。如果你针对某个 class 进行 operator(）重载，它就成为一个仿函数。

```cpp
#include <iostream>
#include <algorithm>
using namespace std;
//回调函数
void call_back(char elem)
{
 cout << elem << endl;
}
//仿函数
struct Functor
{
 void operator() (char elem) 
 {
  cout << elem << endl;
 } 
};
int main()
{
 string strA = "hello";
 string strB = "world";
 
 for_each(strA.begin(),strA.end(),Functor());
 cout<<"===========GAP==============="<<endl;
 for_each(strB.begin(),strB.end(),call_back);
 getchar();
 return 0;
}
```

> 仿函数需要经过3次的构造和析构。

仿函数和回调函数区别在于:

1. 使用仿函数可以声明在业务相关的类内部 缩小作用域
2. 使用仿函数可以使用类的成员属性和成员函数
3. 仿函数是一个**类** 可以使用面向对象的各种机制(封装 继承 多态)
4. 若使用回调函数 那么只能声明为某个类的静态成员函数或全局函数，使用类内部的资源需要用一些手段传参,没有直接使用成员函数便捷

---

参考：

https://my.oschina.net/mlgb/blog/290350

[C++仿函数（functor）](https://my.oschina.net/llehs/blog/180594)











# C++析构函数为什么是虚函数

原因：基类对象的指针操作派生类对象时，防止析构函数只调用基类的，而不调用派生类的



参考：

1. https://blog.csdn.net/zkangaroo/article/details/57000397

+++++++++++++++++









# 实现memcpy:memo:

```cpp
void *my_memcpy(void *dst, void *src, int n)
{
    char *d = (char *)(dst);
    char *s = (char *)(src);
    if (d > s && d < s + n)
    {
        for(int i = n-1;i >= 0;--i)
            *(d + i) = *(s + i);
    }
    else
    {
        for(int i = 0;i < n;++i)
            *(d + i) = *(s + i);
    }
    return dst;
}
```

### memmove与memcpy的区别？



### strcpy与mencpy的区别?





# 快速排序:timer_clock:

```cpp
int partition(vector<int> &nums, int start, int end)
{
	int p = nums[start];
	while (start < end)
	{
		while (nums[end] >= p && start < end)
			--end;
		nums[start] = nums[end];
		while (nums[start] <= p && start < end)
			++start;
		nums[end] = nums[start];
	}
	nums[start] = p;
	return start;
}

void quick_sort(vector<int> &nums, int left, int right)
{
	if (left < right)
	{
		int p = partition(nums, left, right);
		quick_sort(nums, left, p - 1);
		quick_sort(nums, p + 1, right);
	}
}
```



# 堆排序:bowling:

```cpp
void heap_sort(vector<int> &nums, int n)
{
	if (n == 1)
		return;
	for (int i = n / 2 - 1; i >= 0; --i)
	{
		int left = 2 * i + 1, right = 2 * i + 2;
		int imax = i;
		if (left < n && nums[left] > nums[imax])
			imax = left;
		if (right < n && nums[right] > nums[imax])
			imax = right;
		if (imax != i)
			swap(nums[i], nums[imax]);
	}
	swap(nums[0], nums[n - 1]);
	heap_sort(nums, n - 1);
}
```





# :high_heel:堆TopK



[C++实现最大堆和最小堆](https://blog.csdn.net/qq_37941471/article/details/81841624)

[最小堆 构建、插入、删除的过程图解](https://blog.csdn.net/hrn1216/article/details/51465270)



---
#Network

![img](https://i.loli.net/2020/11/12/9QHpVy1oEwDJ3uX.png)

参考：

1. [搞定计算机网络面试，看这篇就够了（补充版）](https://juejin.im/post/6844903662838349838)

# 多问为什么！

### :level_slider: 网络分层

`OSI`与`TCP/IP`分层模型

![网络分层模型](https://i.loli.net/2020/11/08/ehZWxY8KMJpaBQr.png)

**为什么网络需要分层？**

* 大部分软件系统都是分层架构的，为了工程上实现/调试/维护方便。网络系统分得更明显一点，因为其系统设计写成了协议。

* 把`TCP/IP`层次化是有好处的。比如，如果互联网只由一个协议统筹，某个地方需要改变设计时，就必须把所有部分整体替换掉。而分层之后只需把变动的层替换掉即可。把各层之间的接口部分规划好之后，每个层次内部的设计就能够自由改动了。

**分层模型传输过程**

![分层模型传输过程](https://i.loli.net/2020/11/11/bwuhqyjpio1AO7r.png)

发送端在层与层之间传输数据时，每经过一层时必定会被打上一个该层所属的首部信息。反之，接收端在层与层传输数据时，每经过一层时会把对应的首部消去。

---

参考：[为什么网络协议选择分层设计？这样做有什么好处？](https://www.zhihu.com/question/26424507)

### :3rd_place_medal: 为什么需要三次握手

**为什么TCP客户端最后还要发送一次确认呢？**

1. 为了防止 **已失效的链接请求报文突然又传送到了服务端**，因而产生错误。

   客户端发出的连接请求报文并未丢失，而是在某个网络节点长时间滞留了，以致延误到链接释放以后的某个时间才到达Server。这是，Server误以为这是Client发出的一个新的链接请求，于是就向客户端发送确认数据包，同意建立链接。若不采用“三次握手”，那么只要Server发出确认数据包，新的链接就建立了。由于client此时并未发出建立链接的请求，所以其不会理睬Server的确认，也不与Server通信；而这时Server一直在等待Client的请求，这样Server就白白浪费了一定的资源。若采用“三次握手”，在这种情况下，由于Server端没有收到来自客户端的确认，则就会知道Client并没有要求建立请求，就不会建立链接。

   **如果采用的是三次握手，就算是那一次失效的报文传送过来了，服务端接受到了那条失效报文并且回复了确认报文，但是客户端不会再次发出确认。由于服务器收不到确认，就知道客户端并没有请求连接。**

2. 因为双方都需要确认对方收到了自己发送的序列号，确认过程最少要进行三次通信。

   参考：[知乎 . TCP 为什么是三次握手，而不是两次或四次？](https://www.zhihu.com/question/24853633/answer/115173386)

3. 因为信道不可靠，而 TCP 想在不可靠信道上建立可靠地传输，那么三次通信是理论上的最小值。（而 UDP 则不需建立可靠传输，因此 UDP不需要三次握手。）

   参考：[Google Groups . TCP 建立连接为什么是三次握手？{技术}{网络通信}](https://groups.google.com/forum/#!msg/pongba/kF6O7-MFxM0/5S7zIJ4yqKUJ)

   

> **TCP传了 SYN,为啥还要传 ACK**？
>
> 双方通信无误必须是两者互相发送信息都无误。传了 SYN，证明发送方到接收方的通道没有问题，但是接收方到发送方的通道还需要 ACK 信号来进行验证。

### :hand: 为什么是四次挥手？

1. **这个是一个全双工的连接，两边都需要断开，每次的断开都需要两次的握手。**

   建立连接的时候， 服务器在LISTEN状态下，收到建立连接请求的SYN报文后，把ACK和SYN放在一个报文里发送给客户端。
   而关闭连接时，服务器收到对方的FIN报文时，仅仅表示对方不再发送数据了但是还能接收数据，而自己也未必全部数据都发送给对方了，所以己方可以立即关闭，也可以发送一些数据给对方后，再发送FIN报文给对方来表示同意现在关闭连接，**因此，己方ACK和FIN一般都会分开发送，从而导致多了一次。即另一方并不需要也急着断开，还可以继续发送消息。**

2. **服务器可能还有数据需要传输给客户端**

   因为客户端请求释放时，**服务器可能还有数据需要传输给客户端，因此服务端要先响应客户端 FIN 请求（服务端发送 ACK），然后数据传输**，传输完成后，服务端再提出 FIN 请求（服务端发送 FIN）；而连接时则没有中间的数据传输，因此连接时可以 ACK 和 SYN 一起发送。



**为什么客户端最后还要等待2MSL？**

MSL（Maximum Segment Lifetime），TCP允许不同的实现可以设置不同的MSL值。

第一，保证客户端发送的最后一个ACK报文能够到达服务器，因为这个ACK报文可能丢失，站在服务器的角度看来，我已经发送了FIN+ACK报文请求断开了，客户端还没有给我回应，应该是我发送的请求断开报文它没有收到，于是服务器又会重新发送一次，而客户端就能在这个2MSL时间段内收到这个重传的报文，接着给出回应报文，并且会重启2MSL计时器。

第二，防止类似与“三次握手”中提到了的“已经失效的连接请求报文段”出现在本连接中。客户端发送完最后一个确认报文后，在这个2MSL时间中，就可以使本连接持续的时间内所产生的所有报文段都从网络中消失。这样新的连接中不会出现旧连接的请求报文。

---

参考：

1. [两张动图-彻底明白TCP的三次握手与四次挥手](https://blog.csdn.net/qzcsu/article/details/72861891)

### :field_hockey: 如果已经建立了连接，但是客户端突然出现故障了怎么办？

TCP还设有一个**保活计时器**，显然，客户端如果出现故障，服务器不能一直等下去，白白浪费资源。服务器每收到一次客户端的请求后都会重新复位这个计时器，时间通常是设置为2小时，若两小时还没有收到客户端的任何数据，服务器就会发送一个探测报文段，以后每隔75秒发送一次。若一连发送10个探测报文仍然没反应，服务器就认为客户端出了故障，接着就关闭连接。

### :chart_with_downwards_trend: ​GET 和 POST的区别

1. GET用来**获取数据**，POST用来**提交数据**
2. GET请求通过URL（请求行）提交数据，**在URL中可以看到所传参数**。POST通过“请求体”传递数据，**参数不会在url中显示**
3. **GET请求提交的数据有长度限制，POST请求没有限制。**
4. GET请求返回的内容可以被浏览器缓存起来。而每次提交的POST，浏览器在你按下F5的时候会跳出确认框，浏览器不会缓存POST请求返回的内容。
5. GET对数据进行查询，POST主要对数据进行增删改！简单说，GET是只读，POST是写。
6. get 请求的url是在服务器上有日志记录，在浏览器也能查到历史记录，但是post请求的参数都在body里面，浏览器历史记录不到

> 如果是指网络安全，那两者一样。
> 如果考虑到某些服务端和客户端的默认配置和默认使用方式，那么POST在很多时候比GET安全。
> 而在HTTP的定义中，GET被称为安全方法，POST却不是.

感觉对于服务器更安全的是Get，对于客户端更安全的是Post。

**本质上：**

首先get和post在本质上都是tcp链接，但由于http协议和浏览器或者服务器的限制，从而使它们在应用过程中产生了差别，但是它们中还有一个较大的区别：**get在请求时发送一个数据包，会将header和data一起发送过去，而post会产生两个数据包先发送header，服务器返回100，然后在发送data，服务器返回200**

> 所以当你一层一层的把get和post剖析到底，你会发现他们的本质就是tcp连接，没有啥区别，只是由于http协议规定和浏览器或者服务器的限制，导致他们在应用过程中体现形式不同。



**RFC**：

**1.safe（安全）**

> 这里的安全和通常所理解的安全意义不同，就好比如果一个请求的语义本质上就是获取数据（只读），那么这个请求就是安全的。客户端向服务器发起的请求如果没有引起服务器端任何的状态变化，那么他就是安全的而post请求来提交数据必然会是服务器发生相应的变化。从这个维度来看，get请求相对服务器而言，是安全的，post则不安全的。

**ldempotend（幂等）**

> **幂等通俗的来讲就是指同一个请求执行多次和仅执行一次的效果完全相等。**这里来扯出幂等主要是为了处理同一个请求重复发送的情况，假如在请求响应之前失去连接，如果这个请求时幂等的，那么就可以放心的重发一次请求。所以可以得出get请求时幂等的，可以重复发送请求，post请求时不幂等的，重复请求可能会发生无法预知的后果。

**cacheable（可缓存性）**

> 顾名思义，就是一个请求是否可以被缓存，绝大多数部分，post都是不可缓存的（某些浏览器可能支持post缓存），但get是可以缓存的。

**勉强理解一下大概就是：**

> get是请求获取指定资源，get方法时安全、幂等、可缓存的，get方法的报文主体没有任何语义。

> post是根据报文主体来对指定资源做出处理，post不安全，不幂等，不可缓存（大部分情况下）。



---

参考：

1. [都 2019 年了，还问 GET 和 POST 的区别](https://blog.fundebug.com/2019/02/22/compare-http-method-get-and-post/)
2. [POST 方法比 GET 方法更安全吗? 为什么?](https://www.zhihu.com/question/54076547)
3. [get和post的区别？](https://juejin.im/post/6844903824738500615)



### :fallen_leaf: HTTP报文

#### 请求报文

HTTP 请求报文由3部分组成(请求行+请求头+请求体)

![HTTP请求报文](https://i.loli.net/2020/11/11/pGh3toQX8WC6Nq5.png)

**请求行**包括：请求方法、请求URL、HTTP协议及版本：

GET和POST是最常见的HTTP方法,初次以外还包括 DELETE、HEAD、OPTIONS、PUT、TRACE，不过现在大部分的浏览器只支持GET和POST

请求对应的URL地址,他和报文头的Host属性,组合起来是一个完整的请求URL



**报文头**是一些参数信息：

有若干个属性,形式为key:val,服务端据此获取客户端信息

**报文体**是具体传输的内容。



#### 响应报文

响应报文与请求报文一样,由三个部分组成(响应行,响应头,响应体)

![HTTP响应报文](https://i.loli.net/2020/11/11/vtYpgrFsSqO6UTA.png)



参考：[HTTP请求头和响应头详解](https://www.jianshu.com/p/9a68281a3c84)

### :station: HTTP状态码：

![HTTP状态码](https://i.loli.net/2020/10/19/3Ow5z4nsGbPrMoD.png)

- 1xx：表示通知信息，如请求收到了或正在进行处理
  - 100 Continue：继续，客户端应继续其请求
  - 101 Switching Protocols 切换协议。服务器根据客户端的请求切换协议。只能切换到更高级的协议，例如，切换到 HTTP 的新版本协议
- 2xx：表示成功，如接收或知道了
  - 200 OK: 请求成功
- 3xx：表示重定向，如要完成请求还必须采取进一步的行动
  - 301 Moved Permanently: 永久移动。请求的资源已被永久的移动到新 URL，返回信息会包括新的 URL，浏览器会自动定向到新 URL。今后任何新的请求都应使用新的 URL 代替
- 4xx：表示客户的差错，如请求中有错误的语法或不能完成
  - 400 Bad Request: 客户端请求的语法错误，服务器无法理解
  - 401 Unauthorized: 请求要求用户的身份认证
  - 403 Forbidden: 服务器理解请求客户端的请求，但是拒绝执行此请求（权限不够）
  - 404 Not Found: 服务器无法根据客户端的请求找到资源（网页）。通过此代码，网站设计人员可设置 “您所请求的资源无法找到” 的个性页面
  - 408 Request Timeout: 服务器等待客户端发送的请求时间过长，超时
- 5xx：表示服务器的差错，如服务器失效无法完成请求
  - 500 Internal Server Error: 服务器内部错误，无法完成请求
  - 503 Service Unavailable: 由于超载或系统维护，服务器暂时的无法处理客户端的请求。延时的长度可包含在服务器的 Retry-After 头信息中
  - 504 Gateway Timeout: 充当网关或代理的服务器，未及时从远端服务器获取请求

### :hand: HTTP的主要方法

<img src="https://i.loli.net/2020/11/07/3rBJ2u5WDK7kRZF.png" alt="HTTP方法" style="zoom: 67%;" />

| 方法    | 意义                                                         |
| ------- | ------------------------------------------------------------ |
| OPTIONS | 请求一些选项信息，允许客户端查看服务器的性能                 |
| GET     | 请求指定的页面信息，并返回实体主体                           |
| HEAD    | 类似于 get 请求，只不过返回的响应中没有具体的内容，用于获取报头 |
| POST    | 向指定资源提交数据进行处理请求（例如提交表单或者上传文件）。数据被包含在请求体中。POST请求可能会导致新的资源的建立和/或已有资源的修改 |
| PUT     | 从客户端向服务器传送的数据取代指定的文档的内容               |
| DELETE  | 请求服务器删除指定的页面                                     |
| TRACE   | 回显服务器收到的请求，主要用于测试或诊断                     |

* 下面这个例子是查询HTTP服务器端支持的HTTP方法种类。

  ![OPTIONS操作](https://i.loli.net/2020/11/11/5VeAOKHfTIRpuvL.png)

### :dizzy: HTTP2.0与HTTP1.0的区别

![HTTP区别](https://i.loli.net/2020/11/08/V91ZJx8fDbi2cBK.png)



### :inbox_tray: 什么是`SQL`注入？

`SQL`注入就是通过把`SQL`命令插入到Web表单提交或输入域名或页面请求的查询字符串，最终达到欺骗服务器执行恶意的`SQL`命令。



`SQL`注入的思路：

1. SQL注入的位置
2. 判断服务器类型和后台数据类型
3. 针对不通的服务器和数据库特点进行`SQL`注入攻击

应对的方法：

1. **参数绑定**使用预编译手段，绑定参数是最好的防SQL注入的方法。目前许多的ORM框架及JDBC等都实现了SQL预编译和参数绑定功能，攻击者的恶意SQL会被当做SQL的参数而不是SQL命令被执行。在mybatis的mapper文件中，对于传递的参数我们一般是使用`#`和`$`来获取参数值。当使用`#`时，变量是占位符，就是一般我们使用javajdbc的PrepareStatement时的占位符，所有可以防止sql注入；当使用​`$`时，变量就是直接追加在sql中，一般会有sql注入问题。
2. **使用正则表达式过滤传入的参数**



### :cookie: Cookie技术

`Cookie` 通过在请求和响应报文中写入 Cookie 信息来控制客户端的状态。

相当于，**在客户端第一次请求后，服务器会下发一个装有客户信息的「小贴纸」，后续客户端请求服务器的时候，带上「小贴纸」，服务器就能认得了了**。

* 没有Cookie信息状态下的请求

  ![](https://i.loli.net/2020/11/11/sWbtqAl25B3c1Mf.png)

* 第2次以后（存有Cookie信息状态）的请求

  ![](https://i.loli.net/2020/11/11/fxLopbZyX5684ar.png)

**底层原理**

*  WEB服务器通过在HTTP响应消息中增加Set-Cookie响应头字段将Cookie信息发送给浏览器，

*  浏览器则通过在HTTP请求消息中增加Cookie请求头字段将Cookie回传给WEB服务器。



Cookie的传送过程示意图

![Cookie流程](https://i.loli.net/2020/11/08/mqBkljREA9ZrG17.jpg)



**Cookie的缺陷**

(1) cookie会被附加在每个HTTP请求中，所以无形中增加了流量。

(2) 由于在HTTP请求中的cookie是明文传递的，所以安全性成问题。（除非用HTTPS)

(3) Cookie的大小限制在4KB左右。对于复杂的存储需求来说是不够用的。



---

参考：

1. [会话技术——Cookies和Session详解](https://juejin.im/post/6844903930346881038)

### :speech_balloon: Session技术

**什么是会话？**

**会话是浏览器和服务器之间的多次请求和响应**。也就是说，从浏览器**访问服务器开始**，到**访问服务器结束**，**浏览器关闭为止**的这段时间内容产生的**多次请求和响应**，合起来叫做浏览器和服务器之间的一次会话。

**为什么使用会话技术？**

实际上会话问题解决的还是客户端与服务器之间的通信问题，通过一些会话技术，可以将每个用户的数据以例如cookie/session的形式存储，方便以后用户访问web资源的时候使用

> 假定场景：A和B两人在某个网上购物商场登陆账号后，A买了一个HHKB的键盘，而B则购买了一把民谣吉他，这些信息都会被保存下来
>
> 用途是：保存账户信息，登录时询问日后是否自动登录，或者根据之前浏览，购买过的商品，分析用户喜欢什么类型的商品，做出精准推送

服务器使用session把用户的信息临时保存在了服务器上，用户离开网站后session会被销毁。这种用户信息存储方式相对cookie来说更安全，**可是session有一个缺陷：如果web服务器做了负载均衡，那么下一个操作请求到了另一台服务器的时候session会丢失。**

![Cookie管理Session](https://i.loli.net/2020/11/11/yODECA6QiuZRpg9.png)



---

参考：

1. [会话技术——Cookies和Session详解](https://juejin.im/post/6844903930346881038)
2. [彻底理解cookie，session，token](https://zhuanlan.zhihu.com/p/63061864)
3. [认识HTTP----Cookie和Session篇](https://zhuanlan.zhihu.com/p/27669892)



### :camera_flash: Session和Cookie的区别

**从存储方式上比较**

Cookie只能存储字符串，如果要存储非ASCII字符串还要对其编码。

Session可以存储任何类型的数据，可以把Session看成是一个容器

**从隐私安全上比较**

Cookie存储在浏览器中，对客户端是可见的。信息容易泄露出去。如果使用Cookie，最好将Cookie加密

Session存储在服务器上，对客户端是透明的。不存在敏感信息泄露问题。

**从有效期上比较**

Cookie保存在硬盘中，只需要设置maxAge属性为比较大的正整数，即使关闭浏览器，Cookie还是存在的

Session的保存在服务器中，设置maxInactiveInterval属性值来确定Session的有效期。并且Session依赖于名为JSESSIONID的Cookie，该Cookie默认的maxAge属性为-1。如果关闭了浏览器，该Session虽然没有从服务器中消亡，但也就失效了。

**从对服务器的负担比较**

Session是保存在服务器的，每个用户都会产生一个Session，如果是并发访问的用户非常多，是不能使用Session的，Session会消耗大量的内存。

Cookie是保存在客户端的。不占用服务器的资源。像baidu、Sina这样的大型网站，一般都是使用Cookie来进行会话跟踪。

**从浏览器的支持上比较**

如果浏览器禁用了Cookie，那么Cookie是无用的了！

如果浏览器禁用了Cookie，Session可以通过URL地址重写来进行会话跟踪。

**从跨域名上比较**

Cookie可以设置domain属性来实现跨域名

Session只在当前的域名内有效，不可跨域名

### :copyright: `IP`协议

`IP`协议的作用是把各种数据包传送给对方。而要保证确实传送到对方那里，则需要满足各类条件。其中两个重要的条件是`IP`地址和`MAC`地址（Media Access Control Address）。**`IP`地址指明了节点被分配到的地址，`MAC`地址是指网卡所属的固定地址**。`IP`地址可以和MAC地址进行配对。`IP`地址可变换，但`MAC`地址基本上不会更改。

什么是MAC地址？

MAC地址也叫物理地址、硬件地址，由网络设备制造商生产时烧录在网卡的[EPROM](https://baike.baidu.com/item/EPROM/1690813)(一种闪存芯片，通常可以通过程序擦写)。[IP地址](https://baike.baidu.com/item/IP地址/150859)与MAC地址在计算机里都是以[二进制](https://baike.baidu.com/item/二进制/361457)表示的，IP地址是32位的，而MAC地址则是48位的 。

#### 有了 IP 地址，为什么还要用 MAC 地址

IP地址属于网络层，而MAC地址属于数据链路层。 网络层协议使数据可以从一个网络传递到另一个网络上（ARP根据目的IP地址，找到中间节点的MAC地址，通过中间节点传送，从而最终到达目的网络）；数据链路层协议可以使数据从一个节点传递到相同链路的另一个节点上（通过MAC地址）。

1. **MAC地址寻址的时间复杂度太大**

   如果只有MAC地址，是无法支撑起这么大的网络的，你觉得直接访问到MAC地址就行了，问题是你让路由器怎么给你找到路线呢？

2. **没有统一的硬件地址**

   由于全世界存在着各式各样的网络，`他们使用不同的硬件地址`。要使这些异构网络能够互相通信就必须进行`非常复杂的硬件地址转化工作`，因此由用户或用户主机来完成这项工作几乎是不可能的的事。但IP编址就把这个复杂的问题解决了。连接到互联网的主机只需要各自拥有一个唯一的IP地址，他们之间的通信就像连接在同一个网络那么简单方便。因为ARP是由计算机软件自动进行的，对用户来说是看不见这种调用过程的。

> IP地址是逻辑地址，需要映射到物理地址MAC地址才能将数据写入对方的网卡。

---

参考：

1. [有了 IP 地址，为什么还要用 MAC 地址](https://blog.csdn.net/hsd2012/article/details/51074549)
2. [为什么有了Mac地址，还要IP地址](https://www.jianshu.com/p/7d8df9db0484)



### :artificial_satellite: DNS协议



`DNS`（Domain Name System）服务是和HTTP协议一样位于应用层的协议。它提供域名到IP地址之间的解析服务。

简单的过程：

![DNS简单解析过程](https://i.loli.net/2020/11/11/h1Di7pjZxnPqYgz.png)

复杂解析过程：

当一个应用进程需要把主机名解析为`ip`地址时，该应用进程就调用解析程序，并成为`dns`的一个客户，把待解析的域名在`dns`请求报文中，以**`udp`用户数据报**方式发送给本地域名服务器。**本地域名服务器**在查找域名后，把对应的`ip`地址放在回答报文中返回。应用进程获得目的主机的`ip`地址后即可进行通信。
若本地域名服务器不能回答该请求，则此域名服务器就暂时成为了`dns`中的另一个客户，并向其它域名服务器发送查询请求。这种过程直至找到能够回答该请求的域名服务器为止。

![img](https://i.loli.net/2020/10/18/pTKw2oPygBu3N1C.jpg)



域名服务解析的两种方式：

**客户端发出的查询都是递归查询，DNS服务器向外发出的查询一般都是迭代查询**

![递归查询](https://i.loli.net/2020/10/18/4otA7jgN9UEnHO5.jpg)



![迭代查询](https://i.loli.net/2020/10/18/AIYaNl6HeUxySgt.jpg)





![递归加迭代](https://i.loli.net/2020/10/18/GFAp6VNz71CHd9L.jpg)



### 



### :card_file_box: FTP协议

文件传输协议FTP(File Transfer Protocol)是因特网中使用最广泛的文件传输协议。FTP使用交互式的访问，允许客户指定文件的类型和格式(如指明是否使用ASCII码)，并允许文件具有存取权限(如访问文件的用户必须经过授权，并输入有效的口令)。

文件传输协议有基于**TCP**的FTP和基于**UDP**的简单文件传输协议**TFTP**，它们都是文件共享协议中的一大类，即复制整个文件，其特点是：若要存取一个文件，就必须先获得一个本地的文件副本。如果要修改文件，只能对文件的副本进行修改，然后再将修改后的文件传回到原节点。



与Telnet类似，FTP最早的设计是用于两台不同的主机，这两个主机可能运行在不同的操作系统下、使用不同的文件结构、并可能使用不同字符集。但不同的是，Telnet获得异构性是强制两端都采用同一个标准：使用7比特ASCII码的NVT。而FTP是采用另一种方法来处理不同系统间的差异。FTP支持有限数量的文件类型（ASCII，二进制，等等）和文件结构（面向字节流或记录）



FTP与我们已描述的另一种应用不同，它采用两个TCP连接来传输一个文件。

1. 控制连接以通常的客户服务器方式建立。服务器以被动方式打开众所周知的用于FTP的端口（21），等待客户的连接。客户则以主动方式打开TCP端口21，来建立连接。控制连接始终等待客户与服务器之间的通信。该连接将命令从客户传给服务器，并传回服务器的应答。
   由于命令通常是由用户键入的，所以IP对控制连接的服务类型就是“最大限度地减小迟延”。
2. 每当一个文件在客户与服务器之间传输时，就创建一个数据连接。（其他时间也可以创建，后面我们将说到）。
   由于该连接用于传输目的，所以IP对数据连接的服务特点就是“最大限度提高吞吐量”。



连接情况：

![文件传输中的过程处理](https://i.loli.net/2020/11/12/YNWHw5nD4kyS67Z.png)

从图中可以看出，交互式用户通常不处理在控制连接中转换的命令和应答。这些细节均由两个协议解释器来完成。标有“用户接口”的方框功能是按用户所需提供各种交互界面（全屏幕菜单选择，逐行输入命令，等等），并把它们转换成在控制连接上发送的FTP命令。类似地，从控制连接上传回的服务器应答也被转换成用户所需的交互格式。





---

参考：

1. [深入理解FTP协议](https://www.cnblogs.com/luoxn28/p/5585458.html)
2. [第27章 FTP:文件传送协议](http://docs.52im.net/extend/docs/book/tcpip/vol1/27/)







## X.509 数字证书

简单来说，数字证书就是一张附带了数字签名的信息表。

<img src="https://i.loli.net/2020/08/25/7XI4THyOUWvmwCx.jpg" alt="X.509证书" style="zoom:67%;" />

### 数字证书的签署

总的来说，就是对公钥和信息进行hash得到摘要，然后使用私钥对摘要进行加密得到加密后的摘要。加加密后的摘要和公钥以及信息包装成一个证书。

#### 根认证机构的构建

**简要流程**

1. 根认证机构「CA」生成公钥 `ca_KeyPub` 和私钥 `ca_KeyPri`，以及基本信息表 `ca_Info`。`ca_Info` 中一般包含了「CA」的名称、证书的有效期等信息。
2. 根认证机构「CA」对（`ca_KeyPub` + `ca_Info`）进行散列运算，得到散列值 `ca_Hash`。
3. 根认证机构「CA」使用其私钥 `ca_KeyPri` 对 `ca_Hash` 进行非对称加密，得到加密的散列值 `enc_ca_Hash`。
4. 根认证机构「CA」将（`ca_KeyPub` + `ca_Info` + `enc_ca_Hash`）组合生成自签名的数字证书**「ca_Cert」**。这张证书称之为根证书。

根证书**「ca_Cert」**包含的内容：`ca_KeyPub` + `ca_Info` + `enc_ca_Hash`。

![根认证机构](https://i.loli.net/2020/08/25/9Zj4xVOUKuL7B6r.png)

**「ca_Cert」**可用于签署下一级的证书。

#### 单级认证机构的证书签署

**简要流程**

1. 服务器「S」生成公钥 `s_KeyPub` 和私钥 `s_KeyPri`，以及基本信息表 `s_Info`。`s_Info` 中一般包含了「S」的名称、证书要求的有效期等信息。
2. 服务器「S」将 `s_KeyPub`、`s_Info` 送给根认证机构「CA」。
3. 根认证机构「CA」通过某种方式验证「S」的身份之后，再加上根认证机构自己的一些信息 `ca_Info`，然后对它们（`s_KeyPub` + `s_Info` + `ca_Info`）进行散列运算，得到散列值 `s_Hash`。
4. 根认证机构「CA」使用其私钥 `ca_KeyPri` 对 `s_Hash` 进行非对称加密，得到加密的散列值 `enc_s_Hash`。
5. 根认证机构「CA」将（`s_KeyPub` + `s_Info` + `ca_Info` + `enc_s_Hash`）组合签署成数字证书**「s_Cert」**并回送给「S」。

服务器证书**「s_Cert」**包含的内容：`s_KeyPub` + `s_Info` + `ca_Info` + `enc_s_Hash`。

![单级认证机构的证书签署](https://i.loli.net/2020/08/25/H9ysQozAJO825av.png)

**「s_Cert」**不可用于签署下一级的证书。

#### 二级（或以上）认证机构的构建

> 在现实中，仅仅靠一个认证机构是满足不了海量证书签署需求的，因此需要构建分支认证机构。

**简要流程**

1. 二级认证机构「CA2」生成公钥 `ca2_KeyPub` 和私钥 `ca2_KeyPri`，以及基本信息表 `ca2_Info`。`ca2_Info` 中一般包含了「CA2」的名称、证书要求的有效期等信息。
2. 二级认证机构「CA2」将 `ca2_KeyPub`、`ca2_Info` 送给根认证机构「CA」。
3. 根认证机构「CA」通过某种方式验证「CA2」的身份之后，再加上根认证机构自己的一些信息 `ca_Info`，然后对它们（`ca2_KeyPub` + `ca2_Info` + `ca_Info`）进行散列运算，得到散列值 `ca2_Hash`。
4. 根认证机构「CA」使用其私钥 `ca_KeyPri` 对 `ca2_Hash` 进行非对称加密，得到加密的散列值 `enc_ca2_Hash`。
5. 根认证机构「CA」将（`ca2_KeyPub` + `ca2_Info` + `ca_Info` + `enc_ca2_Hash`）组合签署成数字证书**「ca2_Cert」**并回送给「CA2」。

二级认证机构证书**「ca2_Cert」**包含的内容：`ca2_KeyPub` + `ca2_Info` + `ca_Info` + `enc_ca2_Hash`。

**「ca2_Cert」**可用于签署下一级的证书。

三级或更多级认证机构的构建流程跟这个流程差不多，这里就不再赘述了。

#### 二级（或以上）认证机构的证书签署

**简要流程**

1. 服务器「S2」生成公钥 `s2_KeyPub` 和私钥 `s2_KeyPri`，以及基本信息表 `s2_Info`。`s2_Info` 中一般包含了「S2」的名称、证书要求的有效期等信息。
2. 服务器「S2」将 `s2_KeyPub`、`s2_Info` 送给二级认证机构「CA2」。
3. 二级认证机构「CA2」通过某种方式验证「S2」的身份之后，再加上根认证机构自己的一些信息 `ca2_Info`，然后对它们（`s2_KeyPub` + `s2_Info` + `ca2_Info`）进行散列运算，得到散列值 `s2_Hash`。
4. 二级认证机构「CA2」使用其私钥 `ca2_KeyPri` 对 `s2_Hash` 进行非对称加密，得到加密的散列值 `enc_s2_Hash`。
5. 二级认证机构「CA2」将（`s2_KeyPub` + `s2_Info` + `ca2_Info` + `enc_s2_Hash`）组合签署成数字证书**「s2_Cert」**并回送给「S2」。

服务器证书**「s2_Cert」**包含的内容：`s2_KeyPub` + `s2_Info` + `ca2_Info` + `enc_s2_Hash`。

**「s2_Cert」**不可用于签署下一级的证书。

三级或更多级认证机构证书签署流程跟这个流程差不多，也不再赘述了。

从上面可以看出，证书签署的流程是：**「ca_Cert」**-> **「ca2_Cert」**->**「s2_Cert」**。它是一条完整的链条，我们把它称之为「证书链」。

#### 现实中的证书签署

现实中的证书大多数是由二级认证机构签署的。

并且，以某种方式（如 DNS）对服务器的身份进行验证之后，一般无需让服务器提供任何信息（CSR 文件）。

认证机构会提供证书、证书链以及私钥，服务器直接使用就好了。

### 服务器的配置

如果服务器「S」使用的证书是由根认证机构「CA」直接签署的，那么只需要向客户端提供**「s_Cert」**，然后自己使用私钥 `s_KeyPri` 即可实现非对称加密。

如果服务器「S2」使用的证书不是由根认证机构「CA」直接签署的，则不仅需要向客户端提供**「s2_Cert」**，而且还要提供除根认证机构「CA」之外所有认证机构的证书（这里还要提供**「ca2_Cert」**），否则客户端可能会提示证书链不完整而无法通过验证。服务器自己使用私钥 `s2_KeyPri` 即可实现非对称加密。

### 客户端验证服务器的身份

#### 单级认证机构的验证

**简要流程**

（假设根认证机构「CA」的根证书**「ca_Cert」**已经安装到操作系统中且被信任。下同。）

1. 服务器「S」下发证书**「s_Cert」**给客户端「C」。
2. 客户端「C」检查到**「s_Cert」**中的 `ca_Info`，发现它是由「CA」签署的。
3. 客户端「C」取出**「ca_Cert」**中的 `ca_KeyPub`，对**「s_Cert」**中的 `enc_s_Hash` 进行解密得到 `s_Hash`。
4. 客户端「C」对**「s_Cert」**中的（`s_KeyPub` + `s_Info` + `ca_Info`）进行散列运算，得到散列值 `s_Hash_tmp`。
5. 客户端「C」判断 `s_Hash` 和 `s_Hash_tmp` 是否相等。如果两者相等，则证明**「s_Cert」**是由**「ca_Cert」**签署的。
6. 客户端「C」检查**「ca_Cert」**，发现该证书是根证书，且已经被系统信任，身份验证通过。

> 如果**「ca_Cert」**没有安装到系统中，那么将无法对 `enc_s_Hash` 进行解密，也就无法验证**「s_Cert」**的真实性了。下同。

#### 二级（或以上）认证机构的验证

**简要流程**

1. 服务器「S2」下发证书**「s2_Cert」**、**「ca2_Cert」**给客户端「C」。
2. 客户端「C」检查到**「s2_Cert」**中的 `ca2_Info`，发现它是由「CA2」签署的。
3. 客户端「C」取出**「ca2_Cert」**中的 `ca2_KeyPub`，对**「s2_Cert」**中的 `enc_s2_Hash` 进行解密得到 `s2_Hash`。
4. 客户端「C」对**「s2_Cert」**中的（`s2_KeyPub` + `s2_Info` + `ca2_Info`）进行散列运算，得到散列值 `s2_Hash_tmp`。
5. 客户端「C」判断 `s2_Hash` 和 `s2_Hash_tmp` 是否相等。如果两者相等，则证明**「s2_Cert」**是由**「ca2_Cert」**签署的。
6. 客户端「C」检查到**「ca2_Cert」**中的 `ca_Info`，发现它是由「CA」签署的。
7. 客户端「C」取出**「ca_Cert」**中的 `ca_KeyPub`，对**「ca2_Cert」**中的 `enc_ca2_Hash` 进行解密得到 `ca2_Hash`。
8. 客户端「C」对**「ca2_Cert」**中的（`ca2_KeyPub` + `ca2_Info` + `ca_Info`）进行散列运算，得到散列值 `ca2_Hash_tmp`。
9. 客户端「C」判断 `ca2_Hash` 和 `ca2_Hash_tmp` 是否相等。如果两者相等，证明**「ca2_Cert」**是由**「ca_Cert」**签署的。
10. 客户端「C」检查**「ca_Cert」**，发现该证书是根证书，且已经被系统信任，身份验证通过。

三级或更多级认证机构证书验证流程跟这个流程差不多，就是一环扣一环地验证下去。

### 加密传输的数据

服务器「S」的身份得到客户端「C」的认可之后，服务器「S」可以使用 `s_KeyPri` 对传出的数据进行加密或者对传入的数据进行解密。

反过来，客户端「C」可以使用 `s_KeyPub` 对传出的数据进行加密或者对传入的数据进行解密。

由于非对称加密的效率较低，所以一般使用非对称加密协商并交换一个临时的会话密钥之后，使用会话密钥进行对称加密。



#### 现实中的证书验证

现实中，一些众所周知且被信任证书认证机构的根证书都被内置到了操作系统中。

而客户端在检查服务器证书的时候，一般还会检查它的有效期以及该证书是否在认证机构的证书吊销列表中。证书吊销列表一般是在线检查的。



---

参考：

1. [X.509数字证书的结构与解析](https://blog.csdn.net/xy010902100449/article/details/52145009)
2. [X.509 数字证书的基本原理及应用](https://zhuanlan.zhihu.com/p/36832100)



# HTTP概述

HTTP是一个属于应用层的面向对象的协议，由于其简捷、快速的方式，适用于分布式超媒体信息系统。

![HTTP发展史](https://i.loli.net/2020/09/11/xQoLU1WAXklzyVi.png)

## HTTP/0.9

HTTP 是基于 TCP/IP 协议的[**应用层协议**](http://www.ruanyifeng.com/blog/2012/05/internet_protocol_suite_part_i.html)。它不涉及数据包（packet）传输，主要规定了客户端和服务器之间的通信格式，默认使用80端口。

> 协议规定，服务器只能回应HTML格式的字符串，不能回应别的格式。

## HTTP/1.x

> 在早期，HTTP 使用一个简单的模型来处理这样的连接。这些连接的生命周期是短暂的：每发起一个请求时都会创建一个新的连接，并在收到应答时立即关闭。连接的成本较高。

当请求发起时，网络延迟和带宽都会对性能造成影响。现代浏览器往往要发起很多次请求(十几个或者更多)才能拿到所需的完整信息，证明了这个早期模型的效率低下。

在 HTTP/1.x 里有多种模型：*短连接*, *长连接*, 和 *HTTP 流水线。*

![HTTP三种模型](https://i.loli.net/2020/07/18/BcpZOXTKSFIDRUe.png)



### 短链接模型

HTTP/1.0 的默认模型。每一个 HTTP 请求都由它自己独立的连接完成；这意味着发起每一个 HTTP 请求之前都会有一次 TCP 握手，而且是连续不断的。

> 在 HTTP/1.1 中，只有当 [`Connection`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Connection) 被设置为 `close` 时才会用到这个模型

### 长连接模型

保持连接去完成多次连续的请求，减少了不断重新打开连接的时间。在 HTTP/1.1 里，默认就是长连接的。

> 短连接有两个比较大的问题：创建新连接耗费的时间尤为明显，另外 TCP 连接的性能只有在该连接被使用一段时间后(热连接)才能得到改善。另外我们知道，TCP协议有个滑动窗口，有慢启动这回事，就是说每次建立新连接后，数据先是慢慢地传，然后滑动窗口慢慢变大，才能较高速度地传。

具体流程：

一个长连接会保持一段时间，重复用于发送一系列请求，**节省了新建 TCP 连接握手的时间，还可以利用 TCP 的性能增强能力**。当然这个连接也不会一直保留着：连接在空闲一段时间后会被关闭(服务器可以使用 [`Keep-Alive`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Keep-Alive) 协议头来指定一个最小的连接保持时间)。

缺点：

就算是在空闲状态，它还是会消耗服务器资源，而且在重负载时，还有可能遭受 [DoS attacks](https://developer.mozilla.org/en-US/docs/Glossary/DoS_attack) 攻击。这种场景下，可以使用非长连接，即尽快关闭那些空闲的连接，也能对性能有所提升。

> 长连接一个优化的方法就是设置一个超时时间，但是具体这个时间是多少，应该通过测试之后得出一个较为均衡的时间。

### 流水线模型(管线化)

**多个连续的请求甚至都不用等待立即返回就可以被发送**。HTTP 流水线在现代浏览器中并不是默认被启用的。

默认情况下，[HTTP](https://developer.mozilla.org/en/HTTP) 请求是按顺序发出的。下一个请求只有在当前请求收到应答过后才会被发出。由于会受到网络延迟和带宽的限制，在下一个请求被发送到服务器之前，可能需要等待很长时间。

**流水线是在同一条长连接上发出连续的请求，而不用等待应答返回。这样可以避免连接延迟。理论上讲，性能还会因为两个 HTTP 请求有可能被打包到一个 TCP 消息包中而得到提升。**就算 HTTP 请求不断的继续，尺寸会增加，但设置 TCP 的 [MSS](https://en.wikipedia.org/wiki/Maximum_segment_size)(Maximum Segment Size) 选项，仍然足够包含一系列简单的请求。

> 比如，当请求一个包含10张图片的HTML Web页面，与挨个连接相比，用持久连接可以让请求更快结束。而管线化技术则比持久连接还要快。请求数越多，时间差就越明显。



#### 队头阻塞

在一般情况下，HTTP遵守“请求-响应”的模式，也就是客户端每次发送一个请求到服务端，服务端返回响应，这种模式很简单，但是有一个致命缺陷那就是页面中有多个请求，每个请求必须等到前一个请求响应之后才能发送，并且当前请求的响应返回之后，当前请求的下一个请求才能发送，流程如下图

![不带管线的队头](https://i.loli.net/2020/11/12/Iim4qdxThogSEMk.png)

在TCP链接中，http请求必须等待前一个请求响应之后，才能发送，后面的依次类推，由此可以看出，如果在一个tcp通道中如果某个http请求的响应因为某个原因没有及时返回，后面的响应会被阻塞，这就是**队头阻塞。**

> 注意这里说的是响应之后，并不是请之后!



为了提高速度和效率，在持久连接的基础上，HTTP1.1进一步地支持在持久连接上使用管道化（pipelining）特性。**管道化允许客户端在已发送的请求收到服务端的响应之前发送下一个请求**，借此来减少等待时间提高吞吐，如果多个请求能在同一个TCP分节发送的话，还能提高网络利用率，流程如图：

![带管线的队头阻塞](https://i.loli.net/2020/11/12/YTriXMRKdEQLf6U.png)

同一个tcp连接中可以同时发送多个http请求，也就是并发，**但是在响应的时候，必须排队响应，谁先到达的谁先响应，相比不支持管道化的http请求确实提高了效率，但是还是有局限性**，假如其中某个响应因为某种原因延迟了几秒，后面的响应都会被阻塞。上面箭头所指的响应如果阻塞了，那么这个也是**队头阻塞**。

**并且使用HTTP管道化还有一些限制**:

1、管道化要求服务端按照请求发送的顺序返回响应（FIFO），原因很简单，HTTP请求和响应并没有序号标识，无法将乱序的响应与请求关联起来。

2、当客户端在支持管道化时需要保持未收到响应的请求，当连接意外中断时，需要重新发送这部分请求。如果这个请求只是从服务器获取数据，那么并不会对资源造成任何影响，而如果是一个提交信息的请求如post请求，那么可能会造成资源多次提交从而改变资源，这是不允许的。而不会对服务器资源产生影响的请求有个专业名词叫做幂等请求。客户端在使用管道化的时候请求方式必须是幂等请求。

**比较**：

![管线化和非管线化的对比](https://i.loli.net/2020/11/12/cRSVqah4gTDjWY8.png)

**上面的管线化的模型就是加速了请求的过程，但是响应的过程还是存在队头阻塞。**

> 因为HTTP管道化本身可能会导致队头阻塞的问题，以及上面提到的一些限制，**现代浏览器默认都关闭了管道化，并且大部分服务器也是默认不支持管道化的**。



**如何解决队头阻塞？**

客户端使用并发长连接，注意这个并发指的是tcp并发连接。

> 并发长连接虽然在一定程度上解决了http的队头阻塞，但是会对服务器的性能有较高的要求

## HTTP/2

> HTTP/1.1 版的头信息肯定是文本（ASCII编码），数据体可以是文本，也可以是二进制。HTTP/2 则是一个彻底的二进制协议，头信息和数据体都是二进制，并且统称为"帧"（frame）：头信息帧和数据帧。

:laughing: HTTP/2 没有改动 HTTP 的应用语义。 HTTP 方法、状态代码、URI 和标头字段等核心概念一如往常。 不过，HTTP/2 修改了数据格式化（分帧）以及在客户端与服务器间传输的方式。这两点统帅全局，通过新的分帧层向我们的应用隐藏了所有复杂性。 因此，所有现有的应用都可以不必修改而在新协议下运行。

> *为什么不是 HTTP/1.2？*
>
> 为了实现 HTTP 工作组设定的性能目标，HTTP/2 引入了一个新的二进制分帧层，该层无法与之前的 HTTP/1.x 服务器和客户端向后兼容，因此协议的主版本提升到 HTTP/2。



### 二进制分帧层

HTTP/2 所有性能增强的核心在于新的二进制分帧层，它定义了如何封装 HTTP 消息并在客户端与服务器之间传输。

![HTTP/2二进制分帧层](https://i.loli.net/2020/07/18/QFrEgPCV7GAq6wm.png)



这里所谓的“层”，指的是位于套接字接口与应用可见的高级 HTTP API 之间一个经过优化的新编码机制：HTTP 的语义（包括各种动词、方法、标头）都不受影响，**不同的是传输期间对它们的编码方式变了**。 **HTTP/1.x 协议以换行符作为纯文本的分隔符，而 HTTP/2 将所有传输的信息分割为更小的消息和帧，并采用二进制格式对它们编码。**



#### 数据流、消息和帧

- *数据流*：已建立的连接内的双向字节流，可以承载一条或多条消息。
- *消息*：与逻辑请求或响应消息对应的完整的一系列帧。
- *帧*：HTTP/2 通信的最小单位，每个帧都包含帧头，至少也会标识出当前帧所属的数据流。

关系：

- 所有通信都在一个 TCP 连接上完成，此连接可以承载任意数量的双向数据流。(**多工**)
- 每个数据流都有一个唯一的标识符和可选的优先级信息，用于承载双向消息。
- 每条消息都是一条逻辑 HTTP 消息（例如请求或响应），包含一个或多个帧。
- **帧是最小的通信单位，承载着特定类型的数据，例如 HTTP 标头、消息负载等等。 来自不同数据流的帧可以交错发送，然后再根据每个帧头的数据流标识符重新组装。**

![二进制帧](https://i.loli.net/2020/07/18/mvZHTDVKUw5paXR.png)

简言之，HTTP/2 将 HTTP 协议通信分解为二进制编码帧的交换，这些帧对应着特定数据流中的消息。所有这些都在一个 TCP 连接内复用。 这是 HTTP/2 协议所有其他功能和性能优化的基础。

HTTP/2 帧结构如下：

![帧结构](https://i.loli.net/2020/07/18/myhEWKrbG6sPQZu.png)



实际的传输过程可能是下面这样(吞吐量增大)：

![HTTP/2传输](https://i.loli.net/2020/07/18/ShtzgQewfm21aXi.png)

#### 请求与响应复用

HTTP/2 中新的二进制分帧层实现了完整的请求和响应复用：客户端和服务器可以将 HTTP 消息分解为互不依赖的帧，然后交错发送，最后再在另一端把它们重新组装起来。

![请求与复用](https://i.loli.net/2020/07/18/cgiF86Xdl7yeRWJ.png)





#### 数据流优先级

![数据流优先级](https://i.loli.net/2020/07/18/n7HTaUA8ZGp2Egy.png)



我们来看一下上图中的几个操作示例。 从左到右依次为：

1. 数据流 A 和数据流 B 都没有指定父依赖项，依赖于隐式“根数据流”；A 的权重为 12，B 的权重为 4。因此，根据比例权重：数据流 B 获得的资源是 A 所获资源的三分之一。
2. 数据流 D 依赖于根数据流；C 依赖于 D。 因此，D 应先于 C 获得完整资源分配。 权重不重要，因为 C 的依赖关系拥有更高的优先级。
3. 数据流 D 应先于 C 获得完整资源分配；C 应先于 A 和 B 获得完整资源分配；数据流 B 获得的资源是 A 所获资源的三分之一。
4. 数据流 D 应先于 E 和 C 获得完整资源分配；E 和 C 应先于 A 和 B 获得相同的资源分配；A 和 B 应基于其权重获得比例分配。





#### 流控制

流控制是一种阻止发送方向接收方发送大量数据的机制，以免超出后者的需求或处理能力：发送方可能非常繁忙、处于较高的负载之下，也可能仅仅希望为特定数据流分配固定量的资源。 例如，客户端可能请求了一个具有较高优先级的大型视频流，但是用户已经暂停视频，客户端现在希望暂停或限制从服务器的传输，以免提取和缓冲不必要的数据。 再比如，一个代理服务器可能具有较快的下游连接和较慢的上游连接，并且也希望调节下游连接传输数据的速度以匹配上游连接的速度来控制其资源利用率；等等。类似TCP流量控制。





#### 服务器推送

HTTP/2 新增的另一个强大的新功能是，服务器可以对一个客户端请求发送多个响应。 换句话说，除了对最初请求的响应外，服务器还可以向客户端推送额外资源（图 12-5），而无需客户端明确地请求。

![服务器推送](https://i.loli.net/2020/07/18/Bht8slFucdr7veP.png)



#### 标头压缩

每个 HTTP 传输都承载一组标头，这些标头说明了传输的资源及其属性。 在 HTTP/1.x 中，此元数据始终以纯文本形式，通常会给每个传输增加 500–800 字节的开销。如果使用 HTTP Cookie，增加的开销有时会达到上千字节。为了减少此开销和提升性能，HTTP/2 使用 HPACK 压缩格式压缩请求和响应标头元数据，这种格式采用两种简单但是强大的技术：

1. 这种格式支持通过静态霍夫曼代码对传输的标头字段进行编码，从而减小了各个传输的大小。
2. 这种格式要求客户端和服务器同时维护和更新一个包含之前见过的标头字段的索引列表（换句话说，它可以建立一个共享的压缩上下文），此列表随后会用作参考，对之前传输的值进行有效编码。

利用霍夫曼编码，可以在传输时对各个值进行压缩，而利用之前传输值的索引列表，我们可以通过传输索引值的方式对重复值进行编码，索引值可用于有效查询和重构完整的标头键值对。

![标头压缩](https://i.loli.net/2020/07/18/Ghy8azel4qFEiBm.png)



#### 哈夫曼树如何压缩

文件压缩的主要思想是利用哈夫曼编码来实现的，但是得到编码之前我们需要构建这棵树。那么利用什么来构建树呢？！这里，我们需要统计每个字符出现的次数，用次数来构建HuffmanTree。假设我们现在有一个.txt的小文件，内容是"aaaabbbccd"。字符存在计算机中时以字节为单位的，因此我们需要将这些字符压缩成0、1表示的编码，0和1表示字节中的“位”，这样能大大降低文件的大小。

![哈夫曼树压缩](https://i.loli.net/2020/09/11/VLBIRDHC8kPO6xw.png)







#### 体验HTTP2

[https://http2.akamai.com/demo](https://http2.akamai.com/demo)

---

参考链接：

1. [HTTP 连接管理进化论](https://segmentfault.com/a/1190000013594849)
2. https://developers.google.com/web/fundamentals/performance/http2?hl=zh-cn
3. [白话http队头阻塞](https://cloud.tencent.com/developer/article/1509279)



## HTTPS详解

![dasda](https://i.loli.net/2020/10/17/BFiqd65hfxjDRSV.png)

### 什么是HTTPS？

HTTPS是在HTTP上建立SSL加密层，并对传输数据进行加密，是HTTP协议的安全版。**现在它被广泛用于万维网上安全敏感的通讯，例如交易支付方面。**

### HTTP协议存在的问题？

1. 通信使用明文（不加密），内容可能被窃听
2. 无法证明报文的完整性，所以可能遭篡改
3. 不验证通信方的身份，因此有可能遭遇伪装

### HTTPS的优势？

1. 数据隐私性：内容经过对称加密，每个连接生成一个唯一的加密密钥
2. 数据完整性：内容传输经过完整性校验
3. 身份认证：第三方无法伪造服务端（客户端）身份

![HTTP/HTTPS](https://i.loli.net/2020/08/25/DZ8aQeSNg2j3czw.jpg)





### HTTPS协议

HTTPS并非是应用层的一种新协议。只是HTTP通信接口部分用SSL和TLS协议代替而已。

通常，HTTP直接和TCP通信。当使用SSL时，则演变成先和SSL通信，再由SSL和TCP通信了。简言之，**所谓HTTPS，其实就是身披SSL协议这层外壳的HTTP**。

![image-20201017115517500](https://i.loli.net/2020/10/17/oSFPaGJkXDwWOu4.png)

在采用SSL后，HTTP就拥有了HTTPS的加密、证书和完整性保护这些功能。也就是说**HTTP加上加密处理和认证以及完整性保护后即是HTTPS**。



HTTPS 协议的主要功能基本都依赖于 TLS/SSL 协议，TLS/SSL 的功能实现主要依赖于三类基本算法：散列函数 、对称加密和非对称加密，其利用非对称加密实现身份认证和密钥协商，对称加密算法采用协商的密钥对数据加密，基于散列函数验证信息的完整性。

![HTTPS依赖的算法](https://i.loli.net/2020/08/25/Gc5ohszgeSOMKUT.jpg)

### 数字证书

数字证书认证机构处于客户端与服务器双方都可信赖的第三方机构的立场上。

![数字证书](https://i.loli.net/2020/08/27/cVIlSrNBJEd2Xhp.jpg)

数字证书认证机构的业务流程：

- 服务器的运营人员向第三方机构CA提交公钥、组织信息、个人信息(域名)等信息并申请认证;
- CA通过线上、线下等多种手段验证申请者提供信息的真实性，如组织是否存在、企业是否合法，是否拥有域名的所有权等;
- 如信息审核通过，CA会向申请者签发认证文件-证书。证书包含以下信息：申请者公钥、申请者的组织信息和个人信息、签发机构 CA的信息、有效时间、证书序列号等信息的明文，同时包含一个签名。 其中签名的产生算法：首先，使用散列函数计算公开的明文信息的信息摘要，然后，采用 CA的私钥对信息摘要进行加密，密文即签名;
- 客户端 Client 向服务器 Server 发出请求时，Server 返回证书文件;
- 客户端 Client 读取证书中的相关的明文信息，采用相同的散列函数计算得到信息摘要，然后，利用对应 CA的公钥解密签名数据，对比证书的信息摘要，如果一致，则可以确认证书的合法性，即服务器的公开密钥是值得信赖的。
- 客户端还会验证证书相关的域名信息、有效时间等信息; 客户端会内置信任CA的证书信息(包含公钥)，如果CA不被信任，则找不到对应 CA的证书，证书也会被判定非法。

### HTTPS工作流程

![https工作流程](https://i.loli.net/2020/08/26/TQeCNM26jFX3nWv.jpg)

1. Client发起一个HTTPS（比如[https://juejin.im/user/5a9a9cdcf265da238b7d771c](https://link.zhihu.com/?target=https%3A//juejin.im/user/5a9a9cdcf265da238b7d771c)）的请求，根据RFC2818的规定，Client知道需要连接Server的443（默认）端口。

2. Server把事先配置好的公钥证书（public key certificate）返回给客户端。

3. Client验证公钥证书：比如是否在有效期内，证书的用途是不是匹配Client请求的站点，是不是在CRL吊销列表里面，它的上一级证书是否有效，这是一个递归的过程，直到验证到根证书（操作系统内置的Root证书或者Client内置的Root证书）。如果验证通过则继续，不通过则显示警告信息。

4. Client使用伪随机数生成器生成加密所使用的对称密钥，然后用证书的公钥加密这个对称密钥，发给Server。

5. Server使用自己的私钥（private key）解密这个消息，得到对称密钥。至此，Client和Server双方都持有了相同的对称密钥。

6. Server使用对称密钥加密“明文内容A”，发送给Client。

7. Client使用对称密钥解密响应的密文，得到“明文内容A”。

8. Client再次发起HTTPS的请求，使用对称密钥加密请求的“明文内容B”，然后Server使用对称密钥解密密文，得到“明文内容B”。

---

参考：

1. [HTTPS的安全原理](https://www.jianshu.com/p/aa3f6e47f327)







## 虚拟IP原理

虚拟IP技术。虚拟IP，就是一个未分配给真实主机的IP，也就是说对外提供数据库服务器的主机除了有一个真实IP外还有一个虚IP，使用这两个IP中的任意一个都可以连接到这台主机，所有项目中数据库链接一项配置的都是这个虚IP，当服务器发生故障无法对外提供服务时，动态将这个虚IP切换到备用主机。

其实现原理主要是靠 TCP/IP 的 ARP 协议。因为IP地址只是一个逻辑地址，在以太网中 MAC 地址才是真正用来进行数据传输的物理地址，每台主机中都有一个 ARP 高速缓存，存储同一个网络内的 IP 地址与 MAC 地址的对应关系，以太网中的主机发送数据时会先从这个缓存中查询目标 IP 对应的 MAC 地址，会向这个 MAC 地址发送数据。操作系统会自动维护这个缓存。这就是整个实现的关键。





---

参考：

1. [虚拟IP技术](http://www.xumenger.com/virtual-ip-20190220/)













# 传输层:blue_car:



## TCP:wavy_dash:

#### TCP中流的解释

TCP中的“流”(stream)指的是流入到进程或从进程流出的字节序列。“面向字节流”的含义是：虽然应用程序和TCP的交互是一次一个数据块（大小不等），但TCP把应用程序交下来的数据看成仅仅是一连串的无结构的字节流。TCP并不知道所传送的字节流的含义。TCP不保证接收方应用程序所收到的数据块和发送方应用程序所发出的数据块具有对应大小的关系（例如，发送方应用程序交给发送方的TCP共10个数据块，但接收方的TCP可能只用了4个数据块就把收到的字节流交付上层的应用程序）。但接收方应用程序收到的字节流必须和发送方应用程序发出的字节流完全一样。当然，接收方的应用程序必须有能力识别收到的字节流，把它还原成有意义的应用层数据。

一个简单的示意图如下：

![TCP流的概念](https://i.loli.net/2020/07/11/ty89pm5J12SBYxT.png)

> TCP和UDP在发送报文时所采用的方式完全不同。TCP并不关心应用进程一次把多长的报文发送到TCP的缓存中，而是根据对方给出的窗口值和当前网络拥塞的程度来决定一个报文段应包含多少个字节（UDP发送的报文长度是应用进程给出的）。如果应用进程传送到TCP缓存的数据块太长，TCP就可以把它划分短一些再传送。如果应用进程一次只发来一个字节，TCP也可以等待积累有足够多的字节后再构成报文段发送出去

#### TCP报文格式

![TCP报文](https://i.loli.net/2020/07/11/WOpzMnVACiHdgkb.png)

英文版：

![TCP报文](https://i.loli.net/2020/11/12/cftgZa6eoYsb5zm.png)

TCP的固定包头为20个字节，下面是几个参数：

1. 序号：即SEQ序号。TCP连接中传送的数据流中的每一个字节都编上一个序号。序号字段的值则指的是本报文段所发送的数据的第一个字节的序号。
2. 确认号：即确认序号，也叫ACK序号。是期望收到对方的下一个报文段的数据的第一个字节的序号。只有ACK标志位为1时，确认序号字段才有效，ACK=SEQ+1。
3. 数据偏移：它指出TCP报文段的数据起始处距离TCP报文段的起始处有多远。该字段长 4 位，单位为 4 字节。表示为 TCP 首部的长度。所以 TCP 首部长度最多为 60 字节。
4. 标志位：共6个，即URG(紧急比特)、ACK(确认比特)、PSH(推送比特)、RST(复位比特)、SYN(同步比特)、FIN(结束比特)等。
5. 窗口大小：窗口字段用来控制对方发送的数据量，单位为字节。TCP连接的一端根据设置的缓存空间大小确定自己的接收窗口大小，然后通知对方以确定对方的发送窗口的上。
6. 校验和：检验和字段检验的范围包括首部和数据这两部分。在计算检验和时，要在TCP报文段的前面加上12字节的伪首部。
7. 紧急指针：紧急指针指出在本报文段中的紧急数据的最后一个字节的序号。
8. 选项：TCP只规定了一种选项，即最大报文段长度MSS（MaximumSegment Size）。MSS告诉对方TCP：“我的缓存所能接收的报文段的数据字段的最大长度是MSS 个字节。”

几个控制位：

```text
CWR：用于 IP 首部的 ECN 字段。ECE 为 1 时，则通知对方已将拥塞窗口缩小。
ECE：在收到数据包的 IP 首部中 ECN 为 1 时将 TCP 首部中的 ECE 设置为 1，表示从对方到这边的网络有拥塞。
URG：紧急模式
ACK：确认
PSH：推送，接收方应尽快给应用程序传送这个数据。没用到
RST：该位为 1 表示 TCP 连接中出现异常必须强制断开连接。
SYN：初始化一个连接的同步序列号
FIN：该位为 1 表示今后不会有数据发送，希望断开连接
```

选项（Options）：

受 Data Offset 控制，长度最大为 40 字节。一般 Option 的格式为 TLV 结构：

![选项格式](https://i.loli.net/2020/11/12/bgudhc4e2AFEJKH.png)

常见的 TCP Options 有，SACK 字段就位于该选项中:

![img](https://i.loli.net/2020/11/12/ruohKXElcVspNCi.jpg)



**SACK 的工作原理**

如下图所示， 接收方收到 500-699 的数据包，但没有收到 300-499 的数据包就会回 SACK(500-700) 给发送端，表示收到 500-699 的数据。

![img](https://i.loli.net/2020/11/12/GEOyYZBe9XNjFfL.jpg)

#### 三次握手：

> 三次握手是必须的——TCP 需要 seq 序列号来做可靠重传或接收，而避免连接复用时无法分辨出 seq 是延迟或者是旧链接的 seq，因此需要三次握手来约定确定双方的 ISN（初始 seq 序列号）。



![image-20200711165225619](https://i.loli.net/2020/07/11/EwG4tcyShsvIARa.png)



#### 四次挥手

其中A发送的X为前面已传送过的数据的最后一个字节的序号加1。

第一次A到B方向结束，第二次B到A方向结束。

第二次B发送的SEQ=Z(在半关闭状态B可能又发送了一些数据),B还必须重复上次已发送过的确认号ACK = X+1。

![image-20200711170105870](https://i.loli.net/2020/07/11/jaXZsPKSeGUuN6k.png)

> 请注意，TCP规定，FIN报文段即使不携带数据，它也消耗掉一个序号。
>
> 请注意，现在TCP连接还没有释放掉。必须经过时间等待计时器(TIME-WAIT timer)设置的时间2MSL后，A才进入到CLOSED状态。时间MSL叫做最长报文段寿命(Maximum Segment Lifetime)，RFC 793建议设为2分钟。但这完全是从工程上来考虑，对于现在的网络，MSL = 2分钟可能太长了一些。因此TCP允许不同的实现可根据具体情况使用更小的MSL值。因此，从A进入到TIME-WAIT状态后，要经过4分钟才能进入到CLOSED状态，才能开始建立下一个新的连接。当A撤销相应的传输控制块TCB后，就结束了这次的TCP连接。

为什么A在TIME-WAIT状态(发送最后一个数据包之后)必须等待2MSL的时间呢？这有两个理由。

* 第一，为了保证A发送的最后一个ACK报文段能够到达B。这个ACK报文段有可能丢失，因而使处在LAST-ACK状态的B收不到对已发送的FIN + ACK报文段的确认。B会超时重传这个FIN + ACK报文段，而A就能在2MSL时间内收到这个重传的FIN + ACK报文段。接着A重传一次确认，重新启动2MSL计时器。最后，A和B都正常进入到CLOSED状态。如果A在TIME-WAIT状态不等待一段时间，而是在发送完ACK报文段后立即释放连接，那么就无法收到B重传的FIN + ACK报文段，因而也不会再发送一次确认报文段。这样，B就无法按照正常步骤进入CLOSED状态。

* 第二，防止上一节提到的“已失效的连接请求报文段”出现在本连接中。A在发送完最后一个ACK报文段后，再经过时间2MSL，就可以使本连接持续的时间内所产生的所有报文段都从网络中消失。这样就可以使下一个新的连接中不会出现这种旧的连接请求报文段。B只要收到了A发出的确认，就进入CLOSED状态。同样，B在撤销相应的传输控制块TCB后，就结束了这次的TCP连接。**我们注意到，B结束TCP连接的时间要比A早一些。**



#### **TCP**的4个定时器

> 重传定时器、坚持定时器、保持定时器、时间等待定时器

**重传计时器**：

当TCP发送报文段时，就创建该特定报文段的重传计时器。

1. 若在计时器截止时间到(通常60秒)之前收到了对此特定报文段的确认，则撤销此计时器。
2. 若在计时器截止时间之前没有收到对此特定报文的确认，则就认为该报文丢失，需要重传此报文段，并将计时器复位。

**坚持计时器**-防止收不到非0窗口大小的报文

> 假设TCP收到了一个窗口大小为0报文段，发送TCP就停止传送报文段，直到接收TCP发送一个非零的窗口大小。但是这个确认有可能丢失，若确认丢了，接收TCP并不会知道，而是认为他已经完成任务了。但是发送TCP由于没有收到确认，就会一直等待接收方发送确认来通知窗口的大小。双方的TCP这时就会造成死锁，所以要使用一个计时器来避免死锁的发送。

1. 当TCP收到一个窗口大小为0的确认时，就要启动坚持计时器。当坚持计时器期限到时，发送TCP就发送一个特殊的探测报文，这个探测报文段只有一个字节数据，它有一个序号，但是它的序号永远不需要确认。探测报文段提醒对端，确认已丢失，必须重传。
2. 坚持计时器的值设置为重传时间的数值。若没有收到从接收端来的响应，需要发送一个探测报文，并将坚持计时器的值加倍和复位，直到这个值增大到门限值(通常60秒)为止。在这以后，发送端每隔60秒发送一个探测报文，直到窗口重新打开。

**保活计时器**
保活计时器用来防止两个TCP之间的连续出现长时间的空闲。

1. 假定客户已主动与服务器建立了TCP链接。然后这个客户端出现故障。在这种情况下，这个链接就会永远的处于打开状态。而服务器维护一个链接，也是要耗费一定的资源的，所以必须采取措施，使服务器不能白白等下去。
2. 要解决这种问题，就要对服务器设置保活计时器。每当服务器收到客户的信息，就将计时器复位，保活时间通常设置为2小时。若服务器过了两小时还没有收到客户的信息，他就发送一个探测报文，以后每隔75秒就发一次，连续发送10个探测报文后客户端仍然没有响应，服务器就认为客户端出现了故障，接着就关闭这个链接。

**时间等待计时器**
当客户端进入TIME-WAIT状态的时候，链接还没有释放掉，必须等待2倍的MSL(最长报文段寿命)后，客户端才能关闭连接。在时间等待期间，链接还处于一种过渡状态。这就可以使重复的FIN报文段(若果有的话)可以到达目的站因而可将其丢弃。



#### 保证传输可靠

理想的传输条件有以下两个特点：

1. 传输信道不产生差错。
2. 不管发送方以多快的速度发送数据，接收方总是来得及处理收到的数据。

> 我们可以使用一些可靠传输协议，当出现差错时让发送方重传出现差错的数据，同时在接收方来不及处理收到的数据时，及时告诉发送方适当降低发送数据的速度。这样一来，本来是不可靠的传输信道就能够实现可靠传输了。

**序号与确认号**

有一个问题：这条连接突然断开重连后，TCP 怎么样识别之前旧链接重发的包？——这就需要独一无二的 ISN（初始序列号）机制。

**超时重传**

超时重传：可靠传输协议是这样设计的：A只要超过了一段时间仍然没有收到确认，就认为刚才发送的分组丢失了，因而重传前面发送过的分组。这就叫做超时重传。

> 要实现超时重传，就要在每发送完一个分组设置一个超时计时器。如果在超时计时器到期之前收到了对方的确认，就撤销已设置的超时计时器

确认丢失与确认迟到：

![超时重传](https://i.loli.net/2020/07/12/xdfKO1VknoBw93Y.png)

**停止等待协议** - 简单的保证传输的可靠性- ARQ协议

停止等待协议：“停止等待”就是每发送完一个分组就停止发送，等待对方的确认。在收到确认后再发送下一个分组。(信道利用率低)

**连续ARQ协议**

连续ARQ协议：发送方每收到一个确认，就	把发送窗口向前滑动一个分组的位置。

接收方一般都是采用累积确认的方式。这就是说，接收方不必对收到的分组逐个发送确认，而是在收到几个分组后，对按序到达的最后一个分组发送确认，这就表示：到这个分组为止的所有分组都已正确收到了。

![连续ARQ协议](https://i.loli.net/2020/07/12/zPNJiYuF54cKZjR.png)



**滑动窗口**

发送窗口表示：在没有收到B的确认的情况下，A可以连续把窗口内的数据都发送出去。凡是已经发送过的数据，在未收到确认之前都必须暂时保留，以便在超时重传时使用



![image-20200712102609675](https://i.loli.net/2020/07/12/5S4jCXeYUzdsA9c.png)



从以上所述可以看出，要描述一个发送窗口的状态需要三个指针：P1，P2和P3。指针都指向字节的序号。这三个指针指向的几个部分的意义如下：小于P1的是已发送并已收到确认的部分，而大于P3的是不允许发送的部分。P3 - P1 = A的发送窗口（又称为通知窗口）P2 - P1 = 已发送但尚未收到确认的字节数P3 - P2 = 允许发送但尚未发送的字节数（又称为可用窗口或有效窗口）



发送方的应用进程把字节流写入TCP的发送缓存，接收方的应用进程从TCP的接收缓存中读取字节流。下图表示了发送方维持的发送缓存和发送窗口，以及接收方维持的接收缓存和接收窗口。

![发送窗口-接受窗口](https://i.loli.net/2020/07/13/AHokRbG94IL2QTJ.png)



总结：

发送缓存用来暂时存放：

1. 发送应用程序传送给发送方TCP准备发送的数据
2. TCP已发送出但尚未收到确认的数据。

> 发送窗口通常只是发送缓存的一部分。已被确认的数据应当从发送缓存中删除，因此发送缓存和发送窗口的后沿是重合的。发送应用程序最后写入发送缓存的字节减去最后被确认的字节，就是还保留在发送缓存中的被写入的字节数。发送应用程序必须控制写入缓存的速率，不能太快，否则发送缓存就会没有存放数据的空间。

接收缓存用来暂时存放：

1. 按序到达的、但尚未被接收应用程序读取的数据
2. 未按序到达的数据。

> 如果收到的分组被检测出有差错，则要丢弃。如果接收应用程序来不及读取收到的数据，接收缓存最终就会被填满，使接收窗口减小到零。反之，如果接收应用程序能够及时从接收缓存中读取收到的数据，接收窗口就可以增大，但最大不能超过接收缓存的大小。



**超时重传的选择**

TCP采用了一种自适应算法，它记录一个报文段发出的时间，以及收到相应的确认的时间。这两个时间之差就是报文段的往返时间RTT。TCP保留了RTT的一个加权平均往返时间 $RTT_S$（这又称为平滑的往返时间，S表示Smoothed。因为进行的是加权平均，因此得出的结果更加平滑）。每当第一次测量到RTT样本时，RTTS值就取为所测量到的RTT样本值。但以后每测量到一个新的RTT样本，就按下式重新计算一次$RTT_S$

![image-20200712151531273](https://i.loli.net/2020/07/12/GJhzbLVsRHOAl24.png)

> RFC2988推荐的α值为1/8，即0.125。用这种方法得出的加权平均往返时间RTTS就比测量出的RTT值更加平滑



超时计时器设置的超时重传时间 RTO (RetransmissionTime-Out)应略大于上面得出的加权平均往返时间$RTT_S$。RFC 2988建议使用下式计算RTO：
$$
RTO = RTT_{S} + 4 \times RTT_{D}
$$
而$RTT_D$是RTT的偏差的加权平均值，它与$RTT_S$和新的RTT样本之差有关。当第一次测量时，RTTD值取为测量到的RTT样本值的一半。在以后的测量中，则使用下式计算加权平均的RTTD：

![image-20200713230031382](https://i.loli.net/2020/07/13/m7gAfzWUo5RbspQ.png)

> 这里 β 是个小于1的系数，它的推荐值是1/4，即0.25。



接受方有一个判断接受的报文时之前发送的还是之后重传的报文的问题，这里接受方如何判断给哪一个报文发送确认？

![判断报文](https://i.loli.net/2020/07/13/qjMtme2gTbl5LBp.png)



**选择确认SACK**

这就是若收到的报文段无差错，只是未按序号，中间还缺少一些序号的数据，那么能否设法只传送缺少的数据而不重传已经正确到达接收方的数据？



#### 流量控制

> 所谓流量控制(flow control)就是让发送方的发送速率不要太快，要让接收方来得及接收

滑动窗口流量控制：

![可变窗口流量控制](https://i.loli.net/2020/07/12/CWZ9bIioQDTj5aA.png)



现在我们考虑一种情况。、B向A发送了零窗口的报文段后不久，B的接收缓存又有了一些存储空间。于是B向A发送了rwnd = 400的报文段。然而这个报文段在传送过程中丢失了。A一直等待收到B发送的非零窗口的通知，而B也一直等待A发送的数据。如果没有其他措施，这种互相等待的死锁局面将一直延续下去。这个时候就需要**坚持计时器**来保证了。



#### 控制TCP发送报文段的时机

有三种发送报文段的方法：

1. 第一种机制是TCP维持一个变量，它等于最大报文段长度MSS。只要缓存中存放的数据达到MSS字节时，就组装成一个TCP报文段发送出去。
2. 第二种机制是由发送方的应用进程指明要求发送报文段，即TCP支持的推送(push)操作
3. 第三种机制是发送方的一个计时器期限到了，这时就把当前已有的缓存数据装入报文段（但长度不能超过MSS）发送出去。

在TCP的实现中广泛使用Nagle算法。算法如下：若发送应用进程把要发送的数据逐个字节地送到TCP的发送缓存，则发送方就把第一个数据字节先发送出去，把后面到达的数据字节都缓存起来。当发送方收到对第一个数据字符的确认后，再把发送缓存中的所有数据组装成一个报文段发送出去，同时继续对随后到达的数据进行缓存。只有在收到对前一个报文段的确认后才继续发送下一个报文段。当数据到达较快而网络速率较慢时，用这样的方法可明显地减少所用的网络带宽。Nagle算法还规定，当到达的数据已达到发送窗口大小的一半或已达到报文段的最大长度时，就立即发送一个报文段。这样做，就可以有效地提高网络的吞吐量。

另一个问题叫做糊涂窗口综合症。要解决这个问题，可以让接收方等待一段时间，使得或者接收缓存已有足够空间容纳一个最长的报文段，或者等到接收缓存已有一半空闲的空间。只要出现这两种情况之一，接收方就发出确认报文，并向发送方通知当前的窗口大小。此外，发送方也不要发送太小的报文段，而是把数据积累成足够大的报文段，或达到接收方缓存的空间的一半大小。



#### 拥塞控制

> 流量控制与拥塞控制的区别：
>
> 拥塞控制与流量控制的关系密切，它们之间也存在着一些差别。所谓拥塞控制就是防止过多的数据注入到网络中，这样可以使网络中的路由器或链路不致过载。
>
> 相反，流量控制往往指点对点通信量的控制，是个端到端的问题（接收端控制发送端）。流量控制所要做的就是抑制发送端发送数据的速率，以便使接收端来得及接收。

![拥塞控制](https://i.loli.net/2020/07/14/fLu7xqndgeIrDW6.png)

什么是网络拥塞？

在计算机网络中的链路容量（即带宽）、交换结点中的缓存和处理机等，都是网络的资源。在某段时间，若对网络中某一资源的需求超过了该资源所能提供的可用部分，网络的性能就要变坏。这种情况就叫做拥塞(congestion)。

> 所谓拥塞控制就是防止过多的数据注入到网络中，这样可以使网络中的路由器或链路不致过载。

拥塞控制所要做的都有一个前提，就是网络能够承受现有的网络负荷。拥塞控制是一个全局性的过程，涉及到所有的主机、所有的路由器，以及与降低网络传输性能有关的所有因素。但TCP连接的端点只要迟迟不能收到对方的确认信息，就猜想在当前网络中的某处很可能发生了拥塞，但这时却无法知道拥塞到底发生在网络的何处，也无法知道发生拥塞的具体原因（是访问某个服务器的通信量过大？还是在某个地区出现了自然灾害）。

拥塞控制所起的作用如下：

![image-20200714152723980](https://i.loli.net/2020/07/14/hJ7a5IwSXPsgWnR.png)

图中随着提供的负载的增大，网络吞吐量的增长速率逐渐减小。也就是说，在网络吞吐量还未达到饱和时，就已经有一部分的输入分组被丢弃了。当网络的吞吐量明显地小于理想的吞吐量时，网络就进入了轻度拥塞的状态。更值得注意的是，当提供的负载达到某一数值时，网络的吞吐量反而随提供的负载的增大而下降，这时网络就进入了拥塞状态。当提供的负载继续增大到某一数值时，网络的吞吐量就下降到零，网络已无法工作。这就是所谓的死锁(deadlock)。



由于计算机网络是一个很复杂的系统，因此可以从控制理论的角度来看拥塞控制这个问题。这样，从大的方面看，可以分为开环控制和闭环控制两种方法。开环控制方法就是在设计网络时事先将有关发生拥塞的因素考虑周到，力求网络在工作时不产生拥塞。但一旦整个系统运行起来，就不再中途进行改正了。

闭环控制是基于反馈环路的概念。属于闭环控制的有以下几种措施：

1. 监测网络系统以便检测到拥塞在何时、何处发生。
2. 把拥塞发生的信息传送到可采取行动的地方。
3. 调整网络系统的运行以解决出现的问题。



##### 几种方法

> 1999年公布的因特网建议标准RFC 2581定义了进行拥塞控制的四种算法，即慢开始(slow-start)、拥塞避免(congestion avoidance)、快重传(fast retransmit)和快恢复(fast recovery)。

1. **慢开始和拥塞避免**

   发送方维持一个叫做拥塞窗口 cwnd (congestion window)的状态变量。拥塞窗口的大小取决于网络的拥塞程度，并且动态地在变化。发送方让自己的发送窗口等于拥塞窗口。

   送方控制拥塞窗口的原则是：只要网络没有出现拥塞，拥塞窗口就再增大一些，以便把更多的分组发送出去。但只要网络出现拥塞，拥塞窗口就减小一些，以减少注入到网络中的分组数。

   > 发送方又是如何知道网络发生了拥塞呢？我们知道，当网络发生拥塞时，路由器就要丢弃分组。因此只要发送方没有按时收到应当到达的确认报文，就可以猜想网络可能出现了拥塞。现在通信线路的传输质量一般都很好，因传输出差错而丢弃分组的概率是很小的（远小于1 %）。

   慢开始算法的思路是这样的。当主机开始发送数据时，如果立即把大量数据字节注入到网络，那么就有可能引起网络拥塞，因为现在并不清楚网络的负荷情况。

   经验证明，较好的方法是先探测一下，即由小到大逐渐增大发送窗口，也就是说，由小到大逐渐增大拥塞窗口数值。通常在刚刚开始发送报文段时，先把拥塞窗口cwnd设置为一个最大报文段MSS的数值[插图]。而在每收到一个对新的报文段的确认后，把拥塞窗口增加至多一个MSS的数值。用这样的方法逐步增大发送方的拥塞窗口cwnd，可以使分组注入到网络的速率更加合理。

   慢开始拥塞窗口变化：

   ![慢开始](https://i.loli.net/2020/07/14/TMJ52wevaWmkRVQ.png)

   图解：

   ![拥塞避免](https://i.loli.net/2020/07/14/5HK3RSk9TQPIBxv.png)

   拥塞避免算法就是指拥塞窗口按线性规律增长。

   在TCP拥塞控制的文献中经常可看见“乘法减小”(Multiplicative Decrease)和“加法增大”(Additive Increase)这样的提法。“乘法减小”是指不论在慢开始阶段还是拥塞避免阶段，只要出现超时（即很可能出现了网络拥塞），就把慢开始门限值ssthresh减半，即设置为当前的拥塞窗口的一半（与此同时，执行慢开始算法）。当网络频繁出现拥塞时，ssthresh值就下降得很快，以大大减少注入到网络中的分组数。而“加法增大”是指执行拥塞避免算法后，使拥塞窗口缓慢增大，以防止网络过早出现拥塞。上面两种算法合起来常称为AIMD算法（加法增大乘法减小）。对这种算法进行适当修改后，又出现了其他一些改进的算法。但使用最广泛的还是AIMD算法。

   

2. **快重传和快恢复**

   快重传算法规定，发送方只要一连收到三个重复确认就应当立即重传对方尚未收到的报文段M3，而不必继续等待为M3设置的重传计时器到期。由于发送方能尽早重传未被确认的报文段，因此采用快重传后可以使整个网络的吞吐量提高约20%。

   示意图：

   ![快重传](https://i.loli.net/2020/07/14/KI9kO2QlhpMxTmw.png)

   快重传配合使用的还有快恢复算法，其过程有以下两个要点：

   * 当发送方连续收到三个重复确认时，就执行“乘法减小”算法，把慢开始门限ssthresh减半。这是为了预防网络发生拥塞。请注意，接下去不执行慢开始算法。
   * 由于发送方现在认为网络很可能没有发生拥塞（如果网络发生了严重的拥塞，就不会一连有好几个报文段连续到达接收方，也就不会导致接收方连续发送重复确认），因此与慢开始不同之处是现在不执行慢开始算法（即拥塞窗口cwnd现在不设置为1），而是把cwnd值设置为慢开始门限ssthresh减半后的数值，然后开始执行拥塞避免算法（“加法增大”），使拥塞窗口缓慢地线性增大。

   示意图：

   ![快恢复](https://i.loli.net/2020/07/14/cJgVNzImsjn5ufK.png)



如果把拥塞控制和接收方对发送方的流量控制一起考虑，那么很显然，发送方的窗口的上限值应当取为接收方窗口rwnd和拥塞窗口cwnd这两个变量中较小的一个，也就是说：

![窗口控制](https://i.loli.net/2020/07/14/Z7cMaROU4yufg9S.png)







### 流量控制

滑动窗口



### 拥塞控制



快重传、快恢复、超时重传，拥塞避免









## UDP:package:

UDP一次交付一个完整的报文，不会对报文进行拆分。因此，应用程序必须选择合适大小的报文。若报文太长，UDP把它交给IP层后，IP层在传送时可能要进行分片，这会降低IP层的效率。反之，若报文太短，UDP把它交给IP层后，会使IP数据报的首部的相对长度太大，这也降低了IP层的效率。

![UDP传输方式](https://i.loli.net/2020/07/11/1KCEaScv2sG5tLq.png)

UDP数据报格式：(首部8字节)

![UDP格式](https://i.loli.net/2020/07/11/LQVmS293fCpDIeF.png)

伪报头格式：

![伪报头格式](https://i.loli.net/2020/07/11/upR5QLAOncyTPjG.png)

> **校验和计算：**伪报头+UDP数据报

伪报头的作用是验证UDP数据报是否正确传送到目的进程。

计算校验和：

在发送方，首先是先把全零放入检验和字段。再把伪首部以及UDP用户数据报看成是由许多16位的字串接起来。若UDP用户数据报的数据部分不是偶数个字节，则要填入一个全零字节（但此字节不发送）。然后按二进制反码计算出这些16位字的和。将此和的二进制反码写入检验和字段后，就发送这样的UDP用户数据报。在接收方，把收到的UDP用户数据报连同伪首部（以及可能的填充全零字节）一起，按二进制反码求这些16位字的和。当无差错时其结果应为全1。

> 二进制反码求和：0和0相加是0，但要产生一个进位1，0和1相加是1，1和1相加是0。若最高位相加后产生进位，则最后得到的结果要加1。
>
> （0）反 + （0）反 = 1 + 1 = 10
>
> （1）反 +（0）反=0+ 1 =1
>
> （1）反 + （1）反 = 0 + 0 = 0
>
> **"二进制反码求和" 等价于 "二进制求和再取反"**
>
> 二进制求出的和如果大于16位时所做的操作,用和值中高16位加上低16位的值作为最终的和值,然后再做取反运算.

下面是计算校验和的一个例子：

![UDP校验和](https://i.loli.net/2020/07/11/v72HMrARs13nfJO.png)

> 这样的检验和，既检查了UDP用户数据报的源端口号和目的端口号以及UDP用户数据报的数据部分，又检查了IP数据报的源IP地址和目的地址。





#### 







网卡收到一条数据到进程处理数据,这之间经历了什么(中断的上半部下半部,网络层协议拆包)？







## 拥塞控制算法

TCP拥塞控制算法的目的可以简单概括为：**公平竞争、充分利用网络带宽、降低网络延时、优化用户体验，然而就目前而言要实现这些目标就难免有权衡和取舍。**

### 算法分类

**基于丢包策略**的传统拥塞控制算法的几个迭代版本，如图所示：

![拥塞控制算法迭代](https://i.loli.net/2020/11/12/DqTPGmJ6UaOvXVp.png)

与此同时还有一类算法是基于RTT延时策略来进行控制的，但是这类算法在发包速率上可能不够激进，竞争性能不如其他算法，因此在共享网络带宽时有失公平性，但是算法速率曲线却是很平滑

![img](https://i.loli.net/2020/11/12/JtoOAnGLIm2KSr9.png)



### 如何感知拥塞

在TCP连接的发送方一般是基于丢包来判断当前网络是否发生拥塞，丢包可以由重传超时RTO和重复确认来做判断。

![img](https://i.loli.net/2020/11/12/5OTIDH9tLiFAZmq.png)





### 拥塞控制基本策略

**拥塞控制是一个动态的过程**，它既要提高带宽利用率发送尽量多的数据又要避免网络拥堵丢包RTT增大等问题，基于这种高要求并不是单一策略可以搞定的，因此TCP的 **拥塞控制策略实际上是分阶段分策略的综合过程**：

![img](https://i.loli.net/2020/11/12/V4w9N8qHLQMZBr3.png)



**TCP Tahoe 和TCP Reno**

这两个算法代号取自太浩湖Lake和Tahoe里诺市，两者算法大致一致，对于丢包事件判断都是以重传超时retransmission timeout和重复确认为条件，但是对于重复确认的处理两者有所不同，对于超时重传RTO情况两个算法都是将拥塞窗口降为1个MSS，然后进入慢启动阶段。

TCP Tahoe算法：如果收到三次重复确认即第四次收到相同确认号的分段确认，并且分段对应包无负载分段和无改变接收窗口的话，Tahoe算法则进入快速重传，将慢启动阈值改为当前拥塞窗口的一半，将拥塞窗口降为1个MSS，并重新进入慢启动阶段。

TCP Reno算法：如果收到三次重复确认，Reno算法则进入快速重传只将拥塞窗口减半来跳过慢启动阶段，将慢启动阈值设为当前新的拥塞窗口值，进入一个称为快速恢复的新设计阶段。TCP New Reno



TCP New Reno是对TCP Reno中快速恢复阶段的重传进行改善的一种改进算法，New Reno在低错误率时运行效率和选择确认SACK相当，在高错误率仍优于Reno。





**TCP BIC 和TCP CUBIC**

TCP BIC旨在优化高速高延迟网络的拥塞控制，其拥塞窗口算法使用二分搜索算法尝试找到能长时间保持拥塞窗口最大值，Linux内核在2.6.8至2.6.18使用该算法作为默认TCP拥塞算法。



CUBIC则是比BIC更温和和系统化的分支版本，其使用三次函数代替二分算法作为其拥塞窗口算法，并且使用函数拐点作为拥塞窗口的设置值，Linux内核在2.6.19后使用该算法作为默认TCP拥塞算法。



**TCP PRR**

TCP PRR是旨在恢复期间提高发送数据的准确性，该算法确保恢复后的拥塞窗口大小尽可能接近慢启动阈值。在Google进行的测试中，能将平均延迟降低3~10%恢复超时减少5%，PRR算法后作为Linux内核3.2版本默认拥塞算法。

TCP BBR是由Google设计于2016年发布的拥塞算法，该算法认为随着网络接口控制器逐渐进入千兆速度时，分组丢失不应该被认为是识别拥塞的主要决定因素，所以基于模型的拥塞控制算法能有更高的吞吐量和更低的延迟，可以用BBR来替代其他流行的拥塞算法。



Google在YouTube上应用该算法，将全球平均的YouTube网络吞吐量提高了4%，BBR之后移植入Linux内核4.9版本。



其中比较有名的Vegas算法是大约在1995年由亚利桑那大学的研究人员拉里·彼得森和劳伦斯·布拉科夫提出，这个新的TCP拥塞算法以内华达州最大的城市拉斯维加斯命名，后成为TCP Vegas算法。

关于基于RTT的TCP Vegas算法的详细介绍可以查阅文档：

> http://www.cs.cmu.edu/~srini/15-744/F02/readings/BP95.pdf

文档对Vegas算法和New Reno做了一些对比，我们从直观图形上可以看到Vegas算法更加平滑，相反New Reno则表现除了较大的波动呈锯齿状，如图所示：

![img](https://i.loli.net/2020/11/12/8QRwet2NGb9Orcs.jpg)

实际上还有更细粒度的分类，由于不是今天的重点，就不再深入展开了，当前使用的拥塞控制算法还是基于丢包Loss-Based作为主流。





---

参考：

1. [万字长文|全网最强 TCP/IP 拥塞控制总结...](https://my.oschina.net/u/3872630/blog/4434563)
2. [万字详文：TCP 拥塞控制详解](https://zhuanlan.zhihu.com/p/144273871)

# [一泡尿的时间，快速读懂QUIC协议](https://juejin.im/post/6844903985262903304)

如何让网络数据传输地更快？(合并一些层)

![如何传输的更快](https://i.loli.net/2020/11/12/McdVSu7AgFUaTRb.png)

### 为什么需要QUIC？

1. 中间设备的僵化

   可能是 TCP 协议使用得太久，也非常可靠。所以我们很多中间设备，包括防火墙、NAT 网关，整流器等出现了一些约定俗成的动作。

2. 依赖于操作系统的实现导致协议僵化

   TCP 是由操作系统在内核西方栈层面实现的，应用程序只能使用，不能直接修改。虽然应用程序的更新迭代非常快速和简单。但是 TCP 的迭代却非常缓慢，原因就是操作系统升级很麻烦。

3. 建立连接的握手延迟大

   不管是 HTTP1.0/1.1 还是 HTTPS，HTTP2，都使用了 TCP 进行传输。HTTPS 和 HTTP2 还需要使用 TLS 协议来进行安全传输。这就出现了两个握手延迟：

   1. TCP 三次握手导致的 TCP 连接建立的延迟。

   2. TLS 完全握手需要至少 2 个 RTT 才能建立，简化握手需要 1 个 RTT 的握手延迟。

   对于很多短连接场景，这样的握手延迟影响很大，且无法消除。

4. 队头阻塞

   队头阻塞主要是 TCP 协议的可靠性机制引入的。TCP 使用序列号来标识数据的顺序，数据必须按照顺序处理，如果前面的数据丢失，后面的数据就算到达了也不会通知应用层来处理。

   另外 TLS 协议层面也有一个队头阻塞，因为 TLS 协议都是按照 record 来处理数据的，如果一个 record 中丢失了数据，也会导致整个 record 无法正确处理。

 QUIC 协议选择了 UDP，因为 UDP 本身没有连接的概念，不需要三次握手，优化了连接建立的握手延迟，同时在应用程序层面实现了 TCP 的可靠性，TLS 的安全性和 HTTP2 的并发性，只需要用户端和服务端的应用程序支持 QUIC 协议，完全避开了操作系统和中间设备的限制。





QUIC 是 Quick UDP Internet Connections 的缩写，谷歌发明的新传输协议。

> 与 TCP 相比，QUIC 可以减少延迟。

QUIC 协议可以在 1 到 2 个数据包（取决于连接的服务器是新的还是已知的）内，完成连接的创建（包括 TLS）。

![QUIC握手](https://i.loli.net/2020/11/12/Do24kg6HWaR8lVi.png)



QUIC 与现有 TCP + TLS + HTTP/2 方案相比，有以下几点主要特征：

1. 利用缓存，显著减少连接建立时间；(减少了 TCP 三次握手及 TLS 握手时间)
2. 改善拥塞控制，拥塞控制从内核空间到用户空间；
3. 没有 head of line 阻塞的多路复用；
4. 前向纠错，减少重传；
5. 连接平滑迁移，网络状态的变更不会影响连接断线。





拥塞控制、加密和一些HTTP/2的特性都移动到QUIC层去了

![QUIC层](https://i.loli.net/2020/11/12/u8RbdLX1hwEQTlN.png)

从图上可以看出，QUIC 底层通过 UDP 协议替代了 TCP，上层只需要一层用于和远程服务器交互的 HTTP/2 API。这是因为 QUIC 协议已经包含了多路复用和连接管理，HTTP API 只需要完成 HTTP 协议的解析即可。

QUIC也合并了TLS握手过程到它的连接过程之中

![image-20201112155241502](https://i.loli.net/2020/11/12/W5U3wNFbjzIcgG1.png)



#### 目标

QUIC 协议的主要目的，是为了整合 TCP 协议的可靠性和 UDP 协议的速度和效率。







### QUIC连接过程

**Step1**：首次连接时，客户端发送 Inchoate Client Hello 给服务端，用于请求连接；

**Step2**：服务端生成 g、p、a，根据 g、p 和 a 算出 A，然后将 g、p、A 放到 Server Config 中再发送 Rejection 消息给客户端；

**Step3**：客户端接收到 g、p、A 后，自己再生成 b，根据 g、p、b 算出 B，根据 A、p、b 算出初始密钥 K。B 和 K 算好后，客户端会用 K 加密 HTTP 数据，连同 B 一起发送给服务端；

**Step4**：服务端接收到 B 后，根据 a、p、B 生成与客户端同样的密钥，再用这密钥解密收到的 HTTP 数据。为了进一步的安全（前向安全性），服务端会更新自己的随机数 a 和公钥，再生成新的密钥 S，然后把公钥通过 Server Hello 发送给客户端。连同 Server Hello 消息，还有 HTTP 返回数据；

**Step5**：客户端收到 Server Hello 后，生成与服务端一致的新密钥 S，后面的传输都使用 S 加密。

这样，QUIC 从请求连接到正式接发 HTTP 数据一共花了 1 RTT，这 1 个 RTT 主要是为了获取 Server Config，后面的连接如果客户端缓存了 Server Config，那么就可以直接发送 HTTP 数据，实现 0 RTT 建立连接。

![image-20201112192246347](https://i.loli.net/2020/11/12/p8Fb3w2WTICJsAG.png)

这里使用的是 DH 密钥交换算法，DH 算法的核心就是服务端生成 a、g、p 3 个随机数，a 自己持有，g 和 p 要传输给客户端，而客户端会生成 b 这 1 个随机数，通过 DH 算法客户端和服务端可以算出同样的密钥。在这过程中 a 和 b 并不参与网络传输，安全性大大提高。因为 p 和 g 是大数，所以即使在网络中传输的 p、g、A、B 都被劫持，那么靠现在的计算机算力也没法破解密钥。



### QUIC连接迁移

> 当手机从数据信号切换到WIFI信号时需要可以灵活的进行连接的切换。

TCP 连接基于四元组（源 IP、源端口、目的 IP、目的端口），切换网络时至少会有一个因素发生变化，导致连接发生变化。当连接发生变化时，如果还使用原来的 TCP 连接，则会导致连接失败，就得等原来的连接超时后重新建立连接，所以我们有时候发现切换到一个新网络时，即使新网络状况良好，但内容还是需要加载很久。如果实现得好，当检测到网络变化时立刻建立新的 TCP 连接，即使这样，建立新的连接还是需要几百毫秒的时间。

QUIC 的连接不受四元组的影响，当这四个元素发生变化时，原连接依然维持。那这是怎么做到的呢？道理很简单，**QUIC 连接不以四元组作为标识，而是使用一个 64 位的随机数，这个随机数被称为 Connection ID，即使 IP 或者端口发生变化，只要 Connection ID 没有变化，那么连接依然可以维持。**

是不是很强~

![连接迁移](https://i.loli.net/2020/11/12/TrGfclm1XwJbkOx.png)



### QUIC解决队头阻塞问题

![队头阻塞](https://i.loli.net/2020/11/12/J9C7YKflUqSGTQP.png)

HTTP 一般又允许每个主机建立 6 个 TCP 连接，这样可以更加充分地利用带宽资源，但每个连接中队头阻塞的问题还是存在。

HTTP/2 的多路复用解决了上述的队头阻塞问题。不像 HTTP/1.1 中只有上一个请求的所有数据包被传输完毕下一个请求的数据包才可以被传输，HTTP/2 中每个请求都被拆分成多个 Frame 通过一条 TCP 连接同时被传输，这样即使一个请求被阻塞，也不会影响其他的请求。如下图所示，不同颜色代表不同的请求，相同颜色的色块代表请求被切分的 Frame。

![image-20201112193653271](https://i.loli.net/2020/11/12/FSCO4jJ2ueU51km.png)

事情还没完，HTTP/2 虽然可以解决“请求”这个粒度的阻塞，但 HTTP/2 的基础 TCP 协议本身却也存在着队头阻塞的问题。HTTP/2 的每个请求都会被拆分成多个 Frame，不同请求的 Frame 组合成 Stream，Stream 是 TCP 上的逻辑传输单元，这样 HTTP/2 就达到了一条连接同时发送多条请求的目标，这就是多路复用的原理。我们看一个例子，在一条 TCP 连接上同时发送 4 个 Stream，其中 Stream1 已正确送达，Stream2 中的第 3 个 Frame 丢失，TCP 处理数据时有严格的前后顺序，先发送的 Frame 要先被处理，这样就会要求发送方重新发送第 3 个 Frame，Stream3 和 Stream4 虽然已到达但却不能被处理，那么这时整条连接都被阻塞。

![image-20201112193827513](https://i.loli.net/2020/11/12/YGdVE3y1nHi86Dk.png)

不仅如此，由于 HTTP/2 必须使用 HTTPS，而 HTTPS 使用的 TLS 协议也存在队头阻塞问题。TLS 基于 Record 组织数据，将一堆数据放在一起（即一个 Record）加密，加密完后又拆分成多个 TCP 包传输。一般每个 Record 16K，包含 12 个 TCP 包，这样如果 12 个 TCP 包中有任何一个包丢失，那么整个 Record 都无法解密。

![image-20201112194051260](https://i.loli.net/2020/11/12/3vDl4FKuRtSifkE.png)



那 QUIC 是如何解决队头阻塞问题的呢？主要有两点。

- QUIC 的传输单元是 Packet，加密单元也是 Packet，整个加密、传输、解密都基于 Packet，这样就能避免 TLS 的队头阻塞问题；
- QUIC 基于 UDP，UDP 的数据包在接收端没有处理顺序，即使中间丢失一个包，也不会阻塞整条连接，其他的资源会被正常处理。

![image-20201112193253455](https://i.loli.net/2020/11/12/w7DFB2ojmCJlk98.png)



### QUIC的拥塞控制

拥塞控制的目的是避免过多的数据一下子涌入网络，导致网络超出最大负荷。QUIC 的拥塞控制与 TCP 类似，并在此基础上做了改进。

QUIC 重新实现了 TCP 协议的 Cubic 算法进行拥塞控制，并在此基础上做了不少改进。



**热拔插**

TCP 中如果要修改拥塞控制策略，需要在系统层面进行操作。QUIC 修改拥塞控制策略只需要在应用层操作，并且 QUIC 会根据不同的网络环境、用户来动态选择拥塞控制算法。

![image-20201112194918754](https://i.loli.net/2020/11/12/Gf4xhmKiTnlyWLj.png)

### QUIC前向纠错FEC

QUIC 使用前向纠错(FEC，Forward Error Correction)技术增加协议的容错性。一段数据被切分为 10 个包后，依次对每个包进行异或运算，运算结果会作为 FEC 包与数据包一起被传输，如果不幸在传输过程中有一个数据包丢失，那么就可以根据剩余 9 个包以及 FEC 包推算出丢失的那个包的数据，这样就大大增加了协议的容错性。

这是符合现阶段网络技术的一种方案，现阶段带宽已经不是网络传输的瓶颈，往返时间才是，所以新的网络传输协议可以适当增加数据冗余，减少重传操作。

![image-20201112194343219](https://i.loli.net/2020/11/12/ejmniVGcFlTrRsf.png)





### QUIC重传序列号单调递增

TCP 为了保证可靠性，使用 Sequence Number 和 ACK 来确认消息是否有序到达，但这样的设计存在缺陷。

超时发生后客户端发起重传，后来接收到了 ACK 确认消息，但因为原始请求和重传请求接收到的 ACK 消息一样，所以客户端就郁闷了，不知道这个 ACK 对应的是原始请求还是重传请求。如果客户端认为是原始请求的 ACK，但实际上是左图的情形，则计算的采样 RTT 偏大；如果客户端认为是重传请求的 ACK，但实际上是右图的情形，又会导致采样 RTT 偏小。图中有几个术语，RTO 是指超时重传时间（Retransmission TimeOut），跟我们熟悉的 RTT（Round Trip Time，往返时间）很长得很像。采样 RTT 会影响 RTO 计算，超时时间的准确把握很重要，长了短了都不合适。

![image-20201112195439072](https://i.loli.net/2020/11/12/M4Smbkgu1aI3LpN.png)



QUIC 解决了上面的歧义问题。与 Sequence Number 不同的是，Packet Number 严格单调递增，如果 Packet N 丢失了，那么重传时 Packet 的标识不会是 N，而是比 N 大的数字，比如 N + M，这样发送方接收到确认消息时就能方便地知道 ACK 对应的是原始请求还是重传请求。

![image-20201112195456998](https://i.loli.net/2020/11/12/EhqmK85PY9oFA3V.png)





### ACK Delay

TCP 计算 RTT 时没有考虑接收方接收到数据到发送确认消息之间的延迟，如下图所示，这段延迟即 ACK Delay。QUIC 考虑了这段延迟，使得 RTT 的计算更加准确。

![image-20201112195628088](https://i.loli.net/2020/11/12/k9djmq3NFlOoAtg.png)



### 更多的 ACK 块

一般来说，接收方收到发送方的消息后都应该发送一个 ACK 回复，表示收到了数据。但每收到一个数据就返回一个 ACK 回复太麻烦，所以一般不会立即回复，而是接收到多个数据后再回复，TCP SACK 最多提供 3 个 ACK block。但有些场景下，比如下载，只需要服务器返回数据就好，但按照 TCP 的设计，每收到 3 个数据包就要“礼貌性”地返回一个 ACK。而 QUIC 最多可以捎带 256 个 ACK block。在丢包率比较严重的网络下，更多的 ACK block 可以减少重传量，提升网络效率。

![image-20201112195654062](https://i.loli.net/2020/11/12/Da2AnVZRCgBHWIi.png)



### QUIC流量控制

似乎一样。



---

参考：

1. [The Road to QUIC](https://medium.com/cloudflare-blog/the-road-to-quic-9f100dc57d9d)
2. [科普：QUIC协议原理分析](https://zhuanlan.zhihu.com/p/32553477)
3. [Quic协议介绍和浅析](https://blog.csdn.net/jeffrey11223/article/details/84382123)





# 参考与更多:heavy_plus_sign:

1. [计算机网络面试总结](https://blog.csdn.net/chenchaofuck1/article/details/51980794)



---




<p align="center">
    <a href="https://www.jiahongw.com">
        <img width="200" src="https://i.loli.net/2020/11/13/vqTDSPc7hj5LzlC.jpg">
    </a>
    <br >
    <a href="https://hugo.jiahongw.com/"><img src="https://img.shields.io/badge/%3E-HOME-green.svg"></a>
    <a href="https://hugo.jiahongw.com/"><img src="https://img.shields.io/badge/%3E-ABOUT-green.svg"></a>
    <a href="mailto:1427298682@qq.com"><img src="https://img.shields.io/badge/%3E-Email-green.svg"></a>
</p>


<h1 align="center">Interview OS</h1>





![OS板块](https://i.loli.net/2020/10/30/1mE9onuwc3AlgaG.png)

[高频知识——操作系统面试问题整理](https://blog.nowcoder.net/n/49211c67aaaa49eb8842f7e979c79498)

![img](https://img2020.cnblogs.com/blog/1515111/202007/1515111-20200716085222492-1986911087.png)

[小白如何学习操作系统？](https://www.cnblogs.com/cxuanBlog/p/13320810.html)



#### 进程、线程、协程区别:diamond_shape_with_a_dot_inside:

##### 进程与线程的来由:comet:

进程的作用与定义：是为了提高CPU的执行效率，为了避免因等待而造成CPU空转以及其他计算机硬件资源的浪费而提出来的。

线程的引入：例如，有一个Web服务器要进程的方式并发地处理来自不同用户的网页访问请求的话，可以创建父进程和多个子进程的方式来进行处理，但是创建一个进程要花费较大的**系统开销**和占用较多的**资源**。除外，这些不同的用户子进程在执行的时候涉及到**进程上下文切换**，上下文切换是一个复杂的过程。所以，为了减少进程切换和创建的开销，提高执行效率和节省资源，人们在操作系统中引入了"线程（thread）"的概念。

(进程的消耗太大，所以引入线程)

##### 进程与线程的数据:dagger:

进程是系统资源分配的最小单位, 系统由一个个进程(程序)组成 一般情况下，包括**文本区域**（text region）、**数据区域**（data region）和**堆栈**（stack region）。

- 文本区域存储处理器执行的代码
- 数据区域存储变量和进程执行期间使用的动态分配的内存；
- 堆栈区域存储着活动过程调用的指令和本地变量。

> 与进程的控制表**PCB**相似，线程也有自己的控制表**TCB**，但是TCB中所保存的线程状态比PCB表少得多。

<img src="https://i.loli.net/2020/09/06/s6AoJexnj2XV9pm.png" alt="进程与线程" style="zoom:50%;" />



**线程属于进程，并且共享进程的内存地址空间**

**线程几乎不占有系统资源通信问题:**  进程相当于一个容器,而线程而是运行在容器里面的,因此**对于容器内的东西,线程是共同享有的**,因此线程间的通信可以直接通过全局变量进行通信,但是由此带来的例如多个线程读写同一个地址变量的时候则将带来不可预期的后果,因此这时候引入了各种锁的作用,例如互斥锁等。

> **同时多线程是不安全的,当一个线程崩溃了,会导致整个进程也崩溃了,即其他线程也挂了, 但多进程而不会,一个进程挂了,另一个进程依然照样运行。**



##### 上下文切换:bar_chart:

进程切换分3步:

1. 切换页目录以使用新的地址空间
2. 切换内核栈
3. 切换硬件上下文

而线程切换只需要第2、3步,因此进程的切换代价比较大



**协程，英文Coroutines，是一种比线程更加轻量级的存在。**正如一个进程可以拥有多个线程一样，一个线程也可以拥有多个协程。

协程是属于线程的。协程程序是在线程里面跑的，因此协程又称微线程和纤程等

**协没有线程的上下文切换消耗。协程的调度切换是用户(程序员)手动切换的,因此更加灵活,因此又叫用户空间线程.**

**原子操作性。由于协程是用户调度的，所以不会出现执行一半的代码片段被强制中断了，因此无需原子操作锁。**

<img src="https://i.loli.net/2020/09/06/d3EBGfPmD6Titc1.png" alt="进程-线程-协程" style="zoom:50%;" />

> 协程不是被操作系统内核所管理，而完全是由程序所控制（也就是在用户态执行）。**协程的暂停完全由程序控制，线程的阻塞状态是由操作系统内核来进行切换。**
>
> 好处：
>
> ​		性能得到了很大的提升，不会像线程切换那样消耗资源。





 如果说操作系统引入进程的目的是为了提高程序并发执行，以提高资源利用率和系统吞吐量。那么操作系统中引入线程的目的，则是为了减少进程并发执行过程中所付出的时空开销，使操作系统能很好的并发执行。

　　进程process定义了一个**执行环境**，包括它自己私有的地址空间、一个句柄表，以及一个安全环境；线程则是一个**控制流**，有他自己的调用栈call stack，记录了它的执行历史。

　　线程由两个部分组成：1）**线程的内核对象**，操作系统用它来对线程实施管理。内核对象也是系统用来存放线程统计信息的地方。2）**线程堆栈**，它用于维护线程在执行代码时需要的所有参数和局部变量。当创建线程时，系统创建一个线程内核对象。该线程内核对象不是线程本身，而是操作系统用来管理线程的较小的数据结构。可以将线程内核对象视为由关于线程的统计信息组成的一个小型数据结构。



---

参考链接：

1. [线程，进程，协程详细解释](https://blog.csdn.net/ai2000ai/article/details/104125442)
2. [进程、线程和协程的概念](https://juejin.im/post/6844903607892967432)



#### 进程的几种状态

<img src="https://i.loli.net/2020/10/15/vbltYRN2jw1GCTQ.png" alt="三种进程状态" style="zoom: 33%;" />

1. **就绪(Ready)状态**

   当进程已分配到除CPU以外的所有必要资源后，只要再获得CPU，便可立即执行，进程这时的状态称为就绪状态。在一个系统中处于就绪状态的进程可能有多个，通常将它们排成一个队列，称为就绪队列。

2. **执行状态**

   进程已获得CPU，其程序正在执行。在单处理机系统中，只有一个进程处于执行状态； 在多处理机系统中，则有多个进程处于执行状态。

3. **阻塞状态**

   正在执行的进程由于发生某事件而暂时无法继续执行时，便放弃处理机而处于暂停状态，亦即进程的执行受到阻塞，把这种暂停状态称为阻塞状态，有时也称为等待状态或封锁状态。致使进程阻塞的典型事件有：请求I/O，申请缓冲空间等。通常将这种处于阻塞状态的进程也排成一个队列。有的系统则根据阻塞原因的不同而把处于阻塞状态的进程排成多个队列。



#### [死锁，活锁和饥饿](https://www.cnblogs.com/ktgu/p/3529143.html):closed_lock_with_key:

死锁:closed_lock_with_key:：是指**两个或两个以上的进程（或线程）**在执行过程中，因**争夺资源而造成的一种互相等待的现象**，若无外力作用，它们都将无法推进下去。此时称系统处于死锁状态或系统产生了死锁，这些永远在互相等待的进程称为死锁进程。

死锁的条件:

1. 互斥
2. 请求和保持
3. 不剥夺原则
4. 环路等待



如何避免死锁？:runner:

[预防](https://interview.huihut.com/#/?id=预防)

- 打破互斥条件：改造独占性资源为虚拟资源，大部分资源已无法改造。
- **打破不可抢占条件：当一进程占有一独占性资源后又申请一独占性资源而无法满足，则退出原占有的资源。**
- **打破占有且申请条件：采用资源预先分配策略，即进程运行前申请全部资源，满足则运行，不然就等待，这样就不会占有且申请。**
- **打破循环等待条件：实现资源有序分配策略，对所有设备实现分类编号，所有进程只能采用按序号递增的形式申请资源。**
- 有序资源分配法
- 银行家算法





活锁:articulated_lorry:：**是指线程1可以使用资源，但它很礼貌，让其他线程先使用资源，线程2也可以使用资源，但它很绅士，也让其他线程先使用资源。**这样你让我，我让你，最后两个线程都无法使用资源。



饥饿:hungary: :是指如果线程T1占用了资源R，线程T2又请求封锁R，于是T2等待。T3也请求资源R，当T1释放了R上的封锁后，系统首先批准了T3的请求，T2仍然等待。然后T4又请求封锁R，当T3释放了R上的封锁之后，系统又批准了T4的请求......，T2可能永远等待。



##### 如何检测死锁

一般来说，由于操作系统有并发，共享以及随机性等特点，通过预防和避免的手段达到排除死锁的目的是很困难的。这需要较大的系统开销，而且不能充分利用资源。为此，一种简便的方法是系统为进程分配资源时，不采取任何限制性措施，但是提供了检测和解脱死锁的手段：能发现死锁并从死锁状态中恢复出来。因此，在实际的操作系统中往往采用死锁的检测与恢复方法来排除死锁。常利用资源分配图、进程等待图来协助这种检测。

核心是：**不试图阻止死锁，而是当检测到死锁发生时，采取措施进行恢复。**

可以对进程 - 资源分配图进行检测(按周期进行检测)：

* 如果进程 - 资源分配图中无环路，此时系统没有发生死锁。
* 如果进程 - 资源分配图中有环路，则可分为以下两种情况：
  1. 每种资源类中仅有一个资源，则系统发生了死锁。此时，环路是系统发生死锁的充分必要条件，环路中的进程就是死锁进程
  2. 每种资源类中有多个资源，则环路的存在只是产生死锁的**必要不充分条件**，系统未必会发生死锁。

##### 死锁恢复

- 资源剥夺法
  剥夺陷于死锁的进程所占用的资源，但并不撤销此进程，直至死锁解除。

- 进程回退法
  根据系统保存的检查点让所有的进程回退，直到足以解除死锁，这种措施要求系统建立保存检查点、回退及重启机制。

- 进程撤销法

- - 撤销陷入死锁的所有进程，解除死锁，继续运行。
  - 逐个撤销陷入死锁的进程，回收其资源并重新分配，直至死锁解除。

可选择符合下面条件之一的先撤销： 1.CPU消耗时间最少者 2.产生的输出量最小者
3.预计剩余执行时间最长者 4.分得的资源数量最少者后优先级最低者

- 系统重启法
  结束所有进程的执行并重新启动操作系统。这种方法很简单，但先前的工作全部作废，损失很大。



参考：

1. [操作系统中的死锁检测方法](https://patents.google.com/patent/CN103399818B/zh)
2. [死锁的产生、防止、避免、检测和解除](https://zhuanlan.zhihu.com/p/61221667)

#### 什么是守护进程？

**守护进程就是在后台运行,不与任何终端关联的进程**,通常情况下守护进程在系统启动时就在运行,它们以root用户或者其他特殊用户(apache和postfix)运行,并能处理一些系统级的任务.习惯上守护进程的名字通常以d结尾(sshd),但这些不是必须的.

参考：

1. [什么是守护进程](https://www.zhihu.com/question/38609004)

#### Linux运行内存分区:triangular_flag_on_post:

虚拟内存是一个抽象概念 ，**它为 每个进程提供了一个假象， 即每个进程都在独占地使用主存 。**

虚拟地址空间(和C程序空间一致)如下：

<img src="https://i.loli.net/2020/08/13/j2f7mTU9u8YLSOA.png" alt="虚拟地址空间" style="zoom: 80%;" />

**在 Linux中 ，地址空间最上面的区域是保留给操作系统中的代码和数据的** ，这对所有进程来说都是一样 。**地址空间的底部区域存放用户进程定义的代码和数据** 。

<img src="https://i.loli.net/2020/08/13/pietcT9bzVwFQaY.png" alt="解释" style="zoom:80%;" />





#### 进程间通信:eagle:

1. **管道(PIPE) / FIFO(有名管道)**

   管道可用于具有亲缘关系进程间的通信，有名管道克服了管道没有名字的限制，因此，除具有管道所具有的功能外，它还允许无亲缘关系进程间的通信；无名管道使用fork实现。

2. **消息队列**

   消息队列是消息的链接表，包括`Posix`消息队列`system V`消息队列。有足够权限的进程可以向队列中添加消息，被赋予读权限的进程则可以读走队列中的消息。**消息队列克服了信号承载信息量少，管道只能承载无格式字节流以及缓冲区大小受限等缺点。**

3. **信号量**

   要作为进程间以及同一进程不同线程之间的同步手段。

4. **共享内存**

   使得多个进程可以访问同一块内存空间，是最快的可用`IPC`形式。是针对其他通信机制运行效率较低而设计的。往往与其它通信机制，如信号量结合使用，来达到进程间的同步及互斥。

   - 优点：无须复制，快捷，信息量大
   - 缺点：
     1. 通信是通过将共享空间缓冲区直接附加到进程的虚拟地址空间中来实现的，因此进程间的读写操作的同步问题
     2. 利用内存缓冲区直接交换信息，内存的实体存在于计算机中，只能同一个计算机系统中的诸多进程共享，不方便网络通信

5. **域套接字(Domain Socket)**

   更为一般的进程间通信机制，可用于不同机器之间的进程间通信。起初是由Unix系统的BSD分支开发出来的，但现在一般可以移植到其它类Unix系统上：Linux和System V的变种都支持套接字。

6. **信号(Signal)**

   信号是比较复杂的通信方式，用于通知接受进程有某种事件发生，除了用于进程间通信外，进程还可以发送信号给进程本身；Linux除了支持Unix早期信号语义函数sigal外，还支持语义符合Posix.1标准的信号函数sigaction（实际上，该函数是基于BSD的，BSD为了实现可靠信号机制，又能够统一对外接口，用sigaction函数重新实现了signal函数）；

   > 一般来说，signal是对“中断"这种概念在软件层面上的模拟，也称”软中断“，其中信号的发送者相当于中断源，而接收者相当于处理器，所以必须是一个进程。



如果说“命名管道”把“管道”这种原来只适用近亲的手段推广到了同一台计算机中的任意进程之间，则Socket又进一步将其推广至计算机网络中的任意进程之间。从这个意义上讲，Socket成了最一般、最普遍适用的进程间通信手段和机制。事实上，现在有些Unix系统中的管道机制也反过来改成通过Socket来实现。

##### 为什么共享内存更快？

**拷贝4次**(一般进程通信方式)

1，由用户空间缓冲区中将数据拷贝到内核空间缓冲区中
2，内核空间缓冲区将数据拷贝到内存中
3，内存将数据拷贝到到内核缓冲区
4，内核空间缓冲区到用户空间缓冲区.

**拷贝2次**(共享内存通信)

1，用户空间到内存。
2，内存到用户空间。



#### 线程间通信:ear:

- 锁机制：包括互斥锁/量（mutex）、读写锁（reader-writer lock）、自旋锁（spin lock）、条件变量（condition）
  - 互斥锁/量（mutex）：提供了以排他方式防止数据结构被并发修改的方法。
  - 读写锁（reader-writer lock）：允许多个线程同时读共享数据，而对写操作是互斥的。
  - 自旋锁（spin lock）与互斥锁类似，都是为了保护共享资源。互斥锁是当资源被占用，申请者进入睡眠状态；而自旋锁则循环检测保持者是否已经释放锁。
  - 条件变量（condition）：可以以原子的方式阻塞进程，直到某个特定条件为真为止。对条件的测试是在互斥锁的保护下进行的。条件变量始终与互斥锁一起使用。
- 信号量机制(Semaphore)
  - 无名线程信号量
  - 命名线程信号量
- 信号机制(Signal)：类似进程间的信号处理
- 屏障（barrier）：屏障允许每个线程等待，直到所有的合作线程都达到某一点，然后从该点继续执行。

线程间的通信目的主要是用于线程同步，所以线程没有像进程通信中的用于数据交换的通信机制



#### 什么是孤儿进程、僵尸进程？

在`unix/linux`中，正常情况下，子进程是通过父进程创建的，子进程在创建新的进程。子进程的结束和父进程的运行是一个异步过程,即父进程永远无法预测子进程 到底什么时候结束。 当一个 进程完成它的工作终止之后，它的父进程需要调用wait()或者waitpid()系统调用取得子进程的终止状态。

**孤儿进程**:

一个父进程退出，而它的一个或多个子进程还在运行，那么那些子进程将成为孤儿进程。孤儿进程将被`init`进程(进程号为1)所收养，并由`init`进程对它们完成状态收集工作。

**僵尸进程：**

一个进程使用fork创建子进程，**如果子进程退出，而父进程并没有调用`wait`或`waitpid`获取子进程的状态信息**，那么子进程的进程描述符仍然保存在系统中。这种进程称之为僵死进程。



**处理僵尸进程**：

1. **干掉父进程**﻿

   干掉父进程后，让剩下的子进程成为孤儿进程，成为孤儿进程后就和我们上面说的一样了，由`init`进程来领养这些进程，并且来处理这些进程的资源释放等工作。

2. **父进程调用`wait`或`waitpid`**

   等函数等待子进程结束，这会导致父进程挂起。

   执行`wait（）`或 `waitpid（）`系统调用，**则子进程在终止后会立即把它在进程表中的数据返回给父进程，此时系统会立即删除该进入点**。在这种情形下就不会产生defunct进程。

3. **`fork`两次**

   第一次 fork : 父进程fork一个子进程 

   第二次 fork : 子进程fork一个孙进程后退出

   那么孙进程被`init`接管，当孙进程结束后，`init`会回收。

   但子进程的回收还要自己做。

4. **`signal`函数**

   父进程来处理：用signal函数为`SIGCHLD`安装`handler`，在子进程结束后，父进程会收到该信号，可以在`handler`中调用`wait`回收。

   内核来处理:

   如果父进程不关心子进程什么时候结束，可以通过以下两个函数通知内核自己不感兴趣子进程的结束，此时，子进程结束后，内核会回收并不再给你父进程发信号。

   - `signal（SIGCLD, SIG_IGN）`
   - `signal（SIGCHLD, SIG_IGN）`

﻿

参考：[孤儿进程与僵尸进程总结](https://www.cnblogs.com/Anker/p/3271773.html)



#### 内核态和用户态:ice_hockey:

为了安全，用户进程是受限的，它不能随意访问资源、获取资源。所以，由内核进程负责管理和分配资源，它具有最高权限，而用户进程使用被分配的资源。**用户态的程序不能 随意操作内核地址空间，具有一定的安全保护作用。**

而且，操作系统必须能够在有需要的时候能立即切换回内核进程(通过中断)，只有这样，操作系统才能有安全感。

##### 用户态切换到内核态的3种方式

* 系统调用

  这是用户态进程主动要求切换到内核态的一种方式，用户态进程通过系统调用申请使用操作系统提供的服务程序完成工作，比如fork()实际上就是执行了一个创建新进程的系统调用。而系统调用的机制其核心还是使用了操作系统为用户特别开放的一个中断来实现，例如Linux的int 80h中断。

* 中断

  当外围设备完成用户请求的操作后，会向CPU发出相应的中断信号，这时CPU会暂停执行下一条即将要执行的指令转而去执行与中断信号对应的处理程序，如果先前执行的指令是用户态下的程序，那么这个转换的过程自然也就发生了由用户态到内核态的切换。比如硬盘读写操作完成，系统会切换到硬盘读写的中断处理程序中执行后续操作等。

* 异常

  当CPU在执行运行在用户态下的程序时，发生了某些事先不可知的异常，这时会触发由当前运行进程切换到处理此异常的内核相关程序中，也就转到了内核态，比如缺页异常。





#### free()函数如何知道要释放的空间大小:question:

malloc有多种实现，有使用链表的，也有是由在申请内存头部记录信息的，还有使用伙伴的算法。没有一个统一的malloc算法。

参考：https://www.zhihu.com/question/302440083



#### 中断和轮询的特点:egg:

对I/O设备的程序轮询的方式，是早期的计算机系统对I/O设备的一种管理方式。它定时对各种设备轮流询问一遍有无处理要求。轮流询问之后，有要求的，则加以处理。在处理I/O设备的要求之后，处理机返回继续工作。尽管轮询需要时间，但轮询要比I/O设备的速度要快得多，所以一般不会发生不能及时处理的问题。当然，再快的处理机，能处理的输入输出设备的数量也是有一定限度的。而且，程序轮询毕竟占据了CPU相当一部分处理时间，因此，程序**轮询**是一种**效率较低**的方式，在现代计算机系统中已很少应用。

　　程序中断通常简称**中断**，是指CPU在正常运行程序的过程中，由于预先安排或发生了各种随机的内部或外部事件，使CPU中断正在运行的程序，而转到为响应的服务程序去处理。

　　轮询——效率低，等待时间很长，CPU利用率不高。

　　中断——容易遗漏一些问题，CPU利用率高。

> 中断是指在计算机执行期间，系统内发生任何非寻常的或非预期的急需处理事件，使得CPU**暂时中断**当前正在执行的程序而转去执行相应的事件处理程序。待**处理完毕后又返回**原来被中断处继续执行或调度新的进程执行的过程。

**中断向量表**

外部设备的中断常常对应向量表中的某一项，这是通用框架的外部中断处理函数入口，因此在进入通用的中断处理函数之后，系统必须知道正在处理的中断是哪一个设备产生的，而这正是由软件中断号irq定的决。中断向量表的内容是由操作系统在初始化阶段来填写，对于外部中断，操作系统负责实现一个通用的外部中断处理函数，然后把这个函数的入口地址放到中断向量表中的对应位置。用户注册设备驱动ISR，实际上就是挂接到中断向量表中，覆盖某一项的默认处理实现特化。



#### 分段与分页:eyeglasses:

段式存储管理是一种符合用户视角的内存分配管理方案。在段式存储管理中，将程序的地址空间划分为若干段（segment），如代码段，数据段，堆栈段；这样每个进程有一个**二维地址空间**，相互独立，互不干扰。段式管理的优点是：**没有内碎片**（因为段大小可变，改变段大小来消除内碎片）。但**段换入换出时，会产生外碎片**（比如4k的段换5k的段，会产生1k的外碎片）

页式存储管理方案是一种用户视角内存与物理内存相分离的内存分配管理方案。在页式存储管理中，将程序的**逻辑地址划分为固定大小的页（page）**，而**物理内存**划分为同样大小的**帧**，程序加载时，可以将任意一页放入内存中任意一个帧，这些帧不必连续，从而实现了离散分离。页式存储管理的优点是：**没有外碎片**（因为页的大小固定），但**会产生内碎片**（一个页可能填充不满）。

两者的不同点：

目的不同：分页是由于系统管理的需要而不是用户的需要，它是**信息的物理单位**；分段的目的是为了能更好地满足用户的需要，它是**信息的逻辑单位**，它含有一组其**意义相对完整**的信息；

大小不同：页的**大小固定**且由系统决定，而段的长度却**不固定**，由其所完成的功能决定；

地址空间不同： 段向用户提供**二维地址空间**；页向用户提供的是**一维地址空间**；

信息共享：段是信息的逻辑单位，便于存储保护和信息的共享，页的保护和共享受到限制；

内存碎片：页式存储管理的优点是没有外碎片（因为页的大小固定），但会产生内碎片（一个页可能填充不满）；而段式管理的优点是没有内碎片（因为段大小可变，改变段大小来消除内碎片）。但段换入换出时，会产生外碎片（比如4k的段换5k的段，会产生1k的外碎片）。

- 段是信息的**逻辑单位**，它是根据**用户的需要**划分的，因此段对用户是可见的 ；页是信息的**物理单位**，是为了**管理主存**的方便而划分的，对用户是透明的。
- 段的大小**不固定**，有它所完成的功能决定；页大大小**固定**，由系统决定
- 段向用户提供**二维地址空间**；页向用户提供的是**一维地址空间**
- 段是信息的逻辑单位，便于**存储保护和信息的共享**，页的保护和共享**受到限制**。



页是信息的物理单位，分页是为实现离散分配方式，以消减内存的外零头，提高内存的利用率；或者说，分页仅仅是由于系统管理的需要，而不是用户的需要。

段是信息的逻辑单位，它含有一组其意义相对完整的信息。分段的目的是为了能更好的满足用户的需要。

页的大小固定且由系统确定，把逻辑地址划分为页号和页内地址两部分，是由机器硬件实现的，因而一个系统只能有一种大小的页面。段的长度却不固定，决定于用户所编写的程序，通常由编辑程序在对源程序进行编辑时，根据信息的性质来划分。

分页的作业地址空间是一维的，即单一的线性空间，程序员只须利用一个记忆符，即可表示一地址。分段的作业地址空间是二维的，程序员在标识一个地址时，既需给出段名，又需给出段内地址。



##### 内存分段

程序是由若干个逻辑分段组成的，如可由代码分段、数据分段、栈段、堆段组成。**不同的段是有不同的属性的，所以就用分段（*Segmentation*）的形式把这些段分离出来。**

> 分段机制下，虚拟地址和物理地址是如何映射的？

分段机制下的虚拟地址由两部分组成，**段选择子**和**段内偏移量**。

<img src="https://i.loli.net/2020/10/30/21VWRnugyxidceb.jpg" alt="preview" style="zoom:80%;" />

- **段选择子**就保存在段寄存器里面。段选择子里面最重要的是**段号**，用作段表的索引。**段表**里面保存的是这个**段的基地址、段的界限和特权等级**等。
- 虚拟地址中的**段内偏移量**应该位于 0 和段界限之间，如果段内偏移量是合法的，就将段基地址加上段内偏移量得到物理内存地址。



由上面可以知道虚拟地址是通过**段表**与物理地址进行映射的，分段机制会把程序的虚拟地址分成 4 个段，每个段在段表中有一个项，在这一项找到段的基地址，再加上偏移量，于是就能找到物理内存中的地址，如下图：

![分段](https://i.loli.net/2020/10/30/KR8tmxrAbYBeFhi.jpg)

分段的办法很好，解决了程序本身不需要关心具体的物理内存地址的问题，但它也有一些不足之处：

- 第一个就是**内存碎片**的问题。
- 第二个就是**内存交换的效率低**的问题。



**为什么会产生内存碎片？**

假设我们执行了下面几个程序：

- 游戏占用了 512MB 内存
- 浏览器占用了 128MB 内存
- 音乐占用了 256 MB 内存。

假设有 1G 的物理内存，则空闲内存还有 1024 - 512 - 256 = 256MB。如果这个 256MB 不是连续的，被分成了两段 128 MB 内存，这就会导致没有空间再打开一个 200MB 的程序。

![内存碎片](https://i.loli.net/2020/10/30/gxjOFMUrShLnPc1.jpg)





这里的内存碎片的问题共有两处地方：

- 外部内存碎片，也就是产生了多个不连续的小物理内存，导致新的程序无法被装载；
- 内部内存碎片，程序所有的内存都被装载到了物理内存，但是这个程序有部分的内存可能并不是很常使用，这也会导致内存的浪费；

解决外部内存碎片的问题就是**内存交换**。

可以把音乐程序占用的那 256MB 内存写到硬盘上，然后再从硬盘上读回来到内存里。不过再读回的时候，我们不能装载回原来的位置，而是紧紧跟着那已经被占用了的 512MB 内存后面。这样就能空缺出连续的 256MB 空间，于是新的 200MB 程序就可以装载进来。

这个内存交换空间，在 Linux 系统里，也就是我们常看到的 Swap 空间，这块空间是从硬盘划分出来的，用于内存与硬盘的空间交换。



**分段为什么导致效率低？**

对于多进程的系统来说，用分段的方式，内存碎片是很容易产生的，产生了内存碎片，那不得不重新 `Swap` 内存区域，这个过程会产生性能瓶颈。

因为硬盘的访问速度要比内存慢太多了，每一次内存交换，我们都需要把一大段连续的内存数据写到硬盘上。

所以，**如果内存交换的时候，交换的是一个占内存空间很大的程序，这样整个机器都会显得卡顿。**







##### 内存分页

内存分页就是为了解决分段的内存碎片以及效率低而提出来的。

**分页是把整个虚拟和物理内存空间切成一段段固定尺寸的大小**。这样一个连续并且尺寸固定的内存空间，我们叫**页**（*Page*）。在 Linux 下，每一页的大小为 `4KB`。

虚拟地址与物理地址之间通过**页表**来映射：

<img src="https://pic3.zhimg.com/80/v2-e63c20d1bace757600fccb051a29eaf6_1440w.jpg" alt="img" style="zoom:50%;" />



由于内存空间都是预先划分好的，也就不会像分段会产生间隙非常小的内存，这正是分段会产生内存碎片的原因。而**采用了分页，那么释放的内存都是以页为单位释放的，也就不会产生无法给进程使用的小内存。**



如果内存空间不够，操作系统会把其他正在运行的进程中的「最近没被使用」的内存页面给释放掉，也就是暂时写在硬盘上，称为**换出**（*Swap Out*）。一旦需要的时候，再加载进来，称为**换入**（*Swap In*）。所以，一次性写入磁盘的也只有少数的一个页或者几个页，不会花太多时间，**内存交换的效率就相对比较高**。

<img src="https://i.loli.net/2020/10/30/FBlnX4AzjZKEh5I.jpg" alt="img" style="zoom:50%;" />



在分页机制下，虚拟地址分为两部分，**页号**和**页内偏移**。页号作为页表的索引，**页表**包含物理页每页所在**物理内存的基地址**，这个基地址与页内偏移的组合就形成了物理内存地址，见下图。

<img src="https://pic1.zhimg.com/80/v2-f81afcda08a62df36ae13be04b0ea020_1440w.jpg" alt="img" style="zoom:50%;" />



##### 段页式管理

内存分段和内存分页并不是对立的，它们是可以组合起来在同一个系统中使用的，那么组合起来后，通常称为**段页式内存管理**。

段页式内存管理实现的方式：

- 先将程序划分为多个有逻辑意义的段，也就是前面提到的分段机制；
- 接着再把每个段划分为多个页，也就是对分段划分出来的连续空间，再划分固定大小的页；

这样，地址结构就由**段号、段内页号和页内位移**三部分组成。

用于段页式地址变换的数据结构是每一个程序一张段表，每个段又建立一张页表，段表中的地址是页表的起始地址，而页表中的地址则为某页的物理页号，如图所示：

![段页式](https://i.loli.net/2020/10/30/PDgKsZNzp3HRGEe.jpg)



段页式地址变换中要得到物理地址须经过三次内存访问：

- 第一次访问段表，得到页表起始地址；
- 第二次访问页表，得到物理页号；
- 第三次将物理页号与页内位移组合，得到物理地址。

可用软、硬件相结合的方法实现段页式地址变换，这样虽然增加了硬件成本和系统开销，但提高了内存的利用率。



---

参考：

1. [20 张图揭开「内存管理」的迷雾](https://zhuanlan.zhihu.com/p/152119007)

#### 进程调度算法:electric_plug:

**FCFS**(先来先服务)，**优先级**，**时间片**轮转，**多级反馈**

* **FCFS**(先来先服务，队列实现，非抢占的)

  先请求CPU的进程先分配到CPU

* **SJF(最短作业优先调度算法)**

  平均等待时间最短，但难以知道下一个CPU区间长度

* **优先级调度算法(**可以是抢占的，也可以是非抢占的)：

  **优先级越高越先分配到CPU**，相同优先级先到先服务，存在的主要问题是：低优先级进程无穷等待CPU，会导致无穷阻塞或饥饿；解决方案：老化

* **高响应比优先调度算法**

  根据“响应比=（进程执行时间+进程等待时间）/ 进程执行时间”这个公式得到的响应比来进行调度。高响应比优先算法在等待时间相同的情况下，作业执行的时间越短，响应比越高，满足段任务优先，同时响应比会随着等待时间增加而变大，优先级会提高，能够避免饥饿现象。优点是兼顾长短作业，缺点是计算响应比开销大，适用于批处理系统。

* **时间片轮转调度算法**(可抢占的)

  队列中**没有进程被分配超过一个时间片的CPU时间，除非它是唯一可运行的进程。**如果进程的CPU区间超过了一个时间片，那么该进程就被抢占并放回就绪队列。

* **多级队列调度算法**

  将就绪队列分成多个独立的队列，每个队列都有自己的调度算法，队列之间采用固定优先级抢占调度。其中，一个进程根据自身属性被永久地分配到一个队列中。

* **多级反馈队列调度算法**

  与多级队列调度算法相比，其**允许进程在队列之间移动**：若进程使用过多CPU时间，那么它会被转移到更低的优先级队列；在较低优先级队列等待时间过长的进程会被转移到更高优先级队列，以防止饥饿发生。

---

参考：

1. [五种进程调度算法的总结](https://www.jianshu.com/p/ecfddbc0af2d)
2. [大厂面试爱问的「调度算法」，20 张图一举拿下](https://zhuanlan.zhihu.com/p/225162322)



#### 页面置换算法:currency_exchange:

##### 什么是页面置换算法？

进程运行时，若其访问的页面不在内存而需将其调入，但内存已无空闲空间时，就需要从内存中调出一页程序或数据，送入磁盘的对换区，其中选择调出页面的算法就称为**页面置换算法**。



##### 常见的页面置换算法

* **FIFO先进先出算法**

  （优先淘汰最早进入内存的页面）

  在操作系统中经常被用到，比如作业调度（主要实现简单，很容易想到）；

* OPT（Optimal replacement）**最优置换算法**

  （淘汰以后不会使用的页面）

  理论的最优，理论；就是要保证置换出去的是不再被使用的页，或者是在实际内存中最晚使用的算法。

  > FIFO 和 OPT 算法的区别在于：除了在时间上向后或向前看之外，FIFO 算法使用的是页面调入内存的时间，OPT 算法使用的是页面将来使用的时间

* LRU（Least recently use）**最近最少使用算法**

  （淘汰最近没有使用的页面）

  选择最近最长时间未访问过的页面予以淘汰，它认为过去一段时间内未访问过的页面，在最近的将来可能也不会被访问。该算法为每个页面设置一个访问字段，来记录页面自上次被访问以来所经历的时间，淘汰页面时选择现有页面中值最大的予以淘汰。

  > OPT 和 LRU 算法的区别在于：LRU 算法根据各页以前的情况，是“向前看”的，而最佳置换算法则根据各页以后的使用情况，是“向后看”的
  > LRU 性能较好，但需要寄存器和栈的硬件支持

  LRU 是堆栈类的算法，理论上可以证明，堆栈类算法不可能出现 Belady 异常

* LFU（Least frequently use**）最少使用次数算法**

  （根据使用次数来判断）

  最不经常使用（LFU）页面置换算法要求置换具有最小计数的页面。

  这种选择的原因是，积极使用的页面应当具有大的引用计数。然而，当一个页面在进程的初始阶段大量使用但是随后不再使用时，会出现问题。由于被大量使用，它有一个大的计数，即使不再需要却仍保留在内存中。一种解决方案是，定期地将计数右移 1 位，以形成指数衰减的平均使用计数。

* Clock（**时钟置换算法**）

  简单的 CLOCK 算法是给每一帧关联一个附加位，称为使用位。

  当某一页首次装入主存时，该帧的使用位设置为1;

  当该页随后再被访问到时，它的使用位也被置为1。

  对于页替换算法，用于替换的候选帧集合看做一个循环缓冲区，并且有一个指针与之相关联。

  当某一页被替换时，该指针被设置成指向缓冲区中的下一帧。

  当需要替换一页时，操作系统扫描缓冲区，以查找使用位被置为0的一帧。

  每当遇到一个使用位为1的帧时，操作系统就将该位重新置为0；

  如果在这个过程开始时，缓冲区中所有帧的使用位均为0，则选择遇到的第一个帧替换；

  如果所有帧的使用位均为1,则指针在缓冲区中完整地循环一周，把所有使用位都置为0，并且停留在最初的位置上，替换该帧中的页。

  由于该算法循环地检查各页面的情况，故称为 CLOCK 算法，又称为最近未用( Not Recently Used, NRU )算法。

  <img src="https://i.loli.net/2020/10/30/rqkp6NxsbQOU4ho.png" alt="img" style="zoom: 33%;" />



---

参考：

1. [页面置换算法详解](https://www.cnblogs.com/Leophen/p/11397699.html)
2. [大厂面试爱问的「调度算法」，20 张图一举拿下](https://zhuanlan.zhihu.com/p/225162322)

#### 磁盘调度算法:floppy_disk:

磁盘的结构：

![磁盘结构](https://i.loli.net/2020/10/30/QSF9WpB3ngTYPHu.jpg)磁盘调度算法的目的很简单，就是为了提高磁盘的访问性能，一般是通过优化磁盘的访问请求顺序来做到的。

寻道的时间是磁盘访问最耗时的部分，如果请求顺序优化的得当，必然可以节省一些不必要的寻道时间，从而提高磁盘的访问性能。



常见的磁盘调度算法：

- 先来先服务算法

- 最短寻道时间优先算法

- 扫描算法算法

- 循环扫描算法

  只有磁头朝某个特定方向移动时，才处理磁道访问请求，而返回时直接快速移动至最靠边缘的磁道，也就是复位磁头，这个过程是很快的，并且返回中途不处理任何请求，该算法的特点，就是磁道只响应一个方向上的请求。

- LOOK 与 C-LOOK 算法

  我们前面说到的扫描算法和循环扫描算法，都是磁头移动到磁盘「最始端或最末端」才开始调换方向。

  那这其实是可以优化的，优化的思路就是磁头在移动到「最远的请求」位置，然后立即反向移动。

  那针对 SCAN 算法的优化则叫 LOOK 算法，它的工作方式，磁头在每个方向上仅仅移动到最远的请求位置，然后立即反向移动，而不需要移动到磁盘的最始端或最末端，反向移动的途中会响应请求

  而针 C-SCAN 算法的优化则叫 C-LOOK，它的工作方式，磁头在每个方向上仅仅移动到最远的请求位置，然后立即反向移动，而不需要移动到磁盘的最始端或最末端，**反向移动的途中不会响应请求**。

---

参考：

1. [大厂面试爱问的「调度算法」，20 张图一举拿下](https://zhuanlan.zhihu.com/p/225162322)





#### 内存分配算法

##### 首次适应算法（First Fit）

从空闲分区表的第一个表目起查找该表，把最先能够满足要求的空闲区分配给作业，这种方法的目的在于减少查找时间。为适应这种算法，空闲分区表（空闲区链）中的空闲分区要按地址由低到高进行排序。该算法优先使用低址部分空闲区，在低址空间造成许多小的空闲区，在高地址空间保留大的空闲区。

##### 最佳适应算法（Best Fit)

从全部空闲区中找出能满足作业要求的、且大小最小的空闲分区，这种方法能使碎片尽量小。为适应此算法，空闲分区表（空闲区链）中的空闲分区要按从小到大进行排序，自表头开始查找到第一个满足要求的自由分区分配。该算法保留大的空闲区，但造成许多小的空闲区。

##### 最差适应算法（Worst Fit)

从全部空闲区中找出能满足作业要求的、且大小最大的空闲分区，从而使链表中的结点大小趋于均匀，适用于请求分配的内存大小范围较窄的系统。为适应此算法，空闲分区表（空闲区链）中的空闲分区按大小从大到小进行排序，自表头开始查找到第一个满足要求的自由分区分配。该算法保留小的空闲区，尽量减少小的碎片产生。

##### 伙伴算法（buddy）

使用二进制优化的思想，将内存以2的幂为单位进行分配，合并时只能合并是伙伴的内存块，两个内存块是伙伴的三个条件是：

1.大小相等（很好判断）

2.地址连续（也很好判断）

3.两个内存块分裂自同一个父块（其实只要判断低地址的内存块首地址是否是与父块地址对齐，即合并后的首地址为父块大小的整数倍）使用lowbit等位运算可以o(1)判断。

伙伴算法在实现的时候可以使用数组+链表的形式（有点像邻接表那种），因为内存上限是固定的，比较容易确定。下列代码使用的是二维链表（写起来就没有数组加链表简洁）。在分配调整内存块时使用了递归，如果需要提高效率可以改为循环（递归更能体现出思想且代码简单，循环效率更高但是复杂一丢丢，自行选取）。

##### Slab分配算法



##### CMA算法

应用程序中申请一块内存，在应用程序看来是连续的，因为虚拟地址本身是连续的，但实际的内存空间中，所申请的这片内存未必是连续的，不过这对应用程序来说是没关系的，因为应用程序不需要关心实际的内存情况，只要MMU把物理地址映射成虚拟地址就好了。但是如果没有MMU的情况呢，我们又需要一片连续的内存空间，比如设备通过DMA直接访问内存，这种情况下应该怎么办呢？

CMA机制就是为了解决上面提到的问题而产生的。DMA zone并不是DMA专属，其它的程序也可以申请该zone的内存，如果当设备要申请DMA zone空间的一大片连续的内存时候，已经没有连续的大片内存了，只有1页，2页，4页的这种连续的小内存。解决办法就是我们标记某一片连续区域为CMA区域，这部分区域在没有大片连续内存申请的时候只给moveable的程序使用，当大片连续内存请求来的时候，我们去这片区域，把所有moveable的小片内存移动到其它的非CMA区域，更改对应的程序的页表，然后再把空出来的CMA区域给设备，从而实现了DMA大片连续内存的分配。

CMA机制并不是单独存在的，它通常服务于DMA设备，在设备调用dma_alloc_coherent函数申请一块内存后，为了得到一片连续的内存，CMA机制被调用，它保证了申请的内存的连续性。

另外CMA区域通常被分配在高端内存。

![img](https://upload-images.jianshu.io/upload_images/2828107-ebcd8491916f38d9.png?imageMogr2/auto-orient/strip|imageView2/2/w/554/format/webp)

---

参考：

1. [内存分配算法——FF、BF、WF、buddy（伙伴算法）](https://blog.csdn.net/GreyBtfly/article/details/84646981)
2. [Linux学习-内存管理篇（四）-内存分配算法](https://www.jianshu.com/p/271c316b53ef)

#### 伙伴算法和slab算法

##### 伙伴算法(Buddy分配算法)

**作用**

它要解决的问题是**频繁地请求和释放不同大小的一组连续页框，必然导致在已分配页框的块内分散了许多小块的空闲页面**，由此带来的问题是，**即使有足够的空闲页框可以满足请求，但要分配一个大块的连续页框可能无法满足请求**。(*解决碎片问题*)

**流程**

 伙伴算法（Buddy system）把所有的空闲页框分为11个块链表，每块链表中分布包含特定的连续页框地址空间，比如第0个块链表包含大小为2^0个连续的页框，第1个块链表中，每个链表元素包含2个页框大小的连续地址空间，….，第10个块链表中，每个链表元素代表4M的连续地址空间。每个链表中元素的个数在系统初始化时决定，在执行过程中，动态变化。

 伙伴算法每次只能分配2的幂次页的空间，比如一次分配1页，2页，4页，8页，…，1024页(2^10)等等，每页大小一般为4K，因此，伙伴算法最多一次能够分配4M的内存空间。

<img src="https://i.loli.net/2020/11/02/4YEQR5vUJkciONW.png" alt="image" style="zoom: 67%;" />

**申请和回收过程**

  比如，我要分配4(2^2)页（16k）的内存空间，算法会先从free_area[2]中查看nr_free是否为空，如果有空闲块，则从中分配，如果没有空闲块，就从它的上一级free_area[3]（每块32K）中分配出16K，并将多余的内存（16K）加入到free_area[2]中去。如果free_area[3]也没有空闲，则从更上一级申请空间，依次递推，直到free_area[max_order]，如果顶级都没有空间，那么就报告分配失败。

 释放是申请的逆过程，当释放一个内存块时，先在其对于的free_area链表中查找是否有伙伴存在，如果没有伙伴块，直接将释放的块插入链表头。如果有或板块的存在，则将其从链表摘下，合并成一个大块，然后继续查找合并后的块在更大一级链表中是否有伙伴的存在，直至不能合并或者已经合并至最大块2^10为止。

   内核试图将大小为b的一对空闲块（一个是现有空闲链表上的，一个是待回收的），合并为一个大小为2B的单独块，如果它成功合并所释放的块，它会试图合并2b大小的块，

**伙伴算法的优缺点**

优点：

* 较好的解决外部碎片问题
* 当需要分配若干个内存页面时，用于DMA的内存页面必须连续，伙伴算法很好的满足了这个要求
* 只要请求的块不超过512个页面(2K)，内核就尽量分配连续的页面。
* 针对大内存分配设计。



缺点：

* 合并的要求太过严格，只能是满足伙伴关系的块才能合并，比如第1块和第2块就不能合并。
* 碎片问题：一个连续的内存中仅仅一个页面被占用，导致整块内存区都不具备合并的条件(内部碎片问题)
* 浪费问题：伙伴算法只能分配2的幂次方内存区，当需要8K（2页）时，好说，当需要9K时，那就需要分配16K（4页）的内存空间，但是实际只用到9K空间，多余的7K空间就被浪费掉。
* 算法的效率问题： 伙伴算法涉及了比较多的计算还有链表和位图的操作，开销还是比较大的，如果每次2^n大小的伙伴块就会合并到2^(n+1)的链表队列中，那么2^n大小链表中的块就会因为合并操作而减少，但系统随后立即有可能又有对该大小块的需求，为此必须再从2^(n+1)大小的链表中拆分，这样的合并又立即拆分的过程是无效率的。

Linux针对大内存的物理地址分配，采用伙伴算法，如果是针对小于一个page的内存，频繁的分配和释放，有更加适宜的解决方案，如slab和`kmem_cache`等。



##### Slab分配算法

在Linux中，伙伴系统（buddy system）是以页为单位管理和分配内存。但是现实的需求却以字节为单位，假如我们需要申请20Bytes，总不能分配一页吧！那岂不是严重浪费内存。那么该如何分配呢？slab分配器就应运而生了，专为小内存分配而生。slab分配器分配内存以Byte为单位。但是slab分配器并没有脱离伙伴系统，而是基于伙伴系统分配的大内存进一步细分成小内存分配。



 linux 所使用的 slab 分配器的基础是 Jeff Bonwick 为SunOS 操作系统首次引入的一种算法。Jeff的分配器是围绕对象缓存进行的。在内核中，会为有限的对象集（例如文件描述符和其他常见结构）分配大量内存。Jeff发现对内核中**普通对象进行初始化所需的时间超过了对其进行分配和释放所需的时间。**因此他的结论是**不应该将内存释放回一个全局的内存池，而是将内存保持为针对特定目而初始化的状态。**例如，如果内存被分配给了一个互斥锁，那么只需在为互斥锁首次分配内存时执行一次互斥锁初始化函数（mutex_init）即可。后续的内存分配不需要执行这个初始化函数，因为从上次释放和调用析构之后，它已经处于所需的状态中了。

slab层主要起到了两个方面的作用：

1. slab可以对小对象进行分配，这样就不用为每个小对象分配一个页框，节省了空间。

2. 内核中的一些小对象创建析构很频繁，slab对这些小对象做了缓存，可以重复利用一些相同的对象，减少内存分配次数。



<img src="https://i.loli.net/2020/11/02/YhZXSNgnlsdBIA1.jpg" alt="Slab算法" style="zoom:150%;" />



图中给出了 slab结构的高层组织结构。在最高层是 cache_chain，这是一个 slab 缓存的链接列表。cache_chain 的每个元素都是一个 `kmem_cache` 结构的引用（称为一个 cache）。它定义了一个要管理的给定大小的对象池。

每个缓存都包含了一个 slabs 列表，这是一段连续的内存块（通常都是页面）。存在3 种 slab：

**slabs_full**:完全分配的slab

**slabs_partial**:部分分配的slab

**slabs_empty**:空slab，或者没有对象被分配



slab 列表中的每个 slab都是一个连续的内存块（一个或多个连续页），它们被划分成一个个对象。这些对象是从特定缓存中进行分配和释放的基本元素。注意 slab 是 slab分配器进行操作的最小分配单位，因此如果需要对 slab 进行扩展，这也就是所扩展的最小值。通常来说，每个 slab 被分配为多个对象。

由于对象是从 slab 中进行分配和释放的，因此单个 slab 可以在 slab列表之间进行移动。例如，**当一个 slab中的所有对象都被使用完时，就从slabs_partial 列表中移动到 slabs_full 列表中**。**当一个 slab完全被分配并且有对象被释放后，就从 slabs_full 列表中移动到slabs_partial 列表中**。当所有对象都被释放之后，就从 slabs_partial 列表移动到 slabs_empty 列表中。





**slab背后的动机**

​	与传统的内存管理模式相比， slab缓存分配器提供了很多优点。首先，内核通常依赖于对小对象的分配，它们会在系统生命周期内进行无数次分配。slab缓存分配器通过对类似大小的对象进行缓存而提供这种功能，从而避免了常见的碎片问题。slab分配器还支持通用对象的初始化，从而避免了为同一目而对一个对象重复进行初始化。





**slab描述符**

![img](https://i.loli.net/2020/11/02/aW8B47R12zAwQPt.png)

既然是对对象进行管理，那么就有一个内存的指针指向它所管理的对象：void* s_mem。并且它还需要记录哪些对象被使用了，哪些是空闲的。这时就需要有一个数组记录这个东西，这就是free变量。你可能会奇怪它的类型是一个unsigned int：

 ![img](https://images2015.cnblogs.com/blog/646262/201707/646262-20170704153228940-417998395.png)

它是如何记录这个数组的呢？事实上是记录在slab描述符后面的数组中，这个数组中的每一个元素记录着下一个空闲的内存对象的位置。而free记录的就是第一个空闲的对象。这样就可以从free开始遍历所有空闲的对象。

下图显示了slab对象的内存分布，这里需要解释一下的是slab descriptor会根据情况被存放在当前slab的内存中或者存放在通用的高速缓存中。

![Slab对象分布](https://i.loli.net/2020/11/02/2UGgpLHXZR89i3E.png)



##### Slab与Buddy的关系

* slab与Buddy都是内存分配器。
* slab的内存来自Buddy
* slab与Buddy在算法上级别对等。Buddy把内存条当作一个池子来管理，slab是把从Buddy拿
* 到的内存当作一个池子来管理的

---

参考链接：

1. [Linux 伙伴算法简介](https://www.cnblogs.com/cherishui/p/4246133.html)
2. [伙伴算法与slab算法](https://www.cnblogs.com/ljygoodgoodstudydaydayup/p/7116858.html)

#### mmap和brk的区别

从操作系统角度来看，进程分配内存有两种方式，分别由两个系统调用完成：`brk`和`mmap`（不考虑共享内存）。

1. **`brk`**是将数据段(.`data`)的最高地址指针`_edata`往高地址推；
   这是 `brk` 的内存分配方式，可以看到A、B新申请的内存都从堆的底部（堆的地址生长是从低到高的）开始向上生长。
   如果此时 free(A)，A的内存并不会被释放，而是会被回收，等待下一次的利用，或者说是等待B的回收。
   ![brk](https://i.loli.net/2020/11/02/yALVmbhPgFrc4TC.png)
2. **`mmap`**是在进程的虚拟地址空间中（堆和栈中间，称为文件映射区域的地方）找一块空闲的虚拟内存。
   `mmap`直接从堆和栈之间的区域取出了一块区域，当回收这块内存时，操作系统也会直接将这块内存释放。
   但是系统调用和缺页中断比较消耗系统资源，为了CPU的执行效率，`malloc`只在申请的内存大于`128K`时才会调用`mmap`进行分配内存。
   ![mmap](https://i.loli.net/2020/06/23/cexoML3Jib1kEFu.png)

如果将 `brk` 比喻为批发的话，那么 `mmap` 就是零售。

**这两种方式分配的都是虚拟内存，没有分配物理内存。在第一次访问已分配的虚拟地址空间的时候，发生缺页中断，操作系统负责分配物理内存，然后建立虚拟内存和物理内存之间的映射关系。**

---

参考：

1. [操作系统中 brk 和 mmap 的区别](https://mrh1s.top/archives/561)
2. [linux下brk、mmap、malloc和new的区别](https://blog.csdn.net/Helloguoke/article/details/21644473)
3. [进程分配内存的两种方式--brk() 和mmap()（不设计共享内存）](https://blog.csdn.net/yusiguyuan/article/details/39496057)

#### 如何查看端口是否被占用？

1. 使用`netstat`:

   ```shell
   netstat anp | grep 80
   ```

2. 使用`lsof`:

   ```shell
   lsof -i:80
   ```



#### Linux的fork实现

fork的简单例子如下：

```c
#include <unistd.h>
#include <stdio.h>

int main()
{
    int pid = fork();

    if (pid == -1)
        return -1;

    if (pid)
    {
        printf("I am father, my pid is %d\n", getpid());
        return 0;
    }
    else
    {
        printf("I am child, my pid is %d\n", getpid());
        return 0;
    }
}
```

```
I am father, my pid is 466
I am child, my pid is 469
```

看到这个结果是不是很奇怪，为什么if的分支执行到了，else的分支也执行到了:question:



对于函数原型`pid_t fork();`，它有三个返回值

- 该进程为父进程时，返回子进程的`pid`
- 该进程为子进程时，返回
- fork执行失败，返回-1



**fork它是如何知道一个进程是父进程还是子进程的:question:**

fork本身的功能是克隆进程，也就是将原先的一个进程再克隆出一个来，克隆出的这个进程就是原进程的子进程，这个子进程和其他的进程没有什么区别，同样拥有自己的独立的地址空间。**不同的是子进程是在fork返回之后才开始执行的，就像一把叉子一样，执行fork之后，父子进程就分道扬镳了，所以fork这个名字就很形象**



**fork本质**(两个进程+时间片轮转)

fork在执行之后，会**创建出一个新的进程，这个新的进程内部的数据是原进程所有数据的一份拷贝**。因此fork就相当于把某个进程的全部资源复制了一遍，然后让`cs：eip`指向新进程的指令部分。

fork给父进程返回子进程`pid`，给其拷贝出来的子进程返回0，这也是他的特点之一，一次调用，两次返回。两次返回看上去有点神秘，**实质是在子进程的栈中构造好数据后，子进程从栈中获取到的返回值**。



fork的实现分为以下两步

1. 复制进程资源
2. 执行该进程

复制进程的资源包括以下几步

1. 进程`pcb`
2. 程序体，即代码段数据段等
3. 用户栈
4. 内核栈
5. 虚拟内存池
6. 页表

进行进程的话就比较简单了，只需要将其加入到就绪队列即可，接下来就等待`cpu`的调度了。

```c
pid=fork();
```

操作系统创建一个新的进程(子进程)，并且在进程表中相应为它建立一个新的表项。新进程和原有进程的可执行程序是同一个程序；上下文和数据，绝大部分就是原进程（父进程）的拷贝，但它们是两个相互独立的进程!此时程序寄存器pc，在父、子进程的上下文中都声称，这个进程目前执行到fork调用即将返回(此时子进程不占有CPU，子进程的pc不是真正保存在寄存器中，而是作为进程上下文保存在进程表中的对应表项内)。问题是怎么返回，在父子进程中就分道扬镳。
**父进程继续执行，操作系统对fork的实现，使这个调用在父进程中返回刚刚创建的子进程的pid(一个正整数)**，所以下面的if语句中pid<0, `pid==0`的两个分支都不会执行。
**子进程在之后的某个时候得到调度，它的上下文被换入，占据 CPU**，操作系统对fork的实现，使得子进程中fork调用返回0。所以在这个进程（注意这不是父进程了，虽然是同一个程序，但是这是同一个程序的另外一次执行，在操作系统中这次执行是由另外一个进程表示的，从执行的角度说和父进程相互独立）中pid=0。**这个进程继续执行的过程中，if语句中 pid<0不满足，但是`pid==0`是true**。



**相关代码**

将父进程的pcb、虚拟地址位图拷贝给子进程

```c
static int32_t copy_pcb_vaddrbitmap_stack0(task_struct *child_thread, task_struct *parent_thread)
{
      /* a 复制pcb所在的整个页,里面包含进程pcb信息及特级0极的栈,里面包含了返回地址, 然后再单独修改个别部分 */
      memcpy(child_thread, parent_thread, PG_SIZE);
      child_thread->pid = fork_pid();
      child_thread->elapsed_ticks = 0;
      child_thread->status = TASK_READY;
      child_thread->ticks = child_thread->priority; // 为新进程把时间片充满
      child_thread->parent_pid = parent_thread->pid;
      child_thread->general_tag.prev = child_thread->general_tag.next = NULL;
      child_thread->all_list_tag.prev = child_thread->all_list_tag.next = NULL;
      block_desc_init(child_thread->u_block_desc);
      /* b 复制父进程的虚拟地址池的位图 */
      uint32_t bitmap_pg_cnt = DIV_ROUND_UP((0xc0000000 - USER_VADDR_START) / PG_SIZE / 8, PG_SIZE);
      void *vaddr_btmp = get_kernel_pages(bitmap_pg_cnt);
      if (vaddr_btmp == NULL)
            return -1;
      /* 此时child_thread->userprog_vaddr.vaddr_bitmap.bits还是指向父进程虚拟地址的位图地址
    * 下面将child_thread->userprog_vaddr.vaddr_bitmap.bits指向自己的位图vaddr_btmp */
      memcpy(vaddr_btmp, child_thread->userprog_vaddr.vaddr_bitmap.bits, bitmap_pg_cnt * PG_SIZE);
      child_thread->userprog_vaddr.vaddr_bitmap.bits = vaddr_btmp;

      ASSERT(strlen(child_thread->name) < 11); // pcb.name的长度是16,为避免下面strcat越界
      strcat(child_thread->name, "_fork");
      return 0;
}
```



复制子进程的进程体(代码和数据)及用户栈

```c
static void copy_body_stack3(task_struct *child_thread, task_struct *parent_thread, void *buf_page)
{
      uint8_t *vaddr_btmp = parent_thread->userprog_vaddr.vaddr_bitmap.bits;
      uint32_t btmp_bytes_len = parent_thread->userprog_vaddr.vaddr_bitmap.btmp_bytes_len;
      uint32_t vaddr_start = parent_thread->userprog_vaddr.vaddr_start;
      uint32_t idx_byte = 0;
      uint32_t idx_bit = 0;
      uint32_t prog_vaddr = 0;

      /* 在父进程的用户空间中查找已有数据的页 */
      while (idx_byte < btmp_bytes_len)
      {
            if (vaddr_btmp[idx_byte])
            {
                  idx_bit = 0;
                  while (idx_bit < 8)
                  {
                        if ((BITMAP_MASK << idx_bit) & vaddr_btmp[idx_byte])
                        {
                              prog_vaddr = (idx_byte * 8 + idx_bit) * PG_SIZE + vaddr_start;
                              /* 下面的操作是将父进程用户空间中的数据通过内核空间做中转,最终复制到子进程的用户空间 */

                              /* a 将父进程在用户空间中的数据复制到内核缓冲区buf_page,
           目的是下面切换到子进程的页表后,还能访问到父进程的数据*/
                              memcpy(buf_page, (void *)prog_vaddr, PG_SIZE);

                              /* b 将页表切换到子进程,目的是避免下面申请内存的函数将pte及pde安装在父进程的页表中 */
                              page_dir_activate(child_thread);
                              /* c 申请虚拟地址prog_vaddr */
                              get_a_page_without_opvaddrbitmap(PF_USER, prog_vaddr);

                              /* d 从内核缓冲区中将父进程数据复制到子进程的用户空间 */
                              memcpy((void *)prog_vaddr, buf_page, PG_SIZE);

                              /* e 恢复父进程页表 */
                              page_dir_activate(parent_thread);
                        }
                        idx_bit++;
                  }
            }
            idx_byte++;
      }
}
```



为子进程构建thread_stack和修改返回值

```c
static int32_t build_child_stack(task_struct *child_thread)
{
      /* a 使子进程pid返回值为0 */
      /* 获取子进程0级栈栈顶 */
      intr_stack *intr_0_stack = (intr_stack *)((uint32_t)child_thread + PG_SIZE - sizeof(intr_stack));
      /* 修改子进程的返回值为0 */
      intr_0_stack->eax = 0;

      /* b 为switch_to 构建 struct thread_stack,将其构建在紧临intr_stack之下的空间*/
      uint32_t *ret_addr_in_thread_stack = (uint32_t *)intr_0_stack - 1;

      /* ebp在thread_stack中的地址便是当时的esp(0级栈的栈顶),
   即esp为"(uint32_t*)intr_0_stack - 5" */
      uint32_t *ebp_ptr_in_thread_stack = (uint32_t *)intr_0_stack - 5;

      /* switch_to的返回地址更新为intr_exit,直接从中断返回 */
      *ret_addr_in_thread_stack = (uint32_t)intr_exit;

      /* 把构建的thread_stack的栈顶做为switch_to恢复数据时的栈顶 */
      child_thread->self_kstack = ebp_ptr_in_thread_stack;
      return 0;
}
```



拷贝父进程本身所占资源给子进程

```C
static int32_t copy_process(task_struct *child_thread, task_struct *parent_thread)
{
      /* 内核缓冲区,作为父进程用户空间的数据复制到子进程用户空间的中转 */
      void *buf_page = get_kernel_pages(1);
      if (buf_page == NULL)
      {
            return -1;
      }

      /* a 复制父进程的pcb、虚拟地址位图、内核栈到子进程 */
      if (copy_pcb_vaddrbitmap_stack0(child_thread, parent_thread) == -1)
      {
            return -1;
      }

      /* b 为子进程创建页表,此页表仅包括内核空间 */
      child_thread->pgdir = create_page_dir();
      if (child_thread->pgdir == NULL)
      {
            return -1;
      }

      /* c 复制父进程进程体及用户栈给子进程 */
      copy_body_stack3(child_thread, parent_thread, buf_page);

      /* d 构建子进程thread_stack和修改返回值pid */
      build_child_stack(child_thread);

      /* e 更新文件inode的打开数 */
      update_inode_open_cnts(child_thread);

      mfree_page(PF_KERNEL, buf_page, 1);
      return 0;
}
```



主系统API调用

```c
/* fork子进程,内核线程不可直接调用 */
pid_t sys_fork(void)
{
      task_struct *parent_thread = running_thread();
      task_struct *child_thread = get_kernel_pages(1); // 为子进程创建pcb(task_struct结构)
      if (child_thread == NULL)
      {
            return -1;
      }
      ASSERT(INTR_OFF == intr_get_status() && parent_thread->pgdir != NULL);

      if (copy_process(child_thread, parent_thread) == -1)
      {
            return -1;
      }

      /* 添加到就绪线程队列和所有线程队列,子进程由调试器安排运行 */
      ASSERT(!elem_find(&thread_ready_list, &child_thread->general_tag));
      list_append(&thread_ready_list, &child_thread->general_tag);
      ASSERT(!elem_find(&thread_all_list, &child_thread->all_list_tag));
      list_append(&thread_all_list, &child_thread->all_list_tag);

      return child_thread->pid; // 父进程返回子进程的pid
}
```

---

参考：

1. [十九. fork的原理及实现](https://zhuanlan.zhihu.com/p/36872365)
2. [fork进程的过程](https://www.xuebuyuan.com/2213549.html)



#### Malloc原理:biking_man:

> 内存管理模块中是通过bitmap对内存进行管理的，bitmap中的每一个bit位就代表一页大小的内存，该位为1时表示这页已经分配出去了。那么对小块内存进行分配的时候，同样需要一个结构来记录这块内存的情况，也就是说，要通过一种结构来对内存的分配与释放进行管理。

任何实际的分配器都需要一些数据结构，允许它来区别块边界，以及区别已分配块和空闲块 。大多数分配器将这些信息嵌人块本身。一个简单的结构如下：

![image-20201101225827154](../AppData/Roaming/Typora/typora-user-images/image-20201101225827154.png)



##### Linux进程堆管理

Linux维护一个break指针，这个指针指向堆空间的某个地址。从堆起始地址到break之间的地址空间为映射好的，可以供进程访问；而从break往上，是未映射的地址空间，如果访问这段空间则程序会报错。



##### brk与sbrk

要增加一个进程实际的可用堆大小，就需要将break指针向高地址移动。Linux通过brk和sbrk系统调用操作break指针。两个系统调用的原型如下：

```c
int brk(void *addr);
void *sbrk(intptr_t increment);
```

brk将break指针直接设置为某个地址，而sbrk将break从当前位置移动increment所指定的增量。brk在执行成功时返回0，否则返回-1并设置errno为ENOMEM；sbrk成功时返回break移动之前所指向的地址，否则返回(void *)-1。

一个小技巧是，如果将increment设置为0，则可以获得当前break的地址。

##### 简单实现malloc

```c
/* 一个玩具malloc */
#include <sys/types.h>
#include <unistd.h>
void *malloc(size_t size)
{
    void *p;
    p = sbrk(0);
    if (sbrk(size) == (void *)-1)
        return NULL;
    return p;
}
```

这个malloc每次都在当前break的基础上增加size所指定的字节数，并将之前break的地址返回。这个malloc由于对所分配的内存缺乏记录，不便于内存释放，所以无法用于真实场景。



##### 正式实现malloc

**数据结构**

一个简单可行方案是将堆内存空间以块（Block）的形式组织起来，每个块由meta区和数据区组成，meta区记录数据块的元信息（数据区大小、空闲标志位、指针等等），数据区是真实分配的内存区域，并且数据区的第一个字节地址即为malloc返回的地址。

```c
typedef struct s_block *t_block;
struct s_block
{
    size_t size;  /* 数据区大小 8字节*/
    t_block next; /* 指向下个块的指针 8字节*/
    int free;     /* 是否是空闲块 4字节*/
    int padding;  /* 填充4字节，保证meta块长度为8的倍数 4字节*/
    char data[1]  /* 这是一个虚拟字段，表示数据块的第一个字节，长度不应计入meta */
}; // 总共32字节
```

由于我们只考虑64位机器，为了方便，我们在结构体最后填充一个int，使得结构体本身的长度为8的倍数，以便内存对齐。示意图如下：

![Block结构](https://i.loli.net/2020/10/30/EJpAVGhvB5xX7Yw.png)

**寻找合适的block**

　现在考虑如何在block链中查找合适的block。一般来说有两种查找算法：

- **First fit**：从头开始，使用第一个数据区大小大于要求size的块所谓此次分配的块
- **Best fit**：从头开始，遍历所有块，使用数据区大小大于size且差值最小的块作为此次分配的块

　　两种方法各有千秋，best fit具有较高的内存使用率（payload较高），而first fit具有更好的运行效率。这里我们采用first fit算法。

```C
/* First fit */
t_block find_block(t_block *last, size_t size) {
    t_block b = first_block;
    while(b && !(b->free && b->size >= size)) {
        *last = b;
        b = b->next;
    }
    return b;
}
```

find_block从frist_block开始，查找第一个符合要求的block并返回block起始地址，如果找不到这返回NULL。这里在遍历时会更新一个叫last的指针，这个指针始终指向当前遍历的block。这是为了如果找不到合适的block而开辟新block使用的。

**开辟新的block**

如果现有block都不能满足size的要求，则需要在链表最后开辟一个新的block。这里关键是如何只使用sbrk创建一个struct：

```c
#define BLOCK_SIZE 24 /* 由于存在虚拟的data字段，sizeof不能正确计算meta长度，这里手工设置 */
 
t_block extend_heap(t_block last, size_t s) {
    t_block b;
    b = sbrk(0);
    if(sbrk(BLOCK_SIZE + s) == (void *)-1)
        return NULL;
    b->size = s;
    b->next = NULL;
    if(last)
        last->next = b;
    b->free = 0;
    return b;
}
```

**分裂block**

First fit有一个比较致命的缺点，就是可能会让很小的size占据很大的一块block，此时，为了提高payload，应该在剩余数据区足够大的情况下，将其分裂为一个新的block，示意如下：

![分裂block](https://i.loli.net/2020/10/30/wmhYx15ESOszQUD.png)

实现代码：

```c
void split_block(t_block b, size_t s) {
    t_block new;
    new = b->data + s;
    new->size = b->size - s - BLOCK_SIZE ;
    new->next = b->next;
    new->free = 1;
    b->size = s;
    b->next = new;
}
```



**malloc实现**

注意首先我们要定义个block链表的头first_block，初始化为NULL；另外，我们需要剩余空间至少有BLOCK_SIZE + 8才执行分裂操作。

由于我们希望malloc分配的数据区是按8字节对齐，所以在size不为8的倍数时，我们需要将size调整为大于size的最小的8的倍数：

```c
size_t align8(size_t s) {
    if(s & 0x7 == 0)
        return s;
    return ((s >> 3) + 1) << 3;
}
```

malloc代码：

```c
#define BLOCK_SIZE 24
void *first_block=NULL;
 
/* other functions... */
 
void *malloc(size_t size) {
    t_block b, last;
    size_t s;
    /* 对齐地址 */
    s = align8(size);
    if(first_block) {
        /* 查找合适的block */
        last = first_block;
        b = find_block(&last, s);
        if(b) {
            /* 如果可以，则分裂 */
            if ((b->size - s) >= ( BLOCK_SIZE + 8))
                split_block(b, s);
            b->free = 0;
        } else {
            /* 没有合适的block，开辟一个新的 */
            b = extend_heap(last, s);
            if(!b)
                return NULL;
        }
    } else {
        b = extend_heap(NULL, s);
        if(!b)
            return NULL;
        first_block = b;
    }
    return b->data;
}
```



##### calloc的实现

有了malloc，实现calloc只要两步：

1. malloc一段内存
2. 将数据区内容置为0

由于我们的数据区是按8字节对齐的，所以为了提高效率，我们可以每8字节一组置0，而不是一个一个字节设置。我们可以通过新建一个size_t指针，将内存区域强制看做size_t类型来实现。

```c
void *calloc(size_t number, size_t size) {
    size_t *new;
    size_t s8, i;
    new = malloc(number * size);
    if(new) {
        s8 = align8(number * size) >> 3;
        for(i = 0; i < s8; i++)
            new[i] = 0;
    }
    return new;
}
```



#####  free的实现

free的实现并不像看上去那么简单，这里我们要解决两个关键问题：

1. 如何验证所传入的地址是有效地址，即确实是通过malloc方式分配的数据区首地址
2. 如何解决碎片问题

首先我们要保证传入free的地址是有效的，这个有效包括两方面：

- 地址应该在之前malloc所分配的区域内，即在first_block和当前break指针范围内
- 这个地址确实是之前通过我们自己的malloc分配的

第一个问题比较好解决，只要进行地址比较就可以了，关键是第二个问题。这里有两种解决方案：一是在结构体内埋一个magic number字段，free之前通过相对偏移检查特定位置的值是否为我们设置的magic number，另一种方法是在结构体内增加一个magic pointer，这个指针指向数据区的第一个字节（也就是在合法时free时传入的地址），我们在free前检查magic pointer是否指向参数所指地址。这里我们采用第二种方案：

首先我们在结构体中增加magic pointer（同时要修改BLOCK_SIZE）：

```c
typedef struct s_block *t_block;
struct s_block {
    size_t size;  /* 数据区大小 */
    t_block next; /* 指向下个块的指针 */
    int free;     /* 是否是空闲块 */
    int padding;  /* 填充4字节，保证meta块长度为8的倍数 */
    void *ptr;    /* Magic pointer，指向data */
    char data[1]  /* 这是一个虚拟字段，表示数据块的第一个字节，长度不应计入meta */
};
```

然后我们定义检查地址合法性的函数：

```c
t_block get_block(void *p) {
    char *tmp;  
    tmp = p;
    return (p = tmp -= BLOCK_SIZE);
}
 
int valid_addr(void *p) {
    if(first_block) {
        if(p > first_block && p < sbrk(0)) {
            return p == (get_block(p))->ptr;
        }
    }
    return 0;
}
```

当多次malloc和free后，整个内存池可能会产生很多碎片block，这些block很小，经常无法使用，甚至出现许多碎片连在一起，虽然总体能满足某此malloc要求，但是由于分割成了多个小block而无法fit，这就是碎片问题。

一个简单的解决方式时当free某个block时，如果发现它相邻的block也是free的，则将block和相邻block合并。为了满足这个实现，需要将s_block改为双向链表。修改后的block结构如下：

```c
typedef struct s_block *t_block;
struct s_block {
    size_t size;  /* 数据区大小 */
    t_block prev; /* 指向上个块的指针 */
    t_block next; /* 指向下个块的指针 */
    int free;     /* 是否是空闲块 */
    int padding;  /* 填充4字节，保证meta块长度为8的倍数 */
    void *ptr;    /* Magic pointer，指向data */
    char data[1]  /* 这是一个虚拟字段，表示数据块的第一个字节，长度不应计入meta */
};
```

合并方法如下：

```c
t_block fusion(t_block b) {
    if (b->next && b->next->free) {
        b->size += BLOCK_SIZE + b->next->size;
        b->next = b->next->next;
        if(b->next)
            b->next->prev = b;
    }
    return b;
}
```

有了上述方法，free的实现思路就比较清晰了：首先检查参数地址的合法性，如果不合法则不做任何事；否则，将此block的free标为1，并且在可以的情况下与后面的block进行合并。如果当前是最后一个block，则回退break指针释放进程内存，如果当前block是最后一个block，则回退break指针并设置first_block为NULL。实现如下：

```c
void free(void *p) {
    t_block b;
    if(valid_addr(p)) {
        b = get_block(p);
        b->free = 1;
        if(b->prev && b->prev->free)
            b = fusion(b->prev);
        if(b->next)
            fusion(b);
        else {
            if(b->prev)
                b->prev->prev = NULL;
            else
                first_block = NULL;
            brk(b);
        }
    }
}
```



#####  realloc的实现

为了实现realloc，我们首先要实现一个内存复制方法。如同calloc一样，为了效率，我们以8字节为单位进行复制：

```c
void copy_block(t_block src, t_block dst) {
    size_t *sdata, *ddata;
    size_t i;
    sdata = src->ptr;
    ddata = dst->ptr;
    for(i = 0; (i * 8) < src->size && (i * 8) < dst->size; i++)
        ddata[i] = sdata[i];
}
```

然后我们开始实现realloc。一个简单（但是低效）的方法是malloc一段内存，然后将数据复制过去。但是我们可以做的更高效，具体可以考虑以下几个方面：

- 如果当前block的数据区大于等于realloc所要求的size，则不做任何操作
- 如果新的size变小了，考虑split
- 如果当前block的数据区不能满足size，但是其后继block是free的，并且合并后可以满足，则考虑做合并

下面是realloc的实现：

```c
void *realloc(void *p, size_t size) {
    size_t s;
    t_block b, new;
    void *newp;
    if (!p)
        /* 根据标准库文档，当p传入NULL时，相当于调用malloc */
        return malloc(size);
    if(valid_addr(p)) {
        s = align8(size);
        b = get_block(p);
        if(b->size >= s) {
            if(b->size - s >= (BLOCK_SIZE + 8))
                split_block(b,s);
        } else {
            /* 看是否可进行合并 */
            if(b->next && b->next->free
                    && (b->size + BLOCK_SIZE + b->next->size) >= s) {
                fusion(b);
                if(b->size - s >= (BLOCK_SIZE + 8))
                    split_block(b, s);
            } else {
                /* 新malloc */
                newp = malloc (s);
                if (!newp)
                    return NULL;
                new = get_block(newp);
                copy_block(b, new);
                free(p);
                return(newp);
            }
        }
        return (p);
    }
    return NULL;
}
```

##### 遗留问题和优化

以上是一个较为简陋，但是初步可用的malloc实现。还有很多遗留的可能优化点，例如：

- 同时兼容32位和64位系统
- 在分配较大快内存时，考虑使用mmap而非sbrk，这通常更高效
- 可以考虑维护多个链表而非单个，每个链表中的block大小均为一个范围内，例如8字节链表、16字节链表、24-32字节链表等等。此时可以根据size到对应链表中做分配，可以有效减少碎片，并提高查询block的速度
- 可以考虑链表中只存放free的block，而不存放已分配的block，可以减少查找block的次数，提高效率



参考：

1. [十四. malloc&free的实现](https://zhuanlan.zhihu.com/p/36550234)
2. [如何实现一个malloc](https://blog.codinglabs.org/articles/a-malloc-tutorial.html)
3. [brk(）和sbrk()函数的使用](https://blog.csdn.net/yusiguyuan/article/details/39496305)





#### mmap()

创建进程时，建立虚存空间和具体文件之间的映射。但是需要注意的是建立映射的过程中完成很多复杂的需求，比如用函数指针来绑定一些对页面的操作。这两个系统调用的实现过程其实并不简单，非常值得研究，具体还是参看书籍。



**结论**

1）当开辟的空间小于 128K 时，调用 brk（）函数，malloc 的底层实现是系统调用函数 brk（），其主要移动指针 _enddata(此时的 _enddata 指的是 Linux 地址空间中堆段的末尾地址，不是数据段的末尾地址)

2）当开辟的空间大于 128K 时，mmap（）系统调用函数来在虚拟地址空间中（堆和栈中间，称为“文件映射区域”的地方）找一块空间来开辟。

---

参考：[malloc 底层实现及原理](https://www.cnblogs.com/zpcoding/p/10808969.html)



#### 内存管理的本质

对于社会来讲，“管理”是人类发展到一定阶段才产生的。拿时下最疯狂的一件事“买房”来举例，当我抵上未来20年的青春买到一套房子后，并不是将房子从地上挖起来送到我面前，而只是在合法部门将房子的所属权跟我的**号关联起来，我就有权住进这个房子了。腿长在我自己身上，按道理我想进谁的房子就进谁的房子呀，但除非是在原始社会，在有了“管理”的当今社会，乱跑就会被抓起来！原始社会只生活着一个或少量猿猴（需<<求），随便找个洞穴就是房子，一文不值，猿猴不会因为房子而发生冲突，所以才不需要管理。



对计算机来讲，从加电到启动完成，也经历了“原始社会”到“当今社会”的过程，即“实模式→保护模式”，实模式时只有一个进程，一个巴掌拍不响，所以不担心干扰，只管为进入保护模式作好准备，并切换到保护模式。一旦进入保护模式，实际上就是启动一些防止相互干扰的“管理”，其中内存管理就是其中之一，从而多个进程才能和谐共处。



内核要保证各个进程对物理内存（系统范围唯一）的使用不发生干扰，也要保证每个进程中不同的程序片段对虚拟内存（进程范围唯一）的使用不发生干扰：
  ① 每个进程有自己独立的映射关系表，内核的视野能看见系统所有进程，自然也能保证各个进程对物理页面的使用不冲突。
  ② 程序中的全局变量、static变量、函数名等，由编译器安排不冲突的虚拟地址，动态分配/释放时，对虚拟页面的使用都建立记录信息，所以也不会发生冲突。



所以内存管理的本质就是为防止干扰、效率、换入换出等建立记录信息，并利用这些信息达到相应的目的。
  以下就是分配内存时，建立管理信息的大致示意图：

![img](https://i.loli.net/2020/10/16/IrLsGm5u2Pgqdih.png)



- brk()

  从上图也可以看出Linux对虚拟空间的使用安排，brk()就是操作动态分配区间的虚拟地址（分配/释放）。glibc库中的malloc()函数，就是用brk()系统调用分配/释放虚拟页面。
  注意：
  *char \*p = malloc(); // 不能free(p+1)*
  *brk()得到的一个虚拟地址区间（图中灰色区域，用vm_area_struct结构表示），可以释放当中一部分，而裂为两个区域*



#### Linux缓冲区:water_buffalo:

linux中有两个级别的缓冲：IO缓冲与内核缓冲

（1）IO缓冲:对于标准IO操作，都会有一个缓冲区，当用户想要写数据时，首先将数据写入缓冲区，待缓冲区满之后才能调用系统函数写入内核缓冲区。当用户想读取数据时，首先向内核读取一定的数据放入IO缓冲区，读操作从缓冲区中读数据，当读完IO缓冲区的数据时，才能再读取数据到IO缓冲区。

目的：减少对磁盘的读写次数，提高工作效率。

（2）内核缓冲区:操作系统内核部分也有缓冲，其与IO缓冲区是不同的，其主要区别用一张图表示：



<img src="https://i.loli.net/2020/10/26/74NzDaZK6rIxlpM.png" alt="Linux下的文件I/O编程Linux下的文件I/O编程" style="zoom: 67%;" />



* 操作系统（内核）先从磁盘读取数据到内核空间的内存（read①），再把数据从内核空间内存拷贝到用户空间内存（read②）。此后，用户应用程序才可以操作此数据。





**那么内核缓冲做了什么事情呢？**

1. 读：数据预读
2. 写：延时回写







---

参考链接：

1. https://github.com/raxxarr/note/issues/2



#### 什么是RPC

RPC是指远程过程调用，也就是说两台服务器A，B，一个应用部署在A服务器上，想要调用B服务器上应用提供的函数/方法，由于不在一个内存空间，不能直接调用，需要通过网络来表达调用的语义和传达调用的数据。



参考：

1. [什么是RPC? 为什么要用RPC？](https://www.jianshu.com/p/eb66b0c4113d)
2. [什么是RPC？](https://www.jianshu.com/p/7d6853140e13)



#### 线程同步的方式有哪些？

- **互斥量**：采用互斥对象机制，只有拥有互斥对象的线程才有访问公共资源的权限。因为互斥对象只有一个，所以可以保证公共资源不会被多个线程同时访问。
- **信号量**：它允许同一时刻多个线程访问同一资源，但是需要控制同一时刻访问此资源的最大线程数量。
- **事件（信号）**：通过通知操作的方式来保持多线程同步，还可以方便的实现多线程优先级的比较操作。



#### 中断和轮询的特点?

对I/O设备的程序轮询的方式，是早期的计算机系统对I/O设备的一种管理方式。它定时对各种设备轮流询问一遍有无处理要求。轮流询问之后，有要求的，则加以处理。在处理I/O设备的要求之后，处理机返回继续工作。尽管轮询需要时间，但轮询要比I/O设备的速度要快得多，所以一般不会发生不能及时处理的问题。当然，再快的处理机，能处理的输入输出设备的数量也是有一定限度的。而且，程序轮询毕竟占据了CPU相当一部分处理时间，因此，程序**轮询**是一种**效率较低**的方式，在现代计算机系统中已很少应用。

　　程序中断通常简称**中断**，是指CPU在正常运行程序的过程中，由于预先安排或发生了各种随机的内部或外部事件，使CPU中断正在运行的程序，而转到为响应的服务程序去处理。

　　轮询——效率低，等待时间很长，CPU利用率不高。

　　中断——容易遗漏一些问题，CPU利用率高





#### 输入与输出

设备

* 块设备

  块设备存储在固定大小的块中，每个块有自己的地址。块设备的基本特征是每个块都能独立于其他块而读写。硬盘、CD-ROM 和 USB 盘是最常见的块设备。

* 字符设备

  字符设备以字符为单位发送或接收一个字符流，而不考虑任何块结构。字符设备是不可寻址的，也没有任何寻道操作。打印机、网络接口、鼠标，以及大多数与磁盘不同的设备都可看作是字符设备。

  

IO控制方式

1. **程序直接控制方式**。计算机从外部设备读取数据到存储器，每次读一个字的数据。对读入的每个字，CPU 需要对外设状态进行循环检查知道确定该字已经在 I/O 控制器的数据寄存器中。

2. **中断驱动方式**。允许 I/O 设备主动打断 CPU 的运行并请求服务，从而“解放” CPU，使得其向 I/O 控制器发送读命令后可以继续做其他有用的工作。

3. **DMA 方式**。DMA(直接存储器)方式的基本思想是在 I/O 设备和内存之间开辟直接的数据交换通路，彻底“解放” CPU。DMA特点如下：（1）基本单位是数据块 （2）所传送的数据，是从设备直接送入内存的，或者相反 （3）仅在传送一个或多个数据块的开始和结束时，才需 CPU 干预，整块数据的传送是在 DMA 控制器的控制下完成的。

   为了在主机与控制器之间实现成块数据的直接交换，必须在 DMA 控制器中设置如下4类寄存器：

   - 命令/状态寄存器（CR）。用于接收从 CPU 发来的 I/O 命令或有关控制信息，或设备的状态。
   - 内存地址寄存器（MAR）。在输入时，它存放把数据从设备传送到内存的起始目标地址；在输出时，它存放由内存到设备的内存源地址。
   - 数据寄存器（DR）。用于暂存从设备到内存或从内存到设备的数据。
   - 数据计数器（DC）。存放本次要传送的字（节）数。

4. **通道控制方式**。I/O 通道是指专门负责输入/输出的处理机。I/O 通道是 DMA 方式的发展,它可以进一步减少 CPU 的干预，即把对一个数据块的读（或写）为单位的干预，减少为对一组数据块的读（或写）及有关控制和管理为单位的干预。I/O 通道与一般处理机的区别是：通道指令的类型单一没有自己的内存，通道所执行的通道程序是放在主机内存中的，也就是说通道与 CPU 共享内存。I/O 通道与 DMA 方式的区别是：DMA 方式需要 CPU 来控制传输的数据块大小、传输的内存位置，而通道方式中这些信息是由通道控制的。另外，**每个 DMA 控制器对应一台设备与内存传递数据，而一个通道可以控制多台设备与内存的数据交换**。



IO系统层次结构

![img](https://i.loli.net/2020/11/02/VybrTDuUgj1GLco.png)



各层次及其功能如下：

1. 用户层 I/O 软件。实现与用户交互的接口，用户可直接调用在用户层提供的、与 I/O 操作有关的库函数，对设备进行操作。
2. 设备独立性软件。用于实现用户程序与设备驱动器的统一接口、设备命令、设备保护及设备分配与释放等，同时为设备管理和数据传送提供必要的存储空间。
3. 设备驱动程序。与硬件直接相关，负责具体实现系统对设备发出的操作指令，驱动 I/O 设备工作的驱动程序。
4. 中断处理程序。用于保护被中断进程的 CPU 环境，转入相应的中断处理程序进行处理，处理完并恢复被中断进程的现场后，返回到被中断程序。
5. 硬件设备。I/O 设备通常包括一个机械部件和一个电子部件。为了达到设计的模块性和通用性，一般将其分开：电子部件称为设备控制器（或适配器），在个人计算机中，通常是一块插入主板扩充槽的印制电路板；机械部件则是设备本身。





---

参考:

1. https://github.com/jx453331958/blog/issues/17
2. [【操作系统】 输入/输出（I/O）管理](https://my.oschina.net/u/4390999/blog/3418939)























