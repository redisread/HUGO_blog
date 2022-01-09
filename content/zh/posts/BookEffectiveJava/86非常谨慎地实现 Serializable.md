---
title: 86非常谨慎地实现 Serializable
date: 2021-11-20T23:44:23+08:00
description:
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 🪶
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





实现 Serializable 接口的代价：

1. 一旦类的实现被发布，它就会降低更改该类实现的灵活性。（一旦序列化的实现发布，你就必须遵守，很难再进行修改）

2. 可序列化会使类的演变受到限制，施加这种约束的一个简单示例涉及流的唯一标识符，通常称其为串行版本 UID。

   > 每个可序列化的类都有一个与之关联的唯一标识符。如果你没有通过声明一个名为 serialVersionUID 的静态 final long 字段来指定这个标识符，那么系统将在运行时对类应用加密散列函数（SHA-1）自动生成它。这个值受到类的名称、实现的接口及其大多数成员（包括编译器生成的合成成员）的影响。如果你更改了其中任何一项，例如，通过添加一个临时的方法，生成的序列版本 UID 就会更改。如果你未能声明序列版本 UID，兼容性将被破坏，从而在运行时导致 InvalidClassException

3. 增加了出现 bug 和安全漏洞的可能性。

   无论你接受默认行为还是无视它，反序列化都是一个「隐藏构造函数」，其他构造函数具有的所有问题它都有。由于没有与反序列化关联的显式构造函数，因此很容易忘记必须让它能够保证所有的不变量都是由构造函数建立的，并且不允许攻击者访问正在构造的对象内部。依赖于默认的反序列化机制，会让对象轻易地遭受不变性破坏和非法访问

4. 它增加了与发布类的新版本相关的测试负担。

   需要验证是否能够正确的序列化和反序列化。



继承的类不好做序列化，因为父类可能不需要序列化，但是子类需要序列化，子类需要做更多的工作进行适配。

内部类不应该实现Serializable，因为内部包含外围的对象应用，其结构不确定。但是静态内部类可以。





总而言之，认为实现 Serializable 接口很简单这个观点似是而非。除非类只在受保护的环境中使用，在这种环境中，版本永远不必互操作，服务器永远不会暴露不可信的数据，否则实现 Serializable 接口是一项严肃的事情，应该非常小心。如果类允许继承，则更加需要格外小心。

---

***Reference***:

1. [Effective-Java-3rd-edition-Chinese-English-bilingual/Chapter-12-Item-86-Implement-Serializable-with-great-caution.md at dev · clxering/Effective-Java-3rd-edition-Chinese-English-bilingual](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-12/Chapter-12-Item-86-Implement-Serializable-with-great-caution.md)
2. 
