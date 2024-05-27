port=$1
scheme="pure"
prefix=${2}
rl_path=${3}

#path=`pwd -P | sed "s/\//___/g"`
#path_to_model="${path}___..___models___config-v9.01-sfl-simple-net1-mlp2-5days___ckpt-dir___"
#sed -i "s/load_ckpt_dir:.*/load_ckpt_dir: ${path_to_model}/g;s/___/\//g" rl_module/config.yaml
#sed -i "s/load_policy_net_sl_dir:.*/load_policy_net_sl_dir: ${path_to_model}/g;s/___/\//g" rl_module/config-rl.yaml

path=`pwd -P`
log=${prefix}-sage
basetimestamp_fld="$path/log/down-${log}_init_timestamp"
echo "base timestamp folder: $basetimestamp_fld"
rm $basetimestamp_fld

sudo -u `logname` ./server.sh $port $scheme "$rl_path" $log $basetimestamp_fld
echo "server.sh is executed ..."

py_pids=`ps aux | grep "id=$actor_id" | awk -v str="--id=$actor_id" '{if($17==str)print $2}'`
echo "Server (ACTOR $actor_id) is done. closing its python scripts: $py_pids "
for pid in $py_pids
do
    sudo kill -s15 $pid
done

if [[ $num_flows > 1 ]]
then
    for i in `seq 1 $((num_flows-1))`
    do
        iperf_pid=`ps aux | grep "iperf3 -s -p $((port+i))" | awk '{print $2}'`
        echo "Server (ACTOR $actor_id) is done. closing its python scripts: $iperf_pid "
        sudo kill -s9 $iperf_pid
    done
fi
sleep 1

if [[ $analyze == 1 ]]
then
    echo "[Actor $actor_id] Doing Analysis ..."
    echo "------------------------------"
    out="${log}.tr"
    mkdir -p log
    echo $log >> log/$out
    ./mm-thr 500 log/down-${log} 1>log/down-$log.svg 2>res_tmp
    cat res_tmp >>log/$out

    ./mm-del-file log/down-${log} 2>res_tmp2
    ./plot-del.sh log/down-$log.dat
    echo "------------------------------" >> log/$out
    cat res_tmp
    echo "------------------------------"
fi
rm res_tmp res_tmp2

echo "Actor($actor_id) is Finished."
