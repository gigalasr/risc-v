oldcwd=$(pwd)

cd tools/vhdlmake
mkdir -p build
cd build
cmake ..
make 

PATH=$PATH:$(pwd)

cd $oldcwd