#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    hadoopStart.sh
## Description: 启动hadoop集群的脚本.
## Version:     1.0
## Author:      qiaokaifeng
## Created:     2017-10-24
################################################################################
#set -e
#set -x

cd `dirname $0`
## 脚本所在目录
BIN_DIR=`pwd`
cd ..
## 安装包根目录
ROOT_HOME=`pwd`
## 配置文件目录
CONF_DIR=${ROOT_HOME}/conf
## 安装日记目录
LOG_DIR=${ROOT_HOME}/logs
## 安装日记目录
LOG_FILE=${LOG_DIR}/hadoopStart.log
## 最终安装的根目录，所有bigdata 相关的根目录
INSTALL_HOME=$(grep Install_HomeDir ${CONF_DIR}/cluster_conf.properties|cut -d '=' -f2)
Hadoop_Masters=$(grep Hadoop_NameNode ${CONF_DIR}/cluster_conf.properties|cut -d '=' -f2)
namenode_arr=(${Hadoop_Masters//;/ }) 
MASTER1=${namenode_arr[0]}
MASTER2=${namenode_arr[1]}

echo -e '启动Hadoop'

${INSTALL_HOME}/Hadoop/hadoop/sbin/start-dfs.sh
	if [ $? -eq 0 ];then
	    echo -e 'hdfs success \n'
	else 
	    echo -e 'hdfs failed \n'
	fi

# 等待7秒后再验证Hadoop是否启动成功
echo -e "********************验证Hadoop是否启动成功*********************"
sleep 7s
source $(grep Source_File ${CONF_DIR}/cluster_conf.properties|cut -d '=' -f2)
xcall jps | grep -E 'NameNode|DataNode|JournalNode|DFSZKFailoverController|jps show as bellow'
