
```toc
```
## 参考链接
[QChart的简单使用](https://blog.csdn.net/weixin_43450564/article/details/112370125)

## 安装
**windows**

**linux**

```bash
sudo apt install libqt5charts5-dev
```
 

## 使用QChart的前期准备
1. <font color=#FF0000> Qt5.9</font>及以上版本；
2. .pro文件中添加<font color=#FF0000>QT += charts</font>
3. 在使用QChart的各个控件之前，必须先声明一个命名空间。<font color=#FF0000>方法不限，可以使用 QT_CHARTS_USE_NAMESPACE 宏值，也可以手动使用 using namespace QT_CHARTS_NAMESPACE;</font>