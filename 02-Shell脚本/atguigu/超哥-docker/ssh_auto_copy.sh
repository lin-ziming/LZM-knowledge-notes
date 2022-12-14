#!/bin/bash

echo "开始配置免密登录......"
for current in hadoop162 hadoop163 hadoop164 ; do
    for other in hadoop162 hadoop163 hadoop164 ; do
      sshpass -p aaaaaa ssh -q -o StrictHostKeyChecking=no $current "sshpass -p aaaaaa ssh-copy-id  -o StrictHostKeyChecking=no $other"
    done
done
for current in hadoop162 hadoop163 hadoop164 ; do
    for other in hadoop162 hadoop163 hadoop164 ; do
      sshpass -p aaaaaa ssh -q -o StrictHostKeyChecking=no root@$current "sshpass -p aaaaaa ssh-copy-id  -o StrictHostKeyChecking=no root@$other"
    done
done
echo "恭喜, 免密登录配置完成!"

echo "开始格式化 namenode......"
hdfs namenode -format
echo  -e "\033[32m 恭喜, namenode 格式化完成, 请检查是否成功格式化!!! \033[0m"

echo "读取mysql初始密码..."
pwd=$(sudo cat /var/log/mysqld.log | awk -v FS=": " '/password/ {print $2}' | head -n1)
echo "初始密码为: ${pwd}"
echo "给mysql设置新密码: aaaaaa"
mysql -uroot -p${pwd} --connect-expired-password -e "
set global validate_password_length=4;
set global validate_password_policy=0;
set password=password('aaaaaa');
use mysql;
update user set host='%' where user='root';
flush privileges;
CREATE DATABASE gmall2022 CHARACTER SET utf8 COLLATE utf8_general_ci;
use gmall2022;
source /opt/software/mock/mock_db/gmall.sql;
"
echo -e "\033[34m 恭喜, msyql root用户密码已改为:aaaaaa \033[0m"

echo "初始化hive原数据库"
mysql -uroot -paaaaaa -e 'create database metastore'
schematool -initSchema -dbType mysql -verbose

echo -e "\033[31m 本脚本只需要在容器创建成功之后第 1 次启动时在hadoop162上一次执行, 其他情况无需执行!!! \033[0m"


