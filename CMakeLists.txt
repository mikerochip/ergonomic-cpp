cmake_minimum_required(VERSION 3.13)

project(CMakeTest)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_executable(CMakeTest src/main.cpp)
