#!/bin/sh

total_sleep_times=0
total_wake_time=0

average_sleep_time=0
average_wake_time=0

count=0

while (true)
do
	let "count += 1"
	
	echo "-----------------------------"
	echo $(date)
	echo
	echo "Suspend to memory testing times: ${count}"
	echo
	
	let "delay = $RANDOM % 5 + 1 "
	let "total_sleep_times += delay"
	let "average_sleep_time = total_sleep_times / count"
	echo "Suspend random times: ${delay} seconds"
	
	rtcwake -m mem -s ${delay}
	
	echo
	echo "Average sleep time: ${average_sleep_time} seconds"
	
	let "delay = $RANDOM % 5 + 1 "
	let "total_wake_time += delay"
	let "average_wake_time = total_wake_time / count"
	
	echo
	echo "Wait random time: ${delay} seconds"
	
	sleep ${delay}
	
	echo
	echo "Average wake time: ${average_wake_time} seconds"
	echo
	
done
