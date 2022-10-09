#! /bin/bash
#mysql_to_hdfs_inc_init.sh all/表名
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须传入表名/all..."
	exit
fi

function import_data(){
	tableName=$1
	#1、删除topic
	/opt/module/kafka/bin/kafka-topics.sh --delete --topic $tableName --bootstrap-server hadoop102:9092,hadoop103:9092
	#2、增量表导入历史数据
	/opt/module/maxwell/bin/maxwell-bootstrap --database gmall --table $tableName --config /opt/module/maxwell/config.properties
}

#2、根据第一个参数匹配执行
case $1 in
"all")
import_data "cart_info"
import_data "comment_info"
import_data "coupon_use"
import_data "favor_info"
import_data "order_detail_activity"
import_data "order_detail_coupon"
import_data "order_detail"
import_data "order_info"
import_data "order_refund_info"
import_data "order_status_log"
import_data "payment_info"
import_data "refund_payment"
import_data "user_info"
;;
"cart_info")
	import_data "cart_info"
;;
"comment_info")
	import_data "comment_info"
;;
"coupon_use")
	import_data "coupon_use"
;;
"favor_info")
	import_data "favor_info"
;;
"order_detail_activity")
	import_data "order_detail_activity"
;;
"order_detail_coupon")
	import_data "order_detail_coupon"
;;
"order_detail")
	import_data "order_detail"
;;
"order_info")
	import_data "order_info"
;;
"order_refund_info")
	import_data "order_refund_info"
;;
"order_status_log")
	import_data "order_status_log"
;;
"payment_info")
	import_data "payment_info"
;;
"refund_payment")
	import_data "refund_payment"
;;
"user_info")
	import_data "user_info"
;;
*)
	echo "表名输入错误..."
;;
esac