---
dg-publish: false
---
```toc
```

## 名词解释

| 名称              | 中文意思 | 解释                                                                                                                   |
| --------------- | ---- | -------------------------------------------------------------------------------------------------------------------- |
| broker          | 代理节点 |   消息中间件的处理节点，一个kafka节点就是一个broker 一个或多个broker可以组成一个集群                                                                                                                   |
| producer        | 生产者  |                                                                                                                      |
| consumer        | 消费者  |                                                                                                                      |
| consumer groups | 消费组  |                                                                                                                      |
| topic           | 主题   |     kafka对消息进行归类，发布到kafka集群的每一个消息都需要指定一个主题                                                                                                                 |
| partition       | 分区   |                                                                                                                      |
| replication     | 副本   |                                                                                                                      |
| leader          | 领导   |                                                                                                                      |
| follower        | 跟随者  |                                                                                                                      |
| isr             |      | **ISR**（In-Sync Replicas）能够和 leader 保持同步的 follower + leader本身 组成的集合。<br> **Kafka采用的就是一种完全同步的方案，而ISR是基于完全同步的一种优化机制。** |
| 单播              |      |                                                                                                                      |
| 多播              |      |                                                                                                                      |

## 配置文件

## 示例

**启动kafka**

```bash
 sudo ./kafka-server-start.sh -daemon ../config/server.properties 
```

**创建主题**

```bash
 ./kafka-topics.sh --create --zookeeper 192.168.122.51:2181 --replication-factor 1 --partitions 1 --topic test
```

--zookeeper: zookpeerIP：port
--partitions : 创建分区个数
--topic: 主题名称

**查看主题**

```bash
# 主题列表
liuwh@localhost /u/l/k/bin> ./kafka-topics.sh --list --zookeeper 192.168.122.51:2181 
test
test1
# 主题详细信息
liuwh@localhost /u/l/k/bin> ./kafka-topics.sh --describe --zookeeper 192.168.122.51:2181 --topic test1
Topic:test1     PartitionCount:2        ReplicationFactor:1     Configs:
        Topic: test1    Partition: 0    Leader: 0       Replicas: 0     Isr: 0
        Topic: test1    Partition: 1    Leader: 0       Replicas: 0     Isr: 0
```

### 生产者

**发送主题**

```bash
./kafka-console-producer.sh --broker-list 192.168.122.57:9092 --topic test 
```

--broker-list: kafka集群ip:port

### 消费者

**消费主题**

- 消费方式1：当前偏移量+1位置消费

```bash
./kafka-console-consumer.sh --bootstrap-server 192.168.122.57:9092 --topic test
```

--bootstrap-server:kafka ip:port

- 消费方式2：从头开始消费

```bash
./kafka-console-consumer.sh --bootstrap-server 192.168.122.57:9092 --from-beginning  --topic test
```

--from-beginning :从头开始消费，没有该选项从当前偏移量+1位置消费

**创建消费组**

```bash
./kafka-console-consumer.sh --bootstrap-server 192.168.122.57:9092 --consumer-property group.id=testGroup1 --from-beginning --topic test
```

--consumer-property group.id=testGroup1   ：消费者协议  组id=xxx

查看消费组及信息

```bash
# 查看当前消费这存在那些消费组
./kafka-consumer-groups.sh --bootstrap-server 192.168.122.57:9092 --list

# 查看消费组中的具体信息 ：偏移量、最后一天消息的偏移量、堆积的消息数量等
./kafka-consumer-groups.sh --bootstrap-server 192.168.122.57:9092 --describe --group testGroup1

TOPIC                          PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG        CONSUMER-ID                                       HOST                           CLIENT-ID
test                           0          13              13              0          consumer-1-a386c09b-6864-4027-aadb-910c64d24438   /192.168.122.57                consumer-1
-                              -          -               -               -          consumer-1-de60c019-a5f4-4d40-ad3e-2c3b332add0c   /192.168.122.57                consumer-1
```

**概念**

- 单播消息

在一个kafka的<font color=#FF0000>topic</font>分区中，在同一个消费组中启动<font color=#FF0000>多个</font>消费者，那么同一消费组中只有<font color=#FF0000>一个消费者可以收到订阅的topic</font>中的消息，也就是说<font color=#FF0000>同一个消费组中只能有一个消费者能消费该partition</font>的消息。

- 多播消息

不同的消费组订阅同一个partition中，消费组之间互不影响，那么每个消费组都能消费消息，如下在不同消费组中启动的两个消费客户端都可以收到消息topic的消息（这里的topic只有一个partition）。

> 总结：
> 1.一个partition只能被同一消费组中的一个消费者消费，是为了保证消息的顺序性
> 2.partition数量决定了同一消费组中消费者的数量，建议设置消费组中的消费者数量不要超过partition的数量
> 3.partition个数决定kafka 中topic 的并行度，所以想要提高topic的消费能力，应该增大partition数

![[Pasted image 20220826104930.png]]
![[Pasted image 20220826104942.png]]
![[Pasted image 20220826105015.png]]

## docker搭建kafka集群

<https://blog.csdn.net/playadota/article/details/84783825>
