#!/bin/bash
#Name: redismontior.sh
#Action: Zabbix monitoring redis plug-in

REDISCLI="/usr/bin/redis-cli"
HOST=`ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":"`
PASSWORD=xxxxxx
PORT=$1

function json_head {
    printf "{";
    printf "\"data\":[";    
}

function json_end {
    printf "]";
    printf "}";
}

function check_first_element {
    if [[ $FIRST_ELEMENT -ne 1 ]]; then
        printf ","
    fi
    FIRST_ELEMENT=0
}

function databse_detect {
    json_head
    for dbname in $LIST_DATABSE
    do
        local rdbname=$(echo $dbname| sed 's!\n!!g')
        check_first_element
        printf "{"
        printf "\"{#DBNAME}\":\"$rdbname\""
        printf "}"
    done
    json_end
}


if [[ $# < 2 ]];then
    echo -e "\033[33mInput is wrong\033[0m"
    echo -e "\033[33mPlease enter the following format:\033[0m"
    echo -e "\033[33mUsage: $0 RdportNo {ping|connected_clients|total_connections_received|total_commands_processed|total_net_input_bytes|total_net_output_bytes|rejected_connections|keyspace_hits|keyspace_misses|keyspace_misses_percentage|blocked_clients|used_memory|used_memory_rss|used_memory_peak|used_memory_lua|mem_fragmentation_ratio|used_cpu_sys|used_cpu_user|used_cpu_sys_children|used_cpu_user_children|rdb_last_bgsave_status|aof_last_bgrewrite_status|aof_last_write_status|instantaneous_ops_per_sec|list_key_space_db}\033[0m"
    echo -e "\033[33m   Or  \033[0m"
    echo -e "\033[33mUsage: $0 RdportNo dbname {keys|expires|avg_ttl}\033[0m"
elif [[ $# == 2 ]];then  
    case $2 in
        ping)
            result_s=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD ping`
            if [[ $result_s == "PONG" ]];then
              result=1
            else
              result=0
            fi     
            echo $result
        ;;
        version)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "redis_version" | awk -F':' '{print $2}'`
            echo $result
        ;;
        uptime)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "uptime_in_seconds" | awk -F':' '{print $2}'`
            echo $result
        ;;
        connected_clients)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "connected_clients" | awk -F':' '{print $2}'`
            echo $result
        ;;
        total_connections_received) #total_connections_received
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "total_connections_received" | awk -F':' '{print $2}'`
            echo $result
        ;;
        total_commands_processed) #total_commands_processed
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "total_commands_processed" | awk -F':' '{print $2}'`
            echo $result
        ;;
        instantaneous_ops_per_sec) #instantaneous_ops_per_sec
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "instantaneous_ops_per_sec" | awk -F':' '{print $2}'`
            echo $result
        ;;
        total_net_input_bytes) #total_net_input_bytes
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "total_net_input_bytes" | awk -F':' '{print $2}'`
            echo $result
        ;;
        total_net_output_bytes) #total_net_output_bytes
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "total_net_output_bytes" | awk -F':' '{print $2}'`
            echo $result
        ;;
        rejected_connections) #rejected_connections
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "rejected_connections" | awk -F':' '{print $2}'`
            echo $result
        ;;
        keyspace_hits) #keyspace_hits
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "keyspace_hits" | awk -F':' '{print $2}'`
            echo $result
        ;;
        keyspace_misses) #keyspace_misses
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "keyspace_misses" | awk -F':' '{print $2}'`
            echo $result
        ;;        
        keyspace_misses_percentage) #keyspace_misses_percentage
            keyok=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "keyspace_hits" | awk -F':' '{print $2}'`
            keyfailed=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "keyspace_misses" | awk -F':' '{print $2}'`
            num=`awk -v x=$keyok -v y=$keyfailed 'BEGIN{printf "%.2f",y/(x+y)*100}'`
            echo $num
        ;;        

        blocked_clients)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "blocked_clients" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_memory" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_rss)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_memory_rss" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_peak)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_memory_peak" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_lua)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_memory_lua" | awk -F':' '{print $2}'`
            echo $result
        ;;
        mem_fragmentation_ratio)
            umemrss=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_memory_rss" | awk -F':' '{print $2}'`
            umem=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_memory" | awk -F':' '{print $2}'`
            num=`awk -v x=$umem -v y=$umemrss 'BEGIN{printf "%.2f",(y/x)*100}'`
            echo $num
        ;;
        used_cpu_sys)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_cpu_sys" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_cpu_user)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_cpu_user" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_cpu_sys_children)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_cpu_sys_children" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_cpu_user_children)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "used_cpu_user_children" | awk -F':' '{print $2}'`
            echo $result
        ;;
        rdb_last_bgsave_status)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info  | grep -w "rdb_last_bgsave_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        master_last_io_seconds_ago)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info  | grep -w "master_last_io_seconds_ago" | awk -F':' '{print $2}'`
            echo $result
        ;;
        aof_last_bgrewrite_status)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info  | grep -w "aof_last_bgrewrite_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        aof_last_write_status)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info  | grep -w "aof_last_write_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        list_key_space_db)
            LIST_DATABSE=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep '^db.:'|cut -d: -f1`
            databse_detect
        ;;   
        *)
            echo -e "\033[33mUsage: $0 RdportNo {ping|connected_clients|total_connections_received|total_commands_processed|total_net_input_bytes|total_net_output_bytes|rejected_connections|keyspace_hits|keyspace_misses|keyspace_misses_percentage|blocked_clients|used_memory|used_memory_rss|used_memory_peak|used_memory_lua|mem_fragmentation_ratio|used_cpu_sys|used_cpu_user|used_cpu_sys_children|used_cpu_user_children|rdb_last_bgsave_status|aof_last_bgrewrite_status|aof_last_write_status|instantaneous_ops_per_sec|list_key_space_db}\033[0m" 
        ;;
    esac
elif [[ $# == 3 ]];then
    case $3 in
        keys)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "$2" | grep -w "keys" | awk -F'=|,' '{print $2}'`
            echo $result
        ;;
        expires)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "$2" | grep -w "keys" | awk -F'=|,' '{print $4}'`
            echo $result
        ;;
        avg_ttl)
            result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD info | grep -w "$2" | grep -w "avg_ttl" | awk -F'=|,' '{print $6}'`
            echo $result
        ;;
        *)
            echo -e "\033[33mUsage: $0 RdportNo dbname {keys|expires|avg_ttl}\033[0m" 
        ;;
    esac
fi
