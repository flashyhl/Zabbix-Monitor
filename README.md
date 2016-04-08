# Zabbix-Monitor zabbix 监控服务


说明：

1、zabbix_mysq									监控mysql(版本：5.5.42)的各个数值

     zabbix_mysql/zbx_export_templates.xml		模板文件

     zabbix_mysql/conf/zabbix_agentd.con			添加监控脚本参数

     zabbix_mysql/script/getmysqlinfo.s			监控脚本，里面的参数根据需要修改


2、zabbix_redi									监控redis(版本：2.8.24) 自动发现，自动创建items

     zabbix_redis/zbx_export_templates.xml		模板文件

     zabbix_redis/conf/zabbix_agentd.con			添加监控脚本参数
    
     zabbix_redis/script/redisdbports.s			自动发现脚本

     zabbix_redis/script/redismonitor.s			监控脚本，里面的参数根据需要修改

