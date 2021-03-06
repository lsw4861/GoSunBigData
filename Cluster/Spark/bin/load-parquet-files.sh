#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    load-parquet-files.sh
## Description: 加载分区数据到peroson_table
## Author:      qiaokaifeng
## Created:     2017-11-18
################################################################################
#set -x  ## 用于调试用，不用的时候可以注释掉


cd `dirname $0`
BIN_DIR=`pwd`                                                                ## spark/bin目录
cd ..
DEPLOY_DIR=`pwd`
cd ..
CLUSTER_DIR=`pwd`                                                            ## cluster 模块目录
cd ..
PROJECT_DIR=`pwd`                                                            ## 项目根目录
CONF_DIR=${DEPLOY_DIR}/conf                                                    ## spark模块conf目录
LIB_DIR=${DEPLOY_DIR}/lib                                                      ## lib目录
LIB_JARS=`ls ${LIB_DIR}|grep .jar|awk '{print "'${LIB_DIR}'/"$0}'|tr "\n" ":"`   ## jar 包位置以及第三方依赖jar包，绝对路径
sleep 2s
LOG_DIR=${DEPLOY_DIR}/logs                                                   ## log 日记目录
LOG_FILE=${LOG_DIR}/load-parquet-files.log                                   ## log 日记文件
SPARKJOB_PROPERTIES=${DEPLOY_DIR}/conf/sparkJob.properties


if [ ! -d ${LOG_DIR} ]; then
    mkdir -p ${LOG_DIR};
fi


SPARK_STREAMING_KAFKA=1.6.2
KAFKA_VERSION=1.0.0
SCALA_VERSION=2.11

LIB_SPARK_JAR=`ls ${LIB_DIR}| grep ^spark-[0-9].[0-9].[0-9].jar$`

hdfsClusterName=$(grep job.smallfile.merge.hdfs.name  ${SPARKJOB_PROPERTIES} | awk -F "=" '{print $2}')
hdfsPath=$(grep job.smallfile.merge.person_table.hdfs_path  ${SPARKJOB_PROPERTIES} | awk -F "=" '{print $2}')
tableName=$(grep job.smallfile.merge.person_table.hdfs_path   ${SPARKJOB_PROPERTIES}| awk -F "=" '{print $2}')
#####################################################################
# 函数名: start_load_data
# 描述: 加载数据
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function load_parquet()
{
    source /etc/profile
    spark-submit --class com.hzgc.cluster.spark.loaddata.LoadParquetFile \
    --master local[*] \
    --driver-memory 4g \
    ${LIB_DIR}/${LIB_SPARK_JAR} ${hdfsClusterName} ${hdfsPath} ${tableName}
    if [ "$?" -eq "0" ] ; then
        echo "******************** 更新元数据完成 ***************** "
    else
        echo "******************** 更新元数据失败 ***************** "
    fi

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
    echo ""  | tee  -a  ${LOG_FILE}
    echo ""  | tee  -a  ${LOG_FILE}
    echo "==================================================="  | tee -a ${LOG_FILE}
    echo "$(date "+%Y-%m-%d  %H:%M:%S")"                       | tee  -a  ${LOG_FILE}
    load_parquet
}
## 脚本主要业务入口
# 主程序入口
echo "" | tee  -a  ${LOG_FILE}
echo "*******************************************************************"  | tee  -a  ${LOG_FILE}
main


set -x