cmake_minimum_required(VERSION 3.20)
# set 设置变量
set(TEST "true")
set(TEST_2 "这是一个测试")
message(STATUS "TEST: " ${TEST})
message(STATUS "TEST_2: " ${TEST_2})
# 设置多个值 其实就是设置list值 注意空格，或者可以用;代替
set(TEST_LIST "a" "b" "c")
message(STATUS "TEST_LIST: " ${TEST_LIST})

set(TEST_LIST_2 a;b;c)
message(STATUS "TEST_LIST_2: " ${TEST_LIST_2})

# 设置环境变量的值
message(STATUS "CXX: " $ENV{CXX})
set(ENV{CXX} "g++")
message(STATUS "CXX: " $ENV{CXX})

# unset
unset(TEST)
message(STATUS "TEST: " ${TEST})
unset(ENV{CXX})
message(STATUS "CXX: " $ENV{CXX})