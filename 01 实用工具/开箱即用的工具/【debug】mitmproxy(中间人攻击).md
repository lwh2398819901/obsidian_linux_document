---
## dg-publish: false
---
```toc
```

**提示：部分内容由chatgpt参与创作，本人不保证真实、准确性，但是也是经过本人审核过的**

## 简介
**前置知识：**

- [[网络协议#TCP|TCP]]

- [[网络协议#SSL/TLS|SSL/TLS]]

- [[中间人攻击]]




**文档及参考链接:**

- [**官方网站：https://mitmproxy.org/**](https://mitmproxy.org/)

- [**官方文档：https://docs.mitmproxy.org/stable/**](https://docs.mitmproxy.org/stable/)

- [**中文介绍：https://ptorch.com/docs/10/mitmproxy_introduction**](https://ptorch.com/docs/10/mitmproxy_introduction)

- [**优秀总结：https://blog.wolfogre.com/posts/usage-of-mitmproxy/**](https://blog.wolfogre.com/posts/usage-of-mitmproxy/)

- [**推荐视频教程:mitmproxy抓包工具！！！ 从安装到简单使用     https://www.bilibili.com/video/BV1UC4y1t7EL/?spm_id_from=333.337.search-card.all.click&vd_source=ccbe0c793ac5e34ebb735794692f049e**](https://www.bilibili.com/video/BV1UC4y1t7EL/?spm_id_from=333.337.search-card.all.click&vd_source=ccbe0c793ac5e34ebb735794692f049e)

  教程内的源码下载链接：https://pan.baidu.com/s/1PwdPZld7nCdSV3edjbOQWQ 提取码：wsxc 
  
- [**推荐视频教程:【秒懂】https协议原理 https://www.bilibili.com/video/BV1g34y1C7nk/?spm_id_from=333.999.0.0&vd_source=ccbe0c793ac5e34ebb735794692f049e **](https://www.bilibili.com/video/BV1g34y1C7nk/?spm_id_from=333.999.0.0&vd_source=ccbe0c793ac5e34ebb735794692f049e)


   尤其是后两个教程，我推荐是先看<font color=#FF0000>https原理</font>，然后再看官方文档等,可以更好的理解这个工具想要实现的目标及原理。

**背景：**

在windows平台下，获取浏览器当前浏览网页，并记录标题栏及网址信息。

曾想要做如下尝试：\
<span style="background:#A0CCF6">一. 通过浏览器插件方式获取网页</span>

目前主流的浏览器有以下几种：
1.  Google Chrome：Google Chrome 是由 Google 公司开发的一款浏览器，基于 Blink 渲染引擎。
2.  Mozilla Firefox：Mozilla Firefox 是由 Mozilla 组织开发的一款浏览器，基于 Gecko 渲染引擎。
3.  Microsoft Edge：Microsoft Edge 是由 Microsoft 公司开发的一款浏览器，基于 Chromium 渲染引擎。
4.  Safari：Safari 是由 Apple 公司开发的一款浏览器，基于 WebKit 渲染引擎。
5.  Opera：Opera 是由 Opera Software 公司开发的一款浏览器，基于 Blink 渲染引擎。
6.  UC 浏览器：UC 浏览器是由 UCWeb 公司开发的一款浏览器，基于 Blink 渲染引擎。
7.  360 浏览器：360 浏览器是由奇虎 360 公司开发的一款浏览器，基于 Blink 渲染引擎。
其中，Google Chrome、Microsoft Edge、Opera、UC 浏览器和 360 浏览器使用的是 Blink 渲染引擎，Mozilla Firefox 使用的是 Gecko 渲染引擎，Safari 使用的是 WebKit 渲染引擎。

很明显，每个浏览器插件的开发都是不通用的，看到这么多浏览器我就头大了，当然我依然还是进行了尝试。针对谷歌浏览器写了一个插件。

其实就是照着教程抄了一个，教程传送门在这：
[chrome浏览器插件开发视频教程  https://www.bilibili.com/video/BV1a64y187QR?p=1](https://www.bilibili.com/video/BV1a64y187QR?p=1)

并且 教程内的源码下载链接我也copy过来了

源码下载链接:https://pan.baidu.com/s/1AEn1r1F3yPc1jIs4AMcygQ   
提取码:5ova

总结一下最后放弃这个方案的原因：
- 不同种类的浏览器太多，而且浏览器版本不同，插件的编写方式也不同，这点是最重要的原因。
- 如何让用户安装上插件？我查到如果是在windows平台下，可以用修改注册表方式将插件安装在谷歌或者ie浏览器上，但是对火狐无法这样操作，火狐强制要求用户确认安装插件，这点跟原本想要悄悄安装插件的想法相悖。
- 就算安装插件，用户也可能不使用安装插件的浏览器，或者卸载/禁用插件。

在这些考虑之下，最终决定放弃该方案。


<span style="background:#A0CCF6">二.通过wireshark抓包，解析http协议</span>
这无疑是一条比较艰难的实现方式，理论存在，就差实验。

1. 通过libpcap抓包获取所有数据包，解析http协议
2. 





## 测试

### [[【container】docker|docker部署]]

参考链接 ：[dockerhub:mitmproxy](https://hub.docker.com/r/mitmproxy/mitmproxy/)

#### 用法

```sh
$ docker run --rm -it [-v ~/.mitmproxy:/home/mitmproxy/.mitmproxy] -p 8080:8080 mitmproxy/mitmproxy
```

[-v ~/.mitmproxy:/home/mitmproxy/.mitmproxy] 是可选的：它用于存储生成的 CA 证书。

一旦启动，mitmproxy 将作为 HTTP 代理侦听 `localhost:8080`:
设置系统代理

```sh
$ http_proxy=http://localhost:8080/ curl http://example.com/
$ https_proxy=http://localhost:8080/ curl -k https://example.com/
```

你也可以开始 `mitmdump`通过将其添加到命令行的末尾：

```sh
$ docker run --rm -it -p 8080:8080 mitmproxy/mitmproxy mitmdump
Proxy server listening at http://*:8080
[...]
```

为了 `mitmweb`，还需要暴露8081端口：

```sh
# this makes :8081 accessible to the local machine only
$ docker run --rm -it -p 8080:8080 -p 127.0.0.1:8081:8081 mitmproxy/mitmproxy mitmweb --web-host 0.0.0.0
Web server listening at http://0.0.0.0:8081/
No web browser found. Please open a browser and point it to http://0.0.0.0:8081/
Proxy server listening at http://*:8080
[...]
```

您还可以通过 CLI 直接传递选项：

```sh
$ docker run --rm -it -p 8080:8080 mitmproxy/mitmproxy mitmdump --set ssl_insecure=true
Proxy server listening at http://*:8080
[...]
```

如果 `~/.mitmproxy/mitmproxy-ca.pem`存在于容器中，mitmproxy 将从文件所有者那里假定 uid 和 gid。 有关详细信息，请参阅 mitmproxy [文档](http://docs.mitmproxy.org/en/stable/) 。

## 标签

可以看到可用的发布标签 [在这里](https://hub.docker.com/r/mitmproxy/mitmproxy/tags/) 。

- `dev`始终跟踪 git-master 分支并代表不稳定的开发树。
- `latest`始终指向与最新稳定版本相同的图像，包括错误修复版本（例如， `4.0.0`和 `4.0.1`).
- `X.Y.Z`标签包含具有此版本号的 mitmproxy 版本。

## 安全通知

Docker 镜像中的依赖项在发布时被冻结，并且无法更新 原地。 这意味着我们必须捕获任何错误或安全问题 可能存在。 我们通常不会仅仅为了更新而发布新的 Docker 镜像 依赖性（尽管如果我们意识到一个非常严重的问题，我们可能会这样做）。




## 下载

[**官方网站：https://mitmproxy.org/**](https://mitmproxy.org/)
![[Pasted image 20230419095534.png]]


## 使用
### windows
1. 下载后一路安装下一步即可
![[Pasted image 20230419095646.png]]

2. 安装后可以通过cmd命令行启动`mitmproxy --version`，首先查看一下版本

![[Pasted image 20230419095903.png]]

3. 设置系统代理or设置浏览器代理


启动mitmdump

![[Pasted image 20230419100538.png]]

启动后在用户家目录下会创建一个.mitmproxy文件夹
![[Pasted image 20230419100613.png]]

进入文件夹后，可以看到是证书，只要客户端信任其内置的证书颁发机构，`Mitmproxy`即可即时解密加密的流量(指的是https流量，http裸奔在网络上呢，不需要证书)。

通常，这意味着必须在客户端设备上安装`mitmproxy CA`证书。

1. 通过浏览器下载证书
2. 

3. 浏览器安装证书
4. 手动命令安装证书
5. 双击安装证书
6. 给浏览器安装证书



参考链接：[mitmproxy安装证书](https://ptorch.com/docs/10/mitmproxy-concepts-certificates)

### linux
