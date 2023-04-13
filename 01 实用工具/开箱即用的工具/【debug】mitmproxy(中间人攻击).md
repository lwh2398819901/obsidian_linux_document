---
dg-publish: false
---
```toc
```

## 简介
-   [**官方网站：https://mitmproxy.org/**](https://mitmproxy.org/)
-   [**官方文档：https://docs.mitmproxy.org/stable/**](https://docs.mitmproxy.org/stable/)
-   [**优秀总结：https://blog.wolfogre.com/posts/usage-of-mitmproxy/**](https://blog.wolfogre.com/posts/usage-of-mitmproxy/)


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

-   `dev`始终跟踪 git-master 分支并代表不稳定的开发树。
-   `latest`始终指向与最新稳定版本相同的图像，包括错误修复版本（例如， `4.0.0`和 `4.0.1`).
-   `X.Y.Z`标签包含具有此版本号的 mitmproxy 版本。

## 安全通知

Docker 镜像中的依赖项在发布时被冻结，并且无法更新 原地。 这意味着我们必须捕获任何错误或安全问题 可能存在。 我们通常不会仅仅为了更新而发布新的 Docker 镜像 依赖性（尽管如果我们意识到一个非常严重的问题，我们可能会这样做）。
