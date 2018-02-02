#!/bin/bash
# Author: oldboy linux34 chentiangang
# QQ群: 605799367
# The shell that the user executes after logging in.

SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"

# 获取sshstack安装目录
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"

# 获取登陆用户的用户名
username=`whoami`
. ${SSHSTACKDIR}/conf/sshstack.conf

host_list(){
  printf "\033[32m主机列表：\033[32m\n"
  printf "\033[33m        [IP地址]        [主机名]         [备注]\033[33m\n"

  # 在用户数据文件里过滤出已授权主机列表,输出
  awk 'NR>1{print "\t\033[33m"$1"\033[0m\t\033[33m"$2"\033[0m       \033[33m"$3"\033[0m"}' $user_info

  # 默认输出
  printf "\n\033[32m改密：\033[0m\033[33mpassword\033[0m\n"
  printf "\033[32m退出：\033[0m\033[33mexit\033[0m\n"
  printf "\033[32m清屏：\033[0m\033[33mclear\033[0m\n"
  printf "\033[32m提示：\033[0m\033[33m输入主机名或IP地址连接\033[0m\n"
}

reading(){
  clear
  count=0
  while [ "$count" -lt "5" ];do
    ((count=count+1))
    host_list
    stty erase ^?
    read -p "`whoami` 选择主机 > " HOST
    if [ -z "$HOST" ];then
      # 如果输入空的字符串，则跳出本次循环
      continue 
    elif [ "`grep -c "$HOST" $user_info`" == "0" ];then
      case $HOST in
          password) passwd ; continue ;;
          clear) clear ;main ;;
          exit) echo "退出登录" && exit ;;
          quit) echo "退出登录" && exit ;;
          *) printf "\033[31m      error: 不能连接${HOST}.\033[0m\n" && continue;;
      esac
    else
      ssh -i /home/`whoami`/.ssh/id_dsa -p25535 -o StrictHostKeyChecking=no `whoami`@${HOST}
    fi
  done
}
reading
