# SQL

[toc]

## 创建数据库

```sql
create database database_name default charset utf8mb4;
# 创建名为wordpress的数据库，字符编码采用utf8mb4，支持中文
```

## 数据库赋权

```sql
grant all on zabbix.* to zabbix@'%' identified by 'zabbix';
# 创建名为wordpress的用户，可以对wordpress拥有全部权限，他的登录密码也是wordpress。该用户既可以在本机登录，也可以在其他客户端地址登录。
grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';
grant all on zabbix.* to zabbix@'ip.address' identified by 'zabbix';
flush privileges;
```

##  远程连接数据库

```sql
@web1 ~]# mysql -uwordpress -pwordpress -h192.168.2.11 wordpress
# -u指定数据库账户名称，-p指定数据库账户的密码，-h指定需要远程数据库的IP地址
```

## 数据库删除

```sql
drop database database_name;
```

## 导出数据库

```shell
mysqldump > 导出的路径+文件名
```

## 导入数据库

```shell
mysql 数据库名 < 需要导入的数据库文件
```

## 查看数据库

```sql
show databases;
use database.name; #数据库的名字
selcet * from wordpress.wp_users\G #从数据库wordpress的表格wp_users中查看所有数据，\G使用易读格式
```

