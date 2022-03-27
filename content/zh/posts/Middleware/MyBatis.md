---
title: MyBatis
date: 2021-12-16T17:02:17+08:00
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





MyBatis使用模糊查询like：[[MyBatis]模糊查询LIKE的三种方式_睁眼看世界-CSDN博客_mybatis模糊查询like](https://blog.csdn.net/why15732625998/article/details/79081146)



mybatis 最初配置信息是基于 XML ,映射语句(SQL)也是定义在 XML 中的。而到了 MyBatis 3提供了新的基于注解的配置。mybatis提供的注解有很多，大致可以分为以下几类： 

- **增删改查：**@Insert、@Update、@Delete、@Select、@MapKey、@Options、@SelelctKey、@Param、@InsertProvider、@UpdateProvider、@DeleteProvider、@SelectProvider 
- **结果集映射：**@Results、@Result、@ResultMap、@ResultType、@ConstructorArgs、@Arg、@One、@Many、@TypeDiscriminator、@Case 

- **缓存：**@CacheNamespace、@Property、@CacheNamespaceRef、@Flush 













mybatis的insert和insertSelective方法自动生成id后，返回id到参数对象中

```xml
  <insert id="insert" parameterType="com.meituan.pay.openplatform.db.model.RequirementValueDO">
    <selectKey keyProperty="id" order="AFTER" resultType="java.lang.Long">
      SELECT LAST_INSERT_ID()
    </selectKey>
    insert into requirement_value (id, requirement_id, goal, 
      value, achieve_result, create_time, 
      update_time)
    values (#{id,jdbcType=BIGINT}, #{requirementId,jdbcType=BIGINT}, #{goal,jdbcType=VARCHAR}, 
      #{value,jdbcType=VARCHAR}, #{achieveResult,jdbcType=VARCHAR}, #{createTime,jdbcType=TIMESTAMP}, 
      #{updateTime,jdbcType=TIMESTAMP})
  </insert>
```





---

***Reference***:

