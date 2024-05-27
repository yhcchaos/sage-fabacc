#!/bin/bash
port=$1
scheme=$2
rl_path=$3
log_path=$4
prefix=$5
actor_id=$6
                                                                                                                                                                                                                                                                                                                      
log=${prefix}-sage
basetimestamp_fld="$path/log/down-${log}_init_timestamp"
echo "base timestamp folder: $basetimestamp_fld"
rm $basetimestamp_fld
$path/sage $port $rl_path $scheme $log_path $basetimestamp_fld $actor_id


