#!/bin/bash
. /server/scripts/shell-jumpserver/func/funcs
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
    echo "info: 本地创建用户"
    for i in $username;do
      useradd -s /opt/jms/jms.sh $i
      check
      echo $i
    done
    # 设置密码
    echo "info: 生成随机密码"
    echo $PASS | passwd --stdin $username &> /dev/null
    check
    # 写入文件
    . /server/scripts/shell-jumpserver/conf/jms.conf
    echo "info: 写入文件$username_info"
    echo "$TIME  用户名 $username  密码 $PASS" >> $username_info
    break
  fi
done
