#!/bin/bash
# Author: oldboy linux34 chentiangang
# QQ群: 605799367
# Use this script to remove all users that have been added.

SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"

# sshstack的安装目录
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"

# 加载函数库
. ${SSHSTACKDIR}/func/funcs

read -p "输入用户名> " username

# 加载配置文件变量
. ${SSHSTACKDIR}/conf/sshstack.conf

if [ -f $user_info ];then
  # 获取已对用户授权的主机列表
  deluser_ip=`awk 'NR>1{print $1}' $user_info`

  # 在远端删除该用户
  for IP in $deluser_ip;do
    ansible $IP -m shell -a "userdel $username"
    check
  done

  # 删除本地用户
  userdel -r $username

  # 删除用户信息文件
  rm -f $user_info
else 
  echo "用户不存在"
  exit 1
fi
