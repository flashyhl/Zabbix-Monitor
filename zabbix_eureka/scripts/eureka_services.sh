#!/bin/bash

Eureka_Url="http://127.0.0.1:10001/eureka/apps"

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


service_list=`curl -XGET --silent ${Eureka_Url} | grep "<instanceId>" | sed -e "s/<instanceId>//g" |sed -e "s/<\/instanceId>//g"`
for service in $service_list
    do
        check_first_element
        printf "{"
        printf "\"{#SERVICE}\":\"$service\""
        printf "}"
done    
json_end

