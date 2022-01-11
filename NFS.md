# NFS

[TOC]

## 软件

```shell
nfs-utils
```

## 配置

### server端

```shell
vim /etc/exports
/web_share  192.168.2.0/24(rw,no_root_squash)
# 共享目录   权限设置
# no_root_squash，表示远程主机root创建的文件，属主属组就是root。默认会变成nfsnobody
systemctl enable rpcbind --now
systemctl enable nfs --now
NFS使用的是随机端口，每次启动NFS都需要将自己的随机端口注册到rpcbind服务，这样客户端访问NFS时先到rpcbind查询端口信息，得到端口信息后再访问NFS服务
]# ss -tnlp | grep rpcbind
LISTEN     0      128          *:111                      *:*                   users:(("rpcbind",pid=2218,fd=8))
LISTEN     0      128         :::111                     :::*                   users:(("rpcbind",pid=2218,fd=11))

]# showmount -e 192.168.2.31   # showmount -e IP地址，查看NFS共享
Export list for 192.168.2.31:
/webshare 192.168.2.0/24
```

### client端

```shell
1. install nfs-utils
2. mkdir 创建要挂载的目录
3. vim /etc/fstab
server_ip:/webshare /挂载目录	nfs	defaults,_netdev	0	0
4. mount -a
5. df -hT
```

