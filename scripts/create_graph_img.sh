GRAPH_RAW=$(tools/vhdlmake/build/vhdlmake graph)
BASE64_DATA=$(echo "$GRAPH_RAW" | sed -n 's/.*#base64:\(.*\)$/\1/p')
echo "$BASE64_DATA" | base64 -d |  jq -r '.code' > tmp.mmd
mmdc -i tmp.mmd -o graph.svg -t dark
mv graph.svg docs/graph.svg
rm tmp.mmd