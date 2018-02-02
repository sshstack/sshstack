#!/bin/bash
# Author: oldboy linux34 chentiangang
# Add the authorization host with this script.

SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"

# 获取sshstack安装目录
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"

# 加载函数库
. ${SSHSTACKDIR}/func/funcs

while true;do
  read -p '输入用户> ' username
  # 加载配置文件变量
  . ${SSHSTACKDIR}/conf/sshstack.conf
  read -p '授权主机> ' IP
  if id $username &> /dev/null;then
    # 创建用户密钥
    create_key
    # 在授权主机创建用户
    add_user
    # 在本地发送密钥到授权主机
    send_key
    # 将授权主机信息写入用户数据文件
    echo "`grep $IP $host_file`" >> $user_info
    break
  elif [ `grep -c "$username" ${user_info}` -ne "1" ];then
    echo "Error: 用户在${user_info} 未找到"
    continue
  else
    echo "Error: 系统用户 ${username} 不存在."
    continue
  fi
done
