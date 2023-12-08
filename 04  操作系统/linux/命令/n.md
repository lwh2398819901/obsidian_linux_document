---
dg-publish: false
---
```toc
```

## nm
https://blog.csdn.net/stpeace/article/details/47089585?spm=1001.2101.3001.6650.17&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-17-47089585-blog-115426754.pc_relevant_3mothn_strategy_and_data_recovery&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-17-47089585-blog-115426754.pc_relevant_3mothn_strategy_and_data_recovery&utm_relevant_index=18

## netstat
```
-r：--route，显示路由表信息  
-g：--groups，显示多重广播功能群组组员名单  
-s：--statistics，按照每个协议来分类进行统计。默认的显示IP、IPv6、ICMP、ICMPv6、TCP、TCPv6、UDP和UDPv6 的统计信息。  
-M：--masquerade，显示网络内存的集群池统计信息  
-v：--verbose，命令显示每个运行中的基于公共数据链路接口的设备驱动程序的统计信息  
-W：--wide，不截断IP地址  
-n：进制使用域名解析功能。链接以数字形式展示(IP地址)，而不是通过主机名或域名形式展示  
-N：--symbolic，解析硬件名称  
-e：--extend，显示额外信息  
-p：--programs，与链接相关程序名和进程的PID  
-t：所有的 tcp 协议的端口  
-x：所有的 unix 协议的端口  
-u：所有的 udp 协议的端口  
-o：--timers，显示计时器  
-c：--continuous，每隔一个固定时间，执行netstat命令  
-l：--listening，显示所有监听的端口  
-a：--all，显示所有链接和监听端口  
-F：--fib，显示转发信息库(默认)  
-C：--cache，显示路由缓存而不是FIB  
-Z：--context，显示套接字的SELinux安全上下文
```
**命令使用举例 ：**

> netstat -anp：显示系统端口使用情况  
> netstat -nupl：UDP类型的端口  
> netstat -ntpl：TCP类型的端口  
> netstat -na|grep ESTABLISHED|wc -l：统计已连接上的，状态为"established"  
> netstat -l：只显示所有监听端口  
> netstat -lt：只显示所有监听**tcp**端口  

## nslookup

```bash
liuwh@liuwh-PC ~/Desktop> nslookup www.baidu.com
Server:		211.137.191.26
Address:	211.137.191.26#53

Non-authoritative answer:
www.baidu.com	canonical name = www.a.shifen.com.
Name:	www.a.shifen.com
Address: 39.156.66.18
Name:	www.a.shifen.com
Address: 39.156.66.14
```
[nslookup 入门命令详解](https://zhuanlan.zhihu.com/p/361451835)