#!/bin/bash
#自己写的脚本，用于启动/停止kibana
if(($#<1)); then
    echo 请输入单个start|stop|status参数！
    exit
fi
kibana_pid=$(ps -ef | grep '.*node/bin/node.*src/cli'|grep -v grep | awk '{print $2}')

case $1 in
"start")
    # 启动前保证没有kibana进程在运行
    if [ "$kibana_pid" ]; then
        echo "正在关闭kibana..."
        ps -ef | grep '.*node/bin/node.*src/cli'|grep -v grep | awk '{print $2}'| xargs kill
        echo "kibana已停止"
    fi
    echo "正在启动kibana..."
    nohup /opt/module/kibana/bin/kibana > /opt/module/kibana/kibana.log 2>&1 &
    sleep 6s

    pid=$(ps -ef | grep '.*node/bin/node.*src/cli'|grep -v grep | awk '{print $2}')
    [ $pid ] || echo "启动失败"

    # awk按双引号"分割; NF:列的个数;
    # ~ /REG/ 正则匹配
    # if判断，如果NF-1列含有"Server running at"，则按照空格切,存入tA数组，
    # 取数组tA的最后一个(数组下标范围1-length)
    awk -F '"' \
    '{ if($(NF-1) ~ /Server running at/) \
    { split($(NF-1),tA," "); \
    print("日志路径：/opt/module/kibana/kibana.log"); \
    print("kibana启动成功,请访问:\n"tA[length(tA)]) } \
    }' \
    /opt/module/kibana/kibana.log
    
    ;;
"stop")
    if [ "$kibana_pid" ]; then
        echo "正在关闭kibana..."
        ps -ef | grep '.*node/bin/node.*src/cli'|grep -v grep | awk '{print $2}'| xargs kill
        sleep 3s
        pid=$(ps -ef | grep '.*node/bin/node.*src/cli'|grep -v grep | awk '{print $2}')
        [ $pid ] && echo "关闭失败" || echo "kibana已关闭"
    else
        echo "kibana未启动"
    fi
    ;;
"status")
    [ "$kibana_pid" ] && echo "kibana的进程号为：$kibana_pid" || echo "kibana未启动"
    ;;
*)
	echo "参数输入错误,必须是start|stop|status..."
    ;;
esac


