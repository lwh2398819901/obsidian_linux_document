```toc
```

## 前言

我最近关注了一个b站的up主
他的公众号叫考鼎录
对于c语言来说 我感觉他讲的地方有些还是不错的。所以做这个笔记。

<https://www.bilibili.com/video/BV1XB4y1S732/?spm_id_from=333.788&vd_source=ccbe0c793ac5e34ebb735794692f049e>

## goto 很好用啊，为什么强调少用 goto 呢？【C 语言问答】

goto能用吗？能。
一般在什么情况使用？
1.跳出多重循环

```cpp
int main(int argc, char* argv[])
{
	for (size_t i = 0; i < 100; i++) {
		for (size_t j = 0; j < 100; j++) {
			if (i == 50 && j == 75) {
				printf("找到(50, 75)\r\n");
				goto LOOP_EXIT;
			}
		}
	}
	
LOOP_EXIT:
	printf("这里是LOOP标签\r\n");
	return 0;
}
```

2.资源的动态申请和释放模板

```cpp
#include <stdlib.h>
int main(int argc, char* argv[])
{
	int nRet = 0;//0表示正常
	int *pStudent = NULL;
	int *pTeacher = NULL;
	int *pSchool = NULL;
	
	pStudent = (int*)malloc(sizeof(int));
	if (pStudent == NULL) {
		nRet = ‐1;
		goto LABEL_EXIT;
	}
	*pStudent = 0x1111111;
	
	pTeacher = (int*)malloc(sizeof(int));
	if (pTeacher == NULL) {
		nRet = ‐1;
		goto LABEL_EXIT;
	}
	*pTeacher = 0x22222222;
	
	pSchool = (int*)malloc(sizeof(int));
	if (pSchool == NULL) {
		nRet = ‐1;
		goto LABEL_EXIT;
	}
	
LABEL_EXIT:
	//统一的检查和释放
	if (pSchool != NULL)
	{
		free(pSchool);
		pSchool = NULL;
	}
	if (pTeacher != NULL) {
		free(pTeacher);
		pTeacher = NULL;
	}
	
	if (pStudent != NULL) {
		free(pStudent);
		pStudent = NULL;
	}
	return nRet;
}
```

<font color=#FF0000>坏处：</font> <font color=#FF0000>破坏代码结构，逻辑顺序。</font>

**类似goto的方式**

```cpp
do{

	do_something 
	.....
	break;
	

}while(0)

```

<font color=#FF0000>坏处：</font> <font color=#FF0000>1.增加缩进，2.破坏可读性</font>

## 参考链接

[C语言中goto()函数的使用场景](https://blog.csdn.net/weixin_44297979/article/details/103880473)
