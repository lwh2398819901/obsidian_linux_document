
```toc
```

## zookeeper 简介
https://blog.csdn.net/zhangzq86/article/details/80981234


<https://zhuanlan.zhihu.com/p/62526102>

## 启动与停止服务

```bash
# 启动服务
/usr/local/zookeeper/bin/zkServer.sh start
# 停止服务
/usr/local/zookeeper/bin/zkServer.sh start stop
```

## watch

<https://zhuanlan.zhihu.com/p/191481277>

## 节点


https://www.jianshu.com/p/cbe5f0dd6cca
![[Pasted image 20220830084233.png]]
![[Pasted image 20220830085111.png]]

**持久节点（PERSISTENT）**

所谓持久节点，是指在节点创建后，就一直存在，直到有删除操作来主动清除这个节点——不会因为创建该节点的客户端会话失效而消失。

**持久顺序节点（PERSISTENT_SEQUENTIAL）**

这类节点的基本特性和上面的节点类型是一致的。额外的特性是，在ZK中，每个父节点会为他的第一级子节点维护一份时序，会记录每个子节点创建的先后顺序。基于这个特性，在创建子节点的时候，可以设置这个属性，那么在创建节点过程中，ZK会自动为给定节点名加上一个数字后缀，作为新的节点名。这个数字后缀的范围是整型的最大值。


**临时节点（EPHEMERAL）**

和持久节点不同的是，临时节点的生命周期和客户端会话绑定。也就是说，如果客户端会话失效，那么这个节点就会自动被清除掉。注意，这里提到的是会话失效，而非连接断开。另外，在临时节点下面不能创建子节点。

 
**临时顺序节点（EPHEMERAL_SEQUENTIAL）**

 可以用来实现分布式锁

## 配置文件

### zoo.cfg

<https://blog.csdn.net/qinwuxian19891211/article/details/123709087>
<https://blog.csdn.net/nan8426/article/details/117587645>

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

### myid

标识zookeeper id 不可重复


### 配置zookeeper服务

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


## 集群搭建
https://blog.csdn.net/weixin_50642075/article/details/109613621

## 分布式锁
![[Pasted image 20220830090101.png]]



## 操作
**客户端链接集群**

```bash
zkCli.sh -server ip:port
```


https://blog.csdn.net/qq_37555071/article/details/114790538




