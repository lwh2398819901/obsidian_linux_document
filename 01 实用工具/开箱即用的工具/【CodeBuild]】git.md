---
dg-publish: false
---
```toc
```

## git三大特色之Stage(暂存区)
![[Pasted image 20231204104734.png]]
[Git三大特色之Stage(暂存区)_git stage-CSDN博客](https://blog.csdn.net/qq_32452623/article/details/78417609)

<iframe src="https://blog.csdn.net/qq_32452623/article/details/78417609" allow="fullscreen" allowfullscreen="" style="height:100%;width:100%; aspect-ratio: 16 / 9; "></iframe>

## git 命令行中图形化显示提交日志

```bash
# 图形化显示当前分支的提交日志 
git log --graph --oneline 
# 图形化显示当前分支的提交日志及每次提交的变更内容 
git log --graph --patch 
# 图形化显示所有分支的提交日志 
git log --graph --oneline --all 
# 图形化显示所有分支的提交日志及每次提交的变更内容 
git log --graph --patch --all
```

---

## git submodule

[git 嵌套使用：Submodule](https://blog.csdn.net/lckj686/article/details/93161842)

[Git中submodule的使用](https://zhuanlan.zhihu.com/p/87053283)

**练习：**

前置条件：创建项目：`project-main` 和 `project-sub-1`,`project-main`为 主项目，`project-sub-1` 子模块项目。

**1. 创建 submodule**

进入`project-main` ，执行git submodule add <submodule_url>

```bash
git submodule add git@gitee.com:lwh2398819901/project-sub-1.git 
```

此时项目仓库中会多出两个文件：`.gitmodules` 和 `project-sub-1` 。

```bash
[submodule "project-sub-1"]
        path = project-sub-1
        url = git@gitee.com:lwh2398819901/project-sub-1.git
```

<br/>
<br/>

**2.获取 submodule**

首次clone主项目时，子模块为空文件夹\
在当前主项目中执行：
```bash
git submodule update --init
```

<br/>
<br/>

**3.子模块内容的更新**

子模块主动更新（非主项目内）：对于子模块而言，并不需要知道引用自己的主项目的存在。按照正常的 Git 代码管理规范操作即可。

主项目中：

1）子模块文件夹发生了未跟踪的内容变动；（主项目内修改了子模块代码）

```
进入子模块文件夹，按照子模块内部的版本控制体系提交代码，当提交完成后，主项目的状态则进入了情况2。
```

2）子模块文件夹发生了版本变化；

```
在主项目中使用 `git status` 查看仓库状态时，会显示子模块有新的提交。
在这种情况下，可以使用 `git add/git commit` 将其添加到主项目的代码提交中，实际的改动就是那个子模块 `文件` 所表示的版本信息
```

3）子模块文件夹没变，远程有更新；
通常流程是：

```bash
cd project-sub-1
git pull origin master
```

当主项目的子项目特别多时，可能会不太方便，此时可以使用 `git submodule` 的一个命令 `foreach` 执行：

```bash
git submodule foreach 'git pull origin master'
```
<span style="background:#F0A7D8">_终上所述，可知在不同场景下子模块的更新方式如下：_</span>

- 对于子模块，只需要管理好自己的版本，并推送到远程分支即可；
- 对于父模块，若子模块版本信息未提交，需要更新子模块目录下的代码，并执行 `commit` 操作提交子模块版本信息；
- 对于父模块，若子模块版本信息已提交，需要使用 `git submodule update` ，Git 会自动根据子模块版本信息更新所有子模块目录的相关代码。

<br/>
<br/>

**4.删除子模块**

使用 `git submodule deinit` 命令卸载一个子模块。这个命令如果添加上参数 `--force`，则子模块工作区内即使有本地的修改，也会被移除。
```bash
git submodule deinit project-sub-1  
git rm project-sub-1
```
执行 `git submodule deinit project-sub-1` 命令的实际效果，是自动在 `.git/config` 中删除了以下内容：
```git
git [submodule "project-sub-1"]
url = <https://github.com/username/project-sub-1.git>
```
执行 `git rm project-sub-1` 的效果，是移除了 `project-sub-1` 文件夹，并自动在 `.gitmodules` 中删除了以下内容：
```git
[submodule "project-sub-1"]\
path = project-sub-1\
url = <https://github.com/username/project-sub-1.git>
```
此时，主项目中关于子模块的信息基本已经删除（虽然貌似 `.git/modules` 目录下还有残余）
```git
git commit -m "delete submodule project-sub-1"
```
至此完成对子模块的删除。

