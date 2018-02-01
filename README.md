## 为什么要写shell跳板机？
>   跳板机的作用目前主要为解决公司开发人员查看日志的需求。而商业跳板机动辄几十万不是我等屌丝公司能消受得起的，开源的跳板机也有几款，如jumpserver，GateOne,麒麟堡垒机等。

> 但这些真的是拿来就能用的吗？

> 根据生产实践，这些跳板机存在查看日志卡死、web界面无响应、报错提示不直观等问题（简直不能忍了），对于中小公司来说体型过大，安装卸载都大工程。

> 二次开发可能是个较好的选择，但不是每个运维都会python，而且对于100台以下规模服务器来说，价值也不大。

> 所以shell跳板机就有了，它非常轻量级，无需数据库，基于ssh协议和linux基本命令，运行流畅，使用简单。对运维来说具有亲和力，且易于个性化修改和定制，有了它可轻松管理100台左右的服务器。实在是运维同学居家旅行必备良药啊！


## 有哪些功能？
* 1.一键登陆（已实现）
* 2.用户管理（完善中）
* 3.主机授权（完善中）
* 4.批量授权（实现中）
* 5.资产管理（实现中）
* 6.日志审计（规划中）
* 7.用户查询（规划中）

## 如何使用？
### 一、先决条件
* 管理机对所有被管理机做ssh密钥认证
* 管理机安装ansible
* 适用系统为CentOS 7
* 所有主机在hosts文件做主机名与IP地址解析



### 二、目录说明
```sh
.
├── bin                     # 用户管理、资产授权脚本存放目录
│   ├── deluser.sh          # 远程用户脚本
│   ├── localadd.sh         # 本地用户添加
│   ├── remoteadd.sh        # 用户授权
│   └── jms.sh              # 用户登陆后执行的shell
├── conf                    # 配置文件
│   ├── hosts               # 这里填写所有被管理机
│   └── jms.conf            # 相关路径配置文件
├── data                    # 用户注册授权信息目录
│   └── zhangzhongbo.info
├── func                    # 函数存放目录
│   └── funcs
├── README.md
```

### 三、最佳实践
#### 1.安装
将代码拉到本地后，放到/server/scripts/目录下
```sh
[root@test shell-jumpserver]# ls
bin  conf  data  func  README.md
[root@test shell-jumpserver]# pwd
/server/scripts/shell-jumpserver
```
创建软链接
```sh
ln -sv /server/scripts/shell-jumpserver/bin/jms.sh /opt/jms/jms.sh
```
完成安装

#### 2.添加资产
> 将被管理主机填入/server/scripts/shell-jumpserver/conf/hosts即可,如下
```sh
cat /server/scripts/shell-jumpserver/conf/hosts
[IP地址]    [主机名]      [备注]
10.0.1.22   test-web02    接口
10.0.1.24   test-web04    h5页面
10.0.1.25   test-web05    xxxxxx
```

#### 3.创建本地用户
```sh
[root@test ~]# /server/scripts/shell-jumpserver/bin/localadd.sh
输入用户> wanggang
info: 本地创建用户
SUCCESS.
wanggang
info: 生成随机密码
SUCCESS.
info: 写入文件/server/scripts/shell-jumpserver/data/wanggang.info
```
> 用户创建好后，用户信息保存在/server/scripts/shell-jumpserver/data/wanggang.info文件


#### 4.授权主机
```sh
[root@test ~]# /server/scripts/shell-jumpserver/bin/remoteadd.sh
输入用户> wanggang
授权主机> 10.0.1.22
INFO: 生成本地密钥
SUCCESS.
INFO: 创建远端.ssh目录
INFO: 创建远端用户
SUCCESS.
INFO: 发送公钥到远程主机
SUCCESS.
INFO: 修改权限
SUCCESS.
```
> 授权主机后，信息同样保存在/server/scripts/shell-jumpserver/data/wanggang.info文件

#### 5.用户登陆
用户登陆后即要看到已授权的主机，可以通过输入password修改密码，输入主机名或IP地址即可登陆到对应的授权主机。
