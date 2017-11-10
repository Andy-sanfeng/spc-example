<?php

return array(
    // 数据库连接配置
    'db' => [
        'driver' => 'Pdo',
        'dsn' => 'mysql:dbname={{ database_name }};host={{ hostvars[inventory_hostname]['ansible_' + net1_if]['ipv4']['address'] }}:3306',
        'driver_options' => [
            PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\''
        ],
    ],
    'service_manager' => [
        'factories' => [
            'Zend\Db\Adapter\Adapter' => 'Zend\Db\Adapter\AdapterServiceFactory',
            'Zend\Log' => 'Base\Service\Log\SpcLog'
        ],
    ],

    'session' => array(
        'use_cookies' => true,
        'gc_maxlifetime' => 1440,
        'gc_divisor'=>1,
    )


);
