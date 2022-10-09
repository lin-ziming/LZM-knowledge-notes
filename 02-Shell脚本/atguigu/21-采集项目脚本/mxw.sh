#! /bin/bash
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须传入start/stop..."
	exit
fi
#2、根据参数匹配执行
case $1 in
"start")
	/opt/module/maxwell/bin/maxwell --daemon --config /opt/module/maxwell/config.properties
;;
"stop")
	# ""与''区别:
	#	""中$N/$参数名 会取值
	#	''中$N/$参数名会当做普通字符串,不会取值
	#	""中有'',此时以最外面的为准,$N/$参数名 会取值
	#	''中有"",此时以最外面的为准,$N/$参数名会当做普通字符串,不会取值
	ps -ef |grep maxwell |grep -v grep|awk '{print $2}'|xargs kill -9
;;
*)
	echo "参数输入错误..."
;;
esac
