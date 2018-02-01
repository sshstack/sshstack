#!/bin/bash
. /server/scripts/shell-jumpserver/func/funcs

read -p "输入用户名> " username
. /server/scripts/shell-jumpserver/conf/jms.conf
if [ -f $username_info ];then
  deluser_ip=`awk 'NR>1{print $1}' $username_info`
  for IP in $deluser_ip;do
    ansible $IP -m shell -a "userdel $username"
    check
  done
  userdel -r $username
  rm -f $username_info
else 
  echo "用户不存在"
  exit 1
fi
