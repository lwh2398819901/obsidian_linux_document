---
dg-publish: true
---
```toc
```

## resize2fs
https://www.cnblogs.com/wj78080458/p/9927058.html

调整ext2\ext3\ext4文件系统的大小，它可以放大或者缩小没有挂载的文件系统的大小。如果文件系统已经挂载，它可以扩大文件系统的大小，前提是内核支持在线调整大小。


**-d**debug-flags

打开各种resize2fs调试特性，如果它们已经编译成二进制文件的话。调试标志应该通过从以下列表中添加所需功能的数量来计算：

2，调试块重定位。

4，调试iNode重定位。

8，调试移动inode表。

**-f**

强制执行，覆盖一些通常强制执行的安全检查。

**-F**

执行之前，刷新文件系统的缓冲区

**-M**

将文件系统缩小到最小值

**-p**

显示已经完成任务的百分比

**-P**

显示文件系统的最小值

**-S**RAID-stride

resize2fs程序将启发式地确定在创建文件系统时指定的RAID步长。此选项允许用户显式地指定RAID步长设置，以便由resize2fs代替。


## route
***route***
```
uos@uos-PC ~/Desktop> route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         10.10.77.1      0.0.0.0         UG    100    0        0 eno1
10.10.77.0      0.0.0.0         255.255.255.0   U     100    0        0 eno1
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
```
***route -n***  
-n ： 将主机名以 IP 的方式显示
```
uos@uos-PC ~/Desktop> route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.10.77.1      0.0.0.0         UG    100    0        0 eno1
10.10.77.0      0.0.0.0         255.255.255.0   U     100    0        0 eno1
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
uos@uos-PC ~/Desktop> 
```

 
   - Destination ：其实就是 Network 的意思； 
   - Gateway ：就是该接口的 Gateway 那个 IP 啦！若为 0.0.0.0 表示需要额外的 IP； 
   -  Genmask ：就是 Netmask 啦！与 Destination 组合成为一部主机或网域； 
   -  Flags ：共有多个旗标可以来表示该网域或主机代表的意义： 
   			-   U：代表该路由可用； 
   			-   G：代表该网域需要经由 Gateway 来帮忙转递； 
   			-   H：代表该行路由为一部主机，而非一整个网域； 
   - Iface ：就是 Interface (接口) 的意思。



## rpm
rpm查看所有已安装软件 rpm -qa

rpm显示软件的安装路径 rpm -ql redis


## readelf

``` bash
liuwh@liuwh-PC ~/D/l/share> readelf -d libmod.so

Dynamic section at offset 0x2e50 contains 21 entries:
  标记        类型                         名称/值
 0x0000000000000001 (NEEDED)             共享库：[libc.so.6]  ## 注意这里 ！！！！ 这里可以看到库文件依赖别的库文件
 0x000000000000000c (INIT)               0x1000
 0x000000000000000d (FINI)               0x1144
 0x0000000000000019 (INIT_ARRAY)         0x3e40
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x3e48
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x260
 0x0000000000000005 (STRTAB)             0x370
 0x0000000000000006 (SYMTAB)             0x298
 0x000000000000000a (STRSZ)              123 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000003 (PLTGOT)             0x4000
 0x0000000000000007 (RELA)               0x420
 0x0000000000000008 (RELASZ)             168 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffe (VERNEED)            0x400
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x3ec
 0x000000006ffffff9 (RELACOUNT)          3
 0x0000000000000000 (NULL)               0x0
liuwh@liuwh-PC ~/D/l/share> readelf -d a.out 

Dynamic section at offset 0x2e10 contains 25 entries:
  标记        类型                         名称/值
 0x0000000000000001 (NEEDED)             共享库：[libmod.so]  ## 注意这里 ！！！！ 这里可以看到可执行程序依赖的库文件
 0x0000000000000001 (NEEDED)             共享库：[libc.so.6]
 0x000000000000000c (INIT)               0x401000
 0x000000000000000d (FINI)               0x4011f4
 0x0000000000000019 (INIT_ARRAY)         0x403e00
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x403e08
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x400308
 0x0000000000000005 (STRTAB)             0x4003b8
 0x0000000000000006 (SYMTAB)             0x400328
 0x000000000000000a (STRSZ)              81 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x404000
 0x0000000000000002 (PLTRELSZ)           72 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x400468
 0x0000000000000007 (RELA)               0x400438
 0x0000000000000008 (RELASZ)             48 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffe (VERNEED)            0x400418
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x40040a
 0x0000000000000000 (NULL)               0x0
liuwh@liuwh-PC ~/D/l/share> 

```

https://blog.csdn.net/weixin_41964962/article/details/107367856