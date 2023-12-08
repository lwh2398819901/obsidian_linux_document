---
dg-publish: false
---
```toc
```
## 参考


[# Redis之Redis事务](https://blog.csdn.net/weixin_37548768/article/details/124538778)

[redis的事务到底有什么用？](https://www.zhihu.com/question/37387330/answer/2447332075)

[Redis 持久化详解及配置](https://zhuanlan.zhihu.com/p/182972002)

视频教程链接

[【狂神说Java】Redis最新超详细版教程通俗易懂](https://www.bilibili.com/video/BV1S54y1R7SB?p=1&vd_source=ccbe0c793ac5e34ebb735794692f049e)


## 事务


一、Redis事务的概念

Redis 事务的本质是一组命令的集合。事务支持一次执行多个命令，一个事务中所有命令都会被序列化。在事务执行过程，会按照顺序串行化执行队列中的命令，其他客户端提交的命令请求不会插入到事务执行命令序列中。
总结说：redis事务就是一次性、顺序性、排他性的执行一个队列中的一系列命令。

二、Redis事务没有隔离级别的概念

批量操作在发送 EXEC 命令前被放入队列缓存，并不会被实际执行，也就不存在事务内的查询要看到事务里的更新，事务外查询不能看到。

三、Redis不保证原子性

Redis中，单条命令是原子性执行的，但事务不保证原子性，且没有回滚。事务中任意命令执行失败，其余的命令仍会被执行。

 四、Redis事务的三个阶段

```bash
开始事务
命令入队
执行事务
```

五、Redis事务相关命令

```bash
watch key1 key2 ... : 监视一或多个key,如果在事务执行之前，
				被监视的key被其他命令改动，则事务被打断 （ 类似乐观锁 ）
multi : 	标记一个事务块的开始（ queued ）
exec : 		执行所有事务块的命令 （ 一旦执行exec后，之前加的监控锁都会被取消掉 ）　
discard : 	取消事务，放弃事务块中的所有命令
unwatch :	取消watch对所有key的监控
```

<font color=#FF0000>注意</font>
若在事务队列中存在命令性错误（类似于编译性错误），则执行EXEC命令时，所有命令都不会执行

若在事务队列中存在语法性错误（类似于运行时异常），则执行EXEC命令时，其他正确命令会被执行，错误命令抛出异常。

<span style="background:#F0A7D8">ps:等等 这个鬼事务的意义是啥？又不能原子性 又不能隔离的</span>

## watch实现乐观锁
可以利用watch命令实现[[基础知识#乐观锁 (Optimistic Lock)|乐观锁]]功能
监视一个(或多个) key ，如果在事务exec执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。  
  下面这个例子：我们在观察的时候k1值为1，但是事务执行的时候k1值为2，k1被修改了所以不能执行事务。
```
127.0.0.1:6379> set k1 1 #设置k1值为1
OK
127.0.0.1:6379> WATCH k1 #监视k1 （当已经开始监控k1，则其他客户端不能修改k1的值）
OK
127.0.0.1:6379> set k1 2 #设置k1值为2，此操作可能由其他客户端执行
OK
127.0.0.1:6379> MULTI #开始事务
OK
127.0.0.1:6379> set k1 3 #修改k值为3
QUEUED 
127.0.0.1:6379> EXEC #提交事务，但k1值不会被修改为3，k1的值仍然是2，因为在事务开启之前k1的值被修改了
(nil)
127.0.0.1:6379> get k1
"2"

```

## 配置文件详解
redis.conf

1. 配置文件对大小写不敏感
2. 



## 持久化

我认为知乎上的持久化这篇文章已经写的很详细了 ，所以我直接摘抄下来。参考见链接<span style="background:#F0A7D8">【Redis 持久化详解及配置】</span>，其中对于部分语句做了删减整理。


----------------------------------------------
Redis 运行时数据保存在内存中, 一旦重启则数据将全部丢失.

Redis 提供了两种持久化方式:

1.  RDB 持久化: 生成某个时间点的快照文件
2.  AOF 持久化(append only file): 日志追加模式(Redis协议格式保存)

Redis可以同时使用以上两种持久化

### **RDB 持久化**
执行 rdb 持久化时, Redis 会fork出一个子进程, 子进程将内存中数据写入到一个紧凑的文件中, 因此它保存的是某个时间点的完整数据。

如有需要，可以保存最近24小时的每小时备份文件，以及每个月每天的备份文件，便于遇到问题时恢复。

Redis 启动时会从 rdb 文件中恢复数据到内存， 因此恢复数据时只需将redis关闭后，将备份的rdb文件替换当前的rdb文件，再启动Redis即可。

 **优点**

-   rdb文件体积比较小， 适合备份及传输
-   性能会比 aof 好（aof 需要写入日志到文件中）
-   rdb 恢复比 aof 要更快

**缺点**

-   服务器故障时会丢失最后一次备份之后的数据
-   Redis 保存rdb时， fork子进程的这个操作期间, Redis服务会停止响应(一般是毫秒级)，但如果数据量大且cpu时间紧张，则停止响应的时间可能长达1秒

 **相关配置参数**
 
 ```text
################################ SNAPSHOTTING  ################################
# 快照配置
# 注释掉“save”这一行配置项就可以让保存数据库功能失效
# 设置sedis进行数据库镜像的频率。
# 900秒（15分钟）内至少1个key值改变（则进行数据库保存--持久化） 
# 300秒（5分钟）内至少10个key值改变（则进行数据库保存--持久化） 
# 60秒（1分钟）内至少10000个key值改变（则进行数据库保存--持久化）
save 900 1
save 300 10
save 60 10000

#当RDB持久化出现错误后，是否依然进行继续进行工作，yes：不能进行工作，no：可以继续进行工作，可以通过info中的rdb_last_bgsave_status了解RDB持久化是否有错误
stop-writes-on-bgsave-error yes

#使用压缩rdb文件，rdb文件压缩使用LZF压缩算法，yes：压缩，但是需要一些cpu的消耗。no：不压缩，需要更多的磁盘空间
rdbcompression yes

#是否校验rdb文件。从rdb格式的第五个版本开始，在rdb文件的末尾会带上CRC64的校验和。这跟有利于文件的容错性，但是在保存rdb文件的时候，会有大概10%的性能损耗，所以如果你追求高性能，可以关闭该配置。
rdbchecksum yes

#rdb文件的名称
dbfilename dump.rdb

#数据目录，数据库的写入会在这个目录。rdb、aof文件也会写在这个目录
dir /var/lib/redis
```
 


### **AOF 持久化**

AOF 其实就是将客户端每一次操作记录追加到指定的aof（日志）文件中，在aof文件体积多大时可以自动在后台重写aof文件（期间不影响正常服务，中途磁盘写满或停机等导致失败也不会丢失数据）

aof 持久化的fsync策略支持：

-   不执行 fsync：由操作系统保证数据同步到磁盘(linux 默认30秒)， 速度最快
-   每秒1次：最多丢失最近1s的数据（推荐）
-   每条命令：绝对保证数据持久化（影响性能）

> fsync：同步内存中所有已修改的文件数据到储存设备

aof 文件是一个只追加的文件, 若写入了不完整的命令(磁盘满, 停机...)时, 可用自带的 `redis-check-aof` 工具轻易修复问题：执行`redis-check-aof --fix`

aof文件过大时会触发自动重写, 重写后的新aof文件包含了恢复当前数据集所需的最少的命令集合.

> 客户端多次对同一个键 incr 时, 操作N次则会写入N条, 但实际上只需一条 set 命令就可以保存该值, 重建就是生成足够重建当前数据集的最少命令。  
> Redis 重写aof操作同样是通过 fork 子进程来处理的.

Redis 运行时打开 aof:

```text
redis-cli> CONFIG SET appendonly yes
```

> 仅当前实例生命周期内有效

 **优点**

-   充分保证数据的持久化，正确的配置一般最多丢失1秒的数据
-   aof 文件内容是以Redis协议格式保存， 易读

 **缺点**

-   aof 文件通常大于 rdb 文件
-   速度会慢于rdb, 具体得看具体fsyn策略
-   重新启动redis时会极低的概率会导致无法将数据集恢复成保存时的原样(概率极低, 但确实出现过)

**相关配置参数**

```text
############################## APPEND ONLY MODE ###############################
#默认redis使用的是rdb方式持久化，这种方式在许多应用中已经足够用了。但是redis如果中途宕机，会导致可能有几分钟的数据丢失，根据save来策略进行持久化，Append Only File是另一种持久化方式，可以提供更好的持久化特性。Redis会把每次写入的数据在接收后都写入 appendonly.aof 文件，每次启动时Redis都会先把这个文件的数据读入内存里，先忽略RDB文件。
appendonly yes

#aof文件名, 保存目录由 dir 参数决定
appendfilename "appendonly.aof"

#aof持久化策略的配置
#no表示不执行fsync，由操作系统保证数据同步到磁盘，速度最快。
#always表示每次写入都执行fsync，以保证数据同步到磁盘。
#everysec表示每秒执行一次fsync，可能会导致丢失这1s数据。
appendfsync everysec

# 在aof重写或者写入rdb文件的时候，会执行大量IO，此时对于everysec和always的aof模式来说，执行fsync会造成阻塞过长时间，no-appendfsync-on-rewrite字段设置为默认设置为no。如果对延迟要求很高的应用，这个字段可以设置为yes，否则还是设置为no，这样对持久化特性来说这是更安全的选择。设置为yes表示rewrite期间对新写操作不fsync,暂时存在内存中,等rewrite完成后再写入，默认为no，建议yes。Linux的默认fsync策略是30秒。可能丢失30秒数据。
no-appendfsync-on-rewrite no

#aof自动重写配置。当目前aof文件大小超过上一次重写的aof文件大小的百分之多少进行重写，即当aof文件增长到一定大小的时候Redis能够调用bgrewriteaof对日志文件进行重写。当前AOF文件大小是上次日志重写得到AOF文件大小的二倍（设置为100）时，自动启动新的日志重写过程。
auto-aof-rewrite-percentage 100
#设置允许重写的最小aof文件大小，避免了达到约定百分比但尺寸仍然很小的情况还要重写
auto-aof-rewrite-min-size 64mb

#aof文件可能在尾部是不完整的，当redis启动的时候，aof文件的数据被载入内存。重启可能发生在redis所在的主机操作系统宕机后，尤其在ext4文件系统没有加上data=ordered选项（redis宕机或者异常终止不会造成尾部不完整现象。）出现这种现象，可以选择让redis退出，或者导入尽可能多的数据。如果选择的是yes，当截断的aof文件被导入的时候，会自动发布一个log给客户端然后load。如果是no，用户必须手动redis-check-aof修复AOF文件才可以。
aof-load-truncated yes
```

## 发布与订阅
redis并不是专业的发布订阅工具，可以使用kafka   所以这一章不记录了 详细使用见下面链接

https://www.runoob.com/redis/redis-pub-sub.html
## 集群搭建

https://blog.csdn.net/qq_42815754/article/details/82912130

## 主从复制
https://blog.csdn.net/Cantevenl/article/details/115839649

**主从复制的概念**

主从复制，是指将一台Redis服务器的数据，复制到其他的Redis服务器。前者称为主节点(master/leader)，后者称为从节点(slave/follower) ; 

<font color=#FF0000>数据的复制是单向的，只能由主节点到从节点。</font>Master以写为主，Slave以读为主。

默认情况下，每台Redis服务器都是主节点 ;一个主节点可以有多个从节点(或没有从节点)，但一个从节点只能有一个主节点。

**主从复制的作用**
1. 读写分离：主节点写，从节点读，提高服务器的读写负载能力
2. 数据冗余︰主从复制实现了数据的热备份，是持久化之外的一种数据冗余方式。
3. 故障恢复︰当主节点出现问题时，可以由从节点提供服务，实现快速的故障恢复 ; 实际上是一种服务的冗余。
4. 负载均衡︰在主从复制的基础上，配合读写分离，可以由主节点提供写服务，由从节点提供读服务（即写Redis数据时应用连接主节点，读Redis数据时应用连接从节点），分担服务器负载 ; 尤其是在写少读多的场景下，通过多个从节点分担读负载，可以大大提高Redis服务器的并发量。
5. 高可用（集群）基石︰除了上述作用以外，主从复制还是哨兵和集群能够实施的基础，因此说主从复制是Redis高可用的基础。

<span style="background:#F0A7D8">redis运用到工程中，一般最少使用三台设备：</span>
1. 结构上，单台redis服务器会发生单点故障，并且请求压力负载过大
2. 容量上，单台redis服务器内存有限，一般单台redis最大使用内存不应超过20G

### 配置
```bash
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# redis-cli
127.0.0.1:6379> ping 
PONG
127.0.0.1:6379> info replication
# Replication
role:master   # 主
connected_slaves:0 # 从 0个
master_failover_state:no-failover
master_replid:b169f167266a1092e7a160f7afb36fa48a529538
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0
```

模拟主从复制

1. 停止redis服务
2. 拷贝配置文件
3. 修改相应配置文件  (与原始文件相比的修改)
``` bash
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# diff redis.conf redis79.conf
354c354
< logfile ""
---
> logfile "6379.log"
486c486
< dbfilename dump.rdb
---
> dbfilename dump79.rdb
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig [1]# diff redis.conf redis80.conf
138c138
< port 6379
---
> port 6380
341c341
< pidfile /var/run/redis_6379.pid
---
> pidfile /var/run/redis_6380.pid
354c354
< logfile ""
---
> logfile "6380.log"
486c486
< dbfilename dump.rdb
---
> dbfilename dump80.rdb
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig [1]# diff redis.conf redis81.conf
138c138
< port 6379
---
> port 6381
341c341
< pidfile /var/run/redis_6379.pid
---
> pidfile /var/run/redis_6381.pid
354c354
< logfile ""
---
> logfile "6381.log"
486c486
< dbfilename dump.rdb
---
> dbfilename dump81.rdb
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig [1]# 
```

修改内容：
- pid文件
- 端口
- 日志文件
- dump文件

4. 启动服务
```bash
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# redis-server redis79.conf 
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# redis-server redis80.conf
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# redis-server redis81.conf
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# ps aux|grep redis
root      198478  0.0  0.5 268496 10408 ?        Ssl  12:34   0:00 redis-server 127.0.0.1:6379
root      198500  0.0  0.5 268496 10424 ?        Ssl  12:34   0:00 redis-server 127.0.0.1:6380
root      198513  0.0  0.5 268496 10308 ?        Ssl  12:34   0:00 redis-server 127.0.0.1:6381
root      198525  0.0  0.0 221460   860 pts/0    R+   12:34   0:00 grep --color=auto redis
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# 

```
5. 配置从机（命令配置 关闭程序失效）
```
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# redis-cli -p 6380
127.0.0.1:6380> ping
PONG
127.0.0.1:6380> info replication
# Replication
role:master
connected_slaves:0
master_failover_state:no-failover
master_replid:fce590f40d8ffeb33fa0f99ea410c96efd58c7b4
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

127.0.0.1:6380> slaveof 127.0.0.1 6379
OK

127.0.0.1:6380> info replication
# Replication
role:slave
master_host:127.0.0.1
master_port:6379
master_link_status:down
master_last_io_seconds_ago:-1
master_sync_in_progress:0
slave_read_repl_offset:0
slave_repl_offset:0
master_link_down_since_seconds:-1
slave_priority:100
slave_read_only:1
replica_announced:1
connected_slaves:0
master_failover_state:no-failover
master_replid:fce590f40d8ffeb33fa0f99ea410c96efd58c7b4
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0
127.0.0.1:6380> 

127.0.0.1:6380> slaveof no one //提升为主

```

6. 修改配置文件方式
```
# Master-Replica replication. Use replicaof to make a Redis instance a copy of
# another Redis server. A few things to understand ASAP about Redis replication.
#
#   +------------------+      +---------------+
#   |      Master      | ---> |    Replica    |
#   | (receive writes) |      |  (exact copy) |
#   +------------------+      +---------------+
#
# 1) Redis replication is asynchronous, but you can configure a master to
#    stop accepting writes if it appears to be not connected with at least
#    a given number of replicas.
# 2) Redis replicas are able to perform a partial resynchronization with the
#    master if the replication link is lost for a relatively small amount of
#    time. You may want to configure the replication backlog size (see the next
#    sections of this file) with a sensible value depending on your needs.
# 3) Replication is automatic and does not need user intervention. After a
#    network partition replicas automatically try to reconnect to masters
#    and resynchronize with them.
#
# replicaof <masterip> <masterport>   //主机ip 端口

# If the master is password protected (using the "requirepass" configuration
# directive below) it is possible to tell the replica to authenticate before
# starting the replication synchronization process, otherwise the master will
# refuse the replica request.
#
# masterauth <master-password>         //主机密码


```

7. 主机查看当前配置
```
127.0.0.1:6379> info replication
# Replication
role:master
connected_slaves:2  #两个从机
slave0:ip=127.0.0.1,port=6380,state=online,offset=263,lag=1
slave1:ip=127.0.0.1,port=6381,state=online,offset=263,lag=1
master_failover_state:no-failover
master_replid:73b4be556c4c89eb4aea035145e0329f37505f4f
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:263
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:263
127.0.0.1:6379> 
```


<font color=#FF0000>**主机能写，从机不能写！！！**</font>
当主机断开链接，从机依然不能写，（需要配置哨兵模式）。如果主机上线，从机会自动链接主机。



## 哨兵
https://www.jianshu.com/p/06ab9daf921d

哨兵模式是一种特殊的模式，首先Redis提供了哨兵的命令，哨兵是一个独立的进程，作为进程，它会独立运行。其原理是**哨兵通过发送命令，等待Redis服务器响应，从而监控运行的多个Redis实例。**
![[Pasted image 20221026183427.png]]

简单讲 是启动另一个监控进程监控redis集群，同时为了防止哨兵宕机，哨兵也需要集群。

这里的哨兵有两个作用

-   通过发送命令，让Redis服务器返回监控其运行状态，包括主服务器和从服务器。
    
-   当哨兵监测到master宕机，会自动将slave切换成master，然后通过**发布订阅模式**通知其他的从服务器，修改配置文件，让它们切换主机。
    

然而一个哨兵进程对Redis服务器进行监控，可能会出现问题，为此，我们可以使用多个哨兵进行监控。各个哨兵之间还会进行监控，这样就形成了多哨兵模式。

用文字描述一下**故障切换（failover）**的过程。假设主服务器宕机，哨兵1先检测到这个结果，系统并不会马上进行failover过程，仅仅是哨兵1主观的认为主服务器不可用，这个现象成为**主观下线**。当后面的哨兵也检测到主服务器不可用，并且数量达到一定值时，那么哨兵之间就会进行一次投票，投票的结果由一个哨兵发起，进行failover操作。切换成功后，就会通过发布订阅模式，让各个哨兵把自己监控的从服务器实现切换主机，这个过程称为**客观下线**。这样对于客户端而言，一切都是透明的。

![[Pasted image 20221026183307.png]]
<font color=#FF0000>简单讲 是启动另一个监控进程监控redis集群，同时为了防止哨兵宕机，哨兵也需要集群。</font>


## redis缓存问题
详细可见[[10 架构师学习/术语及概念解释#缓存穿透 、缓存击穿、缓存雪崩]]


