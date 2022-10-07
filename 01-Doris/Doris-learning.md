# Doris学习

# 1.安装部署

## 1.1安装要求

- Linux操作系统要求

| linux系统 | 版本        |
| --------- | ----------- |
| Centos    | 7.1及以上   |
| Ubuntu    | 16.04及以上 |

- 软件需求

| 软件 | 版本        |
| ---- | ----------- |
| Java | 1.8及以上   |
| GCC  | 4.8.2及以上 |

- 开发测试环境

| 模块     | CPU  | 内存 | 磁盘                | 网络     | 实例数量 |
| -------- | ---- | ---- | ------------------- | -------- | -------- |
| Frontend | 8核+ | 8GB  | SSD或 SATA，10GB+ * | 千兆网卡 | 1        |
| Backend  | 8核+ | 16GB | SSD或 SATA，50GB+ * | 千兆网卡 | 1-3*     |

- 生产环境

| 模块     | CPU   | 内存 | 磁盘                 | 网络     | 实例数量 |
| -------- | ----- | ---- | -------------------- | -------- | -------- |
| Frontend | 16核+ | 64GB | SSD或 SATA，100GB+ * | 万兆网卡 | 1-5*     |
| Backend  | 16核+ | 64GB | SSD或 SATA，100GB+ * | 万兆网卡 | 10-100*  |

### 注意事项

（1）FE的磁盘空间主要用于存储元数据，包括日志和image。通常从几百MB到几个GB不等。

（2）BE的磁盘空间主要用于存放用户数据，总磁盘空间按用户总数据量* 3（3副本）计算，然后再预留额外40%的空间用作后台compaction以及一些中间数据的存放。

（3）一台机器上可以部署多个BE实例，但是只能部署一个 FE。如果需要 3 副本数据，那么至少需要 3 台机器各部署一个BE实例（而不是1台机器部署3个BE实例）。多个FE所在服务器的时钟必须保持一致（允许最多5秒的时钟偏差）

（4）测试环境也可以仅适用一个BE进行测试。实际生产环境，BE实例数量直接决定了整体查询延迟。

（5）所有部署节点关闭Swap。

（6）FE节点数据至少为1（1个Follower）。当部署1个Follower和1个Observer时，可以实现读高可用。当部署3个Follower时，可以实现读写高可用（HA）。

（7）Follower的数量必须为奇数，Observer 数量随意。

（8）根据以往经验，当集群可用性要求很高时（比如提供在线业务），可以部署3个 Follower和1-3个Observer。如果是离线业务，建议部署1个Follower和1-3个Observer。

（9）Broker是用于访问外部数据源（如HDFS）的进程。通常，在每台机器上部署一个 broker实例即可。

### 内部端口

| 实例名称 | 端口名称               | 默认端口 | 通讯方向               | 说明                                         |
| -------- | ---------------------- | -------- | ---------------------- | -------------------------------------------- |
| BE       | be_prot                | 9060     | FE-->BE                | BE上thrift server的端口用于接收来自FE 的请求 |
| BE       | webserver_port         | 8040     | BE<-->FE               | BE上的http server端口                        |
| BE       | heartbeat_service_port | 9050     | FE-->BE                | BE上心跳服务端口用于接收来自FE的心跳         |
| BE       | brpc_prot*             | 8060     | FE<-->BEBE<-->BE       | BE上的brpc端口用于BE之间通信                 |
| FE       | http_port              | 8030     | FE<-->FE用户<--> FE    | FE上的http_server端口                        |
| FE       | rpc_port               | 9020     | BE-->FEFE<-->FE        | FE上thirt server端口号                       |
| FE       | query_port             | 9030     | 用户<--> FE            | FE上的mysql server端口                       |
| FE       | edit_log_port          | 9010     | FE<-->FE               | FE上bdbje之间通信用的端口                    |
| Broker   | broker_ipc_port        | 8000     | FE-->BROKERBE-->BROKER | Broker上的thrift server用于接收请求          |

当部署多个FE实例时，要保证FE的http_port配置相同。

部署前请确保各个端口在应有方向上的访问权限。

## 1.2 集群部署

生产环境建议FE和BE分开。

### 1.2.1 操作系统安装要求

设置系统最大打开文件句柄数

sudo vim /etc/security/limits.conf

* soft nofile 65536
* hard nofile 131072
* soft nproc 2048
* hard nproc 65536

重启生效

### 1.2.4 配置FE

#### 创建FE元数据存储目录

`mkdir /opt/module/doris-1.1.1/doris-meta`

