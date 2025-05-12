EXT=".vhdl"

set -e 

find . -name "*_tb.vhdl" | while read -r filepath; do 
    filename=$(basename $filepath)
    basename=${filename%$EXT}
    echo -e "\n\033[32mRunning testbench $basename \033[0m"
    tools/vhdlmake/build/vhdlmake run $basename
done 