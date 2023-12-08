---
dg-publish: true
---
```toc
```
## 简介
Libpcap是Packet Capture Libray的英文缩写，即数据包捕获函数库。该库提供的C函数接口用于捕捉经过指定网络接口的数据包，该接口应该是被设为混杂模式。这个在原始套接字中有提到。
## 功能
Libpcap主要有如下功能：
（1）数据包捕获
捕获流经本网卡的所有原始数据包，甚至对交换设备中的数据包也能够进行捕获，本功能是嗅探器的基础。
（2）自定义数据包发送
构造任意格式的原始数据包，并发送到目标网络，本功能是新协议验证、甚至攻击验证的基础。
（3）流量采集与统计
对所采集到的网络中的流量信息进行按照新规则分类，按指标进行统计，并输出到指定终端。利用这项功能可以分析目标网络的流量特性。
（4）规则过滤
Libpcap自带规则过滤功能，并提供脚本编程接口，能够按照用户编程的方式对已经采集到的数据包进行过滤，以便提高分析的性能。
## 原理
一个包捕获机制包含三个主要部分，分别是面向底层的包捕获引擎，面向中间层的数据包过滤器，面向应用层的用户接口。
Linux操作系统对于数据包的处理流程是从底到上的方式，依次经历网络接口卡、网卡驱动层、数据链路层、IP层、传输层，最后到达应用程序。
Libpcap也是基于这种原理，Libpcap的捕获机制并不影响Linux操作系统中网络协议栈对数据包的处理。
对应用程序而言，Libpcap包捕获机制只是提供了一个统一的API接口，用户只需要按照相关的编程流程，简单地调用若干函数就可以捕获到感兴趣的数据包。
具体来说，Libpcap库主要由三个部分组成，网络分接头、数据包过滤器和用户API。
**（1）网络分接头**
网络分接头（Network Tap）是一种链路层旁路机制，负责采集网卡数据包。
**（2） 数据包过滤器**
数据包过滤器(Packet Filter)是针对数据包的一种过滤机制，在Libpcap中采用BPF(BSD Packet Filter)算法对数据包执行过滤操作，这种算法的基本思想就是基于规则匹配，对伊符合条件的额数据包进行放行。
**（3） 用户API**
用户API是Libpcap面向上层应用程序提供的编程接口，用户通过调用相关的函数实现数据包的捕获或者发送。
具体来说，Libpcap的工作原理可以描述为，当一个数据包到达网卡时，Libpcap利用创建的套接字从链路层驱动程序中获得该数据包的拷贝，即旁路机制，同时通过Tap函数将数据包发给BPF过滤器。
BPF过滤器根据用户已经定义好的过滤过则对数据包进行逐一匹配，若匹配成功则放入内核缓冲区，并传递给用户缓冲区，匹配失败则直接丢弃。如果没有设置过滤规则，所有的数据包都将放入内核缓冲区，并传递给用户缓冲区。
![[Pasted image 20220823140408.png]]
![[Pasted image 20220823140353.png]]
## pcap基本工作流程
（1）**确定将要嗅探的接口**，在linux下是类似eth0的东西。在BSD下是类似xll的东西。可以在一个字符串中声明设备，也可以让pcap提供备选接口（我们想要嗅探的接口）的名字。\
（2）**初始化pcap**，此时才真正告诉pcap我们要嗅探的具体接口，只要我们愿意，我们可以嗅探多个接口。但是如何区分多个接口呢，使用文件句柄。就像读写文件时使用文件句柄一样。我们必须给嗅探任务命名，以至于区分不同的嗅探任务。\
（3）**指定过滤规则**，当我们只想嗅探特殊的流量时（例如，仅仅嗅探TCP/IP包、仅仅嗅探经过端口80的包，等等）我们必须设定一个规则集，“编译”并应用它。这是一个三相的并且紧密联系的过程，规则集存储与字符串中，在“编译”之后会转换成pcap可以读取的格式。“编译过程”实际上是调用自定义的函数完成的，不涉及外部的函数。然后我们可以告诉pcap在我们想要过滤的任何任务上实施。\
（4）**抓包**，最后，告诉pcap进入主要的执行循环中，在此阶段，在接收到任何我们想要的包之前pcap将一直循环等待。在每次抓取到一个新的数据包时，它将调用另一个自定义的函数，我们可以在这个函数中肆意妄为，例如，解析数据包并显示数据内容、保存到文件或者什么都不做等等。\
 **当嗅探完美任务完成时，记得关掉任务。**
