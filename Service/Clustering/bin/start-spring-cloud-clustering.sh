#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    start-spring-cloud-clustering
## Description: 启动 spring cloud
## Author:      wujiaqi
## Created:     2018-5-7
################################################################################
#set -x  ## 用于调试用，不用的时候可以注释掉

#---------------------------------------------------------------------#
#                              定义变量                                #
#---------------------------------------------------------------------#

cd `dirname $0`
BIN_DIR=`pwd`                                  ### bin 目录

cd ..
CLUSTERING_DIR=`pwd`                              ### clustering 目录
CONF_CLUSTERING_DIR=${CLUSTERING_DIR}/conf   ### clustering 配置文件目录
LOG_DIR=${CLUSTERING_DIR}/logs                    ### LOG 目录
LOG_FILE=$LOG_DIR/start-spring-cloud.log
cd ..
SERVICE_DIR=`pwd`                              ### service 目录
CONF_SERVICE_DIR=$SERVICE_DIR/conf             ### service 配置文件

cd ..
OBJECT_DIR=`pwd`                               ### RealTimeFaceCompare 目录

JAR_CLUSTERING=`ls ${CLUSTERING_DIR}| grep ^clustering-[0-9].[0-9].[0-9].jar$`

if [ ! -d $LOG_DIR ]; then
    mkdir $LOG_DIR;
fi
#---------------------------------------------------------------------#
#                              定义函数                                #
#---------------------------------------------------------------------#

#####################################################################
# 函数名: start_spring_cloud
# 描述: 启动 spring cloud
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function start_spring_cloud()
{
    if [ ! -d $LOG_DIR ]; then
        mkdir $LOG_DIR;
    fi
    # java -classpath $CONF_CLUSTERING_DIR:$LIB_JARS com.hzgc.service.clustering.ClusteringApplication  | tee -a  ${LOG_FILE}
    java -jar ${JAR_CLUSTERING} | tee -a  ${LOG_FILE}
}

#####################################################################
# 函数名: update_properties
# 描述: 修改jar包中的配置文件
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function update_properties()
{
    cd ${CLUSTERING_DIR}
    cp conf/clusteringApplication.properties ./
    jar uf ${JAR_CLUSTERING} clusteringApplication.properties
    rm -f clusteringApplication.properties

    cp conf/*-site.xml ./
    jar uf ${JAR_CLUSTERING} hbase-site.xml
    jar uf ${JAR_CLUSTERING} core-site.xml
    jar uf ${JAR_CLUSTERING} hdfs-site.xml
    rm -f *-site.xml
}


#####################################################################
# 函数名: main
# 描述: 脚本主要业务入口
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function main()
{
    update_properties
    start_spring_cloud
}



## 打印时间
echo ""  | tee  -a  ${LOG_FILE}
echo ""  | tee  -a  ${LOG_FILE}
echo "==================================================="  | tee -a ${LOG_FILE}
echo "$(date "+%Y-%m-%d  %H:%M:%S")"                       | tee  -a  ${LOG_FILE}
main

set +x