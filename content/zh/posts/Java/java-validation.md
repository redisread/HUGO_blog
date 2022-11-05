---
title: java-validation
date: 2022-04-27T15:53:42+08:00
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





Validation校验注解的使用

| 注解                                                  |                             描述                             |
| ----------------------------------------------------- | :----------------------------------------------------------: |
| *空检查*                                              |                                                              |
| @Null                                                 |                      验证对象是否为null                      |
| @NotNull                                              |        验证对象是否不为null, 无法查检长度为0的字符串         |
| @NotBlank                                             | 检查约束字符串是不是Null还有被trim的长度是否大于0,只对字符串,且会去掉前后空格 |
| @NotEmpty                                             |              检查约束元素是否为NULL或者是EMPTY               |
| *Booelan检查*                                         |                                                              |
| @AssertTrue                                           |                 验证 Boolean 对象是否为 true                 |
| @AssertFalse                                          |                验证 Boolean 对象是否为 false                 |
| *长度检查*                                            |                                                              |
| @Size(min=, max=)                                     | 验证对象（Array,Collection,Map,String）长度是否在给定的范围之内 |
| @Length(min=, max=)                                   | Validates that the annotated string is between min and max included |
| *日期检查*                                            |                                                              |
| @Past                                                 |         验证 Date 和 Calendar 对象是否在当前时间之前         |
| @Future                                               |         验证 Date 和 Calendar 对象是否在当前时间之后         |
| @Pattern                                              |           验证 String 对象是否符合正则表达式的规则           |
| *数值检查*                                            | 建议使用在Stirng,Integer类型，不建议使用在int类型上，因为表单值为“”时无法转换为int，但可以转换为Stirng为”“,Integer为null |
| @Min                                                  |         验证 Number 和 String 对象是否大等于指定的值         |
| @Max                                                  |         验证 Number 和 String 对象是否小等于指定的值         |
| @DecimalMax                                           | 被标注的值必须不大于约束中指定的最大值.这个约束的参数是一个通过BigDecimal定义的最大值的字符串表示.小数存在精度 |
| @DecimalMin                                           | 被标注的值必须不小于约束中指定的最小值. 这个约束的参数是一个通过BigDecimal定义的最小值的字符串表示.小数存在精度 |
| @Digits                                               |             验证 Number 和 String 的构成是否合法             |
| @Digits(integer=,fraction=)                           | 验证字符串是否是符合指定格式的数字，interger指定整数精度，fraction指定小数精度 |
| @Range(min=, max=)                                    |                检查数字是否介于min和max之间.                 |
| @Range(min=10000,max=50000,message=”range.bean.wage”) |                                                              |
| @Valid                                                | 递归的对关联对象进行校验, 如果关联对象是个集合或者数组,那么对其中的元素进行递归校验,如果是一个map,则对其中的值部分进行校验.(是否进行递归验证) |
| @CreditCardNumber                                     |                          信用卡验证                          |
| @Email                                                |    验证是否是邮件地址，如果为null,不进行验证，算通过验证     |
| @ScriptAssert(lang= ,script=, alias=)                 |                                                              |
| @URL(protocol=,host=, port=,regexp=, flags=)          |                                                              |







参数校验失效问题，可以参考《极客时间》： *Spring Web 参数验证常见错误*

1. 需要对入参增加` @Validated`注解或者添加一个`@Valid`开头的注解(可以自定义)
2. 嵌套的参数校验需要在嵌套的类成员上面添加`@Valid`注解， `@Validated` 的定义是不允许修饰一个 Field 的



> 也就是说，对于函数入参：
>
> 1. 是一个类：使用` @Validated`注解或者添加一个`@Valid`开头的注解打表，类里面有嵌套校验，类里面的成员使用`@Valid`注解打标
> 2. 是一个基本类型：使用`@Valid`注解打标



范围校验不能校验参数是否为null

---

***Reference***:

1. [Spring Boot实现各种参数校验，写得太好了 - DockOne.io](http://dockone.io/article/2434740)
