
```toc
```

## ps

ps指令，全称 process status，即**进程状态**，相比于`top`指令，`ps`指令展示的是当前进程状态的快照（snapshot），而不是实时更新。
### ps 命令的风格

这个是我之前没注意到的，ps命令的参数其实支持**三种风格**，分别是 UNIX、BSD和GNU，风格不同，意味着**参数输入的形式**也不同。

-   1.如果是 UNIX 风格，则参数前必须带 "-" 连字符
-   2.如果是 BSD 风格，则参数前不能带有 "-" 连字符
-   3.如果是 GNU 风格，则擦书前必须带两个 "-" 连字符

`ps`命令的文档中提到，在实际使用中，可以随意混合这三种风格，但不可避免的是，这种混合**会带来一定的冲突**，典型如下：

```shell
# 这种形式是 BSD 风格，此时的参数 u 表示的是： 采用基于用户的格式展示
$ ps aux | grep nginx
hongxinxie       94342   0.0  0.0  4345072    592   ??  S    10:19上午   0:00.01 nginx: worker process
hongxinxie        8611   0.0  0.0  4320056    600   ??  Ss   五03下午   0:00.03 nginx: master process nginx

# 由于加了 "-" 连字符，此时变为 UNIX 风格，此时的参数 u 表示的是 user，后面需要加上用户名，表示从全部进程中筛选出指定用户的进程
$ ps -aux | grep nginx
ps: No user named 'x'

# 筛选出用户为 root 的进程
$ ps -u root 
```

  
### ps 命令常见参数

ps 命令常见的参数有： -a、-A、-e、-f、-x、-u、-o

1.不管是`-a`、`-A`、`a`，尽管它们有一定的区别，但是大部分场景下可以将其认为是"显示所有进程"。

```shell
# 这是详细说明，可以看到 -a 和 -A 主要区别在于有无session leaders（后面有补充）
-A：all processes （UNIX风格，展示所有进程）
-a：all with tty, except session leaders （UNIX风格，展示所有进程，除了 session leaders）
a：all with tty, including other users （BSD风格，展示跟tty相关的进程，基本等同于 -A）
```

2.`-e`参数等同于`-A`参数，但是`-e`参数不等同于`e`

```shell
# 展示所有进程
$ ps -e
PID TTY          TIME CMD
1 pts/0    00:00:00 bash
12596 pts/1    00:00:00 man

# 展示命令所使用的环境变量
$ ps e
PID TTY      STAT   TIME COMMAND
1   pts/0    Ss+    0:00 /bin/bash PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin HOSTNAME=dea2e5f26346 TERM=xterm
复制代码
```

3.`-f` 与 `f` 的区别：

```shell
# -f 会输出完整的格式，前面ps -A的时候你会发现只输出了 PID、TTY、TIME、CMD，使用 -f 会多出 UID、PPID、C、STIME、TTY等参数
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
root     12613     0  0 06:38 pts/3    00:00:00 bash
root     12660 12613  0 07:51 pts/3    00:00:00 ps -f

# f 参数则是用分层格式来显示进程，表明进程间的父子关系
$ ps f
PID    TTY      STAT   TIME COMMAND
12613 pts/3    Ss     0:00 bash
12659 pts/3    R+     0:00  \_ ps f
12587 pts/1    Ss     0:00 bash
12596 pts/1    S+     0:00  \_ man ps
12608 pts/1    S+     0:00      \_ pager
12569 pts/2    Ss+    0:00 bash
```

  上面的字段信息解释如下：

-   UID：启动这些进程的用户。
-   PID：进程的进程ID。
-   PPID：父进程的进程号(如果该进程是由另一个进程启动的)
-   C：进程生命周期中的CPU利用率
-   STIME：进程启动时的系统时间
-   TTY：进程启动时的终端设备
-   TIME：运行进程需要的累计CPU时间
-   CMD：启动的程序名称

  
4.`-u` 与 `u`的区别（前面讲风格的时候也提过两者的区别）：

```shell
# -u 是UNIX风格，表示展示特定用户的进程
$ ps -u root
PID   TTY          TIME CMD
  1   pts/0    00:00:00 bash
12569 pts/2    00:00:00 bash
12587 pts/1    00:00:00 bash

# u 是BSD风格，表示采用基于用户的格式展示
$ ps u
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  18236  3160 pts/0    Ss+  Jan15   0:00 /bin/bash
root     12569  0.0  0.1  18244  3308 pts/2    Ss+  Jan15   0:00 bash
root     12587  0.0  0.1  18244  3204 pts/1    Ss   06:36   0:00 bash
复制代码
```

上面的字段信息解释如下：

-   VSZ：进程在内存中的大小，以千字节(KB)为单位
-   RSS：进程在未换出时占用的物理内存
-   STAT：代表当前进程状态的双字符状态码

5.`-x` 与 `x`的区别：