**下面是pcap工作流程图(摘自官网）**
![[Pasted image 20220824105218.png]]
## 用户级API

**1）获取数据包捕获描述字**  
**函数名称**：pcap_t *pcap_open_live(char *device, int snaplen, int promisc, int to_ms, char _ebuf)  
**函数功能**：获得用于捕获网络数据包的数据包捕获描述字。  
**参数说明**：device参数为指定打开的网络设备名。snaplen参数定义捕获数据的最大字节数。Promisc 指定是否将网络接口置于混杂模式。to_ms参数指_定超时时间（毫秒）。ebuf参数则仅在pcap_open_live()函数出错返回NULL时用于传递错误消息。

**2）打开保存捕获数据包文件**  
**函数名称**：pcap_t *pcap_open_offline(char *fname, char *ebuf)  
**函数功能**：打开以前保存捕获数据包的文件，用于读取。  
**参数说明**：fname参数指定打开的文件名。该文件中的数据格式与tcpdump和tcpslice兼容。”-“为标准输入。ebuf参数则仅在pcap_open_offline()函数出错返回NULL时用于传递错误消息。

****3）转储数据包**  
**函数名称**：pcap_dumper_t *pcap_dump_open(pcap_t *p, char *fname)  
**函数功能**：打开用于保存捕获数据包的文件，用于写入。  
**参数说明**：fname参数为”-“时表示标准输出。出错时返回NULL。p参数为调用pcap_open_offline() 或pcap_open_live()函数后返回的pcap结构指针，即网卡句柄。fname参数指定打开的文件名，存盘的文件名。如果返回NULL，则可调用pcap_geterr()函数获取错误消息。

**4）查找网络设备**  
**函数名称**：char *pcap_lookupdev(char *errbuf)  
**函数功能**：用于返回可被pcap_open_live()或pcap_lookupnet()函数调用的网络设备名指针。  
**返回值**：如果函数出错，则返回NULL，同时errbuf中存放相关的错误消息。

**5）获取网络号和掩码**

**函数名称**：int pcap_lookupnet(char *device, bpf_u_int32 *netp,bpf_u_int32 *maskp, char *errbuf)  
**函数功能**：获得指定网络设备的网络号和掩码。  
**参数说明**：netp参数和maskp参数都是bpf_u_int32指针。  
**返回值：**如果函数出错，则返回-1，同时errbuf中存放相关的错误消息。

**6)捕获并处理数据包**  
** 函数名称**：int pcap_dispatch(pcap_t *p, int cnt,pcap_handler callback, u_char *user)  
**函数功能**：捕获并处理数据包。  
**参数说明**：cnt参数指定函数返回前所处理数据包的最大值。cnt= -1表示在一个缓冲区中处理所有的数据包。cnt=0表示处理所有数据包，直到产生以下错误之一：读取到EOF；超时读取。callback参数指定一个带有三个参数的回调函数，这三个参数为：一个从pcap_dispatch()函数传递过来的u_char指针，一个pcap_pkthdr结构的指针，和一个数据包大小的u_char指针。  
**返回值**：如果成功则返回读取到的字节数。读取到EOF时则返回零值。出错时则返回-1，此时可调用pcap_perror()或pcap_geterr()函数获取错误消息。

**7)捕获和处理数据包**  
**函数名称**：int pcap_loop(pcap_t *p, int cnt,pcap_handler callback, u_char *user)  
**函数功能**：功能基本与pcap_dispatch()函数相同，只不过此函数在cnt个数据包被处理或出现错误时才返回，但读取超时不会返回。而如果为pcap_open_live()函数指定了一个非零值的超时设置，然后调用pcap_dispatch()函数，则当超时发生时pcap_dispatch()函数会返回。cnt参数为负值时pcap_loop()函数将始终循环运行，除非出现错误。

**8)输出数据包**  
**函数名称**：void pcap_dump(u_char *user, struct pcap_pkthdr *h,u_char *sp)  
**函数功能**：向调用pcap_dump_open()函数打开的文件输出一个数据包。该函数可作为pcap_dispatch()函数的回调函数。

**参数说明:** 参数1: 所建立的文件pcap_dump_open()的返回值,要进行强制转换.;参数2: 数据包特有的内容.;参数 3: 数据包内容指针

**9)编译字串至过滤程序**  
**函数名称**：int pcap_compile(pcap_t *p, struct bpf_program *fp,char *str, int optimize, bpf_u_int32 netmask)  
**函数功能**：将str参数指定的字符串编译到过滤程序中。  
**参数说明**：

-   p pcap_t类型句柄
-   fp是一个bpf_program结构的指针，在pcap_compile()函数中被赋值。
-   str是过滤表达式
-   optimize 表示是否需要优化过滤表达式。
-   netmask参数指定本地网络的网络掩码。

