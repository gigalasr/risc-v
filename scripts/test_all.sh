EXT=".vhdl"

find . -name "*_tb.vhdl" | while read -r filepath; do 
    filename=$(basename $filepath)
    basename=${filename%$EXT}
    tools/vhdlmake/build/vhdlmake run $basename
done 