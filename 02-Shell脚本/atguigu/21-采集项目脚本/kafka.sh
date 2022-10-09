#! /bin/bash
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "参数必须输入start/stop/status..."
	exit
fi
#2、根据参数匹配执行
case $1 in
"start")
	for host in hadoop102 hadoop103 hadoop104
	do
		echo "=======================start $host kafka======================"
		ssh $host "/opt/module/kafka/bin/kafka-server-start.sh -daemon /opt/module/kafka/config/server.properties"
	done
;;
"stop")
	for host in hadoop102 hadoop103 hadoop104
	do
		echo "=======================stop $host kafka======================"
		ssh $host "/opt/module/kafka/bin/kafka-server-stop.sh"
	done
;;
"status")
	for host in hadoop102 hadoop103 hadoop104
	do
		echo "=======================$host kafka status======================"
        # 1.$()表示拿到执行结果；2.grep -v 反向过滤
		pid=$(ssh $host "ps -ef |grep server.properties | grep -v grep")
        # 中括号表示判断
		[ "$pid" ] && echo "kafka进程正常！！！" || echo "kafka进程不存在或者异常！！！"
	done
;;
*)
	echo "参数输入错误..."
;;
esac