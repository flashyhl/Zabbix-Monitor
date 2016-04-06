# Zabbix-Monitor zabbix 监控服务

说明：
1、zabbix_mysql     监控mysql(版本：5.5.42)的各个数值
   │  zbx_export_templates.xml     模板文件
   │
   ├─conf
   │      zabbix_agentd.conf       添加监控脚本参数
   │
   └─script
           getmysqlinfo.sh         监控脚本，里面的参数根据需要修改
           
           
2、zabbix_redis      监控redis(版本：2.8.24) 自动发现，自动创建items
   │  zbx_export_templates.xml      模板文件
   │
   ├─conf
   │      zabbix_agentd.conf        添加监控脚本参数    
   │
   └─script
          redisdbports.sh           自动发现脚本
          redismonitor.sh           监控脚本，里面的参数根据需要修改

