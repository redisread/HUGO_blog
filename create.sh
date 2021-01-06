dir=$(ls -l ./content/zh/posts/ |awk '/^d/ {print $NF}')
echo -e "all dirs:"
for i in $dir
do
    echo $i
done
echo -e "--end--\n"

read -p "please input dir:" mydir 
echo -e "get dir:"$mydir"\n"

read -p "please input article name:" myname 
echo -e "get name:"$myname"\n"

src="./archetypes/default.md"
dst="./content/zh/posts/"$mydir"/"$myname".md"
cmd="cp "$src" "$dst
$cmd

first_line="title: "$myname
cmd="sed -i '2c "$first_line"' "$dst
echo $cmd
eval $cmd

time_key="{{ .Date }}"
time=$(date "+%Y-%m-%dT%H:%M:%S+08:00")
cmd="sed -i 's/${time_key}/${time}/' "$dst
echo $cmd
eval $cmd