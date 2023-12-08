---
dg-publish: false
---
```toc
```

## 简介

[我们能用zookeeper做什么](https://blog.csdn.net/zhangzq86/article/details/80981234)

[什么是ZooKeeper？](https://zhuanlan.zhihu.com/p/62526102)

## znode节点
![[Pasted image 20220830085111.png]]

### znode结构

-   data：保存数据
-   acl权限：定义什么用户可以操作这个节点，且操作权限
    -   c 创建权限 允许在该节点下创建子节点
    -   w 写权限 允许更新该节点的数据
    -   r 读权限 允许读取数据及子节点列表信息
    -   d 删除权限 允许删除该节点子节点
    -   a 管理者权限 允许对acl进行设置
-   stat : 描述当前znode元数据
-   child ：当前节点的子节点

```bash
[zk: localhost:2181(CONNECTED) 11] get -s /test1 
aaa
cZxid = 0x4
ctime = Thu Dec 08 08:04:34 UTC 2022
mZxid = 0x5
mtime = Thu Dec 08 08:23:08 UTC 2022
pZxid = 0x4
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 3
numChildren = 0

```



![[Pasted image 20221208162740.png]]

[一文了解Zookeeper数据节点-znode](https://www.jianshu.com/p/cbe5f0dd6cca)

### znode类型

**持久节点（PERSISTENT）**
```bash
create /nodeName
```
所谓持久节点，是指在节点创建后，就一直存在，直到有删除操作来主动清除这个节点——不会因为创建该节点的客户端会话失效而消失。

**持久顺序节点（PERSISTENT_SEQUENTIAL）**

```bash
create -s /nodeName
```
这类节点的基本特性和上面的节点类型是一致的。额外的特性是，在ZK中，每个父节点会为他的第一级子节点维护一份时序，会记录每个子节点创建的先后顺序。基于这个特性，在创建子节点的时候，可以设置这个属性，那么在创建节点过程中<font color=#FF0000>，ZK会自动为给定节点名加上一个数字后缀，作为新的节点名。</font>这个数字后缀的范围是整型的最大值。


**临时节点（EPHEMERAL）**

和持久节点不同的是，临时节点的生命周期和客户端会话绑定。也就是说，如果客户端会话失效，那么这个节点就会自动被清除掉。注意，这里提到的是会话失效，而非连接断开。另外，在临时节点下面不能创建子节点。

```bash
create -e /nodeName
```
![[Pasted image 20221208165154.png]]


**临时顺序节点（EPHEMERAL_SEQUENTIAL）**

```bash
create -e -s /nodeName
```
 可以用来实现分布式锁


**container节点（3.5.3版本新增）**
```bash
create -c /nodeName
```
容器节点，当容器中没有任何子节点，该容器节点会被zk定期删除（60s）

**TTL节点**
新版本 不稳定
```bash
create -t /nodeName
```
指定节点的到期时间，到期后被zk定时删除  只能通过配置`zookeeper.extendedTypesEnabled=true`开启

### 命令操作
 ![[Pasted image 20221208162501.png]]
 **查询节点**
```bash
ls -R /path # 查看节点路径 包括子节点
get /path # 查看节点数据
get -s /path # 查看元数据
```
 **设置数据**
```bash
set /path  data
```
 **删除节点**
```bash
delete /path   # 普通删除
delete -v "版本号" /path # 乐观锁删除
```
 **权限设置acl**
![[Pasted image 20221209093202.png]]



## 安装
[zookeeper配置文件详解](https://blog.csdn.net/qinwuxian19891211/article/details/123709087)

[zookeeper配置启动及配置文件解析](https://blog.csdn.net/nan8426/article/details/117587645)

<span style="background:#A0CCF6">1. 下载release版本可执行文件包</span>

基于3.7.1
下载安装包：[**https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz**](https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz)

<span style="background:#A0CCF6">2. 配置文件zoo_sample.cfg 官方提供的简单配置示例</span>

解压后，进入conf目录,查看zoo+sample.cfg文件

```
# The number of milliseconds of each tick         
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
dataDir=/tmp/zookeeper
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1

## Metrics Providers
#
# https://prometheus.io Metrics Exporter
#metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
#metricsProvider.httpPort=7000
#metricsProvider.exportJvmInfo=true
```

```bash
# 心跳的间隔时间
tickTime=2000
# 允许follower（相对于 leader 而言的“客户端”）连接并同步到leader的初始化连接时间，它以tickTime的倍数来表示。当超过设置倍数的tickTime时间，则连接失败
initLimit=10
# leader与follower之间发送消息，请求和应答时间长度。如果follower在设置的时间内不能与leader进行通信，那么此follower将被丢弃
syncLimit=5
# 数据目录
dataDir=/data/zookeeper
# 端口号
clientPort=2181

#cluster 集群部署
# 2888表示follower和leader交换消息所使用的端口，3888表示选举leader所使用的端口，这两个端口可以根据实际情况修改
server.1=172.16.6.121:2888:3888    
server.2=172.16.6.122:2888:3888
server.3=172.16.6.123:2888:3888
```


<span style="background:#A0CCF6">3. 修改配置文件示例</span>
```bash
cp zoo_sample.cfg zoo.cfg 

# 修改配置
dataDir=/usr/local/zookeeper/zkdata  # 手动创建一个目录 作为放日志及持久化的目录
```

## 操作


### 启动与停止服务
1. 启动

进入安装包目录/bin目录
```bash
[root@c7-docker-1 bin]# ./zkServer.sh start ../conf/zoo.cfg # 指定配置文件 可以不指定会默认搜索../conf/zoo.cfg
```

2. 查看状态
```bash
[root@c7-docker-1 bin]# ./zkServer.sh status ../conf/zoo.cfg # 指定配置文件 可以不指定会默认搜索../conf/zoo.cfg
```

3. 停止服务器
```bash
[root@c7-docker-1 bin]# ./zkServer.sh stop ../conf/zoo.cfg # 指定配置文件 可以不指定会默认搜索../conf/zoo.cfg
```


其实./zkServer.sh是个shell脚本，可以通过--help看到有什么功能
```bash
[root@c7-docker-1 bin]# ./zkServer.sh  --help
/usr/bin/java
ZooKeeper JMX enabled by default
Using config: /usr/local/zookeeper/apache-zookeeper-3.7.1-bin/bin/../conf/zoo.cfg
Usage: ./zkServer.sh [--config <conf-dir>] {start|start-foreground|stop|version|restart|status|print-cmd}

```

### 配置zookeeper  systemctl服务

```bash
liuwh@localhost /e/s/system> cat /etc/systemd/system/multi-user.target.wants/zookeeper.service
[Unit]
Description=zookeeper
After=network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
ExecStart=/usr/local/zookeeper/bin/zkServer.sh start
ExecReload=/usr/local/zookeeper/bin/zkServer.sh start restart
ExecStop=/usr/local/zookeeper/bin/zkServer.sh start stop
[Install]
WantedBy=multi-user.target
```


### 节点操作
客户端zkCli.sh
```bash
[root@c7-docker-1 bin]# ./zkCli.sh
[zk: localhost:2181(CONNECTED) 0] help   # 查看可用命令
ZooKeeper -server host:port -client-configuration properties-file cmd args
        addWatch [-m mode] path # optional mode is one of [PERSISTENT, PERSISTENT_RECURSIVE] - default is PERSISTENT_RECURSIVE
        addauth scheme auth
        close 
        config [-c] [-w] [-s]
        connect host:port
        create [-s] [-e] [-c] [-t ttl] path [data] [acl]
        delete [-v version] path
        deleteall path [-b batch size]
        delquota [-n|-b|-N|-B] path
        get [-s] [-w] path
        getAcl [-s] path
        getAllChildrenNumber path
        getEphemerals path
        history 
        listquota path
        ls [-s] [-w] [-R] path
        printwatches on|off
        quit 
        reconfig [-s] [-v version] [[-file path] | [-members serverID=host:port1:port2;port3[,...]*]] | [-add serverId=host:port1:port2;port3[,...]]* [-remove serverId[,...]*]
        redo cmdno
        removewatches path [-c|-d|-a] [-l]
        set [-s] [-v version] path data
        setAcl [-s] [-v version] [-R] path acl
        setquota -n|-b|-N|-B val path
        stat [-w] path
        sync path
        version 
        whoami 
Command not found: Command not found help

```

## 持久化

通过日志和快照来持久化，默认两者都开启

## java SDK Curator客户端
暂时用不到

## 分布式锁
暂时用不到
![[Pasted image 20220830090101.png]]
## watch

[Zookeeper的Watch机制](https://zhuanlan.zhihu.com/p/191481277)


## 集群
集群搭建看这个文章 够用了\
[zookeeper集群搭建（详细步骤）](https://blog.csdn.net/weixin_50642075/article/details/109613621)\
[ZooKeeper实战篇之zk集群搭建、zkCli.sh操作、权限控制ACL、ZooKeeper JavaAPI使用](https://blog.csdn.net/qq_37555071/article/details/114790538)
### zk集群中的角色

**leader:** 主节点，又名领导者。用于写入数据，通过选举产生，如果宕机将会选举新的主节点。

**follower:** 子节点，又名追随者，用于实现数据的读取，同时他也是主节点的备选节点，并拥有投票权。

**observer:** 次级子节点，又名观察者。
[zookeeper的观察者详解](https://zhuanlan.zhihu.com/p/42067231)

### myid

标识zookeeper id 不可重复

### 实验
自己实验版本：

四台centos设备：

	1.  192.168.122.30  zk0  
	2. 192.168.122.80  zk1
	3. 192.168.122.117 zk2  
	4. 192.168.122.147  zk3  观察者

分别已经安装了zk 以及jdk8,且单机版本都可运行成功  创建zoo.cfg文件。

关闭防火墙 `systemctl stop firewalld.service`

1. 修改zk0 /zk1/zk2 zoo.cfg文件 
```
# 放zk日志文件和快照的目录
dataDir=/usr/locla/zookeeper/zkdata
# 2888表示follower和leader交换消息所使用的端口，3888表示选举leader所使用的端口，这两个端口可以根据实际情况修改
server.1=192.168.122.30:2888:3888 
server.2=192.168.122.80:2888:3888
server.3=192.168.122.117:2888:3888
server.4=192.168.122.147:2888:3888:observer
```
2. 修改zk3  zoo.cfg文件 单独多加了

在将会配置为zookeeper观察者的节点，添加下面一行：

```text
peerType=observer
```
注：
dataDir是缓存数据路径 日志 快照 myid
2888为组成zookeeper服务器之间的通信端口，3888为用来选举leader的端口
四台虚拟机都需操作

3. 在dataDir目录下创建myid文件 并且写入myid, 写入数字
```
touch myid
echo 1 > myid
```
写入数字看配置

server.<font color=#FF0000>1</font>=192.168.122.30:2888:3888 
  
server.<font color=#FF0000>2</font>=192.168.122.80:2888:3888

server.<font color=#FF0000>3</font>=192.168.122.117:2888:3888

server.<font color=#FF0000>4</font>=192.168.122.147:2888:3888:observer

4. 启动测试
 4台设备都启动
 
 `./zkServer.sh start ../conf/zoo.cfg`

5. 启动客户端链接集群
```bash
zkCli.sh -server ip:port
```
