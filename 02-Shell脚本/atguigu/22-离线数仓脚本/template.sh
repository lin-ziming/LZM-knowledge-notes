#!/bin/bash
#使用: 脚本 日期
#接收外部传入的日期参数
#判断是否传入了日期，如果传入了，就使用这个日期，如果没有传入，可以退出脚本或手动指定一个日期
# if [ -n "$1"  ]
# then
# 	#如果为true，说明字符串不是空串，相当于传入了日期参数
# 	do_date=$1
# else
# 	#echo 请传入日期
# 	#exit
# 	#提供当前日期的昨天，作为默认日期
# 	do_date=$(date -d yesterday +'%F')
# fi

# 简化写法（杜老师的写法）
[ $1 ] && do_date=$1 || do_date=$(date -d "-1 day" +%F)

echo $do_date

hql="

#编写hql语句

"

hive -e "$hql" --database gmall
