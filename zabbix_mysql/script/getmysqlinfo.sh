#!/bin/bash

#Name: MySQLMontior.sh
#From: flashyhl <2015/08/06>
#Action: Zabbix monitoring mysql plug-in


MySQlBin=/usr/bin/mysql
MySQLAdminBin=/usr/bin/mysqladmin
Host=xxx.xxx.xxx.xxx
User=xxxxxx
Password=xxxxxxxx

if [[ $# == 1 ]];then
    case $1 in
         Ping)
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  ping|grep alive|wc -l`
            echo $result
        ;;
         Threads)
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status|cut -f3 -d":"|cut -f1 -d"Q"`
            echo $result
        ;;
         Questions)
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status|cut -f4 -d":"|cut -f1 -d"S"`
            echo $result
        ;;
         Slowqueries)
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status|cut -f5 -d":"|cut -f1 -d"O"`
            echo $result
        ;;
         Qps)
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status|cut -f9 -d":"`
            echo $result
        ;;
         Slave_IO_State)
            result=`if [ "$($MySQlBin -u$User -p$Password -h$Host  -e "show slave status\G"| grep Slave_IO_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
            echo $result
        ;;
         Slave_SQL_State)
            result=`if [ "$($MySQlBin -u$User -p$Password -h$Host  -e "show slave status\G"| grep Slave_SQL_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
            echo $result
        ;;
         Key_buffer_size)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'key_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Key_reads)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_reads';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_read_requests)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_read_requests';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_cache_miss_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_reads';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_read_requests';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Key_blocks_used)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_used';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_blocks_unused)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_blocks_used_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_used';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
            echo $result
        ;;
         Innodb_buffer_pool_size)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'innodb_buffer_pool_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Innodb_log_file_size)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'innodb_log_file_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Innodb_log_buffer_size)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'innodb_log_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Table_open_cache)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_tables)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Opened_tables)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'opened_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_tables_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'opened_tables';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
            echo $result
        ;;
         Table_open_cache_used_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
            echo $result
        ;;
         Thread_cache_size)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'thread_cache_size';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_cached)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_cached';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_connected)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_connected';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_created)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_created';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_running)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_running';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_free_blocks)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_free_memory)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_hits)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_hits';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_inserts)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_lowmem_prunes)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_lowmem_prunes';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_not_cached)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_not_cached';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_queries_in_cache)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_queries_in_cache';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_total_blocks)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_fragment_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Qcache_used_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
            echo $result
        ;;
         Qcache_hits_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_hits';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
            echo $result
        ;;
         Query_cache_limit)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_limit';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Query_cache_min_res_unit)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_min_res_unit';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Query_cache_size)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_merge_passes)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_merge_passes';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_range)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_range';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_rows)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_rows';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_scan)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_scan';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_first)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_first';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_key)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_key';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_next)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_next';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_prev)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_prev';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_rnd)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_rnd';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_rnd_next)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_rnd_next';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_select)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_select';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_insert)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_insert';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_insert_select)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_insert_select';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_update)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_update';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_replace)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_replace';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_replace_select)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_replace_select';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Table_scan_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_rnd_next';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_select';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Open_files)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_files';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_files_limit)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_files_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_files';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Created_tmp_disk_tables)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Created_tmp_tables)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Created_tmp_disk_tables_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Max_connections)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Max_used_connections)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Max_used_connections';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Processlist)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show processlist" | grep -v "Id" | wc -l`
            echo $result
        ;;
         Max_connections_used_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Max_used_connections';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
        Connection_occupancy_rate)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_connected';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
            echo $result
        ;;

         Table_locks_immediate)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Table_locks_waited)
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'table_locks_waited';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Engine_select)
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'table_locks_waited';"| grep -v Value | awk '{print $2}') | awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
            echo $result
        ;;
        *)
           echo -e "\033[33mUsage: ./getmysqlinfo {Ping|Threads|Questions|Slowqueries|Qps|Slave_IO_State|Slave_SQL_State|Key_buffer_size|Key_reads|Key_read_requests|Key_cache_miss_rate|Key_blocks_used|Key_blocks_unused|Key_blocks_used_rate|Innodb_buffer_pool_size|Innodb_log_file_size|Innodb_log_buffer_size|Table_open_cache|Open_tables|Opened_tables|Open_tables_rate|Table_open_cache_used_rate|Thread_cache_size|Threads_cached|Threads_connected|Threads_created|Threads_running|Qcache_free_blocks|Qcache_free_memory|Qcache_hits|Qcache_inserts|Qcache_lowmem_prunes|Qcache_not_cached|Qcache_queries_in_cache|Qcache_total_blocks|Qcache_fragment_rate|Qcache_used_rate|Qcache_hits_rate|Query_cache_limit|Query_cache_min_res_unit|Query_cache_size|Sort_merge_passes|Sort_range|Sort_rows|Sort_scan|Handler_read_first|Handler_read_key|Handler_read_next|Handler_read_prev|Handler_read_rnd|Handler_read_rnd_next|Com_select|Com_insert|Com_insert_select|Com_update|Com_replace|Com_replace_select|Table_scan_rate|Open_files|Open_files_limit|Open_files_rate|Created_tmp_disk_tables|Created_tmp_tables|Created_tmp_disk_tables_rate|Max_connections|Max_used_connections|Processlist|Max_connections_used_rate|Table_locks_immediate|Table_locks_waited|Engine_select|Connection_occupancy_rate} \033[0m"

        ;;
    esac
fi
