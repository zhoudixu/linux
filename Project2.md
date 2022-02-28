1.ansible环境搭建
 inventory 免密ssh ansible.cfg hosts配置
2.redis集群
yum文件安装集群主机redis安装包，-安装gcc,解压

 for i in {51,52,53,54,55,56}; do ssh 192.168.4.$i /root/redis-4.0.8/utils/install_server.sh; done

 for i in {51,52,53,54,55,56}; do ssh 192.168.4.$i /etc/init.d/redis_6379 stop; done


for i in {51,52,53,54,55,56}; do ssh 192.168.4.$i /etc/init.d/redis_6379 start; done

单独拷贝redis包，redis-3.2.1.gem到redis集群管理机，
yum安装rubygems，然后使用gem命令安装redis-3.2.1.gem
将redis包中src/redis-trib.rb 文件拷贝到/root/bin下,修改权限为可执行


yum -y install libev-4.15-1.el6.rf.x86_64.rpm percona-xtrabackup-24-2.4.13-1.el7.x86_64.rpm qpress-1.1-14.11.x86_64.rpm