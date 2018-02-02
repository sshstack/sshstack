#!/bin/bash
SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"

. ${SSHSTACKDIR}/func/funcs

read -p "输入用户名> " username
. ${SSHSTACKDIR}/conf/sshstack.conf
if [ -f $user_info ];then
  deluser_ip=`awk 'NR>1{print $1}' $user_info`
  for IP in $deluser_ip;do
    ansible $IP -m shell -a "userdel $username"
    check
  done
  userdel -r $username
  rm -f $user_info
else 
  echo "用户不存在"
  exit 1
fi
