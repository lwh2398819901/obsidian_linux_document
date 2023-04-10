---
dg-publish: true
---
```toc
```

## show 基本用法

```mysql
show databases; 		   查看所有数据库
show databases\G; 		   查看所有数据库  转换为行显示
show schemas;			   查看所有数据库
show tables;			   查看所有表
show variables;			   查看所有变量
show variables like '%char%';			   查看包含char的变量
show variables like 'autocommit';		   查看autocommit变量
show engines;			   查看存储引擎
show status;			   查看数据库状态

SHOW CREATE DATABASE	   显示创建数据库的MySQL语句；  
SHOW CREATE TABLE 		   显示创建表的MySQL语句；  
SHOW GRANTS 			   用来显示授予用户（所有用户或特定用户）的安全权限；  

SHOW ERRORS				   用来显示服务器错误消息
SHOW WARNINGS			   用来显示服务器警告消息

可以通过help show;查看帮助
```

## 用户管理

### 用户主机设置

| 设置                    | 权限                        |
| --------------------- | ------------------------- |
| user@localhost        | user用户只能在本地通过socket登录数据库  |
| `user@192.168.0.1`    | user用户只能在192.168.0.1登录数据库 |
| `user@192.168.0.0/24` | user用户可以在该网络任意主机登录数据库     |
| user@%                | user用户可以在任意主机登录数据库        |

### 创建用户（create user）

<font color=#F36208>创建用户 并设置密码</font>
注意：mysql中不能单纯通过用户名说明用户，必须加上主机名 如<test@10.0.0.1>

```mysql
create user 'userName'@'IPAddr'  identified by 'passwd';

示例：
create user 'userName'@'localhost'  identified by '123';  // user用户只能在本地通过socket登录数据库 
create user 'userName'@'192.168.0.1'  identified by '123';  // user用户只能在192.168.0.1登录数据库
create user 'userName'@'192.168.0.0/24'  identified by '123';  // user用户可以在该网络任意主机登录数据库
create user 'user'@'%'  identified by '123'; // user用户可以在任意主机登录数据库
```

mysql用户信息存放在<font color=#FF0000> mysql.user</font>表中。

```mysql
select user,host from mysql.user;
```

<font color=#FF0000>修改用户信息（危险操作）</font>

```mysql
update mysql.user set user=Test where user=test;
```

<font color=#FF0000>刷新授权表信息</font>

```mysql
flush privileges;
```

### 创建用户 （grant ）

grant详细结束见下文权限控制
创建用户授权并设置密码  如果用户存在 则会修改密码

```mysql
grant all on *.* to  'tom2'@'%' identified by '123';

```

#### 创建用户 （with grant option  ）

权限授予tom2 并且tom2可以将自己的权限给别人

```mysql
grant all on *.* to  'tom2'@'%' identified by '123' with grant option  ;

```

### 重命名用户

```mysql
rename user 'tom2'@' to 'tom3'@'%';
```

### 修改用户密码

将tom用户的密码修改为123

```mysql
alter user 'tom'@'%' IDENTIFIED by '123tom';
```

<font color=#FF0000>ps: 未成功，但是所有的介绍都说可以 怀疑是版本的问题或者其他原因，版本5.6.35；</font>

### 删除用户

**语法**

```mysql
drop user 用户
```

**示例**

```mysql
删除user01@localhost 用户
drop user user01@localhost ;
删除user01从默认主机登录
drop user user01
实际执行
drop user user01@%

删除匿名用户
drop user ''@'localhost';

delete语句操纵mysql.user表

delete from mysql.user user='tom';

```

### 用户权限控制

**权限说明**

```mysql
USAGE //无权限 只能登录数据库和使用test的库

ALL   //所有权限

//指定某个权限
select/update/delete/super/slave/reload...

with grant option //表示允许把自己的权限授予其他用户 或从其他用户收回权限
```

**权限保存位置**

```mysql
mysql.user  //所有mysql用户的账号密码，以及用户对全库全表的权限
mysql.db 	//非mysql库的授权都保存在此  比如其他的db01库
mysql.tables_priv //某库某表的授权
mysql.columns_priv //某库某表某列的授权
mysql.procs_priv   //某库存储过程的授权
```

