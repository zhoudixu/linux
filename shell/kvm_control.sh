#!/bin/bash
#该脚本用于执行批量创建、删除虚拟机，支持自定义虚拟机名称
# 1.虚拟机后端盘模板位于/var/lib/libvirt/images/.node_base.qcow2
# 2.虚拟机配置文件模板位于/var/lib/libvirt/images/.node_base.xml
# 3.虚拟网桥配置文件已经提前放在/etc/libvirt/qemu/networks/vbr.xml
#   相关配置中均调用的该网桥配置文件
# Version 1.0   By Tim  2022-03-02
path="/var/lib/libvirt/images/"
img=".node_base.qcow2"
conf=".node_base.xml"

create(){
        read -p "请输入你想创建的虚拟机名：" name
        cd $path
        if [ -e $name.img ];then
                echo "The vm that you hope to create is already exists!"
        else
                qemu-img create -f qcow2 -b $img $name.img 20G
                sed -e "s/node_base/$name/" -e 's/2248000/1024000/' $conf > /etc/libvirt/qemu/$name.xml
                virsh define /etc/libvirt/qemu/$name.xml
                virsh start $name
                echo "The vm $name alreay been created and started! Please enjoy this."
        fi
}

remove(){
        virsh list --all
        read -p "请输入你想删除的虚拟机的名称：" name
        cd $path
        if [ -e $(virsh domblklist xixi | awk -F"/" '/images/{print $NF}') ];then
                virsh destroy $name 2> /dev/null
                virsh undefine $name 2> /dev/null
                rm -rf $name.img
                rm -rf /etc/libvirt/qemu/$name.xml
                echo "删除成功"
        fi
}

case $1 in
create)
        create;;
remove)
        remove;;
*)
        echo "输入错误，请参考以下命令 kvm_control [create|remove]"
esac

