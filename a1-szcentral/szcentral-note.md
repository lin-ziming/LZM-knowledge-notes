# 问题

1. 模型定义有无序顺性？  
   神策智能运营：  
       触发条件：未来  
   　受众用户：历史条件（规则发布前）  
           画像条件、  
           行为条件、A>=3 and B<2 or C=1  
           历史序列条件 ( W Q F) > 2     

# 建议点

预划区域 尽可能划得小一点。

地图考虑用Geohash算法。

# ★项目优先级

1. 规则表设计（规则信息封装类）

2. 聚合逻辑 及 中间状态的 数据结构

3. 写流程（宏观工作流程）

★即 数据结构 先于 逻辑

# 具体开发

## 1.规则表设计（规则信息封装类）

## 2.聚合逻辑 及 中间状态的 数据结构

Redis Key 设计：      规则: 条件: 人 -> x次

## 3.写流程（宏观工作流程）

★即 数据结构 先于 逻辑

# 03

## 0 规则管理平台后端元数据

### 1）规则实例定义信息表

```sql
CREATE TABLE `rule_instance_definition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,  -- 自增主键
  `rule_id` varchar(50) DEFAULT NULL,  -- 规则实例id
  `rule_model_id` int(11) DEFAULT NULL, -- 规则模型id
  `rule_profile_user_bitmap` binary(255) DEFAULT NULL,  -- 规则实例的画像人群bitmap
  `caculator_groovy_code` text,  -- 规则实例的运算状态机groovy可执行代码
  `creator_name` varchar(255) DEFAULT NULL,  -- 规则实例创建人
  `rule_status` int(11) DEFAULT NULL,  -- 规则实例有效状态：1有效，0停用
  `create_time` datetime DEFAULT NULL, -- 规则实例创建时间
  `update_time` datetime DEFAULT NULL, -- 规则实例更新时间
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
```

# 数据量、资源估算

## 5.6 实时项目数据计算

### 5.6.1 跑实时任务，怎么分配内存和CPU资源

128m数据对应1g内存。
1个Kafka分区对应1个CPU。
1CU  = 1CPU + 4g内存
