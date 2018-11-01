#!/bin/bash
#Name: monitor_services.sh
#Author: flashyhl
#Action: Zabbix monitoring eureka services plug-in

Eureka_Url="http://127.0.0.1:10001/eureka/apps"

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

appname=`echo $1 | awk -F":" '{print $2}'`
service_num=`curl -XGET --silent ${Eureka_Url}/${appname}/$1 | grep "<status>" | sed -e "s/<status>//g" |sed -e "s/<status\/>//g" | grep "UP" | wc -l`
if [[ ${service_num} == 1 ]];then
    result=1
else
    result=0
fi
echo $result
