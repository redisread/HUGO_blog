---
title: "使用Java开发 MCP Server 指南"
subtitle: "基于Spring AI与Quarkus框架实现Apple Notes的MCP Server开发指南"
date: 2025-05-06T13:31:35+08:00
publishDate: 2025-05-06T13:31:35+08:00
aliases:
description: "本指南详细介绍了如何使用Java语言，基于Spring AI和Quarkus两大主流框架，开发符合MCP（模型上下文协议）标准的Server端服务。以Apple Notes为例，涵盖项目初始化、依赖引入、核心服务编写、打包配置及调试全流程，适合希望将本地数据接入大模型上下文的开发者参考"
image: 
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner # outer
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h1","h2", "h3", "h4"]
libraries: [katex, mathjax, mermaid, chart, flowchartjs, msc, viz, wavedrom]
tags: ["AI","MCP"]
series: []
categories: ["AI"]
---


## 前言：MCP 核心概念
什么是MCP协议，参考：[MCP 协议](https://km.sankuai.com/collabpage/2687142585)  

### Resources

资源：客户端可读取的类文件数据（如 API 响应或文件内容）

资源是模型上下文协议（MCP）中的核心基本元素，允许服务器暴露数据和内容，这些数据和内容可以被客户端读取并用于LLM交互作为上下文。

### Tools

工具：可由LLM调用的函数（需用户批准）

### Prompts

提示词: 预先编写的模板，帮助用户完成特定任务


## 使用Spring AI 框架开发 Java MCP Server

### 1 初始化 Java Spring Boot 项目

**使用IDEA创建**：

1.  **打开 IntelliJ IDEA**，点击 **"File" -> "New Project"**。

2.  选择 **Spring Initializr**，填写 Group & Artifact 信息。

3.  选择 **Spring Boot 版本**，添加 `Spring Web` 等依赖。

4.  点击 **Finish**，等待 IDEA 自动构建项目。

5.  运行 `DemoApplication.java`（带 `@SpringBootApplication` 的主类）。


### 2 引入依赖
添加 Spring AI 依赖:
```xml
<dependencies>
      <dependency>
          <groupId>org.springframework.ai</groupId>
          <artifactId>spring-ai-mcp-server-spring-boot-starter</artifactId>
      </dependency>

      <dependency>
          <groupId>org.springframework</groupId>
          <artifactId>spring-web</artifactId>
      </dependency>
</dependencies>
```


### 3 编写MCP服务
AppleNotesService.java 文件
```java
package com.jiahongw.applenotesmcp.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jiahongw.applenotesmcp.utils.AppleScriptExecutor;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Service;

@Service
public class AppleNotesService {

    @Tool(description = "根据标题查询 Apple Notes")
    public String queryNotes(@ToolParam(description = "标题") String title) {
        // 使用Text Block构造AppleScript脚本，去除所有转义字符
        String script = """
            tell application "Notes"
                set theNotes to every note whose name is "%s"
                if (count of theNotes) > 0 then
                    return the body of item 1 of theNotes
                else
                    return "未找到"
                end if
            end tell
            """.formatted(title);
        try {
            String rawHtml = AppleScriptExecutor.execute(script);
            // 1. 用 jsoup 解析
            Document doc = Jsoup.parse(rawHtml);
            // 2. 移除所有 base64 图像
            Elements imgs = doc.select("img[src^=data:image]");
            for (Element img : imgs) {
                img.remove();
            }
            // 3. 返回文本内容
            return doc.body().text();
        } catch (Exception e) {
            return "执行异常: " + e.getMessage();
        }
    }

    @Tool(description = "查询指定目录下所有 Apple Notes，返回标题和内容")
    public String queryNotesInFolder(@ToolParam(description = "目录名") String folderName) {
        // AppleScript: 获取指定目录下所有笔记的标题和内容
        String script = """
            tell application "Notes"
                set theFolder to first folder whose name is "%s"
                set theNotes to notes of theFolder
                set output to ""
                repeat with n in theNotes
                    set noteTitle to the name of n
                    set noteBody to the body of n
                    set output to output & noteTitle & "|||SEP|||" & noteBody & "|||END|||"
                end repeat
                return output
            end tell
            """.formatted(folderName);
        try {
            String raw = AppleScriptExecutor.execute(script);
            String[] noteBlocks = raw.split("\\|\\|\\|END\\|\\|\\|");
            List<Map<String, String>> result = new ArrayList<>();
            
            for (String block : noteBlocks) {
                if (block.trim().isEmpty()) continue;
                
                String[] parts = block.split("\\|\\|\\|SEP\\|\\|\\|", 2);
                if (parts.length != 2) continue;
                
                String title = parts[0];
                String html = parts[1];
                
                Document doc = Jsoup.parse(html);
                Elements imgs = doc.select("img[src^=data:image]");
                for (Element img : imgs) {
                    img.remove();
                }
                
                String content = doc.body().text();
                
                Map<String, String> note = new HashMap<>();
                note.put("title", title);
                note.put("content", content);
                result.add(note);
            }
            
            return new ObjectMapper().writeValueAsString(result);
        } catch (Exception e) {
            return "执行异常: " + e.getMessage();
        }
    }
}
```

### 4 打包配置 

打包可执行文件：
```bash
./mvnw clean install
```
这将在target目录下生成一个 xxx-0.0.1-SNAPSHOT.jar包文件

配置 MCP Server：
```json
{
    "apple-notes-spring-mcp": {
      "command": "java",
      "args": [
        "-jar",
        "-Dspring.ai.mcp.server.stdio=true",
        "/Users/victor/Desktop/PARA.R/Areas/AI/MCP/MyMCP/apple-notes-spring-mcp/target/applenotesmcp-0.0.1-SNAPSHOT.jar"]
	}   
}
```

### 5 调试
执行下面指令打开 MCP Server 调试页面进行调试
```bash
npx @modelcontextprotocol/inspector
```

![kk10Q6](https://cos.jiahongw.com/uPic/kk10Q6.png)



## 使用 Quarkus  框架开发 Java MCP Server
>新建一个 Java 实现的访问 Apple Notes 的 MCP Server 。使用 quarkus 框架实现 。


### 1 新建 quarkus 项目
新建一个 `apple-notes-mcp `项目：

```bash
quarkus create app apple-notes-mcp
```

测试编译调试：
```bash
cd apple-notes-mcp  
./mvnw compile quarkus:dev
```

>- 访问 [http://127.0.0.1:8080/hello](http://127.0.0.1:8080/hello)  来查看示例REST端点的响应
>- 访问 [http://127.0.0.1:8080/q/dev/](http://127.0.0.1:8080/q/dev/) 来查看Quarkus开发UI，这个UI提供了许多有用的开发工具和信息



### 2 编写 MCP Server 代码逻辑
打开项目目录 ，在 `pom.xml` 文件添加 **quarkus-mcp-server** 依赖：
```xml
<dependency>
    <groupId>io.quarkiverse.mcp</groupId>
    <artifactId>quarkus-mcp-server-sse</artifactId>
    <version>1.1.0</version>
</dependency>
```

核心代码如下：
```java
package org.acme;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import io.quarkiverse.mcp.server.Tool;
import io.quarkiverse.mcp.server.ToolArg;

public class AppleNotesService {

    @Tool(description = "根据标题查询 Apple Notes")
    public String queryNotes(
            @ToolArg(description = "标题") String title) {
        // 使用Text Block构造AppleScript脚本，去除所有转义字符
        String script = """
            tell application "Notes"
                set theNotes to every note whose name is "%s"
                if (count of theNotes) > 0 then
                    return the body of item 1 of theNotes
                else
                    return "未找到"
                end if
            end tell
            """.formatted(title);
        try {
            ProcessBuilder pb = new ProcessBuilder("osascript", "-e", script);
            Process process = pb.start();
            try (java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(process.getInputStream()))) {
                StringBuilder result = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    result.append(line).append("\n");
                }
                int exitCode = process.waitFor();
                if (exitCode != 0) {
                    return "AppleScript 执行失败，退出码：" + exitCode;
                }
                // 处理 Apple Notes 返回内容，去除 base64 图像和 HTML 标签
                String rawHtml = result.toString().trim();
                // 1. 用 jsoup 解析
                Document doc = Jsoup.parse(rawHtml);
                // 2. 移除所有 base64 图像
                Elements imgs = doc.select("img[src^=data:image]");
                for (Element img : imgs) {
                    img.remove();
                }
                return doc.body().text();
            }
        } catch (Exception e) {
            return "执行异常: " + e.getMessage();
        }
    }

}
```


### 3 编译调试
执行：
```bash
./mvnw compile quarkus:dev
```

打开： [http://127.0.0.1:8080/q/dev/](http://127.0.0.1:8080/q/dev/)
![6GYsWp](https://cos.jiahongw.com/uPic/6GYsWp.png)

找到 Tools 中的 方法进行调试:
![FBb0C2](https://cos.jiahongw.com/uPic/FBb0C2.png)

执行测试：
![XQ8z8g](https://cos.jiahongw.com/uPic/XQ8z8g.png)


### 4 打包运行配置
打包：
```bash
./mvnw package
```

配置：
```json
{
  "apple-notes-mcp": {
      "url": "http://127.0.0.1:8080/mcp/sse",
    }
}
```


---

***Reference***:
* [For Server Developers - Model Context Protocol](https://modelcontextprotocol.io/quickstart/server)
* [quarkiverse/quarkus-mcp-server: This extension enables developers to implement the MCP server features easily.](https://github.com/quarkiverse/quarkus-mcp-server)
* [Implementing a MCP server in Quarkus - Quarkus](https://quarkus.io/blog/mcp-server/)
* [spring-ai-examples/model-context-protocol/weather/starter-stdio-server/README.md at main · spring-projects/spring-ai-examples](https://github.com/spring-projects/spring-ai-examples/blob/main/model-context-protocol/weather/starter-stdio-server/README.md)