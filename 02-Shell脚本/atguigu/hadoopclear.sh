#!/bin/bash
for host in hadoop102 hadoop103 hadoop104
do
	ssh $host rm -rf $HADOOP_HOME/data $HADOOP_HOME/logs
	ssh $host sudo rm -rf /tmp/*
done
