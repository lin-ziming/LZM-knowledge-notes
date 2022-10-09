#!/bin/bash

flink=/opt/module/flink-1.13.6/bin/flink
jar=/opt/gmall211227/edu-1.0-SNAPSHOT.jar
apps=(
com.atguigu.app.dim.DimApp
com.atguigu.app.dwd.log.BaseLogApp
com.atguigu.app.dwd.log.DwdTrafficUniqueVisitorDetail
com.atguigu.app.dwd.log.Dwd_03_DwdTrafficUserJumpDetail

#com.atguigu.realtime.app.dwd.db.Dwd_05_DwdTradeOrderPreProcess
#com.atguigu.realtime.app.dwd.db.Dwd_06_DwdTradeOrderDetail
#com.atguigu.realtime.app.dwd.db.Dwd_08_DwdTradePayDetailSuc
)

running_apps=`$flink list 2>/dev/null | awk  '/RUNNING/ {print \$(NF-1)}'`

for app in ${apps[*]} ; do
    app_name=`echo $app | awk -F. '{print \$NF}'`

    if [[ "${running_apps[@]}" =~ "$app_name" ]]; then
        echo "$app_name 已经启动,无序重复启动...."
    else
         echo "启动应用: $app_name"
        $flink run -d -c $app $jar
    fi
done




