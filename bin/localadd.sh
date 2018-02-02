#!/bin/bash



SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"
. ${SSHSTACKDIR}/func/funcs

PASS=`uuidgen |cut -c -8` 
TIME=`date "+%F:%H:%M:%S"`

# 读取输入参数
while true;do
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
    # 写入文件
    . ${SSHSTACKDIR}/conf/sshstack.conf
    echo "INFO: 写入文件$user_info"
    echo "$TIME  用户名 $username  密码 $PASS" >> $user_info
    break
  fi
done