```shell
# 1.`-x` 与 `x` 我在 Linux 和 Mac 下测试后，发现这两者没有什么区别

# 2.当 -x 和 x 单独使用时，与 -A 基本一致
$ ps x
PID TTY      STAT   TIME COMMAND
  1 pts/0    Ss+    0:00 /bin/bash
12569 pts/2    Ss+    0:00 bash
12587 pts/1    Ss     0:00 bash
12596 pts/1    S+     0:00 man ps
12608 pts/1    S+     0:00 pager
12613 pts/3    Ss     0:00 bash
12664 pts/3    R+     0:00 ps x

# 3.当 -x 和 -a 搭配时，就体现出它的作用，即会展示那些没有 controlling terminal 的进程
$ ps -a
PID TTY          TIME CMD
12596 pts/1    00:00:00 man
12608 pts/1    00:00:00 pag

# 3.1 加上 -x参数，多了一部分的进程
$ ps -ax
PID TTY      STAT   TIME COMMAND
  1 pts/0    Ss+    0:00 /bin/bash
12569 pts/2    Ss+    0:00 bash
12587 pts/1    Ss     0:00 bash
12596 pts/1    S+     0:00 man ps
12608 pts/1    S+     0:00 pager
12613 pts/3    Ss     0:00 bash
12669 pts/3    R+     0:00 ps -ax
复制代码
```

6.`-o`参数：该参数会规定输出的格式，或者说输出哪些字段

```shell
$ ps -o uid,pid,%cpu,%mem
UID   PID %CPU %MEM
 0  12613  0.0  0.1
 0  12671  0.0  0.0
复制代码
```

可以使用的参数有：

```shell
# 这里列举了一些常用的，其他的可通过 man ps 找到
%cpu       percentage CPU usage (alias pcpu)
%mem       percentage memory usage (alias pmem)
comm       command
command    command and arguments
cpu        short-term CPU usage factor (for scheduling)
etime      elapsed running time
gid        processes group id (alias group)
pgid       process group number
pid        process ID
ppid       parent process ID
state      symbolic process state (alias stat)
tdev       control terminal device number
time       accumulated CPU time, user + system (alias cputime)
tty        full name of control terminal
uid        effective user ID
user       user name (from UID)
utime      user CPU time (alias putime)
vsz        virtual size in Kbytes (alias vsize)
xstat      exit or stop status (valid only for stopped or zombie process)
...
复制代码
```

7.`ps -ef` 和 `ps aux` 对比：

通过对上面参数的解释，你会发现其实两个命令是差不多，唯一的不同就是输出的参数有些不同，具体可以自己尝试下。

另外，大家可能会发现，如果加上 `grep` 指令，会导致**抬头信息**没了，这是因为被过滤掉了，如果要展示的话可以参考这里：[grep命令保留第一行](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F6ef88d510264 "https://www.jianshu.com/p/6ef88d510264")

## 补充

### 什么是 session leaders

我们知道，在Linux中，每个进程有几种ID与其相关，分别是 PID、PPID、PGID 和 SID。

-   PID：Process ID，即进程ID，进程的唯一标志，当进程退出时，进程的PID会释放。
-   PPID：Parent Process ID，即父进程的进程ID
-   PGID：Process Group ID，即进程组Leader的PID，如果某个进程的 PID == PGID，则意味着它是进程组Leader
-   SID：Session ID，即会话Leader（session leader）的PID，如果某个进程的 PID == SID，则意味着它是这个会话的Leader

1.会话（session）和进程组只是一种将多个进程看出一个单元（unit）的方式，进程组的所有成员始终属于**同一会话**，但一个会话可能有多个进程组

2.通常，shell程序（bash、或者sh）会是一个会话的领导者（即session leader），并且该shell执行的每一个管道都将是一个进程组，这是为了使shell退出时容易杀死它的子进程。

可通过 `ps -a` 和 `ps -A`得证：

```shell
ps -Ao pid,ppid,pgid,sid,comm
  PID  PPID  PGID   SID COMMAND
    1     0     1     1 bash
12569     0 12569 12569 bash
12587     0 12587 12587 bash
12596 12587 12596 12587 man
12608 12596 12596 12587 pager
12613     0 12613 12613 bash
12654 12613 12654 12613 ps

# -a 命令会排除 session leader，即不会展示 bash 进程
$ ps -ao pid,ppid,pgid,sid,comm

  PID  PPID  PGID   SID COMMAND
12596 12587 12596 12587 man
12608 12596 12596 12587 pager
12653 12613 12653 12613 ps
复制代码
```

## 总结

ps 命令的介绍到这里就结束了，如果你想查看更多参数的含义，可以通过 `man ps` 得到，如果你不想看英文，也可以看这里：[Linux三种风格（Unix、BSD、GNU）下的ps的参数说明](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fruibin_cao%2Farticle%2Fdetails%2F84660224 "https://blog.csdn.net/ruibin_cao/article/details/84660224")

如果你还想看 ps 命令的更多使用，则可以看这里：[10个重要的Linux ps命令实战](https://link.juejin.cn?target=https%3A%2F%2Flinux.cn%2Farticle-4743-1.html "https://linux.cn/article-4743-1.html")

  

作者：言淦  
链接：https://juejin.cn/post/6981457372971532318  


