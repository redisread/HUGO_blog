---
title: "Quic协议为什么这么好"
date: 2020-11-18T18:22:14+08:00
description: 新一代HTTP协议，成为HTTP/3，基于UDP，非常强大.有更快速、更灵活、更安全的特点。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/11/18/nk9DPifsVOJra8q.png
libraries:
- katex
- mathjax
tags:
- quic
series:
- network
categories:
-
---





如何让网络数据传输地更快？(合并一些层)

![如何传输的更快](https://i.loli.net/2020/11/12/McdVSu7AgFUaTRb.png)

### 为什么需要QUIC？

1. **中间设备的僵化**

   可能是 TCP 协议使用得太久，也非常可靠。所以我们很多中间设备，包括防火墙、NAT 网关，整流器等出现了一些约定俗成的动作。

2. **依赖于操作系统的实现导致协议僵化**

   TCP 是由操作系统在内核西方栈层面实现的，应用程序只能使用，不能直接修改。虽然应用程序的更新迭代非常快速和简单。但是 TCP 的迭代却非常缓慢，原因就是操作系统升级很麻烦。

3. **建立连接的握手延迟大**

   不管是 HTTP1.0/1.1 还是 HTTPS，HTTP2，都使用了 TCP 进行传输。HTTPS 和 HTTP2 还需要使用 TLS 协议来进行安全传输。这就出现了两个握手延迟：

   1. TCP 三次握手导致的 TCP 连接建立的延迟。

   2. TLS 完全握手需要至少 2 个 RTT 才能建立，简化握手需要 1 个 RTT 的握手延迟。

   对于很多短连接场景，这样的握手延迟影响很大，且无法消除。

4. **队头阻塞**

   队头阻塞主要是 TCP 协议的可靠性机制引入的。TCP 使用序列号来标识数据的顺序，数据必须按照顺序处理，如果前面的数据丢失，后面的数据就算到达了也不会通知应用层来处理。

   另外 TLS 协议层面也有一个队头阻塞，因为 TLS 协议都是按照 record 来处理数据的，如果一个 record 中丢失了数据，也会导致整个 record 无法正确处理。

 QUIC 协议选择了 UDP，因为 UDP 本身没有连接的概念，**不需要三次握手，优化了连接建立的握手延迟**，同时在应用程序层面实现了 TCP 的可靠性，TLS 的安全性和 HTTP2 的并发性，只需要用户端和服务端的应用程序支持 QUIC 协议，完全避开了操作系统和中间设备的限制。



### QUIC概述

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



#### 如何做到0RTT？

首先解释一下什么是0RTT。

所谓的0RTT就是，**通信双方发起通信连接时，第一个数据包便可以携带有效的业务数据**。而我们知道，这个使用传统的TCP是完全不可能的，除非你使能了TCP Fast Open特性，而这个很难，因为几乎没人愿意为了这个收益去对操作系统的网络协议栈大动手脚。未使能Fast Open的TCP传输第一笔数据前，至少要等1个RTT：

![1-RTT](https://i.loli.net/2020/11/18/pa2qe3TK5Wghnlw.png)

此外，对于HTTPS这种应用而言，由于还需要额外的TLS握手，0RTT就更不可能了。

![https连接](https://i.loli.net/2020/11/18/PnJ4h9rc78GQBMz.png)

首先声明一点，如果一对使用QUIC进行加密通信的双方此前从来没有通信过，那么0RTT是不可能的，即便是QUIC也是不可能的，所谓的0RTT是值之前连接过服务器，后面再次连接的时候就是0RTT。

#### 连接过程

![密钥交换](https://i.loli.net/2020/11/12/p8Fb3w2WTICJsAG.png)

**Step1**：首次连接时，客户端发送 Inchoate Client Hello 给服务端，用于请求连接；

**Step2**：服务端生成 g、p、a，根据 g、p 和 a 算出 A，然后将 g、p、A 放到 Server Config 中再发送 Rejection 消息给客户端；

**Step3**：客户端接收到 g、p、A 后，自己再生成 b，根据 g、p、b 算出 B，根据 A、p、b 算出初始密钥 K。B 和 K 算好后，客户端会用 K 加密 HTTP 数据，连同 B 一起发送给服务端；

**Step4**：服务端接收到 B 后，根据 a、p、B 生成与客户端同样的密钥，再用这密钥解密收到的 HTTP 数据。为了进一步的安全（前向安全性），服务端会更新自己的随机数 a 和公钥，再生成新的密钥 S，然后把公钥通过 Server Hello 发送给客户端。连同 Server Hello 消息，还有 HTTP 返回数据；

**Step5**：客户端收到 Server Hello 后，生成与服务端一致的新密钥 S，后面的传输都使用 S 加密。

这样，QUIC 从请求连接到正式接发 HTTP 数据一共花了 1 RTT，这 1 个 RTT 主要是为了获取 Server Config，后面的连接如果客户端缓存了 Server Config，那么就可以直接发送 HTTP 数据，实现 0 RTT 建立连接。

这里使用的是 DH 密钥交换算法，DH 算法的核心就是服务端生成 a、g、p 3 个随机数，a 自己持有，g 和 p 要传输给客户端，而客户端会生成 b 这 1 个随机数，通过 DH 算法客户端和服务端可以算出同样的密钥。在这过程中 a 和 b 并不参与网络传输，安全性大大提高。因为 p 和 g 是大数，所以即使在网络中传输的 p、g、A、B 都被劫持，那么靠现在的计算机算力也没法破解密钥。



如下图：

![QUIC连接过程](https://i.loli.net/2020/11/18/g4KFIyWvh7ocLP5.png)



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

![HTTP/2多路复用](https://i.loli.net/2020/11/12/FSCO4jJ2ueU51km.png)

事情还没完，HTTP/2 虽然可以解决“请求”这个粒度的阻塞，但 HTTP/2 的基础 TCP 协议本身却也存在着队头阻塞的问题。HTTP/2 的每个请求都会被拆分成多个 Frame，不同请求的 Frame 组合成 Stream，Stream 是 TCP 上的逻辑传输单元，这样 HTTP/2 就达到了一条连接同时发送多条请求的目标，这就是多路复用的原理。我们看一个例子，在一条 TCP 连接上同时发送 4 个 Stream，其中 Stream1 已正确送达，Stream2 中的第 3 个 Frame 丢失，TCP 处理数据时有严格的前后顺序，先发送的 Frame 要先被处理，这样就会要求发送方重新发送第 3 个 Frame，Stream3 和 Stream4 虽然已到达但却不能被处理，那么这时整条连接都被阻塞。

![队头阻塞](https://i.loli.net/2020/11/12/YGdVE3y1nHi86Dk.png)

不仅如此，由于 HTTP/2 必须使用 HTTPS，而 HTTPS 使用的 TLS 协议也存在队头阻塞问题。TLS 基于 Record 组织数据，将一堆数据放在一起（即一个 Record）加密，加密完后又拆分成多个 TCP 包传输。一般每个 Record 16K，包含 12 个 TCP 包，这样如果 12 个 TCP 包中有任何一个包丢失，那么整个 Record 都无法解密。

![使用https的队头阻塞](https://i.loli.net/2020/11/12/3vDl4FKuRtSifkE.png)



那 QUIC 是如何解决队头阻塞问题的呢？主要有两点。

- QUIC 的传输单元是 Packet，加密单元也是 Packet，整个加密、传输、解密都基于 Packet，不会跨越多个 Packet，这样就能避免 TLS 的队头阻塞问题；
- QUIC 基于 UDP，UDP 的数据包在接收端没有处理顺序，即使中间丢失一个包，也不会阻塞整条连接，其他的资源会被正常处理。(Stream 之间相互独立)

![基于UDP解决队头阻塞](https://i.loli.net/2020/11/12/w7DFB2ojmCJlk98.png)

> 当然，并不是所有的 QUIC 数据都不会受到队头阻塞的影响，比如 QUIC 当前也是使用 Hpack 压缩算法 [10]，由于算法的限制，丢失一个头部数据时，可能遇到队头阻塞。
>
> 总体来说，QUIC 在传输大量数据时，比如视频，受到队头阻塞的影响很小。

### QUIC的拥塞控制(可插拔)

拥塞控制的目的是避免过多的数据一下子涌入网络，导致网络超出最大负荷。QUIC 的拥塞控制与 TCP 类似，并在此基础上做了改进。

**AIMD**:线性增加，乘性减少反馈控制算法。

#### 热拔插

TCP 中如果要修改拥塞控制策略，需要在系统层面进行操作。QUIC 修改拥塞控制策略只需要在应用层操作，并且 QUIC 会根据不同的网络环境、用户来动态选择拥塞控制算法。

![可插拔](https://i.loli.net/2020/11/12/Gf4xhmKiTnlyWLj.png)

### QUIC前向纠错FEC

QUIC 使用前向纠错(FEC，Forward Error Correction)技术增加协议的容错性。一段数据被切分为 10 个包后，依次对每个包进行异或运算，运算结果会作为 FEC 包与数据包一起被传输，如果不幸在传输过程中有一个数据包丢失，那么就可以根据剩余 9 个包以及 FEC 包推算出丢失的那个包的数据，这样就大大增加了协议的容错性。

这是符合现阶段网络技术的一种方案，现阶段带宽已经不是网络传输的瓶颈，往返时间才是，所以新的网络传输协议可以适当增加数据冗余，减少重传操作。

![异或实现前向纠错](https://i.loli.net/2020/11/12/ejmniVGcFlTrRsf.png)



### QUIC重传序列号单调递增

TCP 为了保证可靠性，使用 `Sequence Number` 和 ACK 来确认消息是否有序到达，但这样的设计存在缺陷。

超时发生后客户端发起重传，后来接收到了 ACK 确认消息，但因为原始请求和重传请求接收到的 ACK 消息一样，所以客户端就郁闷了，**不知道这个 ACK 对应的是原始请求还是重传请求**。如果客户端认为是原始请求的 ACK，但实际上是左图的情形，则计算的采样 RTT 偏大；如果客户端认为是重传请求的 ACK，但实际上是右图的情形，又会导致采样 RTT 偏小。

> 图中有几个术语，RTO 是指超时重传时间（Retransmission TimeOut），跟我们熟悉的 RTT（Round Trip Time，往返时间）很长得很像。采样 RTT 会影响 RTO 计算，超时时间的准确把握很重要，长了短了都不合适。

![TCP重传序列号相同的问题](https://i.loli.net/2020/11/12/M4Smbkgu1aI3LpN.png)



QUIC 解决了上面的歧义问题。与 Sequence Number 不同的是，Packet Number 严格单调递增，如果 Packet N 丢失了，那么重传时 Packet 的标识不会是 N，而是比 N 大的数字，比如 N + M，这样发送方接收到确认消息时就能方便地知道 ACK 对应的是原始请求还是重传请求。

![QUIC递增的包序列](https://i.loli.net/2020/11/12/EhqmK85PY9oFA3V.png)

如上图所示，RTO 发生后，根据重传的 Packet Number 就能确定精确的 RTT 计算。如果 Ack 的 Packet Number 是 N+M，就根据重传请求计算采样 RTT。如果 Ack 的 Pakcet Number 是 N，就根据原始请求的时间计算采样 RTT，没有歧义性。

### 保证包的顺序

单纯依靠严格递增的 Packet Number 肯定是无法保证数据的顺序性和可靠性。QUIC 又引入了一个 Stream Offset 的概念。

即一个 Stream 可以经过多个 Packet 传输，Packet Number 严格递增，没有依赖。但是 Packet 里的 Payload 如果是 Stream 的话，就需要依靠 Stream 的 Offset 来保证应用数据的顺序。如下图所示，发送端先后发送了 Pakcet N 和 Pakcet N+1，Stream 的 Offset 分别是 x 和 x+y。

![包顺序](https://i.loli.net/2020/11/18/nHsyKAb6ihv9ljS.png)

**假设 Packet N 丢失了，发起重传，重传的 Packet Number 是 N+2，但是它的 Stream 的 Offset 依然是 x，这样就算 Packet N + 2 是后到的，依然可以将 Stream x 和 Stream x+y 按照顺序组织起来**。



### 不允许 Reneging

什么叫 Reneging 呢？就是接收方丢弃已经接收并且上报给 SACK 选项的内容。TCP 协议不鼓励这种行为，但是协议层面允许这样的行为。**主要是考虑到服务器资源有限，比如 Buffer 溢出，内存不够等情况。**

Reneging 对数据重传会产生很大的干扰。因为 Sack 都已经表明接收到了，但是接收端事实上丢弃了该数据。QUIC 中的 ACK 包含了与 TCP 中 SACK 等价的信息，但 QUIC 不允许任何（包括被确认接受的）数据包被丢弃。这样不仅可以简化发送端与接收端的实现难度，还可以减少发送端的内存压力。

QUIC 在协议层面禁止 Reneging，一个 Packet 只要被 Ack，就认为它一定被正确接收，减少了这种干扰。



### 更多的 ACK 块

一般来说，接收方收到发送方的消息后都应该发送一个 ACK 回复，表示收到了数据。但每收到一个数据就返回一个 ACK 回复太麻烦，所以一般不会立即回复，而是接收到多个数据后再回复，**T**CP SACK 最多提供 3 个 ACK block。但有些场景下，比如下载，只需要服务器返回数据就好，但按照 TCP 的设计，每收到 3 个数据包就要“礼貌性”地返回一个 ACK。**而 QUIC 最多可以捎带 256 个 ACK block。在丢包率比较严重的网络下，更多的 ACK block 可以减少重传量，提升网络效率。**

![更多的ACK](https://i.loli.net/2020/11/12/Da2AnVZRCgBHWIi.png)



### ACK Delay

TCP 计算 RTT 时没有考虑接收方接收到数据到发送确认消息之间的延迟，如下图所示，这段延迟即 ACK Delay。QUIC 考虑了这段延迟，使得 RTT 的计算更加准确。

> 这段时间可能是解析包的时间。

![考虑delay](https://i.loli.net/2020/11/12/k9djmq3NFlOoAtg.png)



### QUIC流量控制(基于 stream 和 connecton 级别)

QUIC 的流量控制和 TCP 有点区别，TCP 为了保证可靠性，窗口左边沿向右滑动时的长度取决于已经确认的字节数。如果中间出现丢包，就算接收到了更大序号的 Segment，窗口也无法超过这个序列号。

但 QUIC 不同，就算此前有些 packet 没有接收到，它的滑动只取决于接收到的最大偏移字节数。

![Quic Flow Control](https://i.loli.net/2020/11/18/lGf2PwKpLaqChv6.png)

针对 Stream：
$$
可用窗口 = 最大窗口 - 接受到的最大偏移数
$$


针对 Connection：
$$
可用窗口= stream1可用窗口 + stream2可用窗口 + streamN可用窗口
$$


最重要的是，我们可以在内存不足或者上游处理性能出现问题时，通过流量控制来限制传输速率，保障服务可用性。



### 加密认证的报文

TCP 协议头部没有经过任何加密和认证，所以在传输过程中很容易被中间网络设备篡改，注入和窃听。比如修改序列号、滑动窗口。这些行为有可能是出于性能优化，也有可能是主动攻击。

但是 QUIC 的 packet 可以说是武装到了牙齿。除了个别报文比如 PUBLIC_RESET 和 CHLO，所有报文头部都是经过认证的，报文 Body 都是经过加密的。

这样只要对 QUIC 报文任何修改，接收端都能够及时发现，有效地降低了安全风险。

如下图所示，红色部分是 Stream Frame 的报文头部，有认证。绿色部分是报文内容，全部经过加密。

![quic报文格式](https://i.loli.net/2020/11/18/xYR3GQwFpuUhmr1.png)



![](https://i.loli.net/2020/11/18/Wfk4OZHcyBmFUzp.png)

---

Reference：

1. [The Road to QUIC](https://medium.com/cloudflare-blog/the-road-to-quic-9f100dc57d9d)
2. [科普：QUIC协议原理分析](https://zhuanlan.zhihu.com/p/32553477)
3. [Quic协议介绍和浅析](https://blog.csdn.net/jeffrey11223/article/details/84382123)
4. [QUIC协议是如何做到0RTT加密传输的](https://blog.csdn.net/dog250/article/details/80935534)
5. [Quic协议介绍和浅析](https://blog.csdn.net/jeffrey11223/article/details/84382123)



