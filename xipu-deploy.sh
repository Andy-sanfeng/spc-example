#!/bin/bash

inventory_file="/etc/ansible-hosts"

echo -n "请输入主节点IP: "
read master_ip
echo -n "请输入主节点主机名: "
read master_hostname
echo -n "请输入从节点个数: "
read slave_node_num
echo "[master]" >${inventory_file}
echo "${master_ip} hostname=${master_hostname}" >>${inventory_file}
echo "" >>${inventory_file}
echo "[slave]" >>${inventory_file}
i=1
while [ $i -le ${slave_node_num} ]
do
    echo -n "请输入第 ${i} 个从节点IP: "
    read slave_ip
    echo -n "请输入第 ${i} 个从节点主机名: "
    read slave_hostname
    echo "${slave_ip} hostname=${slave_hostname}" >>${inventory_file}
   ((i++))
done

cat <<EOF >>${inventory_file}

[nagios-server:children]
master

[nagios-client:children]
slave
EOF

find / -type f -name xp_autodeploy.yml >/tmp/a 2>/dev/null
if [ `cat /tmp/a | wc -l` != 1 ]
then
    echo "系统中存在2个xp_autodeploy.yml，请确保只有刚下载的目录下存在 xp_autodeploy.yml 文件。"
    cat /tmp/a
    exit 2
fi

playbool_yml=`cat /tmp/a`

echo ""
echo "现在开始部署，执行命令：ansible-playbook -i ${inventory_file} ${playbool_yml}"
ansible-playbook -i ${inventory_file} ${playbool_yml}

