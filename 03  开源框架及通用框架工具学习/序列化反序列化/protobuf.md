
---
dg-publish: true
---
```toc
```
## 安装
deepin v20下安装
```bash
sudo apt install gogoprotobuf # 命令行程序
sudo apt install libprotobuf-dev # 开发库
```
## 示例
### 创建address.proto文件
```protobuf
syntax = "proto3";
package tutorial;

message Persion {
     string name = 1;
     uint64 type = 2;
     uint64 age = 3;
}

message AddressBook {
     repeated Persion persion = 1;
}
```
运行protoc命令
```bash
protoc address.proto  --cpp_out=.
```
生成 address.pb.cc，address.pb.h文件

### c++写入程序
编写write.cpp文件
```cpp
#include <iostream>
#include <fstream>
#include <string>
#include "address.pb.h"

using namespace std;

void PromptForAddress(tutorial::Persion *persion) {
    string name="zycxxx";
    persion->set_name(name);

    int age=300;
    persion->set_age(age);

    int type=20;
    persion->set_type(type);
}

int main(int argc, char **argv) {
    //GOOGLE_PROTOBUF_VERIFY_VERSION;

    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " ADDRESS_BOOL_FILE" << endl;
        return -1;
    }

    tutorial::AddressBook address_book;
    {
        fstream input(argv[1], ios::in | ios::binary);
        if (!input) {
            cout << argv[1] << ": File not found. Creating a new file." << endl;
        }
        else if (!address_book.ParseFromIstream(&input)) {
            cerr << "Filed to parse address book." << endl;
            return -1;
        }
    }

    // Add an address
    PromptForAddress(address_book.add_persion());
    // Add an address
    PromptForAddress(address_book.add_persion());
    // Add an address
    PromptForAddress(address_book.add_persion());

    const tutorial::Persion& person = address_book.persion(0);

    std::cout << "\t Name : " <<person.name() << endl;
    std::cout << "\t Type : " << person.type() << endl;
    std::cout << "\t age : " << person.age() << endl;

    {
        fstream output(argv[1], ios::out | ios::trunc | ios::binary);
        if (!address_book.SerializeToOstream(&output)) {
            cerr << "Failed to write address book." << endl;
            return -1;
        }
    }

    // Optional: Delete all global objects allocated by libprotobuf.
    //google::protobuf::ShutdownProtobufLibrary();

    return 0;
}

```

编译程序
```bash
g++ -std=c++11 address.pb.cc write.cpp -lprotobuf -lpthread -o write
```

使用
```bash
./write 1.txt
```

### c++读取程序
编写read.cpp文件
```cpp
#include <iostream>
#include <fstream>
#include <string>
#include "address.pb.h"

using namespace std;

void ListPeople(const tutorial::AddressBook& address_book) 
{
        for (int i = 0; i < address_book.persion_size(); i++) 
        {
                const tutorial::Persion& persion = address_book.persion(i);

                cout << persion.name() << " " << persion.age()<<" "<<persion.type() << endl;
        }
}

int main(int argc, char **argv)
{
        //GOOGLE_PROTOBUF_VERIFY_VERSION;

        if (argc != 2) 
        {
                cerr << "Usage: " << argv[0] << " ADDRESS_BOOL_FILE" << endl;
                return -1;
        }

        tutorial::AddressBook address_book;
        {
                fstream input(argv[1], ios::in | ios::binary);
                if (!address_book.ParseFromIstream(&input)) 
                {
                        cerr << "Filed to parse address book." << endl;
                        return -1;
                }
                input.close();
        }
    ListPeople(address_book);
        // Optional: Delete all global objects allocated by libprotobuf.
        //google::protobuf::ShutdownProtobufLibrary();

        return 0;
}
```
编译程序
```bash
g++ -std=c++11 address.pb.cc read.cpp -lprotobuf -lpthread -o read
```

使用
```bash
./read 1.txt
```

## Q&A
- **为什么要加上pthread库？明明没有使用线程**

下面是不加上pthread库编译时运行结果
```
liuwh@liuwh-PC ~/D/protobuf_learn> ./write 1.txt
terminate called after throwing an instance of 'std::system_error'
  what():  Unknown error -1
fish: './write 1.txt' terminated by signal SIGABRT (Abort)

```

下面是我在网上搜索到的答案，虽然跟protobuf不相关，但是加上pthread库后 真的可以运行了。:-D
> 报错场景是编译的时候没问题，但是运行的时候会报错：terminate called after throwing an instance of 'std::system_error'
> 
> 原因是编译的时候忘了加 -pthread或者-lpthread了。



## 参考链接
[官网地址](https://developers.google.cn/protocol-buffers/)