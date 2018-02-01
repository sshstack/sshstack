#!/bin/bash
username=`whoami`
. /server/scripts/shell-jumpserver/conf/jms.conf



host_list(){
  printf "\033[32m主机列表：\033[32m\n"
  printf "\033[33m        [IP地址]        [主机名]         [备注]\033[33m\n"
  awk 'NR>1{print "\t\033[33m"$1"\033[0m\t\033[33m"$2"\033[0m       \033[33m"$3"\033[0m"}' $username_info
  # 默认输出
  printf "\n\033[32m改密：\033[0m\033[33mpassword\033[0m\n"
  printf "\033[32m退出：\033[0m\033[33mexit\033[0m\n"
  printf "\033[32m清屏：\033[0m\033[33mclear\033[0m\n"
  printf "\033[32m提示：\033[0m\033[33m输入主机名或IP地址连接\033[0m\n"
}

reading(){
  stty erase ^?
  read   -p "`whoami` 选择主机 > " HOST
  if [ "`grep -c "$HOST" $username_info`" == "0" ];then
    case $HOST in
        password) passwd ; continue ;;
        clear) clear ;main ;;
        exit) echo "退出登录" && exit ;;
        quit) echo "退出登录" && exit ;;
        "") reading ;;
        *) printf "\033[31m      error: 不能连接${HOST}.\033[0m\n" && continue;;
    esac
  fi
}

main(){
  count=0
  while [ "$count" -lt "5" ];do
    ((count=count+1))
    host_list
    reading
    ssh -i /home/`whoami`/.ssh/id_dsa -p25535 -o StrictHostKeyChecking=no `whoami`@${HOST}
  done
}

main
