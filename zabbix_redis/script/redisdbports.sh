#!/bin/bash

REDISCLI="/usr/bin/redis-cli"
HOST=`ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":"`
PASSWORD=dlhy123456
     
function json_head {
    printf "{"
    printf "\"data\":["
}
     
function json_end {
    printf "]"
    printf "}"
}
     
function check_first_element {
    if [[ $FIRST_ELEMENT -ne 1 ]]; then
        printf ","
    fi
    FIRST_ELEMENT=0
    }
    
   
     
FIRST_ELEMENT=1
json_head


redisports=`ps -ef | grep redis | grep -v grep | awk '{print $NF}' | awk -F":" '{print $2}'`
for rp in $redisports
  do
    rdbs=`$REDISCLI -h $HOST -p $rp -a $PASSWORD info | grep '^db.:'|cut -d: -f1`
    for rdb in $rdbs;
      do
        check_first_element
        printf "{"
        printf "\"{#RDBPORT}\":\"$rp\",\"{#DBNAME}\":\"$rdb\""
        printf "}"
    done
done    
json_end
