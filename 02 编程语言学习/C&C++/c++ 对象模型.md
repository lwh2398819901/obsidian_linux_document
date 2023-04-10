
```toc
```
## 构造析构顺序

![[Pasted image 20220721121211.png]]

```cpp
#include<iostream>
using namespace std;
class Mem{
public:
    Mem(int x)
    {
        x1 = x;
        std::cout << "mem constructor " << x1 << std::endl;
    }

    ~Mem(){
        std::cout << "mem 析构"<<x1<<endl;
    }

    int x1;
};

class Base{
public:
    Base():m(1)
    {
        std::cout << "base constructor" << std::endl;
    }
    
    ~Base(){
        std::cout << "base 析构"<<endl;
    }
    Mem m ;
};

class Test : Base{
private:
    int x;
public:
    Test():m(2)
    {
        std::cout << "test constructor" << std::endl;
    }
    
    ~Test(){
        std::cout << "Test 析构"<<endl;
    
    }
    Mem m ;
};



int main()
{
    {
    	Test t2;
    }
    return 0;
}

```

<https://www.cnblogs.com/lfri/p/12717589.html>

## 构造

- 基类成员对象的构造函数
- 基类的构造函数
- 子类成员对象的构造函数
- 子类的构造函数

**虚基类**
菱形继承问题

![[Pasted image 20220721121341.png]]

假设base类中有一个成员mem
如果不是虚基类继承，则会出现二义性。
当一个类继承了两个来自同父类的子类后，会产生命名空间冲突及资源冗余。
虚基类并不是“绝对的”，而是“相对的”：虚基类在它自身声明、定义的时候无需任何修饰，只是在<font color=#FF0000>子类继承</font>时进行 virtual 修饰。
<https://www.airchip.org.cn/index.php/2022/02/25/cpp-example-virtual-inheritance/>

```cpp
class Base{};

class Byte : virtual public Base{};  //继承时候 使用virtual

class Expert : virtual public Base{};
```

## 析构

- 子类的析构函数
- 子类成员的析构函数
- 基类的析构函数
- 基类成员的析构函数

**虚析构**
多态情况下使用，在<font color=#FF0000>基类的析构函数</font>上增加，释放指向子类的基类指针时，会将子类释放。

<http://c.biancheng.net/view/269.html>

**栈解旋**
栈解旋是指当异常被抛出后，从进入try块起，到异常被抛出前，这期间在栈上构造的所有对象，都会被自动析构，析构的顺序与构造的顺序相反。这一过程被称为栈的解旋（unwinding）。
<https://www.cnblogs.com/laizhenghong2012/p/11782299.html>

## vptr& vtable

**类内存在 虚函数**

```cpp
class Base {
public:
	virtual void f() { cout << "Base::f" << endl; }
	virtual void g() { cout << "Base::g" << endl; }
	virtual void h() { cout << "Base::h" << endl; }
};
```

![[Pasted image 20220721125451.png]]
**一般继承，无虚函数的覆盖**

```cpp
class Base {
public:
	virtual void f() { cout << "Base::f" << endl; }
	virtual void g() { cout << "Base::g" << endl; }
	virtual void h() { cout << "Base::h" << endl; }
};
 
class Derive :public Base 
{
public:
	virtual void f1() { cout << "Derive::f1" << endl; }
	virtual void g1() { cout << "Derive::g1" << endl; }
	virtual void h1() { cout << "Derive::h1" << endl; }
};
```

![[Pasted image 20220721125657.png]]

**有虚函数覆盖的继承**

```cpp
class Base {
public:
	virtual void f() { cout << "Base::f" << endl; }
	virtual void g() { cout << "Base::g" << endl; }
	virtual void h() { cout << "Base::h" << endl; }
};
 
class Derive1 :public Base
{
public:
	virtual void f() { cout << "Derive1::f" << endl; }
	virtual void g1() { cout << "Derive1::g1" << endl; }
	virtual void h1() { cout << "Derive1::h1" << endl; }
};
```

![[Pasted image 20220721125805.png]]

**无虚函数覆盖的多重继承**

```cpp
class Base1 {
public:
	virtual void f() { cout << "Base1::f" << endl; }
	virtual void g() { cout << "Base1::g" << endl; }
	virtual void h() { cout << "Base1::h" << endl; }
};
 
class Base2 {
public:
	virtual void f() { cout << "Base2::f" << endl; }
	virtual void g() { cout << "Base2::g" << endl; }
	virtual void h() { cout << "Base2::h" << endl; }
};
 
class Base3 {
public:
	virtual void f() { cout << "Base3::f" << endl; }
	virtual void g() { cout << "Base3::g" << endl; }
	virtual void h() { cout << "Base3::h" << endl; }
};
 
class Derive2 :public Base1,public Base2,public Base3
{
public:
	virtual void f1() { cout << "Derive::f1" << endl; }
	virtual void g1() { cout << "Derive::g1" << endl; }
};
```

![[Pasted image 20220721125823.png]]

![[Pasted image 20220721125833.png]]

![[Pasted image 20220721125843.png]]

**有虚函数覆盖的多重继承**

