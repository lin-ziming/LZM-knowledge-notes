#!/bin/bash
if(($#!=1))
then
        echo 请输入单个start或stop参数！
        exit
fi

if [ $1 = start ]
then
        cmd="nohup java -jar /opt/module/gmall_logger.jar > /dev/null  2>&1 &"
        elif [ $1 = stop ]
        then
                cmd="ps -ef | grep gmall_logger.jar | grep -v grep | awk  '{print \$2}' | xargs kill "
else
        echo 请输入单个start或stop参数！
fi

#在hadoop102和hadoop103且执行第一层采集通道的启动和停止命令
for i in hadoop102 hadoop103 hadoop104
do
        echo "--------------$i-----------------"
        ssh $i $cmd
done
