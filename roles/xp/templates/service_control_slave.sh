#!/bin/bash

check_mysql()
{
    mysqladmin ping -S /var/lib/mysql/mysql.sock
    while [ $? -ne 0 ]
    do
        sleep 5
        systemctl start mysqld
        mysqladmin ping -S /var/lib/mysql/mysql.sock
    done
}
check_redis()
{ 
   while [ "`ps -ef|grep 'redis-server'|grep -v 'grep'`" == "" ]
    do
        sleep 5
        systemctl start redis.service
    done
}
check_openvswitch()
{ 
   while [ "`ps -ef|grep 'openvswitch'|grep -v 'grep'`" == "" ]
    do
        sleep 5
        systemctl start openvswitch.service
    done
}

service_start()
{
    rsync --daemon
    nohup python /usr/BCP/Service/ServiceControl.py &
    nohup python /usr/BCP/Daemon/DaemonControl.py &
    nohup python /home/noVNC-0.5/utils/websockify.py --target-config=/home/novnc_tokens 9999 &
    nohup python /usr/BCP/Daemon/CheckDaemonControl.py &
}

service_stop()
{
    if [ "`pgrep rsync`" != "" ];then
        kill -9 `pgrep rsync`
    fi

    if [ "`ps -x|grep '/usr/BCP/Service/ServiceControl.py'|grep -v grep|awk '{print $1}'`" != "" ];then
        kill -9 `ps -x|grep '/usr/BCP/Service/ServiceControl.py'|grep -v grep|awk '{print $1}'`
    fi

    if [ "`ps -x|grep '/usr/BCP/Daemon/DaemonControl.py'|grep -v grep|awk '{print $1}'`" != "" ];then
        kill -9 `ps -x|grep '/usr/BCP/Daemon/DaemonControl.py'|grep -v grep|awk '{print $1}'`
    fi

    if [ "`ps -x|grep '/home/noVNC-0.5/utils/websockify.py'|grep -v grep|awk '{print $1}'`" != "" ];then
        kill -9 `ps -x|grep '/home/noVNC-0.5/utils/websockify.py'|grep -v grep|awk '{print $1}'`
    fi

    if [ "`ps -x|grep '/usr/BCP/Daemon/CheckDaemonControl.py'|grep -v grep|awk '{print $1}'`" != "" ];then
        kill -9 `ps -x|grep '/usr/BCP/Daemon/CheckDaemonControl.py'|grep -v grep|awk '{print $1}'`
    fi
}

case $1 in
    start)
        echo "starting services..."
        check_openvswitch
        check_mysql
        check_redis
        service_start
        ;;
    stop)
        echo "stoping services..."
        service_stop
        ;;
    restart)
        echo "restarting services..."
        service_stop
        check_openvswitch
        check_mysql
        check_redis
        service_start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
esac

systemctl stop nginx
systemctl disable nginx
systemctl stop mysqld
systemctl disable mysqld
