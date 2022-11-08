

```toc
```

配套学习视频选用b站视频：

- <https://www.bilibili.com/video/BV1JV411t7ow?spm_id_from=333.999.0.0>

## 课程主要内容介绍(提示：第一次看不懂没关系，后面会循序渐进展开) <https://www.bilibili.com/video/BV1JV411t7ow?p=2>

TCP:
UDP:

传统：

- ip协议
- 路由协议

<span style="background:#A0CCF6">SDN(Software Defined Network):</span>

- 数据平面（交换机）
- 控制平面（操作系统）

## 1.1 什么是Internet？ <https://www.bilibili.com/video/BV1JV411t7ow?p=3>

![[Pasted image 20220422232133.png]]
![[Pasted image 20220428130310.png]]
端系统：end system
![[Pasted image 20220428130517.png]]
![[Pasted image 20220428130600.png]]

节点：

- 主机及其上运行的应用程序
- 路由器、交换机等网络交换设备

边：

- 接入网链路：主机连接到互联网的链路
- 主干链路：路由器间的链路

协议

## 1.2 网络边缘 <https://www.bilibili.com/video/BV1JV411t7ow?p=4>

[10:30](https://www.bilibili.com/video/BV1JV411t7ow?p=4#t=630.548369)

![[Pasted image 20220425121410.png]]
![[Pasted image 20220425123149.png]]
p2p: peer to peer模式

![[Pasted image 20220425130912.png]]
![[Pasted image 20220425130931.png]]

## 1.3 网络核心 <https://www.bilibili.com/video/BV1JV411t7ow?p=5>

准备学习
![[Pasted image 20220427123600.png]]
信令：
时分多路复用
频分多路复用
码分多路服用
![[Pasted image 20220427124056.png]]
![[Pasted image 20220427124135.png]]

![[Pasted image 20220427124334.png]]
![[Pasted image 20220427124858.png]]
![[Pasted image 20220427125025.png]]

## 1.4 接入网和物理媒体 <https://www.bilibili.com/video/BV1JV411t7ow?p=6>

## 1.5 Internet结构和ISP <https://www.bilibili.com/video/BV1JV411t7ow?p=7>

## 1.6 分组延时、丢失和吞吐量 <https://www.bilibili.com/video/BV1JV411t7ow?p=8>

## 1.7 协议层次和服务模型 <https://www.bilibili.com/video/BV1JV411t7ow?p=9>

## 1.8 历史 <https://www.bilibili.com/video/BV1JV411t7ow?p=10>

## 1.9 小结 <https://www.bilibili.com/video/BV1JV411t7ow?p=11>

## 2.0 应用层概述 <https://www.bilibili.com/video/BV1JV411t7ow?p=12>

## 2.1 应用层原理 <https://www.bilibili.com/video/BV1JV411t7ow?p=13>
- C/S
- P2P
- C/S和p2p混合体
	Napster：https://blog.csdn.net/Jailman/article/details/86158198
	

	
在p2p系统上 Peer:对等体  既是服务器也是客户端

 
 
tcp socket 对应的[[术语解释#tcpip四元组|四元组]]

udp socket 本地二元组

ssl

## 2.2 Web and HTTP <https://www.bilibili.com/video/BV1JV411t7ow?p=14>
web 页
[# uri和url的区别与联系（一看就理解）](https://blog.csdn.net/sinat_38719275/article/details/102607458)
URL：
URI:

HTTP 1.0/1.1/2.0
HTTP 无状态

HTTP ：
- 非持久连接
- 持久连接
	>流水线:假设请求对象  请求10个对象 不等待第一个对象返回 继续请求下一个对象
	>
	>非流水线:假设请求对象  请求10个对象 等待第一个对象返回后再请求下一个对象

往返时间RTT：round-trip-time

36分钟



## 2.3 FTP <https://www.bilibili.com/video/BV1JV411t7ow?p=15>

## 2.4 EMail <https://www.bilibili.com/video/BV1JV411t7ow?p=16>

## 2.5 DNS <https://www.bilibili.com/video/BV1JV411t7ow?p=17>

## 2.6 P2P 应用 <https://www.bilibili.com/video/BV1JV411t7ow?p=18>

## 2.7 CDN <https://www.bilibili.com/video/BV1JV411t7ow?p=19>

## 2.8 TCP 套接字编程 <https://www.bilibili.com/video/BV1JV411t7ow?p=20>

## 2.9 UDP 套接字编程 <https://www.bilibili.com/video/BV1JV411t7ow?p=21>

## 2.10 小结 <https://www.bilibili.com/video/BV1JV411t7ow?p=22>

## 3.1 概述和传输层服务 <https://www.bilibili.com/video/BV1JV411t7ow?p=23>

## 3.2 多路复用和解复用 <https://www.bilibili.com/video/BV1JV411t7ow?p=24>

## 3.3 无连接传输 UDP <https://www.bilibili.com/video/BV1JV411t7ow?p=25>

## 3.4 可靠数据传输的原理 <https://www.bilibili.com/video/BV1JV411t7ow?p=26>

## 3.5 面向连接的传输：TCP <https://www.bilibili.com/video/BV1JV411t7ow?p=27>

## 3.6 拥塞控制原理 <https://www.bilibili.com/video/BV1JV411t7ow?p=28>

## 3.7 TCP拥塞 <https://www.bilibili.com/video/BV1JV411t7ow?p=29>

## 4.1导论 <https://www.bilibili.com/video/BV1JV411t7ow?p=30>

## 4.2 路由器组成 <https://www.bilibili.com/video/BV1JV411t7ow?p=31>

## 4.3 IP Internet Protocol <https://www.bilibili.com/video/BV1JV411t7ow?p=32>

## 4.4 通用转发和SDN <https://www.bilibili.com/video/BV1JV411t7ow?p=33>

## 5.1 导论 <https://www.bilibili.com/video/BV1JV411t7ow?p=34>

## 5.2 路由选择算法 <https://www.bilibili.com/video/BV1JV411t7ow?p=35>

## 5.3 自治系统内部的路由选择 <https://www.bilibili.com/video/BV1JV411t7ow?p=36>

## 5.4 ISP之间的路由选择：BGP <https://www.bilibili.com/video/BV1JV411t7ow?p=37>

## 5.5 SDN控制平面 <https://www.bilibili.com/video/BV1JV411t7ow?p=38>

## 5.6 总结 <https://www.bilibili.com/video/BV1JV411t7ow?p=39>

## 6.1 引论和服务 <https://www.bilibili.com/video/BV1JV411t7ow?p=40>

## 6.2 差错检测和纠正 <https://www.bilibili.com/video/BV1JV411t7ow?p=41>

## 6.3 多点访协议 <https://www.bilibili.com/video/BV1JV411t7ow?p=42>

## 6.4 LANs <https://www.bilibili.com/video/BV1JV411t7ow?p=43>

## 6.5 链路虚拟化 <https://www.bilibili.com/video/BV1JV411t7ow?p=44>

## 6.6 数据中心网络 <https://www.bilibili.com/video/BV1JV411t7ow?p=45>

## 6.7 A day in the life of web request <https://www.bilibili.com/video/BV1JV411t7ow?p=46>

## 8 概述 <https://www.bilibili.com/video/BV1JV411t7ow?p=47>

## 8.1 什么是网络安全 <https://www.bilibili.com/video/BV1JV411t7ow?p=48>

## 8.2 加密原理 <https://www.bilibili.com/video/BV1JV411t7ow?p=49>

## 8.3 认证 <https://www.bilibili.com/video/BV1JV411t7ow?p=50>

## 8.4 报文完整性 <https://www.bilibili.com/video/BV1JV411t7ow?p=51>

## 8.5 密钥分发和证书 <https://www.bilibili.com/video/BV1JV411t7ow?p=52>

## 8.6 各个层次的安全性 <https://www.bilibili.com/video/BV1JV411t7ow?p=53>

## 8.7 防火墙 <https://www.bilibili.com/video/BV1JV411t7ow?p=54>

## 8.8 攻击和对策 <https://www.bilibili.com/video/BV1JV411t7ow?p=55>

## 8.9 总结 <https://www.bilibili.com/video/BV1JV411t7ow?p=56>

## 9.1 软件定义网络 <https://www.bilibili.com/video/BV1JV411t7ow?p=57>

## 9.2 命名数据网络（上） <https://www.bilibili.com/video/BV1JV411t7ow?p=58>

## 9.3 命名数据网络（下） <https://www.bilibili.com/video/BV1JV411t7ow?p=59>

## 9.4 移动优先网络和网络试验设施 <https://www.bilibili.com/video/BV1JV411t7ow?p=60>

## 典型习题-陈双武副教授 <https://www.bilibili.com/video/BV1JV411t7ow?p=61>

## 第一章习题 <https://www.bilibili.com/video/BV1JV411t7ow?p=62>

## 第二章习题 <https://www.bilibili.com/video/BV1JV411t7ow?p=63>

## 第三章习题 <https://www.bilibili.com/video/BV1JV411t7ow?p=64>

## 第四章习题 <https://www.bilibili.com/video/BV1JV411t7ow?p=65>

## 第五章习题 <https://www.bilibili.com/video/BV1JV411t7ow?p=66>

## 第六章习题 <https://www.bilibili.com/video/BV1JV411t7ow?p=67>

## 第八章习题 <https://www.bilibili.com/video/BV1JV411t7ow?p=68>

