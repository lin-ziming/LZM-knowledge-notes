#! /bin/bash
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须传入start/stop...."
	exit
fi
#2、根据参数匹配执行
case $1 in
"start")
	echo "====================start hdfs======================"
	ssh hadoop102 "start-dfs.sh"
	echo "====================start yarn======================"
	ssh hadoop103 "start-yarn.sh"
;;
"stop")
	echo "====================stop yarn======================"
	ssh hadoop103 "stop-yarn.sh"
	echo "====================stop hdfs======================"
	ssh hadoop102 "stop-dfs.sh"
;;
*)
	echo "参数传入错误...."
;;
esac