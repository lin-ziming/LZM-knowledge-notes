#! /bin/bash
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须传入一个yyyy-MM-dd日期"
	exit
fi
#2、遍历日志服务器
for host in hadoop102 hadoop103
do
	#3、修改日志服务器application.yml文件中mock.date为指定日期
	ssh $host "sed -i 's/mock.date:.*/mock.date: \"$1\"/g'  /opt/module/applog/application.yml"
	#4、执行java -jar gmall2020-mock-log-2021-10-10.jar模拟生成日志数据
	#nohup: 免挂断[ssh连接断开不影响程序的执行]
	#&： 后台执行[ssh连接断开程序会终止]
	#0< : 标准输入 【外部数据传入脚本】
	#1> ：标准输出 【脚本执行过程中产生日志等输出保存位置】
	#2> : 错误输出 【脚本执行过程中产生错误输出保存位置】
	ssh $host "cd /opt/module/applog;nohup java -jar gmall2020-mock-log-2021-10-10.jar >/dev/null 2>&1 &"
done