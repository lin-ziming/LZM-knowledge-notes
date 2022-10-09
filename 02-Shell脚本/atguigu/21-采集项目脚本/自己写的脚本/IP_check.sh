#! /bin/bash
#注：若IP变了，ssh也就登录不上去了，因此这个脚本纯属扯淡，没卵用！！！

#查看IP,若IP不对,则重启网络
cluster="hadoop"
for i in 102 103 104; do
    host=$cluster$i
    # echo "check $host IP"
    ip=$(ssh $host "sudo ifconfig ens33 |grep netmask |awk '{print \$2}'")
    echo "=============== $host IP:$ip"
    # echo "192.168.1.$i"
    if [ $ip != "192.168.1.$i" ]; then
        echo "$host restart network......"
        ssh $host "sudo systemctl restart network"
    fi
done
# for host in hadoop102 hadoop103 hadoop104; do
#     echo "$host IP:$(ssh $host "sudo ifconfig ens33 |grep netmask |awk '{print \$2}'")"
# done