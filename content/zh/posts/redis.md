---
title: "分布式-Redis"
date: 2020-03-18T01:00:46+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://gitee.com/wujiahong1998/MyBed/raw/master/img/Redis.png
libraries:
- katex
- mathjax
tags:
- redis
- 分布式计算
- 云计算
- 数据库
series:
-
categories:
-
---





集万滴雨水，成一条江河:ocean::ocean:

<!--more-->

# Redis



> REmote DIctionary Server(Redis) 是一个由Salvatore Sanfilippo写的key-value存储系统。
>
> Redis是一个开源的使用ANSI C语言编写、遵守BSD协议[^1]、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。
>
> 它通常被称为数据结构服务器，因为值（value）可以是 字符串(String), 哈希(Hash), 列表(list), 集合(sets) 和 有序集合(sorted sets)等类型。



> 开源界的 5 大许可协议：五大开源许可协议分别是[GPL](https://baike.baidu.com/item/GPL),[LGPL](https://baike.baidu.com/item/LGPL),BSD,MIT,[Apache](https://baike.baidu.com/item/Apache)。



存储类型：

- String: 字符串
- Hash: 散列
- List: 列表
- Set: 集合
- Sorted Set: 有序集合

三个特点：

- Redis支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。
- Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。
- Redis支持数据的备份，即master-slave模式[^2]的数据备份。

**Redis与其他key-value存储有什么不同？**

- Redis有着更为复杂的数据结构并且提供对他们的原子性操作[^3]，这是一个不同于其他数据库的进化路径。Redis的数据类型都是基于基本数据结构的同时对程序员透明，无需进行额外的抽象。
- Redis运行在内存中但是可以持久化到磁盘，所以在对不同数据集进行高速读写时需要权衡内存，因为数据量不能大于硬件内存。在内存数据库方面的另一个优点是，相比在磁盘上相同的复杂的数据结构，在内存中操作起来非常简单，这样Redis可以做很多内部复杂性很强的事情。同时，在磁盘格式方面他们是紧凑的以追加的方式产生的，因为他们并不需要进行随机访问。

## 安装

github链接：[https://github.com/microsoftarchive/redis/releases](https://github.com/microsoftarchive/redis/releases)

Redis是C语言开发，安装Redis需要先将官网下载的源码进行编译，编译依赖gcc环境，如果没有gcc环境，需要安装gcc。

#### 安装GCC

步骤：

```bash
## 先安装 gcc 编译环境,如果已经安装, 请忽略
yum -y install gcc automake autoconf libtool make

## 下载 redis 源代码
wget http://download.redis.io/releases/redis-4.0.1.tar.gz

## 下载完成后,解压
tar zxvf redis-4.0.1.tar.gz

## 跳转到 redis 目录
cd redis-4.0.1

## 编译
make

## 安装编译后的软件到  /usr/local/redis  
## PREFIX必须大写,自动为我们创建redis目录，并将结果安装此目录
make PREFIX=/usr/local/redis install

## 查看安装的结果
cd /usr/local/redis/bin
ls -l
-rwxr-xr-x 1 root root 2451864 Mar 12 13:28 redis-benchmark
-rwxr-xr-x 1 root root 5741096 Mar 12 13:28 redis-check-aof
-rwxr-xr-x 1 root root 5741096 Mar 12 13:28 redis-check-rdb
-rwxr-xr-x 1 root root 2606088 Mar 12 13:28 redis-cli
lrwxrwxrwx 1 root root      12 Mar 12 13:28 redis-sentinel -> redis-server
-rwxr-xr-x 1 root root 5741096 Mar 12 13:28 redis-server
```



## 配置

> Redis 的配置文件位于 Redis 安装目录下，文件名为 redis.conf(Windows 名为 redis.windows.conf)。

redis.conf配置文件详解：

```bash
## 指定包含其它的配置文件，可以多个Redis实例使用同一份配置文件，而各个实例又拥有自己的特定配置文件
include /path/to/local.conf

## 绑定的主机地址, 可以监听一个或多个, 如果为 127.0.0.1 只能本机才能访问
bind 127.0.0.1

## Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程
daemonize no

## Redis以守护进程方式运行时,Redis默认会把 pid 写入 /var/run/redis.pid 文件,可以通过 pidfile 指定
pidfile /var/run/redis_6379.pid

## 指定Redis监听端口，默认端口为6379
port 6379

## 当客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能
timeout 0

## 指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
## debug    会打印出很多信息，适用于开发和测试阶段
## verbose  包含很多不太有用的信息，但比debug要清爽一些
## notice   适用于生产模式
## warning  警告信息（仅记录非常重要/重要的消息）
loglevel verbose

## 日志记录方式，默认为标准输出
## 如果 Redis 以守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null
logfile stdout

## 设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
databases 16

## 指定在多长时间内，有多少次更新操作，就将数据同步到数据文件(持久化)，可以多个条件配合
## save <seconds> <changes>
save 900 1       ## 900秒内有一个更新
save 300 10      ## 300秒内有10个更新
save 60  10000   ## 60秒内有10000个更新

## 指定存储至本地数据库时是否压缩数据，默认为yes
## Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大
rdbcompression yes

## 指定本地数据库文件名，默认值为dump.rdb
dbfilename dump.rdb   ## 也就是安装目录下我们看到的那个文件

## 指定本地数据库存放目录
dir ./

## 当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步
slaveof <masterip> <masterport>

## 当master服务设置了密码保护时，slav服务连接master的密码
masterauth <master-password>

## 设置Redis连接密码
## 如果配置了连接密码，客户端在连接Redis时需要通过AUTH <password>命令提供密码，默认关闭
requirepass foobared

## 设置同一时间最大客户端连接数，默认无限制 
## Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数
## 如果设置 maxclients 0，表示不作限制
## 客户端连接数到达限制时,Redis会关闭新的连接并向客户端返回max number of clients reached错误信息
maxclients 128

## Redis最大内存限制
## Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key
## 当此方法处理后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。
## Redis新的vm机制，会把Key存放内存，Value会存放在swap区
maxmemory <bytes>

## 指定是否在每次更新操作后进行日志记录, 默认为 no
## Redis在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失
## 因为 redis本身同步数据文件是按上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中
appendonly no

## 指定更新日志文件名，默认为 appendonly.aof
appendfilename appendonly.aof

## 指定更新日志条件
## no       : 表示等操作系统进行数据缓存同步到磁盘（快）
## always   : 表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全） 
## everysec :  表示每秒同步一次（折中，默认值）
appendfsync everysec

## 指定是否启用虚拟内存机制，默认值为no
## VM机制将数据分页存放,将访问量较少的页即冷数据swap到磁盘上,访问多的页面由磁盘自动换出到内存中
vm-enabled no

## 虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享
vm-swap-file /tmp/redis.swap

## 将所有大于vm-max-memory的数据存入虚拟内存
## 无论vm-max-memory设置多小,所有索引数据都是内存存储的(Redis的索引数据 就是keys),
## 也就是说,当vm-max-memory设置为0的时候,其实是所有value都存在于磁盘。默认值为0
vm-max-memory 0

## Redis swap文件分成了很多的page，一个对象可以保存在多个page上面，但一个page上不能被多个对象共享
vm-page-size 32

## 设置swap文件中的page数量
## 由于页表（一种表示页面空闲或使用的bitmap）是在放在内存中的,在磁盘上每8个pages将消耗1byte的内存。
vm-pages 134217728

## 设置访问swap文件的线程数,最好不要超过机器的核数,
## 如果设置为0,那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4
vm-max-threads 4

## 设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启
glueoutputbuf yes

## 指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法
hash-max-zipmap-entries 64
hash-max-zipmap-value 512

## 指定是否激活重置哈希，默认为开启（后面在介绍Redis的哈希算法时具体介绍）
activerehashing yes
```

### 注意事项

我们查看了配置文件信息, 总结如下

> 1. 如果你想要以加载配置文件的方式启动 Redis, 那么你需要使用 ./redis-server /path/to/redis.conf 命令启动 Redis 服务端.
> 2. 内存设置大小单位
>
> 1. 1. 1k    => 1000 bytes
>    2. 1kb   => 1024 bytes
>    3. 1m    => 1000000 bytes
>    4. 1mb   => 1024*1024 bytes
>    5. 1g    => 1000000000 bytes
>    6. 1gb   => 1024*1024*1024 bytes
>    7. 1GB 1Gb 1gB 表达一样的意思, 单位不区分大小写
>
> 1. 121321

## 基本操作

连接远程服务器：`redis-cli -h host -p port -a password`

例如：`$redis-cli -h 127.0.0.1 -p 6379 -a "mypass"`

### 键Key

与 Redis 键相关的基本命令：

| 序号 |                          命令及描述                          |
| :--- | :----------------------------------------------------------: |
| 1    | [DEL key](https://www.runoob.com/redis/keys-del.html)  该命令用于在 key 存在时删除 key。 |
| 2    | [DUMP key](https://www.runoob.com/redis/keys-dump.html)  序列化给定 key ，并返回被序列化的值。 |
| 3    | [EXISTS key](https://www.runoob.com/redis/keys-exists.html)  检查给定 key 是否存在。 |
| 4    | [EXPIRE key](https://www.runoob.com/redis/keys-expire.html) seconds 为给定 key 设置过期时间，以秒计。 |
| 5    | [EXPIREAT key timestamp](https://www.runoob.com/redis/keys-expireat.html) EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间。 不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp)。 |
| 6    | [PEXPIRE key milliseconds](https://www.runoob.com/redis/keys-pexpire.html) 设置 key 的过期时间以毫秒计。 |
| 7    | [PEXPIREAT key milliseconds-timestamp](https://www.runoob.com/redis/keys-pexpireat.html) 设置 key 过期时间的时间戳(unix timestamp) 以毫秒计 |
| 8    | [KEYS pattern](https://www.runoob.com/redis/keys-keys.html) 查找所有符合给定模式( pattern)的 key 。 |
| 9    | [MOVE key db](https://www.runoob.com/redis/keys-move.html) 将当前数据库的 key 移动到给定的数据库 db 当中。 |
| 10   | [PERSIST key](https://www.runoob.com/redis/keys-persist.html) 移除 key 的过期时间，key 将持久保持。 |
| 11   | [PTTL key](https://www.runoob.com/redis/keys-pttl.html) 以毫秒为单位返回 key 的剩余的过期时间。 |
| 12   | [TTL key](https://www.runoob.com/redis/keys-ttl.html) 以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)。 |
| 13   | [RANDOMKEY](https://www.runoob.com/redis/keys-randomkey.html) 从当前数据库中随机返回一个 key 。 |
| 14   | [RENAME key newkey](https://www.runoob.com/redis/keys-rename.html) 修改 key 的名称 |
| 15   | [RENAMENX key newkey](https://www.runoob.com/redis/keys-renamenx.html) 仅当 newkey 不存在时，将 key 改名为 newkey 。 |
| 16   | [TYPE key](https://www.runoob.com/redis/keys-type.html) 返回 key 所储存的值的类型。 |

设置键值对 `set key value` 与取出键值对 `get key`

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200317232058.png)

删除键值使用`del key`

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200317235115.png)

### 字符串存储

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200317235240.png)



### Hash存储

之前变量没删除会报错

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200317235350.png)

Redis hash 是一个键值(key=>value)对集合。

Redis hash 是一个 string 类型的 field 和 value 的映射表，hash 特别适合用于存储对象。

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200317235527.png)

*每个 hash 可以存储 232 -1 键值对（40多亿）。*

### 列表存储

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200318001127.png)

展示：

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200318001140.png)

*列表最多可存储 232 - 1 元素 (4294967295, 每个列表可存储40多亿)。*

### 集合存储

指令：`sadd key member` 向集合key添加元素。

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200317235838.png)

指令：`smembers key`，展示集合key中的元素：

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200318000148.png)

### 有序集合-zset

指令：`zadd key score member` ，向有序集合添加元素，并且设置相应的score。

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200318000628.png)

上面设置A且score为0，B且score为2，C且score为1.

指令：`zrangebyscore key l r`,展示有序集合按score排序之后且在范围l到r的元素。

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200318000846.png)

显然元素已经按照score的顺序排列。







[^2]: `主从设备模式`也叫做`主仆模式`英文简称为`Master-Slave`,核心思想是基于分而治之的思想,将一个原始任务分解为若干个语义等同的子任务,并由专门的工作者线程来并行执行这些任务,原始任务的结果是通过整合各个子任务的处理结果形成的
[^1]: 跟其他条款相比，从[GNU通用公共许可证](http://www.bosimedia.com/wiki/GNU通用公共許可證)（GPL）到限制重重的[著作权](http://www.bosimedia.com/wiki/著作權)（Copyright），BSD许可证比较宽松，甚至跟[公有领域](http://www.bosimedia.com/wiki/公有領域)更为接近。事实上，BSD许可证被认为是*copycenter*（中间著作权），介乎标准的copyright与GPL的copyleft之间。"Take it down to the copy center and make as many copies as you want"[[1\]](https://www.wikii.cc/wiki/BSD许可证#endnote_copycenter)。可以说，GPL强迫后续版本必须一样是[自由软件](http://www.bosimedia.com/wiki/自由軟體)，BSD的后续版本可以选择要继续是BSD或其他自由软件条款或[封闭软件](http://www.bosimedia.com/wiki/封閉軟體)等等。
[^3]: 意思就是要么成功执行要么失败完全不执行。单个操作是原子性的。多个操作也支持事务，即原子性，通过MULTI和EXEC指令包起来。