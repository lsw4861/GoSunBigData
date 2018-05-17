#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    start-spring-cloud-device
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
DEVICE_DIR=`pwd`                              ### device 目录
LIB_DEVICE_DIR=${DEVICE_DIR}/lib              ### device lib
CONF_DEVICE_DIR=${DEVICE_DIR}/conf            ### device 配置文件目录
LOG_DIR=${DEVICE_DIR}/logs                    ### LOG 目录
LOG_FILE=$LOG_DIR/start-spring-cloud.log
cd ..
SERVICE_DIR=`pwd`                              ### service 目录
CONF_SERVICE_DIR=$SERVICE_DIR/conf             ### service 配置文件

cd ..
OBJECT_DIR=`pwd`                               ### RealTimeFaceCompare 目录

JAR_DEVICE=`ls ${DEVICE_DIR}| grep ^device-[0-9].[0-9].[0-9].jar$`

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
    # java -classpath $CONF_DEVICE_DIR:$LIB_JARS com.hzgc.service.device.DeviceApplication  | tee -a  ${LOG_FILE}
    java -jar ${JAR_DEVICE} | tee -a  ${LOG_FILE}
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
    cd ${DEVICE_DIR}
    cp conf/deviceApplication.properties ./
    jar uf ${JAR_DEVICE} deviceApplication.properties
    rm -f deviceApplication.properties

    cp conf/*-site.xml ./
    jar uf ${JAR_DEVICE} hbase-site.xml
    jar uf ${JAR_DEVICE} core-site.xml
    jar uf ${JAR_DEVICE} hdfs-site.xml
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