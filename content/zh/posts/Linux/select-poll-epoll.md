---
title: "Select Poll Epoll 详解"
date: 2020-11-18T11:43:19+08:00
description: 本文详细介绍了多路复用中的三种模型，它们是迭代更新的结果。现在常用的会是Epoll。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/11/18/Cv8I7Slfh23FBew.png
libraries:
- katex
- mathjax
tags:
- Epoll
- Select
- Poll
series:
- Linux
categories:
-
---

## 同步异步与阻塞非阻塞

### 用户空间和内核空间

操作系统为了支持多个应用同时运行，需要保证不同进程之间相对独立（一个进程的崩溃不会影响其他的进程 ， 恶意进程不能直接读取和修改其他进程运行时的代码和数据）。 因此操作系统内核**需要拥有高于普通进程的权限**， 以此来调度和管理用户的应用程序。

**于是内存空间被划分为两部分，一部分为内核空间，一部分为用户空间，内核空间存储的代码和数据具有更高级别的权限。**内存访问的**相关硬件**在程序执行期间会进行访问控制（ Access Control），使得用户空间的程序不能直接读写内核空间的内存。

### 进程切换

<img src="https://i.loli.net/2020/08/27/PoucnU64MKWV7rt.jpg" alt="进程切换" style="zoom:67%;" />

上图展示了进程切换中几个最重要的步骤：

1. 当一个程序正在执行的过程中， 中断（interrupt） 或 系统调用（system call） 发生可以使得 CPU 的控制权会从当前进程转移到操作系统内核。
2. 操作系统内核负责保存进程 i 在 CPU 中的上下文（程序计数器， 寄存器）到 PCBi （操作系统分配给进程的一个内存块）中。
3. 从 PCBj 取出进程 j 的CPU 上下文， 将 CPU 控制权转移给进程 j ， 开始执行进程 j 的指令。

>  可以看出来， 操作系统在进行进切换时，需要进行一系列的内存读写操作， 这带来了一定的开销

### 进程阻塞

