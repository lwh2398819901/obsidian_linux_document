---
dg-publish: false
---
```toc
```

## filefrag
>FILEFRAG (8) 系统管理员手册 FILEFRAG (8)\
name\
filefrag - 文件碎片报告\
概要\
filefrag [-bblocksize] [-BeksvxX] [文件 ...]\
描述\
filefrag 报告特定文件的碎片化程度。它允许 ext2 和 ext3 文件系统的间接块，但可以用于任何文件系统的文件。\
filefrag 程序最初尝试使用 FIEMAP ioctl 获取范围信息，该方法更高效、更快速。如果不支持 FIEMAP，则 filefrag 将回退到使用 FIBMAP。\
选项\
-B 强制使用旧的 FIBMAP ioctl 而不是 FIEMAP ioctl 进行测试。\
-bblocksize\
使用以字节为单位的块大小而不是文件系统块大小。为了与早期版本的 filefrag 兼容，如果未指定块大小，则默认为 1024 字节。\
-e 以范围格式打印输出，即使对于块映射文件也是如此。\
-k 使用 1024 字节的块大小进行输出（与“-b 1024”相同）。\
-s 在请求映射之前同步文件。\
-v 检查文件碎片时要详细。\
-x 显示扩展属性的映射。\
-X 以十六进制格式显示扩展块编号。


**查看inode相关命令**
filefrag -v
![[Pasted image 20211012120550.png]]