#!/bin/bash
. /server/scripts/shell-jumpserver/func/funcs
TIME=`date "+%F:%H:%M:%S"`

while true;do
  read -p '输入用户> ' username
  . /server/scripts/shell-jumpserver/conf/jms.conf
  read -p '授权主机> ' IP
  if id $username &> /dev/null;then
    create_key
    add_user
    send_key
    echo "`grep $IP $host_file`" >> $username_info
    break
  elif [ `grep -c "$username" ${username_info}` -ne "1" ];then
    echo "Error: 用户在${username_info} 未找到"
    continue
  else
    echo "Error: 系统用户 ${username} 不存在."
    continue
  fi
done
