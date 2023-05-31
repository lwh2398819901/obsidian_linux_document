---
dg-publish: false
---
```toc
```

# 前言

打算自学java 目前打算跟着狂神说的学习路线走一遍,但是基础篇可能穿插学黑马的课程
课程链接如下：

## 学习路线图

![[Pasted image 20221111211028.png]]

[](https://www.bilibili.com/read/cv5702420)

<https://www.bilibili.com/video/BV12J41137hu?p=37&vd_source=ccbe0c793ac5e34ebb735794692f049e>

## java

**为什么要学java?**

java的特性和优势

- 简单性
- 面向对象
- 可移植性
- 高性能
- 分布式
- 动态性
- 多线程
- 安全性
- 健壮性

**java三大版本**

- javaSE: 标准版（桌面程序，控制台开发）
- javaME:嵌入式开发(手机，小家电....) <font color=#FF0000>已经无人使用了</font>
- javaEE: 企业级开发（web，服务器开发）

**JDK、JRE、JVM**

- JDK:java development kit （java开发者工具）
- JRE:java runtime environment (java运行环境)
- JVM:java virtual machine (java虚拟机)

![[Pasted image 20221111214005.png]]

**JDK与JAVA版本**

 参考链接： [Java--Java版本和JDK版本](https://blog.csdn.net/MinggeQingchun/article/details/120578602)
![[Pasted image 20230224211745.png]]

## 安装环境

**参考链接**

[Linux系统安装Java环境](https://blog.csdn.net/manongxianfeng/article/details/112641235)

[如何在 Ubuntu 20.04 上安装 Java](https://cloud.tencent.com/developer/article/1626610)

[java8官网下载](https://www.oracle.com/java/technologies/downloads/#java8)

[CentOS下JDK的安装教程（及JAVA_HOME配置、以jdk1.8为例）](https://www.hangge.com/blog/cache/detail_2651.html)

为了方便 ，我选择的使用命令行安装 java 8
**debian**
```bash
apt install openjdk-8-jdk
```
**redhat**
```bash
yum install java-1.8.0-openjdk
```
验证是否安装成功

```bash
liuwh@liuwh-PC ~/Desktop> java -version
openjdk version "1.8.0_212"
OpenJDK Runtime Environment (build 1.8.0_212-8u212-b01-1~deb9u1-b01)
OpenJDK 64-Bit Server VM (build 25.212-b01, mixed mode)
```

## Hello world

1. 环境搭建好后，创建一个文件 Hello.java
2. 编写代码

```java
public class Hello{
	public static void main (String[]args){
		System.out.print("Hello world!");
	}
}
```

3. 编译 javac Hello.java  生产Hello.class文件
4. 运行 java Hello

文件名和类名保持一致，并且首字母大写。

## java程序运行的方式

![[Pasted image 20221113122556.png]]
![[Pasted image 20221113122641.png]]
<https://www.jianshu.com/p/e5c86b556247>

## IDE环境安装
### 官网下载
参考链接：
[Ubuntu安装IDEA](https://blog.csdn.net/qq_41931797/article/details/102813106)

1. 从idea官网下载[安装包](https://www.jetbrains.com/idea/download/#section=linux)
2. 通过激活码激活     [激活码网站](http://idea.hicxy.com/)
3. [idea汉化](https://blog.csdn.net/Cooperia/article/details/119329395)
4. ubuntu/deepin环境下 创建desktop文件  ==touch idea.desktop==
5. 将idea软连接到opt下 `ln -s (pwd)/idea-IU-223.8617.56/ /opt/idea`


```bash
[Desktop Entry]
Name=idea
Exec=/opt/idea/bin/idea.sh
Terminal=false
Type=Application
Icon=/opt/idea/bin/idea.svg
Comment=Next Shell for PC
Categories=Development;
X-Deepin-CreatedBy=com.deepin.dde.daemon.Launcher
X-Deepin-AppID=idea
```

5. 拷贝==sudo cp idea.desktop /usr/share/applications/==
### deepin安装
1. 应用商店下载idea
2. 通过激活码激活     [激活码网站](http://idea.hicxy.com/)
3. [idea汉化](https://blog.csdn.net/Cooperia/article/details/119329395)

## idea设置

**自动导入包**
![[Pasted image 20221112231642.png]]
**提示忽略大小写**
![[Pasted image 20221112231709.png]]


## jdk相关
### 版本
https://docs.oracle.com/en/java/javase/index.html
### 帮助文档

## java idea项目结构

```
project(项目)
		module (模块)
				package（包）
					class（类）
```

### 包机制

模块中包含着包，包里包含着类。\
一般包名是<font color=#FF0000>域名倒置</font>，比如com.baidu.www    www省去不写，所以包为com.baidu
![[Pasted image 20221113151144.png]]
**创建包**

```java
package com.test;    //放在包内的代码 需要加上这句话，否则报错  且该语句必须在首行
  
public class test1 {  
    public static void main(String[] args) {  
        System.out.println("test1");  
    }  
    public static void test1(){  
        System.out.println("run test1");  
    }  
}

```

**导入包**

```java
import com.test.test1;   //import 导入包关键字
import com.test2.test2;  
/* 或者这种形式，导入包下所有类
import com.test.*;  
import com.test2.*;
*/


public class Main {  
    public static void main(String[] args) {  
        System.out.println("Hello world!");  
        test1 t = new test1();  
        test2 t2 = new test2();  
        t.test1();  
        t2.test2();  
    }  
}
```

# 语法

## 注释

| 注释             | 符号       |
| -------------- | -------- |
| 单行注释           | //       |
| 多行注释           | /**/     |
| 文档注释   javaDoc | /**   */ |

```java
public class Main {  
    public static void main(String[] args) {  
        // 单行注释  
  
        /* 这是多行注释  
        * 可以写多行  
        *        *   
        * */  

        /**  
         * @Description  这是javaDoc文档注释  
         */  
        System.out.println("Hello world!");  
    }  
}
```

### javaDoc

参考链接 <https://blog.csdn.net/h_xiao_x/article/details/65936510>

| Tag&Parameter                                                     | Usage                                                                   | Applies to                      | Since |
| ----------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------- | ----- |
| @author name                                                      | Describes an author.描述作者                                                | Class, Interface                |       |
| @version version                                                  | Provides version entry. Max one per Class or Interface.版本条目，每个类或接口最多有一个 | Class, Interface                |       |
| @since since-text                                                 | Describes since when this functionality has existed.描述这个功能块从何时有的        | Class, Interface, Field, Method |       |
| @see reference                                                    | Provides a link to other element of documentation.提供链接到其他文档元素的链接        | Class, Interface, Field, Method |       |
| @param name description                                           | Describes a method parameter.描述一个参数                                     | Method                          |       |
| @return description                                               | Describes the return value.描述返回值                                        | Method                          |       |
| @exception classname description<br>@throws classname description | Describes an exception that may be thrown from this method.描述该方法可能抛出的异常 | Method                          |       |
| @deprecated description                                           | Describes an outdated method.描述一个过期的方法                                  | Method                          |       |
| {@inheritDoc}                                                     | Copies the description from the overridden method.从复写方法出拷贝来得描述          | Overriding Method               | 1.4.0 |
| {@link reference}                                                 | Link to other symbol.连到其他的引用                                            | Class, Interface, Field, Method |       |
| {@value}                                                          | Return the value of a static field.返回一个静态作用域的值                          | Static Field                    | 1.4.0 |

生成模板

```java
/**  
 * @author xunlu  
 * @since 1.8  
 * @version 1.0  
 */public class Doc {  
  
    /**  
     * @author xunlu  
     * @param str  
     * @return  
     * @throws Exception  
     */    public String getName(String str)throws Exception{  
  
        return  "Doc";  
    }  
}
```

_**命令行生成**_

```bash
javadoc -encoding UTF-8 -charset UTF-8 Doc.java 
```

_**idea生成**_

工具 -->生成javaDoc-->选择生成目录

## 关键字

参考链接：<https://blog.csdn.net/yh991314/article/details/108521095>

|           | 关键字                                                                                               |
| --------- | ------------------------------------------------------------------------------------------------- |
| 数据类型      | boolean、int、long、short、byte、float、double、char、class、interface、enum、void                           |
| 流程控制      | if、else、do、while、for、switch、case、default、break、continue、return                                    |
| 异常处理      | try、catch、finally、throw、throws                                                                    |
| 修饰符       | public、protected、private、final、void、static、strict、abstract、transient、synchronized、volatile、native |
| 类与类之间关系   | extends、implements                                                                                |
| 建立实例及引用实例 | this、supper、instanceof、new                                                                        |
| 导包        | package、impor                                                                                     |
| 保留字（未使用）  | goto、const、byValue、cast、future、 generic、 inner、 operator、 outer、 rest、 var                        |

**Java标识符定义**

1. 包名、类名、方法名、参数名、变量名等，这些符号被称为标识符。
2. 标识符可以由字母、数字、下划线_ 和 美元符号 $组成
3. 标识符不能以数字开头，不能是java中的关键字。
4. 首字符之后可以是字母（A­Z 或者 a­z）、下划线_ 、美元符号$ 或数字的任何字符。
5. Java 区分大小写，因此 myvar 和 MyVar 是两个不同的标识符。
6. 不可以使用关键字和保留字作为标识符，但标识符中能包含关键字和保留字。
7. 标识符不能包含空格。

**Java标识符规则**

1. 包名所有字母必须小写。例如：cn.com.test
2. 类名和接口名每个单词的首字母都要大写。例如：ArrayList
3. 常量名所有的字母都大写，单词之间用下划线连接。例如：DAY_OF_MONTH
4. 变量名和方法名的第一个单词首字母小写，从第二个单词开始，每个单词首字母大写。例如：lineName、getLingNumber
5. 在程序中，应该尽量使用有意义的英文单词来定义标识符，使得程序便于阅读。例如：使用userName表示用户名，password表示密码。

## 数据类型

| 数据类型 | 关键字     | 取值范围                                                   | 字节   | 注意               |
| ---- | ------- | ------------------------------------------------------ | ---- | ---------------- |
| 整数   | byte    | -128 ~ 127                                             | 1    |                  |
|      | short   | -32768 - 32767                                         | 2    |                  |
|      | int     | -2147483648 ~2147483647                                | 4    |                  |
|      | long    | -9,223,372,036,854,775,808~  9,223,372,036,854,775,807 | 8    | 使用时数字后面代L（大小写都可） |
| 浮点数  | float   |                                                        | 4    | 使用时数字后面代F（大小写都可） |
|      | double  |                                                        | 8    |                  |
| 字符   | char    | 0~65535                                                | 2    |                  |
| 布尔   | boolean |                                                        | 1bit |                  |

```java
public class Main {  
    public static void main(String[] args) {  
        // byte  
        System.out.println("基本类型：byte 二进制位数：" + Byte.SIZE);  
        System.out.println("包装类：java.lang.Byte");  
        System.out.println("最小值：Byte.MIN_VALUE=" + Byte.MIN_VALUE);  
        System.out.println("最大值：Byte.MAX_VALUE=" + Byte.MAX_VALUE);  
        System.out.println();  
  
        // short  
        System.out.println("基本类型：short 二进制位数：" + Short.SIZE);  
        System.out.println("包装类：java.lang.Short");  
        System.out.println("最小值：Short.MIN_VALUE=" + Short.MIN_VALUE);  
        System.out.println("最大值：Short.MAX_VALUE=" + Short.MAX_VALUE);  
        System.out.println();  
  
        // int  
        System.out.println("基本类型：int 二进制位数：" + Integer.SIZE);  
        System.out.println("包装类：java.lang.Integer");  
        System.out.println("最小值：Integer.MIN_VALUE=" + Integer.MIN_VALUE);  
        System.out.println("最大值：Integer.MAX_VALUE=" + Integer.MAX_VALUE);  
        System.out.println();  
  
        // long  
        System.out.println("基本类型：long 二进制位数：" + Long.SIZE);  
        System.out.println("包装类：java.lang.Long");  
        System.out.println("最小值：Long.MIN_VALUE=" + Long.MIN_VALUE);  
        System.out.println("最大值：Long.MAX_VALUE=" + Long.MAX_VALUE);  
        System.out.println();  
  
        // float  
        System.out.println("基本类型：float 二进制位数：" + Float.SIZE);  
        System.out.println("包装类：java.lang.Float");  
        System.out.println("最小值：Float.MIN_VALUE=" + Float.MIN_VALUE);  
        System.out.println("最大值：Float.MAX_VALUE=" + Float.MAX_VALUE);  
        System.out.println();  
  
        // double  
        System.out.println("基本类型：double 二进制位数：" + Double.SIZE);  
        System.out.println("包装类：java.lang.Double");  
        System.out.println("最小值：Double.MIN_VALUE=" + Double.MIN_VALUE);  
        System.out.println("最大值：Double.MAX_VALUE=" + Double.MAX_VALUE);  
        System.out.println();  
  
        // char  
        System.out.println("基本类型：char 二进制位数：" + Character.SIZE);  
        System.out.println("包装类：java.lang.Character");  
        // 以数值形式而不是字符形式将Character.MIN_VALUE输出到控制台  
        System.out.println("最小值：Character.MIN_VALUE="  
                + (int) Character.MIN_VALUE);  
        // 以数值形式而不是字符形式将Character.MAX_VALUE输出到控制台  
        System.out.println("最大值：Character.MAX_VALUE="  
                + (int) Character.MAX_VALUE);  
    }  
}
```

## 类型转换

- 隐式转换

- 强制转换

注意：

1. 不能对布尔类型转换
2. 不能把对象类型转换为不相干类型
3. 高容量转换为低容量类型时，要强制转换，反之不需要会自动隐式转换。
4. 转换可能有内存溢出或精度问题

## 运算符

|       | 运算符                                | 注意                                                                                                                                                                                                                                      |             |
| ----- | ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| 算术运算符 | +，-，*，/,++,--,%                    | ==+==运算符在对字符串，字符，数值时行为要注意                                                                                                                                                                                                               |             |
| 关系运算符 | ==,!=,>,<,>=,<=                    |                                                                                                                                                                                                                                         |             |
| 位运算符  | &,                                 | ,^,~,<<,>>,>>>                                                                                                                                                                                                                          | 并没有<<<这个运算符 |
| 逻辑运算符 | &&，                                | ,！                                                                                                                                                                                                                                      |             |
| 赋值运算符 | =，+=，-=，*=， /=，(%)=,<<=,>>=,&=,^=， | =                                                                                                                                                                                                                                       |             |
| 其他运算符 | 三目运算符（?:）,      instanceof 运算符     | instanceof运算符使用格式如下：<br><span style="background:#A0CCF6">( Object reference variable ) instanceof  (class/interface type)</span><br><br>String name = "James";<br>boolean result = name instanceof String; // 由于 name 是 String 类型，所以返回真 |             |

## 循环结构

**三种循环结构**

- for
- while
- do{}while()

break,continue;

## 条件判断

- if
- else
- else if
- switch
- case
- break
- default

基本等同c++ ，但是switch中的条件可以是字符串了。

switch在jdk7中支持了表达式可以放字符串，这一点是如何做到的？\
字符的本质是数字。\
反编译: java -->class （字节码文件）-->反编译\
在课程中可以看到反编译的代码  对字符串进行了hashCode运算，应该是把字符串算出hash值去运算了。

**jdk12中switch新写法**

```java
switch(condition){
case 1 -> System.out.println(1);
case 2 -> System.out.println(2);
case 3 -> System.out.println(3);
default -> System.out.println(1);
}
这里的 -> 等同于{break;}

```

## 数组

java中数组定义可以用以下两种方式定义
**定义数组(一维，二维，动态创建二维)**

```java
//第一种
int arr [] = new int[]{1,2,3};
int arr2[]={1,2,3};

int [] x;  
x = new int[10];

//第二种
int [] arr = new int []{1,2,3};

//定义二维数组
int[][] arr_1 = new int[][]{{1, 2, 3, 4, 5, 6, 7, 8}, {3, 4}};  
int [] [] arr_2 = {{1,2,3,4},{1,2,3,4}};

//动态创建数组
int [] [] arr_3 = new int[3][];  
arr_3[0]=new int[]{1};  
arr_3[1]=new int[]{2,3,4,5};  
arr_3[2]=new int[]{2,3,4,5,6};
```

推荐使用 第一种方式定义数组
**获取数组长度**\ <font color=#FF0000>数组内置length变量，直接获取该变量即可。例如：arr.length</font>

java中数组默认有初始化值；也就是0；

**遍历数组**

```java
public class Main {  
    public static void main(String[] args) {  
        System.out.println("Hello world!");  
        int[] arr = new int[]{1, 2, 3};  
        int[] arr2 = {1, 2, 3};  
		//定义二维数组
        int[][] arr_1 = new int[][]{{1, 2, 3, 4, 5, 6, 7, 8}, {3, 4}};  
  
        for (int i = 0; i < arr.length; ++i) {  
            System.out.println(arr[i]);  
        }  
  
        for (int i = 0; i < arr_1.length; ++i) {  
            for (int j = 0; j < arr_1[i].length; ++j) {  
                System.out.println(arr_1[i][j]);  
            }  
        }  

		//arr_1.for
		for (int[] ints : arr_1) {  
		    for (int anInt : arr_1) {  
		        System.out.println(anInt);  
			}  
		}


    }  
  
    public int test(int num) {  
        return ++num;  
    }  
}
```

java数组与c++很不一样，首先有一点，java的二维数组的不像c++要固定死[2][4]这样，他每一个一维数组的个数可以不一样。难以理解。\
就像是这样
感觉内存像是这样一般
```
c++
{1，2，3，4，5}
{6，7，8，9，10}
{1，2，3，4，5}
{6，7，8，9，10}

java
{1,2,3,4,5}
{6,7}
{1,2,4,5}
{6,7，8}
```

## 可变参数
![[Pasted image 20230224212141.png]]


# 面向对象


## 值传递和引用传递
Java是值传递。当传的是基本类型时，传的是值的拷贝，对拷贝变量的修改不影响原变量；当传的是引用类型时，传的是引用地址的拷贝，但是拷贝的地址和真实地址指向的都是同一个真实数据，因此可以修改原变量中的值；当传的是String类型时，虽然拷贝的也是引用地址，指向的是同一个数据，但是String的值不能被修改，因此无法修改原变量中的值。

**值传递**
```java
public void test() {
    int a = 1;
    change(a);
    System.out.println("a的值：" + a);
}
private void change(int a) {
    a = a + 1;
}
// 输出
a的值：1
```

**引用传递**
```java
public void test() {
   User user = new User();
   user.setAge(18);
   change(user);
   System.out.println("年龄:" + user.getAge());
}
private void change(User user) {
   user.setAge(19);
}
// 输出
年龄:19
```

对于c++程序员其实很好理解，是吧？
c++程序员看到new后 ，知道这个是个指针，然后传递的是指针的情况下，自然能修改同一处内存。而基本类型是在栈上，是拷贝的数据，所以修改无效。