**10)指定过滤程序**  
**函数名称**：int pcap_setfilter(pcap_t _p, struct bpf_program _fp)  
**函数功能**：指定一个过滤程序。  
**参数说明：**fp参数是bpf_program结构指针，通常取自pcap_compile()函数调用。  
** 返回值__：出错时返回-1；成功时返回0

**11)获取下一个数据包**  
**函数名称**：u_char _pcap_next(pcap_t _p, struct pcap_pkthdr *h)  
** 函数功能__：返回指向下一个数据包的u_char指针

**12)获取数据链路层类型**  
**函数名称：*_int pcap_datalink(pcap_t _p)  
** 函数功能__：返回数据链路层类型，例如DLT_EN10MB

**13)获取快照参数值**  
**函数名称**：int pcap_snapshot(pcap_t _p)  
** 函数功能_*：返回pcap_open_live被调用后的snapshot参数值

**14)检测字节顺序**  
**函数名称**：int pcap_is_swapped(pcap_t *p)  
**函数功能：**返回当前系统主机字节与被打开文件的字节顺序是否不同

**15)获取主版本号**  
** 函数名称**：int pcap_major_version(pcap_t *p)  
**函数功能**：返回写入被打开文件所使用的pcap函数的主版本号

**16)获取辅版本号**  
**函数名称**：int pcap_minor_version(pcap_t _p)  
** 函数功能_*：返回写入被打开文件所使用的pcap函数的辅版本号

**17)结构赋值**  
**函数名称**：int pcap_stats(pcap_t *p, struct pcap_stat *ps)  
**函数功能**：向pcap_stat结构赋值。成功时返回0。这些数值包括了从开始捕获数据以来至今共捕获到的数据包统计。如果出错或不支持数据包统计，则返回-1，且可调用pcap_perror()或pcap_geterr()函数来获取错误消息。

**18)获取打开文件名**  
**函数名称**：FILE *pcap_file(pcap_t *p)  
**函数功能**：返回被打开文件的文件名。

**19)获取描述字号码**  
**函数名称**：int pcap_fileno(pcap_t *p)  
**函数功能**：返回被打开文件的文件描述字号码

**20)显示错误消息**  
**函数名称**：void pcap_perror(pcap_t *p, char *prefix)  
**函数功能**：在标准输出设备上显示最后一个pcap库错误消息。以prefix参数指定的字符串为消息头。示最后一个pcap库错误消息。以prefix参数指定的字符串为消息头。

**21)用来关闭pcap_dump_open打开的文件**  
**函数名称**：void pcap_dump_close(pcap_dumper_t *p); 
**函数功能**：用来关闭pcap_dump_open打开的文件，入参是pcap_dump_open返回的指针；

