---
## dg-publish: false
---
```toc
```

## 简介
前置知识：

- [[网络协议#TCP|TCP]]

- [[网络协议#SSL/TLS|SSL/TLS]]

- [[中间人攻击]]


文档及参考链接:

- [**官方网站：https://mitmproxy.org/**](https://mitmproxy.org/)
- [**官方文档：https://docs.mitmproxy.org/stable/**](https://docs.mitmproxy.org/stable/)
- [**中文介绍：https://ptorch.com/docs/10/mitmproxy_introduction**](https://ptorch.com/docs/10/mitmproxy_introduction)
- [**优秀总结：https://blog.wolfogre.com/posts/usage-of-mitmproxy/**](https://blog.wolfogre.com/posts/usage-of-mitmproxy/)
- [**  **]()
- [**  **]()
- [**  **]()

类似工具
[[]]


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