```cpp
class Base1 {
public:
	virtual void f() { cout << "Base1::f" << endl; }
	virtual void g() { cout << "Base1::g" << endl; }
	virtual void h() { cout << "Base1::h" << endl; }
};
 
class Base2 {
public:
	virtual void f() { cout << "Base2::f" << endl; }
	virtual void g() { cout << "Base2::g" << endl; }
	virtual void h() { cout << "Base2::h" << endl; }
};
 
class Base3 {
public:
	virtual void f() { cout << "Base3::f" << endl; }
	virtual void g() { cout << "Base3::g" << endl; }
	virtual void h() { cout << "Base3::h" << endl; }
};
 
class Derive3 :public Base1, public Base2, public Base3
{
public:
	virtual void f() { cout << "Derive3::f1" << endl; }
	virtual void g1() { cout << "Derive3::g1" << endl; }
};

```

![[Pasted image 20220721130030.png]]
![[Pasted image 20220721130035.png]]
![[Pasted image 20220721130039.png]]

[虚指针（vptr）与虚基表（vtable）](https://blog.csdn.net/qq_25065595/article/details/107372446)

## stack(栈)

存在于某作用域(stack)的一块内存空间(memory space)。
例如调用函数时，函数本身会形成一个stack用来放置它所接受的参数(入栈)，以及返回地址(函数调用地址)。

举个例子，函数体内申请的所有局部变量都会存放在栈区，当程序运行至函数体外时，所有存放在栈区的变量将按照入栈顺序，逆序出栈释放。

```c++
#include <iostream>
#include <string>
using namespace std;
struct PrintClass
{
	PrintClass(string _name){
		name = _name;
		cout <<"PrintClass new "<<name <<endl;
	}
	
	~PrintClass(){
		cout <<"PrintClass delete "<<name <<endl;
	}
	string name;
};

void test(){
	int a =0 ;//栈区
	int b =1 ;//栈区
	int *c = new int; //指针c本身是存放在栈区的临时变量 指针指向的地址是存放在堆区 这里需要特殊注意。因为指针临时变量会被释放，而指向的地址不会 
	PrintClass p("局部变量"); //p的作用域在{}之间 当p出{}之间后会调用p的析构
}
PrintClass p2("全局变量"); //全局变量的开始与释放可以好好看看
int main(){
	cout << "main begin"<<endl;
	test();  //调用test 将会把test的地址放到栈区 作为调用函数返回地址
	cout << "main end"<<endl;
	return 0;
}
```

```sh
PrintClass new 全局变量  //全局变量是放在全局区 在main之前被创建
main begin
PrintClass new 局部变量
PrintClass delete 局部变量
main end
PrintClass delete 全局变量 //在main函数结束后 全局变量才会被释放

```

## heap（堆）

由操作系统提供的global空间，程序可动态创建或删除。

```c++
#include <iostream>
#include <string>
using namespace std;
struct PrintClass
{
	PrintClass(string _name){
		name = _name;
		cout <<"PrintClass new "<<name <<endl;
	}
	
	~PrintClass(){
		cout <<"PrintClass delete "<<name <<endl;
	}
	string name;
};


int main(){
	cout << "main begin"<<endl;
	PrintClass *p =new PrintClass("heap");
	cout << "main end"<<endl;
	return 0;
}
```

```sh
liuwh@liuwh-PC /tmp> ./a.out 
main begin
PrintClass new heap
main end
liuwh@liuwh-PC /tmp> 
```

what ? 发生了什么 ？为什么没有打印出析构函数？

因为new出来的对象是要显式delete的 系统不会像对待栈区的变量一样堆区变量的调用析构函数。

## new & delete

在c++中 new 和delete这一块的真相是什么？
new : 先分配内存 调用malloc() 然后调用构造函数。
delete: 先调用析构函数 然后删除内存 实际是调用free函数。

**但是new一个对象 实际是只增加了一个对象的内存空间吗？**

在侯捷老师的c++面向对象高级开发视频课程中 以vc编译器举例如下

![[vc编译器内存分布示例.png]]

图中 complex为类对象 其中包含两个float类型对象，大小为8个字节。

以debug编译出的程序(上图最左)，可以看到申请了8字节内存，但是实际分配了64字节。

下图中，每一个空格代表4个字节。
其中最头和最尾部为cookie在debug和release模式下都要有，debug多了32+4字节大小的调试信息。然后由于需要内存对齐，所以又添加了12字节的补齐大小内存。

![[vc编译器内存分布示例2.png]]

**new 一个数组呢？**
可以看到申请数组时，同样需要添加上下的cookie和内存补齐，但是与单个的对象相比 数组稍微节省了一部分的空间（每个单个对象的cookie）
![[vc编译器内存分布示例3.png]]

## malloc
```CPP
#include <stdlib.h>  
  
int main(int argc, char const *argv[])  
{  
   void *ptr;  
  
   ptr = malloc(1024 * 1024 * 1024); // 申请 1GB 内存  
  
   sleep(3600); // 睡眠3600秒, 方便调试  
  
   return 0;  
}
```


[你真的理解内存分配吗？](https://mp.weixin.qq.com/s/5DNxQBqNuMfqTe_6A6-b_Q)
[一文读懂 Linux 内存分配全过程](https://mp.weixin.qq.com/s/mphzuIqqBYecry0psTsbxQ)
