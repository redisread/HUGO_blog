---
title: thrift-annotation-BP
date: 2022-01-14T16:19:48+08:00
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

# Thrift 原理

> 围绕如何准确的识别类型和尽可能的压缩空间。

CSV、TXT、JSON、XML格式能够快速的识别类型吗？然后可以使得序列化后的空间足够小吗？之后能够保证向后兼容吗？

> 这些针对结构化数据进行编码主要想解决的问题是提升开发人员的效率，所以重视的是数据的“人类可读性”。



## Thrift的做法

- 定义一个文件（也就是IDL文件），里面存储了结构体内部的字段的顺序、类型以及名称，还有方法的定义等。

- 写一个解析文件的程序，然后自动根据文件将结构体进行序列化和反序列化。（只要按照IDL 里面出现的字段顺序，一个个对着字节数组去读或者写数据就好了）

  例如下面的IDL文件：

  ```java
  struct Student {
    1 : i64 id;
    2 : string name;
    3 : i32 socre;
  }
  ```

在我们的Java中，IDL文件生成的类文件中就包括了Scheme定义和解析的程序定义和实现。

## Thrift具体的实现

1. **如何准确识别类型和值？**

序列化和反序列化的格式：

![序列化格式](https://cos.jiahongw.com/uPic/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBASmlhaG9uZ1d1,size_20,color_FFFFFF,t_70,g_se,x_16.png)

> Thrift对于参数进行序列化的方式类似于一种递归顺序的序列化方式，每次序列话一个字段的时候，都首先读取1B的数据判断类型，然后读取2B的数据拿到字段的顺序id，此时根据这个id拿到这个字段的具体类型，判断和前面的到的类型是否一样，如果不一样，则跳过，否则继续进行下一步。

> Enum在Thrift中就是一个整型数字，而exception的解析和struct的解析是一样的。

2. **如何向前和向后兼容？**

假如此时去掉name这个字段，并且添加studentName和classId这两个字段，如何做到向前和向后兼容呢？

```java
struct Student {
  1 : i64 id;
  // 2 : string name;
  3 : i32 socre;
  4	: string studentName;
  5 : i64 classId;
}
```

因为thrift进行序列化是按照type和id进行写入的，当注释掉不要的字段之后，就不会再写入这个字段的数据了，不会占用额外的空间，所以可以向前兼容；

当增加字段时候，也因为序列化是咋好type和id进行写入的，对于之前的字段写入逻辑，没有任何影响，新增加的字段只要顺序id和之前不一样，然后按照type和id在后面增加写入即可，新结构照样可以做到向后兼容。

> 这样，在读取数据的时候，老版本的 v1 代码，看到自己没有见过的编号就可以跳过。新版本的 v2 代码，对于老数据里没有的字段，也就是读不到值而已，并不会出现不兼容的情况。

**在这个机制下，我们顺序排列的编号，就起到了版本的作用，而我们不需要再专门去进行数据版本的管理了。**

3. **如何减少传输数据的大小？**

通过编号和类型的确让我们有了向前向后兼容性，但是似乎又让我们的数据冗余变大了。

进一步优化的TCompactProtocol是怎么做的？

- **Delta Encoding**

  **顾名思义，TCompactProtocol 就是一种“紧凑”的编码方式**。Thrift 的 IDL 都是从 1 开始编号的，而且通常两个字段的编号是连续的。所以这个协议在存储编号的时候，存储的不是编号的值，而是存储编号和上一个编号的差。

  用4bit存储与上一个顺序编号的差值，然后使用4bit表示字段的类型。那么通常来说，通过一个字节，我们就能把编号和类型表示出来。

- **ZigZag+VQL**

  如果两个序号的差如果超过 15 怎么办呢？

  那么，我们就通过 1 个字节来表示类型，然后再用 1~5 个字节来表示两个连续编号之间的差。

  ![image-20220208175029609](https://cos.jiahongw.com/uPic/image-20220208175029609.png)

  这个编码方式的每一个字节的高位，都会用第一个 bit 用来标记，也就是第一个 bit 用来标记整个整数是否还需要读入下一个字节，而后面的 7 个 bit 用来表示实际存放的数据。这样，一个 32 位的整型数，最少只要用一个字节来表示，最多也只需要用 5 个字节来表示，因为 7bit x 5=35 bit 已经足够有 32 位了。

  ![image-20220208175043611](https://cos.jiahongw.com/uPic/image-20220208175043611.png)



简单来说，就是负数变成正数，而正数去乘以 2。这样的情况下，7 个 bit 就可以表示 -64 到 63 这 128 个数了。

> 偶数解码直接除以2，奇数解码直接加1除以2再变成负数。

![image-20220208175525685](https://cos.jiahongw.com/uPic/image-20220208175525685.png)

通过 ZigZag+VQL 这两种方式，你可以看到，存储一个整数，常常只需要 2 个字节就够了，可以说大大缩小了需要占用的硬盘空间。





# Thrift开发建议

- **不要修改已存在的fieldId或者已经存在的接口**

因为thrift序列化是通过id+type去对应字段的，所以如果更改了已有的id或已有字段的type，都会破坏thrift本身的向后兼容性，从而导致出错。

从另一个角度也可以得知thrift并不关注字段名称，如果后期想要修改某个字段的名称，完全不需要担心（如把ownerId改为poiId）。

- **每个Field(对就java 对象的属性)的fieldId是唯一的，且可以乱序可以不连续**

在反序列化时，是通过switch（id）的方式去对应字段的而不是for循环对应顺序，所以中间的id不连续并不会影响反序列化（当然还是推荐让id连续）。

- **非required域可以删除，前提是它的整数编号不会被其他域使用**

在删除时即代表服务端已经不再使用这个字段，那么无论调用端序列化时是否带了这个序号所对应的字段，服务端反序列化不取即可，但注意这个序号一定不能复用，否则就会涉及到老版本的调用端传了该序列号对应的字段，而新版本的服务端则根据该序列号会将其对应成另一个字段，从而导致错误。

- **不允许新增或随便删除requird字段**

在序列化和反序列化时，都会对required修饰的字段进行校验（基本类型加required修饰无作用）。如果加了required字段，因为所有使用老版本的客户端都没有传该字段，那么在反序列化校验时一定会出错。如果去掉了required字段，理解为该字段不再是必须，而依旧引了老包的客户端如果不再传输该字段的话，序列时校验则会出错，故不推荐加减required修饰的字段。

## 兼容性问题

基本规则：

- thrift传输的是字段ID，不会传输字段名；因此修改字段名不会影响兼容性，但不能修改字段ID。这里包含结构里的字段，异常的字段，服务方法声明里参数和异常的字段
- 服务名不会传输，但方法名会传输；因此可以修改服务名，但不能修改方法名，但不建议修改。
- 包名不会传输。

以下情况是兼容的：

- 新增加optional字段
- 不改字段ID的情况下修改字段名
- 新增加方法
- 给方法增加可选参数、调整参数顺序
- 修改包名
- 修改服务名，不建议这么做

以下情况是不兼容的：

- 新增加required字段
- 删除required字段
- 修改字段ID，即使不改字段名
- 修改方法名称
- 删除方法参数、修改参数id
- 删除方法

不能判定的：

- 删除optional字段，这个要看业务的依赖程度，理论上标识为optional的字段应该是可选的，但实际中并不一定如此。



# Thrift注解开发

IDL和注解的区别：IDL方式需要先按照Thrift官方的语法规范编写Thrift文件，再使用Thrift文件生成Java类文件。而注解方法可以直接定义Java类对象，然后加上相应的注解就能够使用。

![注解和IDL的区别](https://cos.jiahongw.com/uPic/image-20220114165821119.png)

整体来看，Thrift注解相对于IDL来说在使用上会更简便一点。



## MTthrift的优化和解决

### 1 配置繁琐问题

- 如果我们想要在HelloService类中新增一个方法，如果漏添加@ThriftMethod注解，此时在编译阶段不会出现任何异常，但是在运行阶段会抛出NPE异常；
- 如果我们需要对HelloModel对象新增字段，此时在getter或者setter方法上漏填加@ThriftField注解，会导致序列化或者反序列化的时候获取不到实际的值；

如何解决？

1. 增加@ThriftMethod的定义主要是为了明确区分出实际要执行RPC调用的方式，为了省略这个定义，我们需要额外排除基类Object和代理类Proxy的方式，同时**保证当前类的父类和接口内部包含的所有方法都能在判断范围内**，避免遗漏；这个时候就可以省略对@ThriftMethod和@ThriftStruct的注解配置。**两个注解只要配置了一个就没问题**。

2. 允许在字段上面添加@ThriftField注解注解，而不需要强制添加在字段的Getter/Setter方法上；实现的方式是：原先的实现@ThriftField必须添加在参数的getter方法和setter方法上，否则会抛出IllegalStateException，我们取消掉参数对private修饰符的判断限制来避免抛出异常。

   这样**业务不需要一定要在getter和setter方法上添加@ThriftField注解，可以直接添加在字段的声明位置。**结构对象也可以可以不用添加@ThriftStruct注解；

   > 通常不建议业务显示声明构造方法，如果要声明的话，切记只允许给一个构造方法添加@ThriftConstructor注解；



### 2 集合泛型之兼容性问题

- Response<TestResponse>和Response<TestResponse2>这种泛型定义映射到同一个。
- TestResponse自定义结构中如果同时存在字段Map<String, String>和Map<String, Integer>时，映射到相同的codec后也会存在类似的类型转换异常
- RPC 方法的参数如果是包装数据类型（Integer、Long等），同时又传null的话，服务端收到时会分配对应的基础类型的默认值



如何解决？

> 主要是同时通过对swift-codec的源码以及SDK的代码改造来规避部分集合类型参数、或者特定泛化类型场景下的问题来解决的。

1. 类似Response<TestResponse>和Response<TestResponse2>这种定义，在运行的时候会进行类型擦除，所以如果没有保留内部定义的类型信息的话，在通过Codec类进行序列化和反序列化的时候会映射到同一个Codec，此时必然会导致其中一个泛型定义在序列化或者反序列化的时候抛出ClassCastException。

   服务启动阶段动态生成codec编解码器相关的代码逻辑，当我们构造每个接口内部的方法的元信息ThriftMethodMetadata时，会通过方法的returnType对象转换为ThriftType对象；**ThriftType对象覆盖实现了equals和hashcode方法，在比较的时候只对ThriftProtocolType和javaType进行了判断，没有涉及到keyType和valueType、以及structMetadata；**

   > 如果此时参数是集合类型的话，此时虽然keyType和valueType不一致，但是在ThriftType比较的时候仍然会判断为同一个对象；
   >
   > 如果此时参数是ThriftStruct类型的话，此时虽然structMetadata不一致，但是同样在ThriftType比较的时候仍然会判断为同一个对象；（使用范型判断javaType其实是同一种类型）

   MTthrift修改了equals函数和hashCode函数，使得可以判断出不同的类型

   ```diff
   private final ThriftProtocolType protocolType;
   private final Type javaType;
   private final ThriftType keyType;
   private final ThriftType valueType;
   private final ThriftStructMetadata structMetadata;
   private final ThriftEnumMetadata<?> enumMetadata;
   private final ThriftType uncoercedType;
   
   @Override
   public boolean equals(Object o) {
     if (this == o) {
       return true;
     }
     if (o == null || getClass() != o.getClass()) {
       return false;
     }
     final ThriftType that = (ThriftType) o;
     if (javaType != null ? !javaType.equals(that.javaType) : that.javaType != null) {
       return false;
     }
     if (protocolType != that.protocolType) {
       return false;
     }
     // 新增
   + if (keyType != null ? !keyType.equals(that.keyType) : that.keyType != null) return false;
   + if (valueType != null ? !valueType.equals(that.valueType) : that.valueType != null) return false;
     return true;
   }
   
   @Override
   public int hashCode() {
     int result = protocolType != null ? protocolType.hashCode() : 0;
     result = 31 * result + (javaType != null ? javaType.hashCode() : 0);
     // 新增
   + result = 31 * result + (keyType != null ? keyType.hashCode() : 0);
   + result = 31 * result + (valueType != null ? valueType.hashCode() : 0);
     return result;
   }
   ```

   因此，我们需要需要修改ThriftType的equals和hashcode方法，保证ThriftType在比较的时候会考虑到泛型信息；同时修改codec对象的命名方式，保证不会重复；

   > com.facebook.swift.codec.metadata.ThriftType#equals

2. 通过源码分析和代码的实现，我们发现当读取到的参数值为null的话，会进行一次默认值的赋值操作；

   ```java
   int argumentPosition = 0;
   for (ThriftFieldMetadata argument : parameters) {
     // 包装数据类型 如果为null值会被赋值为对应基础类型的默认值；
     if (args[argumentPosition] == null) {
       Type argumentType = argument.getThriftType().getJavaType();
       if (argumentType instanceof Class) {
         Class<?> argumentClass = (Class<?>) argumentType;
         argumentClass = Primitives.unwrap(argumentClass);
         // 赋予默认值
         args[argumentPosition] = Defaults.defaultValue(argumentClass);
       }
     }
     argumentPosition++;
   }
   ```

### 3 注解支持范型程度

如果是Response<TestResponse>这种的定义是允许的，如果泛型自身是通配符相关，没有明确类型的话那么是不支持的；

**1、Thrift注解不支持object类型；**

**2、Thrift注解不支持List<?>等类似的通配符；**

1、可以继承；但是父类和子类的ThriftField的id不允许重复

2、在作为实际参数的时候，不允许声明的时候对象为父类，但是返回子类对象；



## 基本使用

### 1 定义接口

接口类添加`@ThriftService`注解，接口方法添加`@ThriftMethod`注解。

```java
@ThriftService
public interface RpcService {
  	@ThriftMethod
  	BaseTResponse queryInventoryData(BaseTRequest tRequest);
  
  	@ThriftMethod(value="definedName",exception = {@ThriftException(type = TestException.class, id = 1)})
  	Response<List<TestResponse>> queryInventoryDetail(DetailTRequest tRequest);
}
```

【建议】**建议两个注解都加上**。通常情况下不需要对接口添加`@ThriftService`并且同时在每个方法上面添加`@ThriftMethod`。添加两个注解中的其中一个也行的通。



### 2 定义请求结构和响应结构

在请求类或者响应类上面添加`@ThriftStruct`注解，在字段的上面添加`@ThriftField`注解并且标上序号，例如: `@ThriftField(value = 2)`，并且在字段上面添加注释的`@FieldDoc`注解。

请求例子：

```java
@TypeDoc(
    description = "queryRequest"
)
@ThriftStruct
class queryRequest {
		@FieldDoc(
        description = "仓id",
        example = "323"
    )
  	@ThriftField(1)
  	// @ThriftField(value = 1, requiredness = Requiredness.REQUIRED)
		Long poiId;
  
  	@FieldDoc(
        description = "库位类型",
        example = "101"
    )
  	@ThriftField(2)
  	// @ThriftField(value = 2, requiredness = Requiredness.OPTIONAL)
  	Integer shelfType;
  	
  	//..getter方法和setter方法
}
```

【建议】**建议`@ThriftStruct`和`@ThriftField`注解都加上**。通常两个注解不必同时存在，存在一个即可。

响应例子：

```java
@TypeDoc(
    description = "TBaseResponse"
)
@ThriftStruct
public class TBaseResponse<T> {
		@FieldDoc(
        description = "RPC请求状态信息",
        example = "code msg"
    )
  	@ThriftField(1)
		Status status;
		
		@FieldDoc(name = "data",
        description = "响应信息数据部分",
        rule = "响应信息数据的封装bean或者基本数据类型的封装类",
        example = "依赖泛型中数据结构",
        typeName = "T")
    @ThriftField(2)
    private T data;
		
		//..getter方法和setter方法
}
```

> Status定义：
>
> ```java
> @TypeDoc(
>     description = "RPC状态消息"
> )
> @ThriftStruct
> public class Status {
>   	@FieldDoc(
>         description = "返回码",
>         example = {"0"},
>         defaultValue = "0"
>     )
>   	@ThriftField(1)
>     private int code = 0;
> 
>     @FieldDoc(
>         description = "返回信息",
>         example = {"成功"},
>         defaultValue = "成功"
>     )
>   	@ThriftField(2)
>     private String msg = "success";
>   
>   	//..getter方法和setter方法
> }
> ```

【强制】**TBaseResponse禁止继承**。如果实在需要继承，子类的字段的顺序id不能和父类字段的顺序id冲突。

【建议】**直接在字段上面加`@ThriftField`注解**。如果不在字段上面添加`@ThriftField`注解，需要同时在getter和setter方法上面添加`@ThriftStruct`注解。如下：

> ```java
> @ThriftStruct
> public class CommonRequest {
> 
>     private String id;
> 
>     private String operator;
> 
>     @ThriftField(1)
>     public String getId() {
>         return id;
>     }
> 
>     @ThriftField
>     public void setId(String id) {
>         this.id = id;
>     }
> 
>     @ThriftField(2)
>     public String getOperator() {
>         return operator;
>     }
> 
>     @ThriftField
>     public void setOperator(String operator) {
>         this.operator = operator;
>     }
> }
> ```
>
> 

**通常不建议业务显示声明构造方法，如果要声明的话，切记只允许给一个构造方法添加@ThriftConstructor注解**。



3 

## 最佳实践

> 注解方式可以使用继承；但是父类和子类的ThriftField的id不允许重复。这就要求我们最好在基类中定义的id最好大一点，id大小和资源的占用没有直接的关系，因为对id的查找是通过一个switch语句进行寻找的。范型使用无关继承。
>
> 在作为实际参数的时候，不允许声明的时候对象为父类，但是返回子类对象

1. 所有的 POJO 类属性必须使用包装数据类型。
2. RPC 方法的返回值和参数必须使用包装数据类型。

因为Thrift 注解方式序列化和反序列化都是基于包装类型的，虽然对于基本类型也有适配，但为了减少风险还是建议直接使用包装类型。



require字段没有进行设置，在服务端和客户端下分别会发生什么情况？



Thrift传输数据为null导致空指针异常:

在涉及到相互依赖的系统中，传null会让问题隐藏更深，更不易查找

**实践建议：**

1. 尽量不用null；比如String，建议struct内，默认值用 "" 表示；
2. 可能出现null的字段设置为optional，不再被序列化，也不会报错；
3. 非要用 null，可以打开serializeNullStringAsBlank选项；但一般情况下不建议使用；
4. 容器中元素不能为null，需要在插入数据之前做检查；





### 1 定义基本返回类型

定义返回状态信息结构：

```java
@TypeDoc(
    description = "RPC状态消息"
)
@ThriftStruct
public class Status {

    @FieldDoc(
        description = "返回码",
        example = {"0"},
        defaultValue = "0"
    )
    @ThriftField(1)
    private int code = 0;

    @FieldDoc(
        description = "返回信息",
        example = {"成功"},
        defaultValue = "成功"
    )
    @ThriftField(2)
    private String msg = "success";

   // ...构造函数、Getter、Setter函数
}

```



定义基本返回结果范型基类：

> 这里规定了所有的返回结果的变量都为data

```java
@TypeDoc(
    description = "BaseResponse"
)
@ThriftStruct
public class TBaseResponse<T> {

    @FieldDoc(
        description = "状态信息",
        example = {"0:success"},
        defaultValue = "0:success"
    )
    @ThriftField(1)
    private Status status;

    @FieldDoc(name = "data",
        description = "响应信息数据部分",
        rule = "响应信息数据的封装bean或者基本数据类型的封装类",
        example = "依赖泛型中数据结构",
        typeName = "T")
    @ThriftField(2)
    private T data;

    public TBaseResponse() {
    }

    public TBaseResponse(int code, String msg) {
        this.status = new Status(code, msg);
    }

    public TBaseResponse(int code, String msg, T data) {
        this.status = new Status(code, msg);
        this.data = data;
    }

   /* ============ static tools ============= */

   // ...Getter、Setter函数
}

```



定义列表或者分页查询响应结构的基本类型：

```java

@TypeDoc(
    description = "TBaseList"
)
@ThriftStruct
public class TBaseList<T> {

    @FieldDoc(
        description = "总行数",
        example = {"如:10"}
    )
    @ThriftField(1)
    private long total;

    @FieldDoc(name = "list",
        description = "list部分",
        rule = "响应信息数据的封装bean或者基本数据类型的封装类",
        example = "依赖泛型中数据结构返回列表",
        typeName = "List<T>")
    @ThriftField(2)
    private List<T> list;

    public TBaseList() {

    }

    public TBaseList(List<T> list) {
        this.list = list;
        this.total = CollectionUtils.isEmpty(list)?0:list.size();
    }

    public TBaseList(long total, List<T> list) {
        this.total = total;
        this.list = list;
    }

    /* ============ static tools ============= */

    public static <T> TBaseList<T> build(long total, List<T> list) {
        return new TBaseList<>(total, list);
    }

    public static <T> TBaseList<T> build(List<T> list) {
        return new TBaseList<>(list);
    }

    public static <T> TBaseList<T> build() {
        return new TBaseList<>();
    }

   	// Getter、Setter函数
}
```



### 2 编写传输的DTO结构

```java
@TypeDoc(description = "sku信息")
@ThriftStruct
public class InventorySkuInfoDTO {

    @FieldDoc(
        description = "商品id",
        example = {}
    )
    @ThriftField(1)
    private Long skuId;

    @FieldDoc(
        description = "供应商id",
        example = {}
    )
    @ThriftField(2)
    private Long supplierId;

    @FieldDoc(
        description = "库位id",
        example = {}
    )
    @ThriftField(3)
    private Long shelfId;

    @FieldDoc(
        description = "库位编码",
        example = {}
    )
    @ThriftField(4)
    private String shelfCode;

    @FieldDoc(
        description = "批次id",
        example = {}
    )
    @ThriftField(5)
    private Long lotId;

    @FieldDoc(
        description = "批次号",
        example = {}
    )
    @ThriftField(6)
    private String lotNo;

    @FieldDoc(
        description = "可用库存",
        example = {}
    )
    @ThriftField(7)
    private String availableQuantity;

   // ...构造函数、Getter、Setter函数
}
```



### 3 定义查询的请求

后面查询的请求也可以进行规范，设置一个基本类型

```java
@TypeDoc(
    description = "sku信息查询接口请求"
)
@ThriftStruct
public class InventoryInfoQueryTRequest {

    @FieldDoc(
        description = "仓id",
        example = {}
    )
    @ThriftField(value = 1, requiredness = Requiredness.REQUIRED)
    private Long poiId;

    @FieldDoc(
        description = "商品id",
        example = {}
    )
    @ThriftField(2)
    private List<Long> skuIdList;

    @FieldDoc(
        description = "库位编码",
        example = {}
    )
    @ThriftField(3)
    private String shelfCode;

    @FieldDoc(
        description = "供应商id",
        example = {}
    )
    @ThriftField(4)
    private Long supplierId;

    @FieldDoc(
        description = "过滤的库位类型",
        example = {}
    )
    @ThriftField(5)
    private List<Integer> filterShelfTypeList;

    @FieldDoc(
        description = "过滤的库位编码",
        example = {}
    )
    @ThriftField(6)
    private List<String> filterShelfCodeList;

    @FieldDoc(
        description = "分页信息",
        example = {}
    )
    @ThriftField(value = 7, requiredness = Requiredness.REQUIRED)
    private TPaging paging;

		// Getter、Setter方法
}

```





### 4 定义接口

```java
@InterfaceDoc(
    type = InterfaceDoc.InterfaceType.THRIFT_ANNOTATION,
    displayName = "库存ES查询接口",
    description = "库存ES查询接口",
)
@ThriftService
public interface InventoryESQueryTService {

    @MethodDoc(
        displayName = "查询ES宽表的sku信息接口",
        description = "查询ES宽表的sku信息接口",
        parameters = {
            @ParamDoc(
                name = "request",
                description = "筛选条件",
                rule = "不可以为null")
        },
        returnValueDescription = "返回满足条件的sku查询结果"
    )
    @ThriftMethod
    TBaseResponse<TBaseList<InventorySkuInfoDTO>> queryEsInventorySkuInfo(
        InventoryInfoQueryTRequest tRequest);
}
```



### 5 实现接口

```java
@Service
@MdpThriftServer
public class InventoryESQueryTServiceImpl implements InventoryESQueryTService {

    private static final Logger LOGGER = LoggerFactory.getLogger(InventoryESQueryTServiceImpl.class);

    @Resource
    private InventoryQueryService inventoryQueryService;

    @Override
    public TBaseResponse<TBaseList<InventorySkuInfoDTO>> queryEsInventorySkuInfo(
        InventoryInfoQueryTRequest tRequest) {
        TBaseResponse<TBaseList<InventorySkuInfoDTO>> tResponse = new TBaseResponse<>();
        tResponse.setData(inventoryQueryService.inventoryQueryByPoiAndParam(tRequest));
        tResponse.setStatus(new Status(0,"success"));
        return tResponse;
    }
}

```

后续这一块可以加上AOP，减少重复代码的编写。添加日志打印。



## 限制和规范

1. 如果业务之前使用IDL方式定义接口，想更新为thrift注解的方式，这时服务端需要和调用端同步升级，保持一致。
2. 如果有非无参构造函数，需要在构造函数上加上@ThriftConstructor注解，一个类只能有一个带有@ThriftConstructor注解的构造函数。
3. 属性 ID 可以顺序追加，不可更改已有属性 ID & 数据类型
4. 参数支持的容器类型: List、Set、Map
5. 所有接口必须抛出 TException
6. 自定义异常必须继承自 AbstractThriftException，同时重写toString方法（AbstractThriftException的toString方法不够明确）
7. **Thrift 注解代码 和IDL生成的目标代码, 不能相互引用**
8. **所有的 POJO 类属性强烈建议使用包装数据类型，如果用基础类型的话无法使用IDL方式里的isSet来判断某个属性是否被赋值过。**
9. **RPC 方法的返回值必须使用包装数据类型**
10. **如果枚举类型中有int属性，该属性的值不能为负数**
11. 继承需要保证顺父类和子类的顺序id不能冲突
12. 不支持多态，参数、返回值等必须使用接口里声明的具体类型。e.g. public Person getPerson() 方法不能返回 Student(Person的子类)。
13. thrift不支持重载，但是可以使用@ThriftMethod 的value字段
    - 为方法提供一个别名，已变通地实现重载。 java支持overload，但是thrift不支持；当2个方法的名字相同的时候，可以将其中1个方法使用 value 字段起一个别名。
    - e.g. 如果类中有 methodA(int) 、mehtodA(String) ,thrift是不支持的。但是可以给 methodA(int) 加一个注解 @ThriftMethod(value="anotherMethodA"})，thrift内部会使用anotherMethodA(int)和mehtodA(String)。



## 枚举

Thrift 中注解开发时 enum 相关的几点建议：

1. 尽量保持调用端和服务端的 thrift 定义一致
2. 在枚举类中定义@ThriftEnumValue方法来显式声明枚举值与整数的对应关系，避免使用默认的编解码规则
3. 如果声明了带有@ThriftEnumValue的返回整数类型的无参public函数，请确保每个枚举值调用该方法的返回值都不一样（参考Object的hashcode方法）

反例：

```java
/**
 * 没有提供枚举值到整数的对应关系，在编解码时会按照声明顺序进行索引
 */
@ThriftEnum
public enum ThriftAnnotatedEnum {
    FIRST_VALUE("first"),
    SECOND_VALUE("second");

    private String description;

    ThriftAnnotatedEnum(String description) {
        this.description = description;
    }
}
```

正例：

```java
@ThriftEnum
public enum ThriftAnnotatedEnum {
    FIRST_VALUE("fist"),
    SECOND_VALUE("second");

    private String description;

    ThriftAnnotatedEnum(String description) {
        this.description = description;
    }
	
	//提供了返回int类型的无参public函数，建立从枚举值到整数的映射
    @ThriftEnumValue
    public int getIntValue() {
        return this.description.hashCode();
    }
}

// 或者
@ThriftEnum
public enum ThriftAnnotatedEnum {
    FIRST_VALUE("fist", 0),
    SECOND_VALUE("second", 1);

    private String description;
    private int intValue;//直接在枚举类定义整数类型的成员变量用于标识

    ThriftAnnotatedEnum(String description, int intValue) {
        this.description = description;
        this.intValue = intValue;
    }

    @ThriftEnumValue
    public int getIntValue() {
        return intValue;
    }
}
```

## 注解和IDL映射

service <-> @ThriftService

struct <-> @ThriftStruct

struct 属性 <-> @ThriftField

enum <-> @ThriftEnumValue

# 拓展

> Thrift 发表的时候，Protobuf 还只是在 Sawzall 论文中被提到，它要到 2008 年的 7 月才正式发布，而 gRPC 更是要到 2015 年才正式开源。

1. gRPC和Thrift的区别

2. Google 的 Protobuf 和 gRPC

3. 什么是codec：

   编写一个网络应用程序需要实现某种 codec (编解码器)，codec的作用就是将原始字节数据与目标程序数据格式进行互转。网络中都是以字节码的数据形式来传输数据的，codec 由两部分组成：decoder(解码器)和encoder(编码器)







---

***Reference***:

1. https://km.sankuai.com/page/28187066
2. https://km.sankuai.com/page/759221648
3. [SETT June 2009 - Apache Thrift](http://jnb.ociweb.com/jnb/jnbJun2009.html)
4. [11 | 通过Thrift序列化：我们要预知未来才能向后兼容吗？](https://time.geekbang.org/column/article/425863)
5. [《Thrift: Scalable Cross-Language Services Implementation》](https%3A%2F%2Fthrift.apache.org%2Fstatic%2Ffiles%2Fthrift-20070401.pd)
6. https://km.sankuai.com/page/28187076
