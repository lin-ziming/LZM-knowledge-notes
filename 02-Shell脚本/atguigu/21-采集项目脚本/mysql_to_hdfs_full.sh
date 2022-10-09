#! /bin/bash
#mysql_to_hdfs.sh all/表名 [日期]
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须传入一个参数[all/表名]...."
	exit
fi
#2、判断日期是否传入,如果传入使用指定的日期,如果没有传入使用前一天的日期
[ "$2" ] && datestr=$2 || datestr=$(date -d "-1 day" +%F)

function import_data(){
	tableName=$1
	path="/origin_data/gmall/db/${tableName}_full/$datestr"
	#判断目标路径是否存在,如果存在需要删除旧数据,如果不存在创建目录
	hdfs dfs -test -e $path
	if [ $? -eq 0 ]
	then
		#删除目录[删除数据]
		echo "目录存在,删除中...."
		hdfs dfs -rm -r $path
		echo "目录删除完成..."
	fi
	echo "准备创建目录..."
	#创建目录
	hdfs dfs -mkdir -p $path
	echo "目录创建完成..."
	#同步表全量数据
	echo "准备同步${tableName}数据..."
	python /opt/module/datax/bin/datax.py -p"-Dtargetdir=$path" /opt/module/datax/job/import/gmall.${tableName}.json
	echo "${tableName}表数据同步完成..."
}
#3、根据第一个参数匹配执行
case $1 in
#导入所有增量表
"all")
	import_data "activity_info"
	import_data "activity_rule"
	import_data "base_category1"
	import_data "base_category2"
	import_data "base_category3"
	import_data "base_dic"
	import_data "base_province"
	import_data "base_region"
	import_data "base_trademark"
	import_data "cart_info"
	import_data "coupon_info"
	import_data "sku_attr_value"
	import_data "sku_sale_attr_value"
	import_data "sku_info"
	import_data "spu_info"
;;
"activity_info")
	import_data "activity_info"
;;
"activity_rule")
	import_data "activity_rule"
;;
"base_category1")
	import_data "base_category1"
;;
"base_category2")
	import_data "base_category2"
;;
"base_category3")
	import_data "base_category3"
;;
"base_dic")
	import_data "base_dic"
;;
"base_province")
	import_data "base_province"
;;
"base_region")
	import_data "base_region"
;;
"base_trademark")
	import_data "base_trademark"
;;
"cart_info")
	import_data "cart_info"
;;
"coupon_info")
	import_data "coupon_info"
;;
"sku_attr_value")
	import_data "sku_attr_value"
;;
"sku_sale_attr_value")
	import_data "sku_sale_attr_value"
;;
"sku_info")
	import_data "sku_info"
;;
"spu_info")
	import_data "spu_info"
;;
*)
	echo "表名输入错误..."
;;
esac