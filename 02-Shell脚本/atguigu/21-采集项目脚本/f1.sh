#! /bin/bash
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须传入参数..."
	exit
fi
#2、根据参数匹配执行
case $1 in
"start")
	for host in hadoop102 hadoop103
	do
		echo "=================开启 $host 日志采集=================="
		ssh $host "nohup /opt/module/flume/bin/flume-ng agent -n a1 -c /opt/module/flume/conf/ -f /opt/module/flume/job/file_to_kafka.conf -Dflume.root.logger=INFO,console >/opt/module/flume/log.txt 2>&1 &"
	done
;;
"stop")
	for host in hadoop102 hadoop103
	do
		echo "=================停止 $host 日志采集=================="
		ssh $host "ps -ef | grep flume |grep -v grep|awk '{print \$2}'|xargs kill -9"
	done
;;
*)
	echo "参数输入错误,必须是start/stop..."
;;
esac

