#!/bin/bash
#除了此脚本文件外，把当前目录下的所有文件，里面的
# hadoop162,hadoop163,hadoop164改成hadoop302,hadoop303,hadoop304

pdir=$(cd -P $(dirname $0); pwd)
this_file=$(basename $0)

function read_dir(){
for file in `ls $1 |grep -v $this_file` #注意此处这是两个反引号，表示运行系统命令
	do
		if [ -f $1/$file ]  #在此处处理文件即可
		then
		sed -i	-e "s/hadoop162/hadoop302/g" \
			-e "s/hadoop163/hadoop303/g" \
			-e "s/hadoop164/hadoop304/g" $1/$file
		fi
	done
}
 
read_dir $pdir




# sed -i "s/hadoop162/hadoop302/" /opt/software/mock/mock_db/application.properties
# sed -i "s/hadoop162/mock_date=$day/" /opt/module/maxwell-1.27.1/config.properties
