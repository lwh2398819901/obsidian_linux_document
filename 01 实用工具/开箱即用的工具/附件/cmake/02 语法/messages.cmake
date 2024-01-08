cmake_minimum_required(VERSION 3.20)
message("hello world")  # 单行
message("hello          # 多行
        world")
message(hello world)    # 加不加双引号都可以
message(${CMAKE_VERSION})
# 列出cmake message所有用法

set(CMAKE_VERBOSE_MAKEFILE FALSE)
message(SILENT " This message will be silent.") # 不输出任何信息
message(STATUS "Hello, world!") # 输出状态信息
message(WARNING "This is a warning message.") # 输出警告信息
#message(FATAL_ERROR "This is a fatal error message.") # 输出错误信息
message(AUTHOR_WARNING "This is an author warning message.") # 输出作者警告信息
message(DEPRECATION "This is a deprecation message.") # 输出弃用信息
message(NOTICE "This is a notice message.") # 输出注意信息
#设置为debug  不起效果
set(CMAKE_BUILD_TYPE Debug)
message(DEBUG "This is a debug message.") # 输出调试信息
message(VERBOSE "This is a verbose message.") # 输出详细信息
message(ERROR "This is an error message.") # 输出错误信息

message("This is a plain text message.") # 输出纯文本信息
message("${CMAKE_CURRENT_SOURCE_DIR}") #打印变量 输出当前源目录的路径 