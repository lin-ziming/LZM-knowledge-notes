#! /bin/bash
#business_import_data.sh
#1、清理旧数据 /origin_data/gmall/db
hdfs dfs -test -e /origin_data/gmall/db
if [ $? -eq 0 ]
then
	hdfs dfs -rm -r /origin_data/gmall/db
fi
#2、遍历日期[需要生成2020-06-10、2020-06-11、2020-06-12、2020-06-13、2020-06-14、2020-06-15、2020-06-16]
for datestr in "2020-06-10" "2020-06-11" "2020-06-12" "2020-06-13" "2020-06-14" "2020-06-15" "2020-06-16"
do
#3、停止maxwell[历史数据不需要maxwell采集]
	mxwpid=$(ps -ef |grep maxwell| grep -v grep)
	[ "$mxwpid" ] && mxw.sh stop;echo "maxwell已停止" || echo "maxwell未启动..."
#4、修改生成数据的配置[mock.date、mock.clear、mock.clear.user配置]
	echo "准备修改生成数据的日期配置..."
	sed -i "s/mock.date=.*/mock.date=$datestr/g" /opt/module/gmall/application.properties
	echo "生成数据的日期配置已经修改完成..."
	if [ $datestr == "2020-06-10" ]
	then
		echo "首次生成数据,修改mock.clear、mock.clear.user配置为1..."
		sed -i "s/mock.clear=.*/mock.clear=1/g" /opt/module/gmall/application.properties
		sed -i "s/mock.clear.user=.*/mock.clear.user=1/g" /opt/module/gmall/application.properties
		echo "首次生成数据,mock.clear、mock.clear.user配置修改完成..."
	else
		echo "非首次生成数据,修改mock.clear、mock.clear.user配置为0..."
		sed -i "s/mock.clear=.*/mock.clear=0/g" /opt/module/gmall/application.properties
		sed -i "s/mock.clear.user=.*/mock.clear.user=0/g" /opt/module/gmall/application.properties
		echo "非首次生成数据,mock.clear、mock.clear.user配置修改完成..."
	fi
#5、生成当前日期的数据
	echo "准备生成${datestr}日期的数据..."
	cd /opt/module/gmall
	nohup java -jar gmall2020-mock-db-2021-11-14.jar >/dev/null 2>&1
	echo "${datestr}日期的数据生成完成..."
#6、如果当前时间是2020-06-14
	if [ $datestr == "2020-06-14" ] || [ $datestr == "2020-06-15" ] || [ $datestr == "2020-06-16" ] 
	then
		#6.1、修改maxwell mock_date参数
		echo "准备修改maxwell配置日期..."
		sed -i "s/mock_date=.*/mock_date=$datestr/g" /opt/module/maxwell/config.properties
		echo "maxwell配置日期修改完成..."
		#6.2、如果是2020-06-14,删除maxwell元数据,避免采集到模拟生成历史数据的时候binlog记录
		if [ $datestr == "2020-06-14" ]
		then
			#2020-06-14是首日导入数据,所以历史数据mysql binlog日志不需要,需要删除maxwell断点记录
			echo "断点记录删除中..."
			mysql -uroot -p081010 -e"
use maxwell;
drop table maxwell.bootstrap;
drop table maxwell.columns;
drop table maxwell.databases;
drop table maxwell.heartbeats;
drop table maxwell.positions;
drop table maxwell.schemas;
drop table maxwell.tables;
"
			echo "断点记录删除完成..."
			#6.3、启动maxwell
			mxw.sh start
			echo "首日准备导入增量全部历史数据中...."
			mysql_to_kafka_inc_init.sh all
			echo "首日增量数据导入完成..."
		else
			#启动maxwell
			mxw.sh start
		fi
		#6.4、开始导入数据[全量表数据导入]
		mysql_to_hdfs_full.sh all $datestr
	fi
done
#8、启动Flume将增量数据从kafka导入hdfs
fpid=$(ssh hadoop104 "ps -ef |grep kafka_to_hdfs_db_inc.conf |grep -v grep")
[ "$fpid" ] && echo "增量采集Flume已经启动..." || f3.sh start

