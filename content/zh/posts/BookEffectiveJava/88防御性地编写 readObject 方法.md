---
title: 88防御性地编写 readObject 方法
date: 2021-11-21T13:24:22+08:00
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



类似在构造函数和getter函数制作防御性副本，在反序列化函数readObject（其实也是另外一个构造函数）也最好在适当的地方制作防御性副本。



在readObject可以对一些字段进行校验，校验错误自动抛出错误，这样就不会导致更严重的错误。例如，在该函数中对比起始时间和终止时间，显然，起始时间是要早于终止时间的，所以我们进行判断：

```java
// readObject method with validity checking - insufficient!
private void readObject(ObjectInputStream s) throws IOException, ClassNotFoundException {
    s.defaultReadObject();
    // Check that our invariants are satisfied
    if (start.compareTo(end) > 0)
        throw new InvalidObjectException(start +" after "+ end);
}
```

虽然这可以防止攻击者创建无效的 Period 实例，但还有一个更微妙的问题仍然潜伏着。可以通过字节流来创建一个可变的 Period 实例，该字节流以一个有效的 Period 实例开始，然后向 Period 实例内部的私有日期字段追加额外的引用。攻击者从 ObjectInputStream 中读取 Period 实例，然后读取附加到流中的「恶意对象引用」。

> 这些引用使攻击者能够访问 Period 对象中的私有日期字段引用的对象。通过修改这些日期实例，攻击者可以修改 Period 实例

```java
public class MutablePeriod {
    // A period instance
    public final Period period;

    // period's start field, to which we shouldn't have access
    public final Date start;

    // period's end field, to which we shouldn't have access
    public final Date end;

    public MutablePeriod() {
        try {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            ObjectOutputStream out = new ObjectOutputStream(bos);

            // Serialize a valid Period instance
            out.writeObject(new Period(new Date(), new Date()));

            /*
            * Append rogue "previous object refs" for internal
            * Date fields in Period. For details, see "Java
            * Object Serialization Specification," Section 6.4.
            */
            byte[] ref = { 0x71, 0, 0x7e, 0, 5 }; // Ref #5
            bos.write(ref); // The start field
            ref[4] = 4; // Ref # 4
            bos.write(ref); // The end field

            // Deserialize Period and "stolen" Date references
            ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bos.toByteArray()));
            period = (Period) in.readObject();
            start = (Date) in.readObject();
            end = (Date) in.readObject();
        } catch (IOException | ClassNotFoundException e) {
            throw new AssertionError(e);
        }
    }
}
```

攻击程序如下：

```java
public static void main(String[] args) {
    MutablePeriod mp = new MutablePeriod();	// 使用正确的数值进行反序列化
    Period p = mp.period; // 拿出引用
    Date pEnd = mp.end;	// 拿出引用

    // Let's turn back the clock
    pEnd.setYear(78); // boom！对引用进行修改
    System.out.println(p); // boom！对引用进行修改

    // Bring back the 60s!
    pEnd.setYear(69);
    System.out.println(p);
}
```



问题的根源在于 Period 的 readObject 方法没有进行足够的防御性复制。**当对象被反序列化时，对任何客户端不能拥有的对象引用的字段进行防御性地复制至关重要。** 因此，对于每个可序列化的不可变类，如果它包含了私有的可变组件，那么在它的 readObjec 方法中，必须要对这些组件进行防御性地复制。下面的 readObject 方法足以保证周期的不变性，并保持其不变性：

```java
// readObject method with defensive copying and validity checking
private void readObject(ObjectInputStream s) throws IOException, ClassNotFoundException {
    s.defaultReadObject();
    // 在校验之前进行防御性复制
    start = new Date(start.getTime());
    end = new Date(end.getTime());
    // Check that our invariants are satisfied
    if (start.compareTo(end) > 0)
        throw new InvalidObjectException(start +" after "+ end);
}
```

> 或者使用序列化代理模式，强烈推荐这种模式。



readObject 方法和构造函数之间还有一个相似之处，适用于非 final 序列化类。与构造函数一样，readObject 方法不能直接或间接调用可覆盖的方法。如果违反了这条规则，并且涉及的方法被覆盖，则覆盖方法将在子类的状态反序列化之前运行。很可能导致程序失败。

编写 readObject 方法的指导原则：

1. 对象引用字段必须保持私有的的类，应防御性地复制该字段中的每个对象。不可变类的可变组件属于这一类。
2. 检查任何不变量，如果检查失败，则抛出 InvalidObjectException。检查动作应该跟在任何防御性复制之后。
3. 如果必须在反序列化后验证整个对象图，那么使用 ObjectInputValidation 接口。
4. 不要直接或间接地调用类中任何可被覆盖的方法。



---

***Reference***:

