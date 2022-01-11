# DNS

[toc]

## 修改hosts

```shell
echo -e "ip_address\tFQDN" >> /etc/hosts
# \t转义字符 tab
# FQDN	域名
```



## 软件

```shell
yum -y install bind bind-chroot
```