**给用户授权**
1）语法

```mysql
grant 权限 on 库.表 to 用户@主机
grant 权限(列1，列2,....) on 库.表 to 用户@主机
```

2）示例

```mysql
创建tom用户
create user 'tom'@'%'  identified by '1';

授权tom用户db02库所有查询权限
grant select on db02.* to  'tom'@'%';

刷新权限表
flush privileges;

授权tom用户testDB库所有查询权限
grant select,update(ID) on testDB.t1 to  'tom'@'%';

查看当前用户权限
show grants;

查看指定用户权限
show grants for 'tom'@'%';
```

**回收权限**

```mysql
语法：
revoke 权限 on 库.表 from 用户；

撤销指定权限
revoke update，select on `mysql`.user from 'tom'@'%';

撤销所有权限
revoke all privileges,grant option from 'tom'@'%';

all privileges 所有权限
grant option 权限下放

```

**查看当前用户权限**

```mysql
show grants;
```

**查看指定用户权限**

```mysql
show grants for 'tom'@'%';
```

## 导入导出sql
### 导入sql
```mysql
#mysql -u 用户名 -p 数据库名 < 存放位置
mysqldump -u root -p test < c:/a.sql  //此方法test库必须存在

# 或者进入mysql 执行source方法
mysql> source   /path/db.sql;
```
### 导出sql
```mysql
# mysqldump -u 用户名 -p 数据库名 > 存放位置
mysqldump -u root -p test > db.sql
```

## 库操作

### 创建

```mysql
创建 da02 库
mysql> create database da02;

创建库并指定默认字符集
mysql> create database da02 default charset gbk;

创建库 如果存在不报错(if not exists)
mysql> create database if not exists da02 default character set utf8;
```

### 查看创建库语句

```mysql
mysql> show create database da01;
+----------+-----------------------------------------------------------------+
| Database | Create Database                                                 |
+----------+-----------------------------------------------------------------+
| da01     | CREATE DATABASE `da01` /*!40100 DEFAULT CHARACTER SET latin1 */ |
+----------+-----------------------------------------------------------------+
1 row in set (0.00 sec)

/*!40100 DEFAULT CHARACTER SET latin1 */  
这里是默认添加的语句 当执行create database da01时。
实际上执行的是 create database da01 DEFAULT CHARACTER SET latin1；
```

这里的latin1 又是怎么来的呢？
查看一下mysql库的默认字符集

```mysql
mysql> show variables like '%char%';
+--------------------------+----------------------------------+
| Variable_name            | Value                            |
+--------------------------+----------------------------------+
| character_set_client     | utf8                             |
| character_set_connection | utf8                             |
| character_set_database   | latin1 					      |
| character_set_filesystem | binary                           |
| character_set_results    | utf8                             |
| character_set_server     | latin1                           |
| character_set_system     | utf8                             |
| character_sets_dir       | /usr/local/mysql/share/charsets/ |
+--------------------------+----------------------------------+
8 rows in set (0.01 sec)
```

