cmake_minimum_required(VERSION 3.13)
project(CMakeTest)

set(CMAKE_CXX_STANDARD 14)

if(EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    conan_basic_setup()
else()
    message(WARNING "conanbuildinfo.cmake doesn't exist, you have to run conan install first")
endif()

include_directories(
  src
)
add_subdirectory(
  src/MyLibrary
)
add_executable(CMakeTest
  src/App/main.cpp
  src/App/MyApp/Foo.cpp
)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

target_link_libraries(CMakeTest MyLibrary ${CONAN_LIBS})
