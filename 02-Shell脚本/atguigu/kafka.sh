#!/bin/bash
# 1. 判断参数个数是否为0
if [ $# -ne 1 ];then
  echo -e "请输入参数：\nstart  启动kafka集群；\nstop  关闭kafka集群"&&exit
fi
# 2. 根据参数执行命令
command="/opt/module/kafka/bin/kafka-server-$1.sh -daemon /opt/module/kafka/config/server.properties"

case $1 in
  "start")
    for host in hadoop103 hadoop102 hadoop104
      do
      echo ========== $host $1 kafka ==========
        ssh $host $command
      done
  ;;
  "stop")
    for host in hadoop103 hadoop102 hadoop104
      do
      echo ========== $host $1 kafka ==========
        ssh $host $command
      done
  ;;
  *)
   echo -e "请输入参数：\nstart  启动kafka集群；\nstop  关闭kafka集群"&&exit
  ;;
esac


