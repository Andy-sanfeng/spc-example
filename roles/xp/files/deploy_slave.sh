#!/bin/sh

function modify_files()
{
# /etc/rsyncd.conf
cat <<EOF >/etc/rsyncd.conf
uid=root
gid=root
use chroot=no
host allow=*
auth users=simple
ignore errors
secrets file=/etc/rsyncd.secrets
[mnt]
path = /mnt
read only = no

[target1]
path = /mnt/target1
read only = no

[target2]
path = /mnt/target2
read only = no
EOF

# /etc/bcpconfig.cfg
sed -i "s/\(DBHost=\).*/\1${master_ip}/g" /etc/bcpconfig.cfg 
sed -i "s/\(RouteIP=\).*/\1${master_ip}/g" /etc/bcpconfig.cfg 
sed -i "s/\(rsync_slave_master=\).*/\1${master_ip}/g" /etc/bcpconfig.cfg
sed -i "s/\(MyType=\).*/\1slave/g" /etc/bcpconfig.cfg

# /root/install_file/service_control.sh
echo "systemctl stop nginx" >> /root/install_file/service_control.sh
echo "systemctl disable nginx" >> /root/install_file/service_control.sh
echo "systemctl stop mysqld" >> /root/install_file/service_control.sh
echo "systemctl disable mysqld" >> /root/install_file/service_control.sh
sh /root/install_file/service_control.sh restart >/dev/null 2>&1

}

main()
{
    echo "部署slave节点，需要master的一些信息，请根据提示输入指定信息："
    echo -n "master节点管理网络IP："
    read master_ip
    
    modify_files 
    echo "部署slave完毕。"
}
main
