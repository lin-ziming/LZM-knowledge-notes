#!/bin/bash
read -p "请输入你要运行的jar包： " jar_name
flink=/opt/module/flink-1.13.6-yarn/bin/flink
jar=/opt/edu_realtime/$jar_name

running_apps=`$flink list 2>/dev/null | awk  '/RUNNING/ {print \$(NF-1)}'`

while read app ; do
    flag=`echo ${app:0:1}`
    if [[ "$flag" != "c" ]]; then 
         continue 
    fi

    app_name=`echo $app | awk -F. '{print \$NF}'`

    if [[ "${running_apps[@]}" =~ "$app_name" ]]; then
        echo "$app_name 已经启动,无序重复启动...."
    else
         echo "启动应用: $app_name"
        $flink run -d -c $app $jar
    fi
done < app_names.txt




