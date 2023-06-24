#!/bin/bash
# author: Redisread
# 显示目录

displayDirs(){
	dir=$(ls -l ./content/zh/posts/ |awk '/^d/ {print $NF}')
	echo -e "all dirs:"
	for i in $dir
	do
	    echo $i
	done
	echo -e "--end--\n"
}


displayDirs