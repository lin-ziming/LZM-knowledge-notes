#!/bin/bash
if(($#!=1))
then
        echo 请输入单个start或stop参数！
        exit
fi


#对传入的单个参数进行校验，在hadoop102和hadoop103且执行第一层采集通道的启动和停止命令
if [ $1 = start ]
then
        cmd="nohup /opt/module/elasticsearch-6.6.0/bin/elasticsearch > /dev/null  2>&1 &"
        elif [ $1 = stop ]
        then
                cmd="ps -ef | grep Elasticsearch | grep -v grep | awk  '{print \$2}' | xargs kill "
else
        echo 请输入单个start或stop参数！
fi

#在hadoop102和hadoop103且执行第一层采集通道的启动和停止命令
for i in hadoop102 hadoop103 hadoop104
do
        echo "--------------$i-----------------"
        ssh $i $cmd
        sleep 5s
done

# #启动kibana
# if [ $1 = start ]; then
#         sleep 2s
#         nohup /opt/module/kibana/bin/kibana > /opt/module/kibana/kibana.log 2>&1 &
# fi

# if [ $1 = stop ]; then
#         ps -ef | grep '.*node/bin/node.*src/cli'|grep -v grep | awk '{print $2}'| xargs kill
# fi
