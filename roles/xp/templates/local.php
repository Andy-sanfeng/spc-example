<?php
include('company.config.php');
return array(
    'db' => [
        'username' => 'simple',
        'password' => '6Ou_FkDq$0u@7U3s',
    ],
    //定义缓存配置
    'caches' => [
        'memcached' => [ //can be called directly via SM in the name of 'memcached'
            'adapter' => [
                'name'     =>'memcached',
                'lifetime' => 7200,
                'options'  => [
                    'servers'   => [
                        [
                            '127.0.0.1',11211
                        ],
                    ],
                    'namespace'  => 'SPC',//memcache key 前缀 ，注意memcache中的前缀要一致
                    'liboptions' => [
                        'COMPRESSION' => true,
                        'binary_protocol' => true,
                        'no_block' => true,
                        'connect_timeout' => 100
                    ],
                ],
            ],
            'plugins' => [
                'exception_handler' => [
                    'throw_exceptions' => false
                ],
            ],
        ],
    ],

    //定义上传相关适配器
    'upload' => [
        'Disk' => [
            'adapter' => 'Disk',
            'root' => ZEND_PATH_UPLOAD,
            'url_prefix_b' => '/upload',
            ],
        //定义上传文件的类型和大小
        'upload_file' => [
            //允许上传的文件mimetype
            'mimetype' => [
                'image/gif',
                'image/jpeg',
                'image/png',
                'image/bmp',
                'application/ms-excel',
                'application/msword',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                'application/octet-stream',
                'application/x-rar-compressed',
                'video/mp4',
                ],
            'image' => [
                // 单位：kb（1kb = 1024bytes）
                'min_size' => '1',
                'max_size' => '5120'
            ],
            'word' => [
                'min_size' => '1',
                'max_size' => '51200'
            ],

            'excel' => [
                'min_size' => '1',
                'max_size' => '51200'
            ],
            'video' => [
                'min_size' => '1',
                'max_size' => '1024000'
            ],
            'other' => [
                'min_size' => '1',
                'max_size' => '1024000'
            ],
        ],
    ],
    'vnc_config'=>[
        'host'=>'{{ hostvars[inventory_hostname]['ansible_' + net1_if]['ipv4']['address'] }}',
        'port'=>'9999'
    ],
    'soap_config'=>[
        "encoding"=>"UTF-8",
        'uri'      =>  "http://{{ hostvars[inventory_hostname]['ansible_' + net1_if]['ipv4']['address'] }}:8080/spc?wsdl",
        'soap_version'   => SOAP_1_1,
    ],
    'vm_config'=>[
        'deadtime'  => 600  //秒
    ],
    'name_config'=>[
        "name"=>"{$productname}",
        "company_name"=>"{$company_name}"
    ],
    'diskSize_config'=>["diskSize"=>0.7],
    'cpuSize_config'=>["cpuSize"=>0.7],
    'ramSize_config'=>["ramSize"=>0.7],


);
