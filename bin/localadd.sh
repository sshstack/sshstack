#!/bin/bash
# Author: oldboy linux34 chentiangang
# QQ群: 605799367
# Use this script to register your users locally. 

SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"
# 获取sshstack安装目录
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"

# 加载函数库
. ${SSHSTACKDIR}/func/funcs

# 随机密码变量
PASS=`uuidgen |cut -c -8` 

# 创建用户时间
TIME=`date "+%F:%H:%M:%S"`

while true;do
  # 读取输入参数
  read -p '输入用户> ' username
  if id $username &> /dev/null;then
    echo "用户已存在."
    continue
  else
    # 本地创建用户
    echo "INFO: 创建用户"
    for i in $username;do
      useradd -s ${SSHSTACKDIR}/bin/sshstack.sh $i
      check
      echo $i
    done
    # 设置密码
    echo "INFO: 生成随机密码"
    echo $PASS | passwd --stdin $username &> /dev/null
    check
    # 加载配置文件变量
    . ${SSHSTACKDIR}/conf/sshstack.conf
    echo "INFO: 写入文件$user_info"
    # 写入文件
    echo "$TIME  用户名 $username  密码 $PASS" >> $user_info
    break
  fi
done
