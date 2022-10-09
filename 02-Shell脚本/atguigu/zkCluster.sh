#!/bin/bash

#判断参数的个数
if [ $# -ne 1 ]
	then
		echo "参数的个数不对！！！"
		exit #退出程序
fi

var=""
case $1 in
"start")
	var=start
	;;
"stop")
	var=stop
	;;
"restart")
	var=restart
	;;
"status")
	var=status
	;;
*)
	echo "参数的内容不对!!!"
	exit #退出不向下继续执行
	;;
esac


	for host in hadoop102 hadoop103 hadoop104
	do
		echo "===============$host=================="
		ssh $host zkServer.sh $var
	done
