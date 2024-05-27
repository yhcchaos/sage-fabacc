timeout=300
#./system_setup.sh
cpu_num=10
#schemes="c2tcp copa vivace ledbat sprout"
#schemes="sage orca indigo dbbr"
#schemes="vegas bbr reno cdg hybla highspeed illinois westwood yeah htcp bic veno cubic"
# 350+
pids=""
schemes="sage"
#bbr-vegas-reno-highspeed-illinois-westwood-yeah-htcp cubic
#schemes="cdg hybla veno bic"
# schemes="vegas bbr"
setup_time=5
#loss_list="0 0.0001 0.001 0.01 0.05" #5
#loss_list="0 0.001"
loss_list="0 0.01"
flow_num_list="1 2 3" #3
bw_list="12 24 48 96 192" #5
del_list="5 10 20 40 80" #5
total_envs=41600
time=60
run_times=1
flow_interval=0
cnt=0
## Pantheon and Mahimahi have problem with links higher than 350Mbps!
## For now, avoid using any link BW>350Mbps. But, stay tuned! A new patch is on the way! ;)
# flow 1: [f1 l2 q6 d5 c13 b13] = 10140 5070
# flow 2: [f1 l2 q5 d5 c13 b5] = 3250 1625
# flow 3: [f1 l2 q5 d5 c13 b5] = 3250 1625

# flow 1: [f1 l5 q6 d5 c13 b13] = 25350
# flow 2: [f1 l5 q5 d5 c13 b5] = 8125 1625
# flow 3: [f1 l5 q5 d5 c13 b5] = 8125 1625
# all:16640
# 1264 - 975 = 289 f=2 l=0 q=3 d=5 c=2 b=3 [2 0 4 80 bbr 20 ]
# 289-260=29->13*2=24->3
for run_id in $run_times
do
for flow_num in $flow_num_list # 1 1 1
do
    if [ "$flow_num" -eq 1 ]; then
        qs_bdp_multiplier_list="0.5 1 2 4 8 16"
    else
        qs_bdp_multiplier_list="1 2 4 8 16"
    fi
    for loss in $loss_list # 2 2 2
    do
        for qs_bdp_multiplier in $qs_bdp_multiplier_list # 6 5 5
        do
            for del in $del_list # 5 5 5
            do
                for cc in $schemes # 13 13 13
                do
                    for bw in $bw_list # 13 5 5
                    do
                        scales=1
                        bdp=$((del*bw/6))
                        qs=$(echo "$qs_bdp_multiplier * $bdp" | bc -l)
                        qs=$(echo "scale=0; $qs/1" | bc)
                        for scale in $scales
                        do
                            if [ $cnt -gt -1 ]; then
                                dl_post="-x${scale}-35"
                                bw2=$(echo "$bw * $scale" | bc -l)
                                bw2=$(echo "scale=0; $bw2/1" | bc)
                                link="$bw$dl_post"
                                port=$((22125+(cnt%cpu_num)*6))
				actor_id=$((cnt%cpu_num))
 				#./sage.sh 10 44545 wired24 wired24 1 300 24 24 7 0 testing 30 1 0 1 1 1
                                ./sage.sh $del $port wired$bw wired$bw 1 $qs $bw $bw 7 0 dataset-gen 60 $actor_id 0 $flow_num 1 1 $loss $run_id &

                                #./cc_solo.sh $cc dataset-gen $flow_num $run_times $flow_interval $del $qs "$loss" $link $time $bw $bw2 $setup_time &
                                cnt=$((cnt+1))
                                echo "------------cnt=$cnt-----------------"
                                echo "------------f=$flow_num, l=$loss, q=$qs_bdp_multiplier, del=$del, cc=$cc, b=$bw---------------"
                                pids="$pids $!"
                                sleep 1
                                if [ $((cnt % cpu_num)) -eq 0 ] || [ $cnt -eq $total_envs ];
                                then
                                    for pid in $pids
                                    do
                                        wait $pid
                                    done
                                    pids=""
                                    ./clean-tmp.sh
                                fi
                            else
                                cnt=$((cnt+1))
                                echo "------------cnt=$cnt-----------------"
                            fi
                        done
                    done
                done
            done
        done
    done
done
done


