---
dg-publish: true
---
```toc
```


## 参考
[redis命令介绍](https://www.redis.net.cn/order/)

[redis命令介绍,英文官网 建议新版看英文](https://redis.io/commands/?group=list)

[Redis的9种数据类型](https://blog.csdn.net/hudeyong926/article/details/99540705)

视频教程链接

[【狂神说Java】Redis最新超详细版教程通俗易懂](https://www.bilibili.com/video/BV1S54y1R7SB?p=1&vd_source=ccbe0c793ac5e34ebb735794692f049e)


## 数据库

redis 默认有16个数据库 ，默认使用第一个数据库。
redis.conf中选项决定

```
# Set the number of databases. The default database is DB 0, you can select
# a different one on a per-connection basis using SELECT <dbid> where
# dbid is a number between 0 and 'databases'-1
databases 16
```

### 库操作

| 操作           | 命令             | 示例 | 注意 |
| -------------- | ---------------- | ---- | ---- |
| 切换库         | select \<index\> | select 0     |      |
| 查看库大小     | dbsize           |      |      |
| 获取所有key    | keys *           |      |      |
| 清空当前库     | flushdb          |      |      |
| 清空所有数据库 | flushall         |      |      |

## key操作

| 操作                | 命令                         | 示例                                 | 注意 |
| ------------------- | ---------------------------- | ------------------------------------ | ---- |
| 获取key value       | get \<key\>                  | get name                             |      |
| 设置key  value      | set \<key\> \<value\>        | set name lwh                         |      |
| 获取key是否存在     | exists    \<key\>            | exists name                          |      |
| 移动key至指定数据库 | move \<key\> \<dbIndex\>     | move name  1   将name移动到1号数据库 |      |
| 设置key过期时间     | EXPIRE  \<key\>  \<seconds\> | EXPIRE name 10                       |      |
| 查看key生存时间     | ttl     \<key\>              | ttl name                             |      |
| 删除key             | del       \<key\>            | del name                             |      |
| 查看key数据类型     | type       \<key\>           | type name                            |      |



## 数据类型


### 五大数据类型
**string**

| 操作                                                                                             | 命令                                          | 示例                | 注意 |
| ------------------------------------------------------------------------------------------------ | --------------------------------------------- | ------------------- | ---- |
| 自增 +1                                                                                          | incr  \<key\>                                 | incr number         |  字符串数字操作，如果value无法转换为数字，则失败    |
| 自减 -1                                                                                          | decr  \<key\>                                 | decr number         |      |
| 自增 +x                                                                                          | incrby  \<key\>  \<number\>                   | incrby number 10    |      |
| 自减 -x                                                                                          | decrby  \<key\>  \<number\>                   | decrby number  10   |      |
| 获取指定范围字符                                                                                 | getrang  \<key\> \<start\> \<end\>            | getrang name 1 3    |      |
| 覆盖指定范围字符串 (从start位置开始)                                                             | getrang  \<key\> \<start\> \<string\>         | getrang name 1 "aa" |      |
| key 设置 过期时间  （set with expire）                                                           | setex   \<key\> \<seconds\> \<value\>         | setex key3 30 "aaa" |      |
| key不存在时才能设置       (set if not exist) 分布式锁时候常用                                    | setnx     \<key\> \<value\>                   | setnx key 123       |      |
| 批量获取key                                                                                      | mget   \<key\> \[key\]                        |  mget k1 k2                   |      |
| 批量设置key                                                                                      | mset   \<key\> \<value\> \[key\]  \[value\]   |   mset k1 v1 k2 v2                  |      |
| 批量设置key   （不存在时才能设置）                                                               | msetnx   \<key\> \<value\> \[key\]  \[value\] |      mset k1 v1 k2 v2                   |  原子操作，如果任何一个错误，全部都设置失败    |
| 先获取后设置 (新版本行为不一致了，旧版本为获取指定key值 设置新key值 ) <br/>将给定 key 的值设为 value ，并返回 key 的旧值(old value)。 | getset     \<key\> \<value\>                                    |                     |      |


**list**

这个list跟数据结构的list基本一致 很好理解。

不太想写了 感觉是重复工作  详细看redis官网命令介绍吧  链接在开头

<span style="background:#A0CCF6">对于list 可以使用list做出 栈，双端队列 单端队列  消息队列等形式</span>

**set**

看名字就知道了 就是set

**hash**

与数据结构map一致

**zset**

有序set 可以自己指定排序规则


### 三种特殊类型

**geospatial**

地理空间数据的类型

**hyperloglog**

HyperLogLog 是一种<font color=#FF0000>基数估算</font>算法。所谓基数估算，就是估算在一批数据中，不重复元素的个数有多少。

[# Redis 中 HyperLogLog 的使用场景](https://zhuanlan.zhihu.com/p/265309426)

**bitmap**

位图

**Stream**
流（Stream）# 5.0新增

具体对于数据结构的应用 可以参考上面的链接



结语：虽然后期可能会对这些数据结构的基础操作命令进行示例添加，但是现在认为并不重要，需要时候去查看一下应用场景及命令即可，所以不在此下功夫了。
下一步进行集群搭建和分布式以及持久化进行研究。

