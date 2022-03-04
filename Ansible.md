1. Ansible配置文件 host_key_checking       = False 用于避免SSH时系统提示主机信息需要添加到knownhost中时需要输入yes的场景

2. ```yaml
   ---
   - name: web 集群安装
     hosts: web
     tasks:
     - name: 安装 apache 服务
       yum:
         name: httpd,php
         state: latest
         update_cache: yes
     - name: 配置 httpd 服务
       service:
         name: httpd
         state: started
         enabled: yes
     - name: 部署网站网页
       unarchive:
         src: files/webhome.tar.gz
         dest: /var/www/html/
         copy: yes
         owner: apache
         group: apache
      
   # 说明：update_cache用于执行更新yum的缓存
   # unarchive模块可以用于远程拷贝同时解压文件到目的位置
   ```

   

