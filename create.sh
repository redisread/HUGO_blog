#!/bin/bash
# author: Redisread
# 创建Markdown模板
displayDirs(){
	dir=$(ls -l ./content/zh/posts/ |awk '/^d/ {print $NF}')
	echo -e "all dirs:"
	for i in $dir
	do
	    echo $i
	done
	echo -e "--end--\n"
}

inputDirAndFilename(){
	read -p "please input dir:" mydir 
	echo -e "get dir:"$mydir"\n"

	read -p "please input article name:" myname 
	echo -e "get name:"$myname"\n"
}


copyDefaultTemplate(){
	src="$PWD/archetypes/default.md"
	dst=$PWD/content/zh/posts/${mydir}"/${myname}.md"
	cp "$src" "$dst"
}

replaceTemplate(){
	title_content='"{{ replace .Name "-" " " | title }}"'
	time_content="{{ .Date }}"
	title="$myname"
	now_time=$(date "+%Y-%m-%dT%H:%M:%S+08:00")
	sed -i "s/${title_content}/${title}/" "$dst"
	sed -i "s/${time_content}/${now_time}/" "$dst"
}

openMarkdownEditor(){
	if [[ `uname` == 'Darwin' ]];then
	# Mac OS X 操作系统
	echo "Mac"
	elif [[ `uname` == 'Linux' ]];then
	# GNU/Linux操作系统
	echo "Linux"
	elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" || "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]];then
	# Windows NT操作系统
	cmd="cd $PWD/content/zh/posts/${mydir}"
	$cmd
	cmd="explorer.exe ${myname}.md"
	echo $cmd
	eval $cmd
	fi
}

main(){
	displayDirs
	inputDirAndFilename
	copyDefaultTemplate
	replaceTemplate
	openMarkdownEditor
}

main