那这里又是怎么设置的呢？
实际上是通过[[02-2 mysql数据库物理文件介绍(日志，存储文件以及配置文件说明)#mysql配置文件#my cnf|my.cnf]]设置的。

### 更改数据库信息

```mysql
更改db01默认字符集
alter database db01 default character set gbk;
alter database db01 default charset utf8;
```

### 删除数据库

```mysql
drop database 库名
drop database db01;
```

## 表操作

### 创建表

create table 表名(字段 数据类型,字段 数据类型(字符长度) 约束条件 .....);
示例：

```mysql
创建 t1 表
mysql> create table t1(id int(5) key,name varchar(10) not null);
```

### 查看表结构

desc t1;
describe t1;

```mysql
mysql> desc t1;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(5)      | NO   | PRI | NULL    |       |
| name  | varchar(10) | NO   |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

```

### 查看创建表语句

```mysql
mysql> show create table t1;
+-------+----------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                           |
+-------+----------------------------------------------------------------------------------------------------------------------------------------+
| t1    | CREATE TABLE `t1` (
  `id` int(5) NOT NULL,
  `name` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 |
+-------+----------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

### 更新表属性信息(alter table)

```mysql
增加一列成为第一列 
alter table t1 add sex int first;

在id后面增加一列id2
alter table t1 add id2 int after id;

删除id2列
alter table t1 drop id2;

修改列名和数据类型 id改为ID 类型int 改为bigint
alter table t1 change id ID bigint;

修改列的数据类型 
alter table t1 modify ID int;

修改表的存储引擎
alter table t2 engine MyISAM;

修改表的默认字符集
alter table t2 default charset=utf8;


```

### 重命名或移动表

```mysql
移动并重命名表
rename table db01.t1 to db02.t11;
或者
alter table db01.t1 rename db02.t11;

重命名
rename table t1 to t11;
alter table t1 rename t11;
```

### 删除表

```mysql
drop table 表名；
```

### 增加记录

```mysql
insert into 表名 set 字段1=xx 字段2=xx;
insert into t1 set id=1,name='aaa';

insert into 表名 values (值1，值2)，(值1，值2);
insert into t1 values(2,'bbb'),(3,'ccc');

insert into 表名 (指定字段1，指定字段2)  values (值1，值2)，(值1，值2);
insert into t1(id,name) values(2,'bbb'),(3,'ccc');
insert into t1(name) values('bbb'),('ccc');


insert into t3 select * from t1; (t3 和t1 的表结构完全相同)
insert into t4 (id,name) select * from t1;(t4的id,name字段数据来源于t1)
```

### 删除记录

```mysql
delete from 表名;
delete from t1;

delete from 表名 where 条件;
delete from t1 where id=1;

truncate 表名
truncate t1;  //truncate 不能添加where条件 只能删除所有记录
```

### 更新记录

```mysql
update 表名 set 字段1=新值，字段2=新值,... where 条件；
update t1 set id=10 ,name=a10 where id=1;

```

### delete/truncate/drop 区别

- delete：删除<font color=#81B300>数据记录</font>
  1. 数据库操作语言（[[基础知识#DML|DML]]）；
  2. 在事务控制里，[[基础知识#DML|DML]]语句要么commit 要么rollback;
  3. 删除<font color=#81B300>大量</font>记录速度慢，<span style="background:#A0CCF6">只删除数据</span>，不回收[[基础知识#高水位线|高水位线]]；
  4. 可以<span style="background:#A0CCF6">带条件删除</span>
- truncate:删除所有数据记录
  1. 数据定义语言（[[基础知识#DDL\\|DDL]]）
  2. <span style="background:#A0CCF6">不在</span>事务控制内，[[基础知识#DDL\\|DDL]]执行前会提交前面所有未提交的事务
  3. 清除大量数据<span style="background:#A0CCF6">速度快</span>，回收[[基础知识#高水位线|高水位线]]
  4. 不能带条件删除
- drop：删除<span style="background:#A0CCF6">数据库对象</span>
  1. 数据定义语言（[[基础知识#DDL\\|DDL]]）

  2. 数据库对象包括 库，表，用户等。

 <br/>

## 查询语句

**常见符号**

| 符号               | 含义          |
| ---------------- | ----------- |
| %                | 匹配0个或任意多个字符 |
| _(下划线)           | 匹配单个字符      |
| like             | 模糊匹配        |
| =                | 等于,精确匹配     |
| >                | 大于          |
| <                | 小于          |
| >=               | 大于等于        |
| <=               | 小于等于        |
| !=,<>            | 不等于         |
| !,not            | 逻辑非         |
| ||,or            | 逻辑或         |
| &&,and           | 逻辑与         |
| between...and... | 两种之间        |
| in(...)          | 在...之中      |

**其他关键字**

| 符号       | 含义     |
| -------- | ------ |
| regexp   | 使用正则匹配 |
| order by | 排序     |
| asc      | 升序     |
| desc     | 降序     |
| group by | 聚合     |
| having   | 筛选     |
| distinct | 去除重复行  |

### 基本查询语句

```mysql
select 字段1,字段2.... from 表名；

# 查看所有数据
select * from 表名；

# 给列指定别名（显示）

select 字段1 测试列名，字段2 测试列名2 from 表名；

# 给列指定别名2（显示）
select 字段1 as 测试列名，字段2 as 测试列名2 from 表名；
```

### where条件

```mysql
select 字段1 from 表名 where 条件；

#逻辑运算
select 字段1 from 表名 where 字段2>100；
select 字段1 from 表名 where 字段2<100 ；
select 字段1 from 表名 where 字段2>=100；

select 字段1 from 表名 where 字段2>100 and 字段2 <200；
select 字段1 from 表名 where 字段2<100 or 字段3 <200；
select 字段1 from 表名 where 字段2>=100 and not 字段3 =100；

#正则
select 字段1 from 表名 where 字段4 regexp '^h'； 以h开头

#between and 
select 字段1 from 表名 where 字段2 not beteen 3000 and 5000; 字段2不在3000到5000之间

```

### 排序

```mysql
# 示例
select 字段1 from 表名 order by 字段名；
# 升序
select 字段1 from 表名 order by 字段名 asc；
# 降序
select 字段1 from 表名 order by 字段名 desc；
```

### 去重

```mysql
select distinct 字段1 from 表名
```

### IFNULL&IF&NULLIF

//如果字段2为空 返回结果1

```mysql
select 字段1，IFNULL(字段2，结果1)  from 表名；
```

//如果字段2为真 返回结果1 否则返回结果2

```mysql
select 字段1，IF(字段2，结果1，结果2)  from 表名；
```

//如果字段1==字段2 返回null 否则返回字段1

```mysql
select 字段1，NULL IF(字段1，字段2)  from 表名；
```

### group by 和having

**1）group by**
根据<font color=#FF0000>给定的数据列</font>进行分组统计，最终获取一个<font color=#FF0000>分组汇总表</font>。（一般和统计函数配合使用才有意义）

```mysql
select max(字段1) from 表名 group by 字段2；
```

ps：个人理解 以字段2为分组标准 分组后的数据 交给前面的统计函数。
例如以<font color=#FF0000>部门</font>字段为标准 分成若干组，找出每组中最大<font color=#FF0000>工资</font>的人以及求出<font color=#FF0000>组内人数</font>

count(*) 统计有多少条数据，这里统计的是分组后每组的人数。

```mysql
select 部门,max(工资),count(*) from 表名 group by 部门；
```

**2）having**

- having 与[[#where条件|where]]类似，根据条件对数据进行筛选
- [[#where条件|where]]是对<font color=#FF0000>表内的列</font>进行筛选
- having是对<font color=#FF0000>查询结果集</font>进行筛选，也就是说[[#where条件|where]]不能直接对结果集进行筛选

```mysql
select 部门,max(工资),count(*) from 表名 group by 部门 having max(工资)>3000 ；

select 部门,max(工资) 工资,count(*) 人数 from 表名 group by 部门 having 工资>3000 ；

```

### 合并函数（concat）

将两列输出合并为一列，可以自己指定分隔符

```mysql
select concat（字段1，'####' 字段2） from 表名 ；

```

### 分页函数（limit）

```mysql
用法：limit 起始位置，偏移量  		起始位置从0开始
select 字段1 from 表名 limit n；//显示前n行
select 字段1  from 表名 limit n，m；//显示n+1行 到m行之间的数据

```

### 多表联合查询

```mysql
```

### 四则运算

```mysql
select 1+1;
select 1-1;
select 1*1;
select 1/1;
select 1+1,(10-1)/3,2*2-2;
select 1+1 from dual; //俗称万能表 oracle中也有

# 函数
select pow(2,3);

```

### 常见的数据类型

## 参考链接

[MySQL中show语法使用总结](https://www.cnblogs.com/saneri/p/6963583.html)

[MySQL查看表结构命令](http://c.biancheng.net/view/7199.html)

[MySQL删除表操作(delete、truncate、drop的区别)](https://blog.csdn.net/z_ryan/article/details/81913481)

[Mysql 用户权限管理](https://www.cnblogs.com/keme/p/10288168.html)

[mysql函数大全](http://c.biancheng.net/mysql/function/)

[mysql函数](https://www.cnblogs.com/tkzc2013/p/13957952.html)
