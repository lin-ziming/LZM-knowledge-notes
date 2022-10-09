#! /bin/bash
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须传入start/stop/status...."
	exit
fi
#2、根据参数匹配执行
var=""
case $1 in
"start")
	var=start
	;;
"stop")
	var=stop
	;;
"status")
	var=status
	;;
*)
	echo "必须传入start/stop/status其中一个"
	exit
	;;
esac

for host in hadoop102 hadoop103 hadoop104
do
	echo "======================start $host zookeeper==================="
	ssh $host "/opt/module/zookeeper/bin/zkServer.sh $var"
done