#### 修改FE配置文件

```shell
vim /opt/module/doris-1.1.1/fe/conf/fe.conf

# web 页面访问端口
http_port = 7030
# 配置文件中指定元数据路径
meta_dir = /opt/module/doris-1.1.1/doris-meta
# 修改绑定 ip
priority_networks = 192.168.188.162/24
```

- 生产环境强烈建议单独指定目录不要放在Doris安装目录下，最好是单独的磁盘（如果有SSD最好）。
- 如果机器有多个ip, 比如内网外网, 虚拟机docker等, 需要进行ip绑定，才能正确识别。
- JAVA_OPTS 默认 java 最大堆内存为 4GB，建议生产环境调整至 8G 以上。

#### 启动FE

`/opt/module/doris-1.1.1/fe/bin/start_fe.sh --daemon`

#### 登录 FE Web页面

地址: http://host:7030/login
用户:root
密码:无

### 1.2.5 配置BE

#### 创建BE数据存放目录

```
mkdir /opt/module/doris-1.1.1/doris-storage1
mkdir /opt/module/doris-1.1.1/doris-storage2.SSD
```

#### 修改BE配置文件

```
vim /opt/module/doris-1.1.1/be/conf/be.conf

storage_root_path = /opt/module/doris-1.1.1/doris-storage1;/opt/module/doris-1.1.1/doris-storage2.SSD,10
priority_networks = 192.168.188.162/24
webserver_port = 7040 
```

注意：

- storage_root_path默认在be/storage下，需要手动创建该目录。多个路径之间使用英文状态的分号;分隔（最后一个目录后不要加）。
- 可以通过路径区别存储目录的介质，HDD或SSD。可以添加容量限制在每个路径的末尾，通过英文状态逗号，隔开，如：

  ```

  storage_root_path=/home/disk1/doris.HDD,50;/home/disk2/doris.SSD,10;/home/disk2/doris

  说明：

  /home/disk1/doris.HDD,50，表示存储限制为50GB，HDD;

  /home/disk2/doris.SSD,10，存储限制为10GB，SSD；

  /home/disk2/doris，存储限制为磁盘最大容量，默认为HDD
  ```
- 如果机器有多个IP, 比如内网外网, 虚拟机docker等, 需要进行IP绑定，才能正确识别。

#### 分发BE和BE存储目录

```
my_rsync be
my_rsync doris-storage1
my_rsync doris-storage2.SSD
```

#### 在 hadoop163 和 hadoop164 中修改 ip

```
priority_networks = 192.168.188.163/24
priority_networks = 192.168.188.164/24
```

### 1.2.6添加BE

BE节点需要先在FE中添加，才可加入集群。可以使用mysql-client连接到FE。

#### 使用 Mysql 客户端连接到 FE

`mysql -h hadoop162 -uroot -P 9030`

- -P 指定端口(注意这里 P 是大写, 小写 p 用来指定密码)
- FE 默认没有密码
- 设置密码：`SET PASSWORD FOR 'root' = PASSWORD('aaaaaa');`

#### 添加 BE

```
ALTER SYSTEM ADD BACKEND "hadoop162:9050";
ALTER SYSTEM ADD BACKEND "hadoop163:9050";
ALTER SYSTEM ADD BACKEND "hadoop164:9050";
```

#### 查看 BE状态

`SHOW PROC '/backends';  或 SHOW PROC '/backends'\G;`

### 1.3.7启动BE

#### 分别在三台设备启动BE进程

`xcall /opt/module/doris-1.1.1/be/bin/start_be.sh --daemon`

#### 查询 BE 状态

```
mysql -h hadoop162 -P 9030 -uroot -paaaaaa

show proc '/backends'; 或 show proc '/backends'\G;
```

Alive为true表示该BE节点存活。

# Doris时区问题

## 查看时区

`show variables like '%time_zone%';`
结果如下：

| Variable_name    | Value         |
| ---------------- | ------------- |
| system_time_zone | Europe/London |
| time_zone        | Europe/London |

system_time_zone 无法修改，自动跟随系统

## 修改时区

1.单会话修改
`set time_zone='Asia/Shanghai';`
**2.全局修改**
`set global time_zone='Asia/Shanghai';`
再查看时区

| Variable_name    | Value         |
| ---------------- | ------------- |
| system_time_zone | Europe/London |
| time_zone        | Asia/Shanghai |



# 时间日期写入Doris的一些细节

1. 把日期用String类型写入Doris不受时区影响。
2. 更改时区后，已经插入Doris的数据不受时区更改影响。
