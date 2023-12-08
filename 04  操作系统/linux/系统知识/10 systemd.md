---
dg-publish: false
---
```toc
```
参考链接 
[Linux：使用systemd管理进程 ](https://www.cnblogs.com/Rohn/p/14489587.html)
[# 可能是史上最全面易懂的 Systemd 服务管理教程！( 强烈建议收藏 )](https://cloud.tencent.com/developer/article/1516125)
					


## 概述

systemd是目前Linux系统上主要的系统守护进程管理工具，由于init一方面对于进程的管理是串行化的，容易出现阻塞情况，另一方面init也仅仅是执行启动脚本，并不能对服务本身进行更多的管理。所以从CentOS 7 开始也由systemd取代了init作为默认的系统进程管理工具。

systemd所管理的所有系统资源都称作Unit，通过systemd命令集可以方便的对这些Unit进行管理。比如`systemctl`、`hostnamectl`、`timedatectl`、`localctl`等命令，这些命令虽然改写了init时代用户的命令使用习惯（不再使用chkconfig、service等命令），但确实也提供了很大的便捷性。

### 特点

-   提供了服务按需启动 的能力，使得特定的服务只有在真定被请求时才启动，显著提高开机启动效率
-   允许更多的进程并行启动： Systemd 通过 **Socket** 缓存、**DBus** 缓存和建立临时挂载点等方法进一步解决了启动进程之间的依赖，做到了所有系统服务并发启动。
-   使用 CGroup 跟踪和管理进程的生命周期：通过 **CGroup** 不仅能够实现服务之间访问隔离，限制特定应用程序对系统资源的访问配额，还能更精确地管理服务的生命周期。
-   专用的系统日志管理服务：**Journald**，这个服务的设计初衷是克服现有 Syslog 服务的日志内容易伪造和日志格式不统一等缺点，Journald 用 二进制格式 保存所有的日志信息，因而日志内容很难被手工伪造。Journald 还提供了一个 journalctl 命令来查看日志信息，这样就使得不同服务输出的日志具有相同的排版格式， 便于数据的二次处理。

## systemctl语法

```bash
systemctl [OPTIONS...] {COMMAND} ...
```
command：(部分)
-   start：启动指定的unit，例如`systemctl start nginx`
-   stop：关闭指定的unit，例如`systemctl stop nginx`
-   restart：重启指定unit，例如`systemctl restart nginx`
-   reload：重载指定unit，例如`systemctl reload nginx`
-   enable：系统开机时自动启动指定unit，前提是配置文件中有相关配置，例如`systemctl enable nginx`
-   disable：开机时不自动运行指定unit，例如`systemctl disable nginx`
-   status：查看指定unit当前运行状态，例如`systemctl status nginx`