**21)刷新缓冲区**  
**函数名称**：int pcap_dump_flush(pcap_dumper_t *p) 
**函数功能**：刷新缓冲区，把捕获的数据包从缓冲区真正拷贝到文件；

  
## example
**main.c**
```c
#include <stdio.h>
#include "pcaptest.h"
  
/*
我尽量让每一个例子都完全独立，在一个到两个函数之间完成 而不是去封装重复的内容，这样做在实际开发中肯定是没有好处的，
唯一的好处是 在观看例子的时候 我不需要去理解函数的调用关系，因为基本上就一到两个函数直接调用。
所以哪怕重复 我也不做修改，反而可能会刻意重复。
参考链接  https://www.devdungeon.com/content/using-libpcap-c 这个链接教程非常棒
*/
  
  
int main()
{
    //getHostDeviceInfo();
    //openNetDev(NULL);
    //testCapNext();
    //testCaploop();
    //testCapAndSaveFile();
    //testOpenCapFile();
    //testSetFilter();
    //testParseEtherData();
    //testParseIPData();
    testParseTCPData();
    return 0;
}
```
**pcaptest.h**
```c
#ifndef PCAPTEST_H
#define PCAPTEST_H
  
//获取本地网卡设备信息
void getHostDeviceInfo(void);
  
//打开网卡并获取属性
void testOpenDev(char*network);
  
//测试捕获数据 next方式
void testCapNext(void);
  
//测试捕获方式 loop方式
void testCaploop(void);
  
//设置过滤
void testSetFilter(void);
  
//测试捕获数据保存为文件
void testCapAndSaveFile(void);
  
//测试打开捕获文件并解析
void testOpenCapFile(void);
  
//解析以太网链路层
void testParseEtherData(void);
//解析ip层
void testParseIPData(void);
//解析tcp
void testParseTCPData(void);
  
#endif // PCAPTEST_H
```
**pcaptest.c**
```c
#include "pcaptest.h"
#include <pcap.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <netinet/if_ether.h>
  
//ip地址转换示例
void TestIpv6()
{
    char ipv6_addr[64];
    //内嵌 IPv4 地址的 IPv6 地址
    //该函数将字符串 src 转换为 af 地址族中的网络地址结构，然后将该网络地址结构复制到 dst。af 参数必须是 AF_INET 或 AF_INET6。
    //inet_pton() 成功时返回 1（网络地址已成功转换）。如果 src 不包含表示指定地址族中有效网络地址的字符串，则返回 0。
    //如果 af 不包含有效的地址族，则返回 -1 并将 errno 设置为 EAFNOSUPPORT。
    inet_pton(AF_INET6, "0:0:0:0:0:0:192.168.200.65", ipv6_addr);
    printf("%s\n", ipv6_addr);
  
    char ipv6_str[64] = {'\0'};
    //该函数将af地址族中的网络地址结构src转换为字符串。结果字符串被复制到 dst 指向的缓冲区，该缓冲区必须是一个非 NULL 指针。调用者在参数大小中指定此缓冲区中可用的字节数。
    //成功时，inet_ntop() 返回一个指向 dst 的非 NULL 指针。如果发生错误，则返回 NULL，并设置 errno 以指示错误。
    inet_ntop(AF_INET6, ipv6_addr, ipv6_str, 64);
  
    printf("%s\n", ipv6_str);
}
  
void TestIpv4()
{
    int ipv4_addr;
    inet_pton(AF_INET, "192.168.200.65", &ipv4_addr);
    printf("%d\n", ipv4_addr);
  
    char ipv4_str[64] = {'\0'};
    inet_ntop(AF_INET, &ipv4_addr, ipv4_str, 64);
  
    printf("%s\n", ipv4_str);
}
/*******************************************内部调用**************************************************/
// 解析链路层 ip TCP
void printPKInfo(const struct pcap_pkthdr *header, const u_char *packet){
    printf("数据包捕获时间: %s", ctime(&header->ts.tv_sec));
    printf("数据包捕获长度: %d\n", header->caplen);
    printf("数据包长度 %d\n", header->len);
  
    for (int i = 0; i < header->caplen; ++i) {
        if (i % 8 == 0 && i > 7)
            printf("\n");
  
        printf("%x\t", packet[i]);
    }
    printf("\n");
  
    struct ether_header *eth_header = (struct ether_header *) packet;
    if (ntohs(eth_header->ether_type) != ETHERTYPE_IP) {
        return;
    }
  
    /* Pointers to start point of various headers */
    const u_char *ip_header;
    const u_char *tcp_header;
    const u_char *payload;
    /* Header lengths in bytes */
    const int ethernet_header_length = 14; /* Doesn't change */
    /* Find start of IP header */
    ip_header = packet + ethernet_header_length;
    //ip层前8个位分别四位版本 四位长度
    int ip_header_length = ((*ip_header) & 0x0F);
    //首部长度的记录都是按照4个字节的单位进行增减的，所以我们算出4bit的首部长度的值之后，乘以4个字节，就可以知道首部的长度了，一个字节代表了8bit
    ip_header_length = ip_header_length * 4;
    printf("IP 头长度: %d\n", ip_header_length);
  
    //获取协议层
    u_char protocol = *(ip_header + 9);
    if (protocol != IPPROTO_TCP) {
        printf("Not a TCP packet. Skipping...\n\n");
        return;
    }
  
    //获取ip地址
    int src, dest;
    memcpy(&src, ip_header + 12, 4);
    memcpy(&dest, ip_header + 16, 4);
  
    char ipv4_str[64] = {'\0'};
    inet_ntop(AF_INET, &src, ipv4_str, 64);
    printf("源IP：%s\n", ipv4_str);
  
  
    char ipv4_dest[64] = {'\0'};
    inet_ntop(AF_INET, &dest, ipv4_dest, 64);
    printf("目标IP：%s\n", ipv4_dest);
  
    //tcp头开始位置
    tcp_header = packet + ethernet_header_length + ip_header_length;
  
    uint16_t srcport1, srcport2,destport1,destport2;
    memcpy(&srcport1, tcp_header , 2);
    memcpy(&destport1, tcp_header+ 2, 2);
  
    srcport2 = ntohs(srcport1);
    destport2 = ntohs(destport1);
  
    printf("srcPort:%d\n",srcport2);
    printf("destport:%d\n",destport2);
  
    //tcp长度 tcp首部偏移12字节后 前四位为长度
    int tcp_header_length = ((*(tcp_header + 12)) & 0xF0) >> 4;
    tcp_header_length = tcp_header_length * 4;
    printf("TCP 头长度: %d\n", tcp_header_length);
  
    /* 协议头总大小 */
    int total_headers_size = ethernet_header_length + ip_header_length + tcp_header_length;
    printf("所有协议头总长度: %d bytes\n", total_headers_size);
  
    //数据长度
    int payload_length = header->caplen - (ethernet_header_length + ip_header_length + tcp_header_length);
    printf("有效数据长度: %d bytes\n", payload_length);
    //数据头
    payload = packet + total_headers_size;
    printf("有效数据内存地址: %p\n", payload);
    printf("有效数据:[\t");
    if (payload_length > 0) {
        const u_char *temp_pointer = payload;
        int byte_count = 0;
        while (byte_count++ < payload_length) {
            printf("%c", *temp_pointer);
            temp_pointer++;
        }
  
    }
    printf("]\n\n");
}
  
//回调函数 loop回调用
void my_loop(u_char *args,
             const struct pcap_pkthdr *header,
             const u_char *packet){
  
    printPKInfo(header,packet);
  	return
}
  
//回调函数 保存文件回调
void processPacket(u_char *arg, const struct pcap_pkthdr *pkthdr, const u_char *packet)
{
    /*
    void pcap_dump(u_char *user, struct pcap_pkthdr *h,u_char *sp)
    向调用pcap_dump_open()函数打开的文件输出一个数据包。该函数可作为pcap_dispatch()函数的回调函数。
    */
    pcap_dump(arg, pkthdr, packet);
    printf("Received Packet Size: %d\n", pkthdr->len);
    return;
}
  
//解析数据
void testParseData(pcap_handler func)
{
    char error_buffer[PCAP_ERRBUF_SIZE];
    char *device = pcap_lookupdev(error_buffer);  //获取第一个可以捕获的设备
    if (device == NULL) {
        printf("错误 未找到设备: %s\n", error_buffer);
        return ;
    }
  
    /* 打开网络接口 */
    pcap_t *handle = pcap_open_live(
                         device,//设备名称
                         BUFSIZ,//抓取个数 最大不超过65535
                         1,     //混合模式
                         10000, //超时时间
                         error_buffer);
  
  
    struct bpf_program filter;
    char filter_exp[] = "port 3306";
  
    if (pcap_compile(handle, &filter, filter_exp, 0, 0) == -1) {
        printf("Bad filter - %s\n", pcap_geterr(handle));
        return ;
    }
    if (pcap_setfilter(handle, &filter) == -1) {
        printf("Error setting filter - %s\n", pcap_geterr(handle));
        return ;
    }
  
  
    pcap_loop(handle, 20, func, NULL);
    pcap_close(handle);
    return ;
}
  
//回调函数 解析链路层
void my_parseEth(
    u_char *args,
    const struct pcap_pkthdr *header,
    const u_char *packet
)
{
    //    数据包肯定是大于ether_ header结构，
    //    但我们只想看看数据包标头的第一部分。我们强制编译器将指向数据包的指针视为ether_ header指针结构。
    //    数据包的数据有效载荷到达在标题之后。不同的数据包类型具有不同的报头长度，但以太网报头始终相同（14字节）IP层则为20字节(但存在可变长度，不过一般不会有)
  
    //    struct ether_header
    //    {
    //    uint8_t  ether_dhost[ETH_ALEN];   /* destination eth addr */
    //    uint8_t  ether_shost[ETH_ALEN];   /* source ether addr    */
    //    uint16_t ether_type;              /* packet type ID field */
    //    } __attribute__((__packed__));
  
    struct ether_header *eth_header = (struct ether_header *) packet;
    if (ntohs(eth_header->ether_type) != ETHERTYPE_IP) {
        printf("Not an IP packet. Skipping...\n\n");
        return;
    }
  
    printf("Total packet available: %d bytes\n", header->caplen);
    printf("Expected packet size: %d bytes\n", header->len);
  
    if (ntohs(eth_header->ether_type) == ETHERTYPE_IP) {
        printf("IP\n");
    } else  if (ntohs(eth_header->ether_type) == ETHERTYPE_ARP) {
        printf("ARP\n");
    } else  if (ntohs(eth_header->ether_type) == ETHERTYPE_REVARP) {
        printf("Reverse ARP\n");
    }
}
  
  
//回调函数 解析IP
void my_parseIP(
    u_char *args,
    const struct pcap_pkthdr *header,
    const u_char *packet
)
{
    /* 链路层长度 */
    int ethernet_header_length = 14; /* 不要修改 链路层固定为14字节 */
    struct ether_header *eth_header = (struct ether_header *) packet;
    if (ntohs(eth_header->ether_type) != ETHERTYPE_IP) {
        printf("Not an IP packet. Skipping...\n\n");
        return;
    }
  
    /* ip层指针 */
    const u_char *ip_header;
    /*ip头开头  包头+14（链路层长度）*/
    ip_header = packet + ethernet_header_length;
    //ip层长度 可变 一般为20字节  ip层前8个位分别四位版本 四位长度
    int ip_header_length = ((*ip_header) & 0x0F);
    //首部长度的记录都是按照4个字节的单位进行增减的，所以我们算出4bit的首部长度的值之后，乘以4个字节，就可以知道首部的长度了，一个字节代表了8bit
    ip_header_length = ip_header_length * 4;
    printf("IP header length (IHL) in bytes: %d\n", ip_header_length);
  
    //获取协议层
    u_char protocol = *(ip_header + 9);
    if (protocol != IPPROTO_TCP) {
        printf("Not a TCP packet. Skipping...\n\n");
        return;
    }
  
    //获取ip地址
    int src, dest;
    memcpy(&src, ip_header + 12, 4);
    memcpy(&dest, ip_header + 16, 4);
  
    char ipv4_str[64] = {'\0'};
    inet_ntop(AF_INET, &src, ipv4_str, 64);
    printf("%s\n", ipv4_str);
  
  
    char ipv4_dest[64] = {'\0'};
    inet_ntop(AF_INET, &dest, ipv4_dest, 64);
    printf("%s\n", ipv4_dest);
}
  
/*******************************************外部调用**************************************************/
//获取本地网卡设备信息
void getHostDeviceInfo()
{
    //interface结构体
    pcap_if_t *devlist, *curr;
    //网络地址类
    pcap_addr_t *addr;
    char errbuf[PCAP_ERRBUF_SIZE];
  
    //查找所有设备
    if (pcap_findalldevs(&devlist, errbuf)) {
        printf("pcap: %s\n", errbuf);
        return ;
    }
    //遍历设备
    for (curr = devlist; curr; curr = curr->next) {
        for (addr = curr->addresses; addr; addr = addr->next) {
            struct sockaddr *realaddr;
            if (addr->addr)
                realaddr = addr->addr;
            else if (addr->dstaddr)
                realaddr = addr->dstaddr;
            else
                continue;
  
            //ipv4或ipv6
            if (realaddr->sa_family == AF_INET || realaddr->sa_family == AF_INET6) {
                //打印属性
                struct sockaddr_in *sin = (struct sockaddr_in *) realaddr;
                if (sin->sin_addr.s_addr) {
                    printf("dev_name: %s\t desc:%s\t flags:%d\t ip:%s\n", curr->name,
                           curr->description, curr->flags, inet_ntoa(sin->sin_addr));
                }
            }
        }
    }
    //释放资源
    pcap_freealldevs(devlist);
}
  
void testOpenDev(char *network)
{
    char *networkIF = NULL;
    char errbuf[PCAP_ERRBUF_SIZE];
    //获取第一个合适的网络接口的字符串指针
    if (network != NULL) {
        networkIF = network;
    } else {
        networkIF = pcap_lookupdev(errbuf);
    }
  
    if (networkIF == NULL) {
        printf("err:%s\n", errbuf);
        return ;
    }
  
    printf("interName : %s\n", networkIF);
    //打开网络接口
    /*
    pcap_t * pcap_open_live(const char * device, int snaplen, int promisc, int to_ms, char * errbuf)
  
    device : 网络接口字符串，可以直接使用硬编码。
    snaplen: 对于每个数据包，从开头要抓多少个字节，我们可以设置这个值来只抓每个数据包的头部，而不关心具体的内容。
             典型的以太网帧长度是1518字节，但其他的某些协议的数据包会更长一点，但任何一个协议的一个数据包长度都必然小于65535个字节。
    promisc: 指定是否打开混杂模式(Promiscuous Mode)，0表示非混杂模式，任何其他值表示混合模式。
             如果要打开混杂模式，那么网卡必须也要打开混杂模式，可以使用如下的命令打开eth0混杂模式：ifconfig eth0 promisc
    to_ms:   指定需要等待的毫秒数，超过这个数值后就会立即返回。0表示一直等待直到有数据包到来。
    errbuf:  存放出错信息的数组。
  
    */
    pcap_t *pcap =  pcap_open_live(networkIF, 65535, 0, 0, errbuf);
    if (pcap == NULL) {
        printf("err:%s\n", errbuf);
        return ;
    }
  
    /*
    int pcap_lookupnet(char *device, bpf_u_int32 * netp, bpf_u_int32 * maskp, char *errbuf);
    功能：获得指定网络设备的网络号和掩码
    函数:
    device: 网络设备名
    netp: 存放网络号的指针
    maskp: 存放掩码的指针
    errbuf: 存放出错信息
    返回值：成功：0，失败： -1
    */
    bpf_u_int32 buf, mask;
    if (pcap_lookupnet(networkIF, &buf, &mask, errbuf) != 0) {
        printf("err:%s\n", errbuf);
        return ;
    }
  
    char ipaddr[64] = {'\0'};
    //获取本地ip地址方式未找到 暂时先使用如下方式
    {
        //interface结构体
        pcap_if_t *devlist, *curr;
        //网络地址类
        pcap_addr_t *addr;
        char errbuf[PCAP_ERRBUF_SIZE];
  
        //查找所有设备
        if (pcap_findalldevs(&devlist, errbuf)) {
            printf("pcap: %s\n", errbuf);
            return ;
        }
        //遍历设备
        for (curr = devlist; curr; curr = curr->next) {
            for (addr = curr->addresses; addr; addr = addr->next) {
                struct sockaddr *realaddr;
                if (addr->addr)
                    realaddr = addr->addr;
                else if (addr->dstaddr)
                    realaddr = addr->dstaddr;
                else
                    continue;
  
                //ipv4或ipv6
                if (realaddr->sa_family == AF_INET || realaddr->sa_family == AF_INET6) {
                    //拷贝
                    struct sockaddr_in *sin = (struct sockaddr_in *) realaddr;
                    if (sin->sin_addr.s_addr && !strcmp(curr->name, networkIF)) {
                        strcpy(ipaddr, inet_ntoa(sin->sin_addr));
                        break;
                    }
                }
            }
        }
        //释放资源
        pcap_freealldevs(devlist);
    }
    printf("ipAddr:%s\n", ipaddr);
    char ipv4_str[64] = {'\0'};
    inet_ntop(AF_INET, &buf, ipv4_str, 64);
    printf("网络号: %s\n", ipv4_str);
    inet_ntop(AF_INET, &mask, ipv4_str, 64);
    printf("mask掩码: %s\n", ipv4_str);
  
  
    /*
    struct pcap_pkthdr
    {
    struct timeval ts; // 抓到包的时间
    bpf_u_int32 caplen; // 表示抓到的数据长度
    bpf_u_int32 len; // 表示数据包的实际长度
    }
    成功返回捕获数据包的地址，失败返回 NULL
    */
    struct pcap_pkthdr pkthdr;
    pcap_next(pcap, &pkthdr);
    printf("数据包捕获时间: %s", ctime(&pkthdr.ts.tv_sec));
    printf("数据包捕获长度: %d\n", pkthdr.caplen);
    printf("数据包长度 %d\n", pkthdr.len);
  
    /*
    struct pcap_stat {
        u_int ps_recv;      // number of packets received
        u_int ps_drop;      // number of packets dropped
        u_int ps_ifdrop;    // drops by interface -- only supported on some platforms
    };
    */
    struct pcap_stat stat;
    pcap_stats(pcap, &stat);
    printf("recv: %d\t drop: %d\t ifdrop: %d\n", stat.ps_recv, stat.ps_drop, stat.ps_ifdrop);
  
    //关闭网络接口
    /* 在操作为网络接口后，我们应该要释放它：
    void pcap_close(pcap_t * p)
     该函数用于关闭pcap_open_live()获取的pcap_t的网络接口对象并释放相关资源。
    */
    pcap_close(pcap);
}
  
void testCapNext()
{
    char error_buffer[PCAP_ERRBUF_SIZE];
    char *device = pcap_lookupdev(error_buffer);  //获取第一个可以捕获的设备
    if (device == NULL) {
        printf("错误 未找到设备: %s\n", error_buffer);
        return ;
    }
  
    /* 打开网络接口 */
    pcap_t *handle = pcap_open_live(
                         device,//设备名称
                         BUFSIZ,//抓取个数 最大不超过65535
                         1,     //混合模式
                         10000, //超时时间
                         error_buffer);
  
  
    /*
     获取下一个数据包
     u_char _pcap_next(pcap_t _p, struct pcap_pkthdr *h)
     返回指向下一个数据包的u_char指针
    */
    struct pcap_pkthdr packet_header;
    const u_char *packet = pcap_next(handle, &packet_header);
    if (packet == NULL) {
        printf("没有抓取到包\n");
        return ;
    }
    printPKInfo(&packet_header,packet);
    pcap_close(handle);
}
  
void testCaploop()
{
    char error_buffer[PCAP_ERRBUF_SIZE];
    char *device = pcap_lookupdev(error_buffer);  //获取第一个可以捕获的设备
    if (device == NULL) {
        printf("错误 未找到设备: %s\n", error_buffer);
        return ;
    }
  
    /* 打开网络接口 */
    pcap_t *handle = pcap_open_live(
                         device,//设备名称
                         BUFSIZ,//抓取个数 最大不超过65535
                         1,     //混合模式
                         10000, //超时时间
                         error_buffer);
  
    /*
    int pcap_loop(pcap_t *p, int cnt, pcap_handler callback, u_char *user)
    p:需要捕获的设备
    cnt:捕获的包个数 0 代表一直捕获
    callback：回调函数 原型如下
    user: 回调函数的参数
  
    typedef void (*pcap_handler)(u_char *args, const struct pcap_pkthdr *header,
                 const u_char *packet);
     args: 回调函数传递的参数 user
     header: 捕获包信息
     packet: 数据包
    */
  
    pcap_loop(handle, 0, my_loop, NULL);
    pcap_close(handle);
    return ;
}
  
void testSetFilter()
{
    char error_buffer[PCAP_ERRBUF_SIZE];
    char *device = pcap_lookupdev(error_buffer);  //获取第一个可以捕获的设备
    if (device == NULL) {
        printf("错误 未找到设备: %s\n", error_buffer);
        return ;
    }
  
    /* 打开网络接口 */
    pcap_t *handle = pcap_open_live(
                         device,//设备名称
                         BUFSIZ,//抓取个数 最大不超过65535
                         1,     //混合模式
                         10000, //超时时间
                         error_buffer);
  
    //设置过滤
    struct bpf_program filter;
    char filter_exp[] = "port 80";
  
    //将过滤字符串放入bpf_program结构体
    if (pcap_compile(handle, &filter, filter_exp, 0, 0) == -1) {
        printf("Bad filter - %s\n", pcap_geterr(handle));
        return ;
    }
  
    //设置过滤
    if (pcap_setfilter(handle, &filter) == -1) {
        printf("Error setting filter - %s\n", pcap_geterr(handle));
        return ;
    }
  
    /*捕获数据包*/
    pcap_loop(handle, 0, my_loop, NULL);
    pcap_close(handle);
}
  
  
void testCapAndSaveFile()
{
    char error_buffer[PCAP_ERRBUF_SIZE];
    char *device = pcap_lookupdev(error_buffer);  //获取第一个可以捕获的设备
    if (device == NULL) {
        printf("错误 未找到设备: %s\n", error_buffer);
        return ;
    }
  
    /* 打开网络接口 */
    pcap_t *handle = pcap_open_live(
                         device,//设备名称
                         BUFSIZ,//抓取个数 最大不超过65535
                         1,     //混合模式
                         10000, //超时时间
                         error_buffer);
  
    /*打开需要写入的文件*/
    pcap_dumper_t *out_pcap = pcap_dump_open(handle, "mysql_test.pcapng");
  
    /*捕获数据包并且写入文件*/
    pcap_loop(handle, 20, processPacket, (u_char *)out_pcap);
  
    /*刷新*/
    pcap_dump_flush(out_pcap);
    //关闭文件
    pcap_dump_close(out_pcap);
    pcap_close(handle);
}
  
void testOpenCapFile()
{
    char error_buffer[PCAP_ERRBUF_SIZE];
    pcap_t *handle = pcap_open_offline("mysql_test.pcapng", error_buffer);
  
    struct bpf_program filter;
    char filter_exp[] = "tcp dst port 3306";
  
    if (pcap_compile(handle, &filter, filter_exp, 0, 0) == -1) {
        printf("Bad filter - %s\n", pcap_geterr(handle));
        return ;
    }
    if (pcap_setfilter(handle, &filter) == -1) {
        printf("Error setting filter - %s\n", pcap_geterr(handle));
        return ;
    }
    pcap_loop(handle, 0, my_loop, NULL);
}
  
  
void testParseEtherData()
{
    testParseData(my_parseEth);
}
  
void testParseIPData()
{
    testParseData(my_parseIP);
}
  
void testParseTCPData()
{
    testParseData(my_loop);
}
```
## 参考链接
[【数据包捕获技术】libpcap原理](https://blog.csdn.net/yilun/article/details/124846435)

[Linux下网络数据包捕获-Libpcap](https://blog.csdn.net/chen1415886044/article/details/115421533)

[libpcap api接口及详细教程](https://blog.csdn.net/stoneliul/article/details/8615122)

[Linux网络编程——原始套接字编程](https://blog.csdn.net/tennysonsky/article/details/44676377)

[Linux下使用libpcap进行网络抓包并保存到文件](https://blog.csdn.net/lvjian_/article/details/88575458)

[c语言 libpcap示例](https://www.devdungeon.com/content/using-libpcap-c)

[tcpdump官网](https://www.tcpdump.org/)