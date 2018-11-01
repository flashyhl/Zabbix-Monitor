#!/bin/sh
#  RabbitMQ  Zabbix
# Author：flashyhl
zabbix_user=zabbix
zabbix_passwd=zabbix_HbaPfsXGqq4SZkR29kQ94RJj
CurlAPI(){
  RespStr=$(/usr/bin/curl --max-time 20 --no-keepalive --silent --user $zabbix_user:$zabbix_passwd "http://127.0.0.1:15672/api/$1" | /etc/zabbix/scripts/rabbitmq_zabbix/JSON.sh -l 2>/dev/null)
  [ $? != 0 ] && echo 0 && exit 1
}

OutStr=''
IFS=$'\n'

if [ -z $1 ]; then
  CurlAPI 'overview?columns=message_stats,queue_totals,object_totals'
  for par in $RespStr; do
    OutStr="$OutStr- rabbitmq.${par/	/ }\n"
  done
  CurlAPI 'queues?columns=name'
  QueueStr=$RespStr
  for q in $QueueStr; do
    qn=${q#*	}
    CurlAPI "queues/%2f/$qn?columns=message_stats,memory,messages,messages_ready,messages_unacknowledged,consumers"
    for par in $RespStr; do
      OutStr="$OutStr- rabbitmq.${par%%	*}[$qn] ${par#*	}\n"
    done
  done
  echo -en $OutStr | /etc/zabbix/bin/zabbix_sender --config /etc/zabbix/etc/zabbix_agentd.conf --host='IGIX_CLOUD_Internal01' --input-file - >/dev/null 2>&1
  echo 1
  exit 0

elif [ "$1" = 'queues' ]; then
  CurlAPI 'queues?columns=name'
  es=''
  for q in $RespStr; do
    OutStr="$OutStr$es{\"{#QUEUENAME}\":\"${q#*	}\"}"
    es=","
  done
  echo -e "{\"data\":[$OutStr]}"
fi