![进程阻塞](https://i.loli.net/2020/08/27/wE6JH2GPmNdxtRu.jpg)

上图展示了一个进程的不同状态：

- New. 进程正在被创建.
- Running. 进程的指令正在被执行
- Waiting. 进程正在等待一些事件的发生（例如 I/O 的完成或者收到某个信号）
- Ready. 进程在等待被操作系统调度
- Terminated. 进程执行完毕（可能是被强行终止的）

我们所说的 “阻塞”是指进程在**发起了一个系统调用**（System Call） 后， 由于该系统调用的操作不能立即完成，需要等待一段时间，于是内核将进程挂起为**等待 （waiting）**状态， 以确保它不会被调度执行， 占用 CPU 资源。

**阻塞的原理**

阻塞的原理？

![分时进程队列](https://i.loli.net/2020/07/24/nTGf4RqI6XoMhbU.png)



对于Socket来说：

当发生阻塞时候，调用阻塞程序，而阻塞程序最重要的一个操作就是将进程从工作队列移除，并且将其加到等待队列。

![阻塞](https://i.loli.net/2020/07/24/rFREihSuvKnLkHG.png)

当发生中断时候，调用中断程序，而中断程序最重要的一个操作就是将等待队列中的进程重新移回工作队列，继续分配系统的CPU资源。

![中断](https://i.loli.net/2020/07/24/fcSiBavkF2ZlORx.png)

### 文件描述符

我们最熟悉的句柄是0、1、2三个，0是标准输入，1是标准输出，2是标准错误输出。0、1、2是整数表示的，对应的FILE *结构的表示就是`stdin`、`stdout`、`stderr`，0就是`stdin`，1就是`stdout`，2就是`stderr`。

```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>
int main(int argc, char **argv)
{
	char buf[10] = "";
	read(0, buf, 9);			  /* 从标准输入 0 读入字符 */
	// fprintf(stdout, "%s\n", buf); /* 向标准输出 stdout 写字符 */
	write(1, buf, strlen(buf));
	return 0;
}
```

### 同步

同步就是一个任务的完成需要依赖另外一个任务时，只有等待被依赖的任务完成后，依赖的任务才能算完成，这是一种可靠的任务序列。**也就是说，调用会等待返回结果计算完成才能继续执行。**

### 异步

异步是不需要等待被依赖的任务完成，只是通知被依赖的任务要完成什么工作，依赖的任务也立即执行，只要自己完成了整个任务就算完成了。**也就是说，其实异步调用会直接返回，但是这个结果不是计算的结果，当结果计算出来之后，才通知被调用的程序。**

> 举个通俗的例子：
> 你打电话问书店老板有没有《分布式系统》这本书，如果是同步通信机制，书店老板会说，你稍等，”我查一下"，然后开始查啊查，等查好了（可能是5秒，也可能是一天）告诉你结果（返回结果）。
> 而异步通信机制，书店老板直接告诉你我查一下啊，查好了打电话给你，然后直接挂电话了（不返回结果）。然后查好了，他会主动打电话给你。在这里老板通过“回电”这种方式来回调。

### 阻塞

阻塞调用是指调用结果返回之前，当前线程会被挂起，一直处于等待消息通知，不能够执行其他业务。

### 非阻塞

不管可不可以读写，它都会立即返回，返回成功说明读写操作完成了，返回失败会设置相应errno状态码，根据这个errno可以进一步执行其他处理。它不会像阻塞IO那样，卡在那里不动。

> 阻塞和非阻塞关注的是**程序在等待调用结果（消息，返回值）时的状态.**

**可以这么理解么？阻塞和非阻塞，应该描述的是一种状态，同步与非同步描述的是行为方式.**



### 多路复用

==IO多路复用是指内核一旦发现进程指定的一个或者多个IO条件准备读取，它就通知该进程==。



在处理 IO 的时候，阻塞和非阻塞都是同步 IO。
只有使用了特殊的 API 才是异步 IO。

![同步IO与异步IO](https://i.loli.net/2020/08/27/KP8ZGYWacQLgDio.png)



select、poll、epoll之间的区别：

|     \      |                       select                       |                       poll                       |                            epoll                             |
| :--------: | :------------------------------------------------: | :----------------------------------------------: | :----------------------------------------------------------: |
|  操作方式  |                        遍历                        |                       遍历                       |                             回调                             |
|  底层实现  |                        数组                        |                       链表                       |                            哈希表                            |
|   IO效率   |      每次调用都进行线性遍历，时间复杂度为O(n)      |     每次调用都进行线性遍历，时间复杂度为O(n)     | 事件通知方式，每当fd就绪，系统注册的回调函数就会被调用，将就绪fd放到rdllist里面。时间复杂度O(1) |
| 最大连接数 |             1024（x86）或 2048（x64）              |                      无上限                      |                            无上限                            |
|   fd拷贝   | 每次调用select，都需要把fd集合从用户态拷贝到内核态 | 每次调用poll，都需要把fd集合从用户态拷贝到内核态 |  调用epoll_ctl时拷贝进内核并保存，之后每次epoll_wait不拷贝   |



## Select

基于select调用的I/O复用模型如下：

![img](https://i.loli.net/2020/08/28/8EvVKNoq7jJl1FO.jpg)

### 流程

![select流程](https://i.loli.net/2020/08/28/Pk5Oi74nawpQN8d.gif)

**传统select/poll的另一个致命弱点就是当你拥有一个很大的socket集合，由于网络得延时，使得任一时间只有部分的socket是"活跃" 的，而select/poll每次调用都会线性扫描全部的集合，导致效率呈现线性下降。**



**但是epoll不存在这个问题，它只会对"活跃"的socket进 行操作**---这是因为在内核实现中epoll是根据每个fd上面的callback函数实现的。于是，只有"活跃"的socket才会主动去调用 callback函数，其他idle状态的socket则不会，在这点上，epoll实现了一个<font color="pink"> "伪"AIO</font>，因为这时候推动力在os内核。

**过程**

当进程A调用select语句的时候，会将进程A添加到多个监听socket的等待队列中

![Select阻塞过程](https://i.loli.net/2020/07/24/4aA8Kbf6GLZy3eE.png)

当网卡接收到数据，然后网卡通过中断信号通知cpu有数据到达，执行中断程序，中断程序主要做了两件事：

1. 将网络数据写入到对应socket的接收缓冲区里面
2. 唤醒队列中的等待进程(A),重新将进程A放入工作队列中.

如下图，将所有等待队列的进程移除，并且添加到工作队列中。

![Select中断](https://i.loli.net/2020/07/24/1WSPrKjHEBstdRl.png)

> 上面只是一种情况，当程序调用 Select 时，内核会先遍历一遍 Socket，如果有一个以上的 Socket 接收缓冲区有数据，那么 Select 直接返回，不会阻塞。

问题：

* 每次调用 Select 都需要将进程加入到所有监视 Socket 的等待队列，每次唤醒都需要从每个队列中移除。这里涉及了两次遍历，而且每次都要将整个 FDS 列表传递给内核，有一定的开销。
* 进程被唤醒后，程序并不知道哪些 Socket 收到数据，还需要遍历一次

> select和poll在内部机制方面并没有太大的差异。相比于select机制，poll只是取消了最大监控文件描述符数限制，并没有从根本上解决select存在的问题。

### Slect API

轮询所有的句柄，找到有处理状态的句柄并且进行操作。

主要函数：

```c
/* According to POSIX.1-2001 */
#include <sys/select.h>

/* According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

int select(int nfds, fd_set *readfds, fd_set *writefds,
           fd_set *exceptfds, struct timeval *timeout);
/**
    nfds:       监控的文件描述符集里最大文件描述符加1，因为此参数会告诉内核检测前多少个文件描述符的状态
    readfds：    监控有读数据到达文件描述符集合，传入传出参数
    writefds：   监控写数据到达文件描述符集合，传入传出参数
    exceptfds：  监控异常发生达文件描述符集合,如带外数据到达异常，传入传出参数
    timeout：    定时阻塞监控时间，3种情况
                1.NULL，永远等下去
                2.设置timeval，等待固定时间
                3.设置timeval里时间均为0，检查描述字后立即返回，轮询
    struct timeval {
        long tv_sec; // seconds 
        long tv_usec; // microseconds 
    };
*/
void FD_CLR(int fd, fd_set *set);	// 把文件描述符集合里fd清0
int  FD_ISSET(int fd, fd_set *set); // 测试文件描述符集合里fd是否置1
void FD_SET(int fd, fd_set *set);   // 把文件描述符集合里fd位置1
void FD_ZERO(fd_set *set);		   //把文件描述符集合里所有位清0
```



### Select例子

**服务器**

```cpp
/*************************************************************************
    > File Name: server.cpp
    > Author: SongLee
    > E-mail: lisong.shine@qq.com
    > Created Time: 2016年04月28日 星期四 22时02分43秒
    > Personal Blog: http://songlee24.github.io/
 ************************************************************************/
#include <netinet/in.h> // sockaddr_in
#include <sys/types.h>  // socket
#include <sys/socket.h> // socket
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/select.h> // select
#include <sys/ioctl.h>
#include <sys/time.h>
#include <iostream>
#include <vector>
#include <string>
#include <cstdlib>
#include <cstdio>
#include <cstring>
using namespace std;
#define BUFFER_SIZE 1024

struct PACKET_HEAD
{
    int length;
};

class Server
{
private:
    struct sockaddr_in server_addr;
    socklen_t server_addr_len;
    int listen_fd;      // 监听的fd
    int max_fd;         // 最大的fd
    fd_set master_set;  // 所有fd集合，包括监听fd和客户端fd
    fd_set working_set; // 工作集合
    struct timeval timeout;

public:
    Server(int port);
    ~Server();
    void Bind();
    void Listen(int queue_len = 20);
    void Accept();
    void Run();
    void Recv(int nums);
};

Server::Server(int port)
{
    bzero(&server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htons(INADDR_ANY);
    server_addr.sin_port = htons(port);
    // create socket to listen
    listen_fd = socket(PF_INET, SOCK_STREAM, 0);
    if (listen_fd < 0)
    {
        cout << "Create Socket Failed!";
        exit(1);
    }
    int opt = 1;
    // 允许重用本地地址和端口
    setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
}

Server::~Server()
{
    for (int fd = 0; fd <= max_fd; ++fd)
    {
        if (FD_ISSET(fd, &master_set))
        {
            close(fd);
        }
    }
}

void Server::Bind()
{
    if (-1 == (bind(listen_fd, (struct sockaddr *)&server_addr, sizeof(server_addr))))
    {
        cout << "Server Bind Failed!";
        exit(1);
    }
    cout << "Bind Successfully.\n";
}

void Server::Listen(int queue_len)
{
    if (-1 == listen(listen_fd, queue_len))
    {
        cout << "Server Listen Failed!";
        exit(1);
    }
    cout << "Listen Successfully.\n";
}

void Server::Accept()
{
    struct sockaddr_in client_addr;
    socklen_t client_addr_len = sizeof(client_addr);

    int new_fd = accept(listen_fd, (struct sockaddr *)&client_addr, &client_addr_len);
    if (new_fd < 0)
    {
        cout << "Server Accept Failed!";
        exit(1);
    }

    cout << "new connection was accepted.\n";
    // 将新建立的连接的fd加入master_set
    FD_SET(new_fd, &master_set);
    if (new_fd > max_fd)
    {
        max_fd = new_fd;
    }
}

void Server::Run()
{
    max_fd = listen_fd; // 初始化max_fd
    FD_ZERO(&master_set);
    FD_SET(listen_fd, &master_set); // 添加监听fd

    while (1)
    {
        FD_ZERO(&working_set);
        memcpy(&working_set, &master_set, sizeof(master_set));

        timeout.tv_sec = 30;
        timeout.tv_usec = 0;

        int nums = select(max_fd + 1, &working_set, NULL, NULL, &timeout);
        if (nums < 0)
        {
            cout << "select() error!";
            exit(1);
        }

        if (nums == 0)
        {
            //cout << "select() is timeout!";
            continue;
        }

        if (FD_ISSET(listen_fd, &working_set))
            Accept(); // 有新的客户端请求
        else
            Recv(nums); // 接收客户端的消息
    }
}

void Server::Recv(int nums)
{
    for (int fd = 0; fd <= max_fd; ++fd)
    {
        if (FD_ISSET(fd, &working_set))
        {
            bool close_conn = false; // 标记当前连接是否断开了

            PACKET_HEAD head;
            recv(fd, &head, sizeof(head), 0); // 先接受包头，即数据总长度
            // std::cout << head.length << std::endl;
            char *buffer = new char[head.length];
            bzero(buffer, head.length);
            int total = 0;
            while (total < head.length)
            {
                int len = recv(fd, buffer + total, head.length - total, 0);
                if (len < 0)
                {
                    cout << "recv() error!";
                    close_conn = true;
                    break;
                }
                total = total + len;
            }

            if (total == head.length) // 将收到的消息原样发回给客户端
            {
                int ret1 = send(fd, &head, sizeof(head), 0);
                int ret2 = send(fd, buffer, head.length, 0);
                if (ret1 < 0 || ret2 < 0)
                {
                    cout << "send() error!";
                    close_conn = true;
                }
            }

            delete buffer;

            if (close_conn) // 当前这个连接有问题，关闭它
            {
                close(fd);
                FD_CLR(fd, &master_set);
                if (fd == max_fd) // 需要更新max_fd;
                {
                    while (FD_ISSET(max_fd, &master_set) == false)
                        --max_fd;
                }
            }
        }
    }
}

int main()
{
    Server server(15000);
    server.Bind();
    server.Listen();
    server.Run();
    return 0;
}
```

**客户端**

```cpp
/*************************************************************************
    > File Name: client.cpp
    > Author: SongLee
    > E-mail: lisong.shine@qq.com
    > Created Time: 2016年04月28日 星期四 23时10分15秒
    > Personal Blog: http://songlee24.github.io/
 ************************************************************************/
#include<netinet/in.h>   // sockaddr_in
#include<sys/types.h>    // socket
#include<sys/socket.h>   // socket
#include<arpa/inet.h>
#include<sys/ioctl.h>
#include<unistd.h>
#include<iostream>
#include<string>
#include<cstdlib>
#include<cstdio>
#include<cstring>
using namespace std;
#define BUFFER_SIZE 1024

struct PACKET_HEAD
{
    int length;
};

class Client 
{
private:
    struct sockaddr_in server_addr;
    socklen_t server_addr_len;
    int fd;
public:
    Client(string ip, int port);
    ~Client();
    void Connect();
    void Send(string str);
    string Recv();
};

Client::Client(string ip, int port)
{
    bzero(&server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    if(inet_pton(AF_INET, ip.c_str(), &server_addr.sin_addr) == 0)
    {
        cout << "Server IP Address Error!";
        exit(1);
    }
    server_addr.sin_port = htons(port);
    server_addr_len = sizeof(server_addr);
    // create socket
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if(fd < 0)
    {
        cout << "Create Socket Failed!";
        exit(1);
    }
}

Client::~Client()
{
    close(fd);
}

void Client::Connect()
{
    cout << "Connecting......" << endl;
    if(connect(fd, (struct sockaddr*)&server_addr, server_addr_len) < 0)
    {
        cout << "Can not Connect to Server IP!";
        exit(1);
    }
    cout << "Connect to Server successfully." << endl;
}

void Client::Send(string str)
{
    PACKET_HEAD head;
    head.length = str.size()+1;   // 注意这里需要+1
    int ret1 = send(fd, &head, sizeof(head), 0);
    int ret2 = send(fd, str.c_str(), head.length, 0);
    if(ret1 < 0 || ret2 < 0)
    {
        cout << "Send Message Failed!";
        exit(1);
    }
}

string Client::Recv()
{
    PACKET_HEAD head;
    recv(fd, &head, sizeof(head), 0);

    char* buffer = new char[head.length];
    bzero(buffer, head.length);
    int total = 0;
    while(total < head.length)
    {
        int len = recv(fd, buffer + total, head.length - total, 0);
        if(len < 0)
        {
            cout << "recv() error!";
            break;
        }
        total = total + len;
    }
    string result(buffer);
    delete buffer;
    return result;
}

int main()
{
    Client client("127.0.0.1", 15000);
    client.Connect();
    while(1)
    {
        string msg;
        getline(cin, msg);
        if(msg == "exit")
            break;
        client.Send(msg);
        cout << client.Recv() << endl;  
    }
    return 0;
}
```

说明：

- 监听socket也由select来轮询，不需要单独的线程；
- working_set每次都要重新设置，因为select调用后它所检测的集合working_set会被修改；
- 接收很长一段数据时，需要循环多次recv。但是recv函数会阻塞，可以通过自定义包头（保存数据长度）



## Poll

poll的机制与select类似，与select在本质上没有多大差别，管理多个描述符也是进行轮询，根据描述符的状态进行处理，但是poll没有最大文件描述符数量的限制。poll和select同样存在一个缺点就是，包含大量文件描述符的数组被整体复制于用户态和内核的地址空间之间，而不论这些文件描述符是否就绪，它的开销随着文件描述符数量的增加而线性增大。

相关的函数：

```c
#include <poll.h>
int poll(struct pollfd fds[], nfds_t nfds, int timeout)；
```

参数描述：

1. 该poll()函数返回fds集合中就绪的读、写，或出错的描述符数量，返回0表示超时，返回-1表示出错；
2. fds是一个`struct pollfd`类型的数组，用于存放需要检测其状态的socket描述符，并且调用poll函数之后fds数组不会被清空；
3. nfds：记录数组fds中描述符的总数量；
4. timeout：调用poll函数阻塞的超时时间，单位毫秒；

其中pollfd结构体定义如下：

```c++
typedef struct pollfd {
        int fd;                         /* 需要被检测或选择的文件描述符*/
        short events;                   /* 对文件描述符fd上感兴趣的事件 */
        short revents;                  /* 文件描述符fd上当前实际发生的事件*/
} pollfd_t;
```

一个pollfd结构体表示一个被监视的文件描述符，通过传递`fds[]`指示 poll() 监视多个文件描述符，其中：

- 结构体的`events`域是监视该文件描述符的事件掩码，由用户来设置这个域。
- 结构体的`revents`域是文件描述符的操作结果事件掩码，内核在调用返回时设置这个域。

events域中请求的任何事件都可能在revents域中返回。合法的事件如下：

| 常量       | 说明                     |
| ---------- | ------------------------ |
| POLLIN     | 普通或优先级带数据可读   |
| POLLRDNORM | 普通数据可读             |
| POLLRDBAND | 优先级带数据可读         |
| POLLPRI    | 高优先级数据可读         |
| POLLOUT    | 普通数据可写             |
| POLLWRNORM | 普通数据可写             |
| POLLWRBAND | 优先级带数据可写         |
| POLLERR    | 发生错误                 |
| POLLHUP    | 发生挂起                 |
| POLLNVAL   | 描述字不是一个打开的文件 |

当需要监听多个事件时，使用`POLLIN | POLLRDNORM`设置 events 域；当poll调用之后检测某事件是否就绪时，`fds[i].revents & POLLIN`进行判断。

### Poll例子

**服务器**

```cpp
#include <netinet/in.h> // sockaddr_in
#include <sys/types.h>  // socket
#include <sys/socket.h> // socket
#include <arpa/inet.h>
#include <unistd.h>
#include <poll.h> // poll
#include <sys/ioctl.h>
#include <sys/time.h>
#include <iostream>
#include <vector>
#include <string>
#include <cstdlib>
#include <cstdio>
#include <cstring>
using namespace std;
#define BUFFER_SIZE 1024
#define MAX_FD 1000

struct PACKET_HEAD
{
    int length;
};

class Server
{
private:
    struct sockaddr_in server_addr;
    socklen_t server_addr_len;
    int listen_fd;             // 监听的fd
    struct pollfd fds[MAX_FD]; // fd数组，大小为1000
    int nfds;

public:
    Server(int port);
    ~Server();
    void Bind();
    void Listen(int queue_len = 20);
    void Accept();
    void Run();
    void Recv();
};

Server::Server(int port)
{
    bzero(&server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htons(INADDR_ANY);
    server_addr.sin_port = htons(port);
    // create socket to listen
    listen_fd = socket(PF_INET, SOCK_STREAM, 0);
    if (listen_fd < 0)
    {
        cout << "Create Socket Failed!";
        exit(1);
    }
    int opt = 1;
    setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
}

Server::~Server()
{
    for (int i = 0; i < MAX_FD; ++i)
    {
        if (fds[i].fd >= 0)
        {
            close(fds[i].fd);
        }
    }
}

void Server::Bind()
{
    if (-1 == (bind(listen_fd, (struct sockaddr *)&server_addr, sizeof(server_addr))))
    {
        cout << "Server Bind Failed!";
        exit(1);
    }
    cout << "Bind Successfully.\n";
}

void Server::Listen(int queue_len)
{
    if (-1 == listen(listen_fd, queue_len))
    {
        cout << "Server Listen Failed!";
        exit(1);
    }
    cout << "Listen Successfully.\n";
}

void Server::Accept()
{
    struct sockaddr_in client_addr;
    socklen_t client_addr_len = sizeof(client_addr);

    int new_fd = accept(listen_fd, (struct sockaddr *)&client_addr, &client_addr_len);
    if (new_fd < 0)
    {
        cout << "Server Accept Failed!";
        exit(1);
    }

    cout << "new connection was accepted.\n";
    // 将新建立的连接的fd加入fds[]
    int i;
    for (i = 1; i < MAX_FD; ++i)
    {
        if (fds[i].fd < 0)
        {
            fds[i].fd = new_fd;
            break;
        }
    }
    // 超过最大连接数
    if (i == MAX_FD)
    {
        cout << "Too many clients.\n";
        exit(1);
    }

    fds[i].events = POLLIN;     // 设置新描述符的读事件
    nfds = i > nfds ? i : nfds; // 更新连接数
}

void Server::Run()
{
    fds[0].fd = listen_fd; // 添加监听描述符
    fds[0].events = POLLIN;
    nfds = 0;

    for (int i = 1; i < MAX_FD; ++i)
        fds[i].fd = -1;

    while (1)
    {
        int nums = poll(fds, nfds + 1, -1);
        if (nums < 0)
        {
            cout << "poll() error!";
            exit(1);
        }

        if (nums == 0)
        {
            continue;
        }

        if (fds[0].revents & POLLIN)
            Accept(); // 有新的客户端请求
        else
            Recv();
    }
}

void Server::Recv()
{
    for (int i = 1; i < MAX_FD; ++i)
    {
        if (fds[i].fd < 0)
            continue;
        if (fds[i].revents & POLLIN) // 读就绪
        {
            int fd = fds[i].fd;
            bool close_conn = false; // 标记当前连接是否断开了

            PACKET_HEAD head;
            recv(fd, &head, sizeof(head), 0); // 先接受包头，即数据总长度

            char *buffer = new char[head.length];
            bzero(buffer, head.length);
            int total = 0;
            while (total < head.length)
            {
                int len = recv(fd, buffer + total, head.length - total, 0);
                if (len < 0)
                {
                    cout << "recv() error!";
                    close_conn = true;
                    break;
                }
                total = total + len;
            }

            if (total == head.length) // 将收到的消息原样发回给客户端
            {
                int ret1 = send(fd, &head, sizeof(head), 0);
                int ret2 = send(fd, buffer, head.length, 0);
                if (ret1 < 0 || ret2 < 0)
                {
                    cout << "send() error!";
                    close_conn = true;
                }
            }

            delete buffer;

            if (close_conn) // 当前这个连接有问题，关闭它
            {
                close(fd);
                fds[i].fd = -1;
            }
        }
    }
}

int main()
{
    Server server(15000);
    server.Bind();
    server.Listen();
    server.Run();
    return 0;
}
```

**客户端**

核Select客户端一样



## Epoll

epoll可以理解为event poll(基于事件的轮询)。

### 使用场合：

1. 当客户处理多个描述符时（一般是交互式输入和网络套接口），必须使用I/O复用。

2. 当一个客户同时处理多个套接口时，而这种情况是可能的，但很少出现。

3. 如果一个TCP服务器既要处理监听套接口，又要处理已连接套接口，一般也要用到I/O复用。

4. 如果一个服务器即要处理TCP，又要处理UDP，一般要使用I/O复用。

5. 如果一个服务器要处理多个服务或多个协议，一般要使用I/O复用。

> I/O多路复用有很多种实现。在linux上，2.4内核前主要是select和poll，自Linux 2.6内核正式引入epoll以来，epoll已经成为了目前实现高性能网络服务器的必备技术。尽管他们的使用方法不尽相同，但是本质上却没有什么区别。



### Epoll原理

不同于select/poll，Epoll正是保存了那些收到数据的Socket到一个双向链表中，这样一来，就少了一次遍历。epoll = <font color=Orange>减少遍历</font> + <font color=Orange>保存就绪Socket</font>

1. **减少遍历**

将控制与阻塞分离。

2. **保存就绪Socket**

维护一个`rdlist`以及`rb_tree`，类似于双向链表操作。

---

通过 epoll_ctl 添加 Sock1、Sock2 和 Sock3 的监视，内核会将 eventpoll的**引用** 添加到这三个 Socket 的等待队列中。

epoll 在 Linux 内核中申请了一个简易的文件系统，用于存储相关的对象，每一个 epoll 对象都有一个独立的 eventpoll 结构体，这个结构体会在内核空间中创造独立的内存，用于存储使用epoll_ctl 方法向 epoll 对象中添加进来的事件。这些事件都会挂到 rbr 红黑树中，这样，重复添加的事件就可以通过红黑树而高效地识别出来。

![epoll数据结构](https://i.loli.net/2020/07/25/hEZDfmGtxvARl79.jpg)



epoll底层实现最重要的两个数据结构:epitem和eventpoll。可以简单的认为epitem是和每个用户态监控IO的fd对应的,eventpoll是用户态创建的管理所有被监控fd的结构，详细的定义如下：

```C
struct epitem {
  struct rb_node  rbn;      
  struct list_head  rdllink; 
  struct epitem  *next;      
  struct epoll_filefd  ffd;  
  int  nwait;                 
  struct list_head  pwqlist;  
  struct eventpoll  *ep;      
  struct list_head  fllink;   
  struct epoll_event  event;  
};

struct eventpoll {
  spin_lock_t       lock; 
  struct mutex      mtx;  
  wait_queue_head_t     wq; 
  wait_queue_head_t   poll_wait; 
  struct list_head    rdllist;   //就绪链表
  struct rb_root      rbr;      //红黑树根节点 
  struct epitem      *ovflist;
};
```

**epoll过程**

调用epoll_create，内核会创建一个eventpoll对象（也就是程序中epfd所代表的对象）。eventpoll对象也是文件系统中的一员，和socket一样，它也会有等待队列。

![创建eventpoll对象](https://i.loli.net/2020/08/30/ZRBTlP5pCqsmJQz.png)

通过 epoll_ctl 添加 Sock1、Sock2 和 Sock3 的监视，内核会将 eventpoll的**引用** 添加到这三个 Socket 的等待队列中。

![image-20200830163121454](https://i.loli.net/2020/08/30/el2hVs7K9nMopP6.png)

当Socket收到数据之后，中断程序会执行将Socket的**引用**添加到eventpoll对象的rdlist就绪列表中。

![添加socket到rdlist](https://i.loli.net/2020/08/30/K296AcT8WbOMN1u.png)



假设计算机中正在运行进程 A 和进程 B、C，在某时刻进程 A 运行到了 epoll_wait 语句，会将进程A添加到eventpoll的等待队列中。

![阻塞加入等待队列](https://i.loli.net/2020/08/30/4uxnkCOJ7UAwcXS.png)



当 Socket 接收到数据，中断程序一方面修改 Rdlist，另一方面唤醒 eventpoll 等待队列中的进程，进程 A 再次进入运行状态。因为Soket包含eventpoll对象的引用，因此可以直接操作eventpoll对象.

![中断加入就绪队列](https://i.loli.net/2020/08/30/q9RTUd2MhnpgXHi.png)



**epoll API**

epoll的api定义:

```c
//用户数据载体
typedef union epoll_data {
   void    *ptr;
   int      fd;
   uint32_t u32;
   uint64_t u64;
} epoll_data_t;
//fd装载入内核的载体
 struct epoll_event {
     uint32_t     events;    /* Epoll events */
     epoll_data_t data;      /* User data variable */
 };
 //三板斧api
int epoll_create(int size); 
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);  
int epoll_wait(int epfd, struct epoll_event *events,
                 int maxevents, int timeout);
```

- **poll_create**是在内核区创建一个epoll相关的一些列结构，并且将一个句柄fd返回给用户态，后续的操作都是基于此fd的，参数size是告诉内核这个结构的元素的大小，类似于stl的vector动态数组，如果size不合适会涉及复制扩容，不过貌似4.1.2内核之后size已经没有太大用途了；
- **epoll_ctl**是将fd添加/删除于epoll_create返回的epfd中，其中epoll_event是用户态和内核态交互的结构，定义了用户态关心的事件类型和触发时数据的载体epoll_data；
- **epoll_wait***是阻塞等待内核返回的可读写事件，epfd还是epoll_create的返回值，events是个结构体数组指针存储epoll_event，也就是将内核返回的待处理epoll_event结构都存储下来，maxevents告诉内核本次返回的最大fd数量，这个和events指向的数组是相关的；
- **epoll_wait**是用户态需监控fd的代言人，后续用户程序对fd的操作都是基于此结构的；

### epoll例子

服务端

```cpp
#include <netinet/in.h> // sockaddr_in
#include <sys/types.h>  // socket
#include <sys/socket.h> // socket
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/epoll.h> // epoll
#include <sys/ioctl.h>
#include <sys/time.h>
#include <iostream>
#include <vector>
#include <string>
#include <cstdlib>
#include <cstdio>
#include <cstring>
using namespace std;
#define BUFFER_SIZE 1024
#define EPOLLSIZE 100

struct PACKET_HEAD
{
    int length;
};

class Server
{
private:
    struct sockaddr_in server_addr;
    socklen_t server_addr_len;
    int listen_fd;                        // 监听的fd
    int epfd;                             // epoll fd
    struct epoll_event events[EPOLLSIZE]; // epoll_wait返回的就绪事件
public:
    Server(int port);
    ~Server();
    void Bind();
    void Listen(int queue_len = 20);
    void Accept();
    void Run();
    void Recv(int fd);
};

Server::Server(int port)
{
    bzero(&server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htons(INADDR_ANY);
    server_addr.sin_port = htons(port);
    // create socket to listen
    listen_fd = socket(PF_INET, SOCK_STREAM, 0);
    if (listen_fd < 0)
    {
        cout << "Create Socket Failed!";
        exit(1);
    }
    int opt = 1;
    setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
}

Server::~Server()
{
    close(epfd);
}

void Server::Bind()
{
    if (-1 == (bind(listen_fd, (struct sockaddr *)&server_addr, sizeof(server_addr))))
    {
        cout << "Server Bind Failed!";
        exit(1);
    }
    cout << "Bind Successfully.\n";
}

void Server::Listen(int queue_len)
{
    if (-1 == listen(listen_fd, queue_len))
    {
        cout << "Server Listen Failed!";
        exit(1);
    }
    cout << "Listen Successfully.\n";
}

void Server::Accept()
{
    struct sockaddr_in client_addr;
    socklen_t client_addr_len = sizeof(client_addr);

    int new_fd = accept(listen_fd, (struct sockaddr *)&client_addr, &client_addr_len);
    if (new_fd < 0)
    {
        cout << "Server Accept Failed!";
        exit(1);
    }

    cout << "new connection was accepted.\n";

    // 在epfd中注册新建立的连接
    struct epoll_event event;
    event.data.fd = new_fd;
    event.events = EPOLLIN;

    epoll_ctl(epfd, EPOLL_CTL_ADD, new_fd, &event);
}

void Server::Run()
{
    epfd = epoll_create(1); // 创建epoll句柄

    struct epoll_event event;
    event.data.fd = listen_fd;
    event.events = EPOLLIN;
    epoll_ctl(epfd, EPOLL_CTL_ADD, listen_fd, &event); // 注册listen_fd

    while (1)
    {
        int nums = epoll_wait(epfd, events, EPOLLSIZE, -1);
        if (nums < 0)
        {
            cout << "poll() error!";
            exit(1);
        }

        if (nums == 0)
        {
            continue;
        }

        for (int i = 0; i < nums; ++i) // 遍历所有就绪事件
        {
            int fd = events[i].data.fd;
            if ((fd == listen_fd) && (events[i].events & EPOLLIN))
                Accept(); // 有新的客户端请求
            else if (events[i].events & EPOLLIN)
                Recv(fd); // 读数据
            else
                ;
        }
    }
}

void Server::Recv(int fd)
{
    bool close_conn = false; // 标记当前连接是否断开了

    PACKET_HEAD head;
    recv(fd, &head, sizeof(head), 0); // 先接受包头，即数据总长度

    char *buffer = new char[head.length];
    bzero(buffer, head.length);
    int total = 0;
    while (total < head.length)
    {
        int len = recv(fd, buffer + total, head.length - total, 0);
        if (len < 0)
        {
            cout << "recv() error!";
            close_conn = true;
            break;
        }
        total = total + len;
    }

    if (total == head.length) // 将收到的消息原样发回给客户端
    {
        int ret1 = send(fd, &head, sizeof(head), 0);
        int ret2 = send(fd, buffer, head.length, 0);
        if (ret1 < 0 || ret2 < 0)
        {
            cout << "send() error!";
            close_conn = true;
        }
    }

    delete buffer;

    if (close_conn) // 当前这个连接有问题，关闭它
    {
        close(fd);
        struct epoll_event event;
        event.data.fd = fd;
        event.events = EPOLLIN;
        epoll_ctl(epfd, EPOLL_CTL_DEL, fd, &event); // Delete一个fd
    }
}

int main()
{
    Server server(15000);
    server.Bind();
    server.Listen();
    server.Run();
    return 0;
}
```



总结：

每次调用poll/select系统调用，操作系统都要把current（当前进程）挂到fd对应的所有设备的等待队列上，可以想象，fd多到上千的时候，这样“挂”法很费事；而每次调用epoll_wait则没有这么罗嗦，epoll只在epoll_ctl时把current挂一遍（这第一遍是免不了的）并给每个fd一个命令“好了就调回调函数”，如果设备有事件了，通过回调函数，会把fd放入rdllist，而每次调用epoll_wait就只是收集rdllist里的fd就可以了——epoll巧妙的利用回调函数，实现了更高效的事件驱动模型。



### epoll工作模式

#### LT模式

LT(level triggered)是缺省的工作方式，并且同时支持block和no-block socket。在这种做法中，内核告诉你一个文件描述符是否就绪了，然后你可以对这个就绪的fd进行IO操作。**如果你不作任何操作，内核还是会继续通知你的**，所以，这种模式编程出错误可能性要小一点。传统的select/poll都是这种模型的代表。

#### ET模式

ET (edge-triggered) 是高速工作方式，只支持no-block socket(非阻塞)。 在这种模式下，**当描述符从未就绪变为就绪时，内核就通过epoll告诉你，然后它会假设你知道文件描述符已经就绪，并且不会再为那个文件描述符发送更多的 就绪通知**，直到你做了某些操作而导致那个文件描述符不再是就绪状态(比如 你在发送，接收或是接受请求，或者发送接收的数据少于一定量时导致了一个EWOULDBLOCK 错误)。但是请注意，如果一直不对这个fd作IO操作(从而导致它再次变成未就绪)，内核就不会发送更多的通知(only once)。不过在TCP协议中，ET模式的加速效用仍需要更多的benchmark确认。



![wallhaven-e7zwmr_1920x1080](https://i.loli.net/2020/11/18/5AizpuafSm6lVtD.png)

---

参考：

1. [IO多路复用之select总结](https://www.cnblogs.com/Anker/archive/2013/08/14/3258674.html)
2. [IO多路复用之poll总结](https://www.cnblogs.com/Anker/archive/2013/08/15/3261006.html)
3. [IO多路复用之epoll总结](http://www.cnblogs.com/Anker/archive/2013/08/17/3263780.html)
4. [Linux IO模式及 select、poll、epoll详解](https://segmentfault.com/a/1190000003063859)
5. [select详解](https://blog.csdn.net/gjggj/article/details/73854104?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522159850213919724835858015%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=159850213919724835858015&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-73854104.pc_ecpm_v3_pc_rank_v3&utm_term=select%E8%AF%A6%E8%A7%A3&spm=1018.2118.3001.4187)
6. [Linux下的I/O复用与epoll详解](https://www.cnblogs.com/lojunren/p/3856290.html)  
7. [聊聊同步、异步、阻塞与非阻塞](https://www.jianshu.com/p/aed6067eeac9)
8. [聊聊Linux 五种IO模型](https://www.jianshu.com/p/486b0965c296)
9. [聊聊IO多路复用之select、poll、epoll详解](https://www.jianshu.com/p/dfd940e7fca2)
10. [Linux IO模式及 select、poll、epoll详解](https://segmentfault.com/a/1190000003063859)
11. [彻底学会使用epoll(一)——ET模式实现分析](http://blog.chinaunix.net/uid-28541347-id-4273856.html)
12. [epoll 或者 kqueue 的原理是什么？](https://www.zhihu.com/question/20122137/answer/14049112)
13. [epoll事件处理机制详解](https://blog.51cto.com/leejia/1021066)
14. [如果这篇文章说不清epoll的本质，那就过来掐死我吧](https://zhuanlan.zhihu.com/p/63179839)
15. [select、poll、epoll整理总结](https://blog.csdn.net/wujiafei_njgcxy/article/details/77584663)