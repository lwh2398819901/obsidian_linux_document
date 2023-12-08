---
dg-publish: false
---
```toc
```

视频教程链接

[【狂神说Java】Redis最新超详细版教程通俗易懂](https://www.bilibili.com/video/BV1S54y1R7SB?p=1&vd_source=ccbe0c793ac5e34ebb735794692f049e)

参考链接：

[官网](https://redis.io/)

[中文官网](https://www.redis.net.cn/)

[github](https://github.com/redis/redis)

## 简介
Redis（<font color=#FF0000>Re</font>mote <font color=#FF0000>Di</font>ctionary <font color=#FF0000>S</font>erver )，即<font color=#FF0000>远程字典服务</font>，是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。

redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件，并且在此基础上实现了master-slave(主从)同步


Redis是Remote Dictionary Server(远程词典服务)的缩写，Redis 是完全开源免费的，遵守BSD协议的NOSQL数据库，Redis使用C语言编写,它的数据模型为 key-value。
Redis是一个单进程单线程，非阻塞I/O
Redis 与其他 key - value 缓存产品有以下三个特点：

    Redis支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。
    Redis不仅支持简单的key-value(string)类型的数据，同时还提供list[列表]，set[集合]，zset[有序集合]，hash[hash]等数据结构的存储。
    Redis支持服务器主从模式[集群-高可用]。

redis和memcache区别

    redis支持数据的持久化，而memcache不支持
    redis不但有string类型的key-value还有更多的数据结构存储，而memcache则只有string类型的key和value
    memcache的集群很弱，而redis支持主从集群的
    端口不同 memcache 11211 redis 6379

**Redis能干嘛？**
1. 内存存储，持久化（rdb，aof）
2. 效率高，可用于高速缓存
3. 发布订阅系统
4. 地图信息分析
5. .........


**Redis特性**
1. 多样的数据类型
2. 持久化
3. 集群
4. 事务
5. ........


## Windows安装

## Linux安装    

1. github下载源码
> git clone https://github.com/redis/redis
2. make
>详细看官方介绍和github readme文件 如果需要ssl等功能  单纯make是最基础功能（也够用了）
3. make install
> 安装到系统默认路径下 /usr/local/bin
4. 创建自己的配置文件,之后使用该配置文件
```bash
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# mkdir redisConfig
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# cd redisConfig/
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# cp /home/liuwh/Desktop/redis/redis.conf ./
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/b/redisConfig# ls
redis.conf
```
5. 修改配置文件
```bash
 #是否在后台执行，yes：后台运行；no：不是后台运行  (默认no)
 daemonize yes
```



6. 通过配置文件启动redis
```bash
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# redis-server ./redisConfig/redis.conf 
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# ps aux|grep redis
root      178950  0.0  0.5 268496 10340 ?        Ssl  09:00   0:00 redis-server 127.0.0.1:6379
root      178974  0.0  0.0 221460   856 pts/1    R+   09:00   0:00 grep --color=auto redis
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# 

```
7. 连接
```bash
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# redis-cli # 可以指定端口 ip 密码 具体看help
127.0.0.1:6379> ping 
PONG
127.0.0.1:6379> set name lwh
OK
127.0.0.1:6379> get name
"lwh"
127.0.0.1:6379> 
```
8. 退出(关闭服务)
```bash
root@iZ2zeda7b4rp7qysxu7wptZ /u/l/bin# redis-cli 
127.0.0.1:6379> SHUTDOWN
not connected> exit
```
## docker安装

[# 史上最详细Docker安装Redis （含每一步的图解）实战](https://blog.csdn.net/weixin_45821811/article/details/116211724)
**配置版本**
```bash
docker run --restart=always --log-opt max-size=100m --log-opt max-file=2 -p 6379:6379 --name myredis -v /home/redis/myredis/myredis.conf:/etc/redis/redis.conf -v /home/redis/myredis/data:/data -d redis redis-server /etc/redis/redis.conf  --appendonly yes  --requirepass 000415
```

**不想配置版本**
```bash
docker run --restart=always --log-opt max-size=100m --log-opt max-file=2 -p 6379:6379 --name myredis -d redis redis-server
```

**连接**
```bash
docker exec -it myredis redis-cli
```

## 性能测试 redis-benchmark
redis自带的压力测试工具  
这个help就挺详细了
```bash
Usage: redis-benchmark [OPTIONS] [COMMAND ARGS...]

Options:
 -h <hostname>      Server hostname (default 127.0.0.1)  	主机名（默认127.0.0.1）
 -p <port>          Server port (default 6379)				Server端口（默认6379）
 -s <socket>        Server socket (overrides host and port) Server套接字（覆盖主机和端口）
 -a <password>      Password for Redis Auth					Redis身份验证的<password>password
 --user <username>  Used to send ACL style 'AUTH username pass'. Needs -a. 用于发送ACL样式的“AUTH username pass”。需要-a 参数配合 
 -u <uri>           Server URI.								服务器uri。
 -c <clients>       Number of parallel connections (default 50) 并行连接数（默认值50）
 -n <requests>      Total number of requests (default 100000)	请求总数（默认为100000）
 -d <size>          Data size of SET/GET value in bytes (default 3) SET/GET值的数据大小（字节）（默认值3）
 --dbnum <db>       SELECT the specified db number (default 0) 选择指定的数据库编号（默认为0）
 -3                 Start session in RESP3 protocol mode.   在RESP3协议模式下启动会话。
 --threads <num>    Enable multi-thread mode.				启用多线程模式。
 --cluster          Enable cluster mode.					启用群集模式。
                    If the command is supplied on the command line in cluster  
                    mode, the key must contain "{tag}". Otherwise, the
                    command will not be sent to the right cluster node.
 --enable-tracking  Send CLIENT TRACKING on before starting benchmark.
 -k <boolean>       1=keep alive 0=reconnect (default 1)
 -r <keyspacelen>   Use random keys for SET/GET/INCR, random values for SADD,
                    random members and scores for ZADD.
                    Using this option the benchmark will expand the string
                    __rand_int__ inside an argument with a 12 digits number in
                    the specified range from 0 to keyspacelen-1. The
                    substitution changes every time a command is executed.
                    Default tests use this to hit random keys in the specified
                    range.
                    Note: If -r is omitted, all commands in a benchmark will
                    use the same key.
 -P <numreq>        Pipeline <numreq> requests. Default 1 (no pipeline).
 -q                 Quiet. Just show query/sec values  		安静模式。只显示查询/秒值
 --precision        Number of decimal places to display in latency output (default 0)
 --csv              Output in CSV format
 -l                 Loop. Run the tests forever
 -t <tests>         Only run the comma separated list of tests. The test
                    names are the same as the ones produced as output.
                    The -t option is ignored if a specific command is supplied
                    on the command line.
 -I                 Idle mode. Just open N idle connections and wait.
 -x                 Read last argument from STDIN.
 --help             Output this help and exit.
 --version          Output version and exit.

Examples:
 Run the benchmark with the default configuration against 127.0.0.1:6379:
   $ redis-benchmark

 Use 20 parallel clients, for a total of 100k requests, against 192.168.1.1:
   $ redis-benchmark -h 192.168.1.1 -p 6379 -n 100000 -c 20

 Fill 127.0.0.1:6379 with about 1 million keys only using the SET test:
   $ redis-benchmark -t set -n 1000000 -r 100000000

 Benchmark 127.0.0.1:6379 for a few commands producing CSV output:
   $ redis-benchmark -t ping,set,get -n 100000 --csv

 Benchmark a specific command line:
   $ redis-benchmark -r 10000 -n 10000 eval 'return redis.call("ping")' 0

 Fill a list with 10000 random elements:
   $ redis-benchmark -r 10000 -n 10000 lpush mylist __rand_int__

 On user specified command lines __rand_int__ is replaced with a random integer
 with a range of values selected by the -r option.

```

```bash
====== SET ======                                                   
  100000 requests completed in 1.48 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1
  host configuration "save": 3600 1 300 100 60 10000
  host configuration "appendonly": no
  multi-thread: n

Latency by percentile distribution:
0.000% <= 0.295 milliseconds (cumulative count 3)
50.000% <= 0.543 milliseconds (cumulative count 51793)
75.000% <= 0.631 milliseconds (cumulative count 76219)
87.500% <= 0.679 milliseconds (cumulative count 88768)
93.750% <= 0.703 milliseconds (cumulative count 93940)
96.875% <= 0.727 milliseconds (cumulative count 97217)
98.438% <= 0.751 milliseconds (cumulative count 98630)
99.219% <= 0.791 milliseconds (cumulative count 99289)
99.609% <= 0.863 milliseconds (cumulative count 99627)
99.805% <= 1.023 milliseconds (cumulative count 99808)
99.902% <= 1.239 milliseconds (cumulative count 99906)
99.951% <= 2.071 milliseconds (cumulative count 99953)
99.976% <= 2.247 milliseconds (cumulative count 99976)
99.988% <= 2.343 milliseconds (cumulative count 99988)
99.994% <= 2.391 milliseconds (cumulative count 99994)
99.997% <= 2.415 milliseconds (cumulative count 99997)
99.998% <= 2.431 milliseconds (cumulative count 99999)
99.999% <= 2.447 milliseconds (cumulative count 100000)
100.000% <= 2.447 milliseconds (cumulative count 100000)

Cumulative distribution of latencies:
0.000% <= 0.103 milliseconds (cumulative count 0)
0.036% <= 0.303 milliseconds (cumulative count 36)
15.358% <= 0.407 milliseconds (cumulative count 15358)
40.458% <= 0.503 milliseconds (cumulative count 40458)
69.754% <= 0.607 milliseconds (cumulative count 69754)
93.940% <= 0.703 milliseconds (cumulative count 93940)
99.402% <= 0.807 milliseconds (cumulative count 99402)
99.700% <= 0.903 milliseconds (cumulative count 99700)
99.796% <= 1.007 milliseconds (cumulative count 99796)
99.863% <= 1.103 milliseconds (cumulative count 99863)
99.894% <= 1.207 milliseconds (cumulative count 99894)
99.924% <= 1.303 milliseconds (cumulative count 99924)
99.939% <= 1.407 milliseconds (cumulative count 99939)
99.950% <= 1.503 milliseconds (cumulative count 99950)
99.957% <= 2.103 milliseconds (cumulative count 99957)
100.000% <= 3.103 milliseconds (cumulative count 100000)

Summary:
  throughput summary: 67476.38 requests per second
  latency summary (msec):
          avg       min       p50       p95       p99       max
        0.539     0.288     0.543     0.711     0.767     2.447
		
	
====== SET ======     
  在1.48秒内完成100000个请求
  50个并行客户端
  3字节有效负载
  保持活动状态：1  只有一台服务器处理该
  主机配置“保存”：3600 1 300 100 60 10000
  主机配置“appendonly”：否
  多线程：否
		
		按百分比分布的延迟：
0.000%<=0.295毫秒（累计计数3）
50.000%<=0.543毫秒（累积计数51793）
75.000%<=0.631毫秒（累计计数76219）
87.500%<=0.679毫秒（累计计数88768）
93.750%<=0.703毫秒（累计计数93940）
96.875%<=0.727毫秒（累计计数97217）
98.438%<=0.751毫秒（累计计数98630）
99.219%<=0.791毫秒（累计计数99289）
99.609%<=0.863毫秒（累计计数99627）
99.805%<=1.023毫秒（累计计数99808）
99.902%<=1.239毫秒（累计计数99906）
99.951%<=2.071毫秒（累计计数99953）
99.976%<=2.247毫秒（累计计数99976）
99.988%<=2.343毫秒（累计计数99988）
99.994%<=2.391毫秒（累计计数99994）
99.997%<=2.415毫秒（累计计数99997）
99.998%<=2.431毫秒（累计计数99999）
99.999%<=2.447毫秒（累计计数100000）
100.000%<=2.447毫秒（累计计数100000）
延迟的累积分布：
0.000%<=0.103毫秒（累计计数0）
0.036%<=0.303毫秒（累计计数36）
15.358%<=0.407毫秒（累计计数15358）
40.458%<=0.503毫秒（累计计数40458）
69.754%<=0.607毫秒（累计计数69754）
93.940%<=0.703毫秒（累计计数93940）
99.402%<=0.807毫秒（累计计数99402）
99.700%<=0.903毫秒（累计计数99700）
99.796%<=1.007毫秒（累计计数99796）
99.863%<=1.103毫秒（累计计数99863）
99.894%<=1.207毫秒（累计计数99894）
99.924%<=1.303毫秒（累计计数99924）
99.939%<=1.407毫秒（累计计数99939）
99.950%<=1.503毫秒（累计计数99950）
99.957%<=2.103毫秒（累计计数99957）
100.000%<=3.103毫秒（累计计数100000）
总结：
吞吐量汇总：每秒67476.38个请求
延迟摘要（毫秒）：
平均        最小      p50        p95      p99       最大
0.539     0.288     0.543     0.711     0.767     2.447

```
