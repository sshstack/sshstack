#!/bin/bash
SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"
. ${SSHSTACKDIR}/func/funcs
TIME=`date "+%F:%H:%M:%S"`

while true;do
  read -p '输入用户> ' username
  . ${SSHSTACKDIR}/conf/sshstack.conf
  read -p '授权主机> ' IP
  if id $username &> /dev/null;then
    create_key
    add_user
    send_key
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
