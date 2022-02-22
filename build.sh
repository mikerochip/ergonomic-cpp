set -x

mkdir -p build
cd build

conan install .. --build=missing

# source dir is parent since that's where CMakeLists.txt is expected to be
cmake -S .. -B .

make all
