#!/bin/sh

count=0

while (true)
do
	let "count += 1"
	
	echo "-----------------------------"
	echo $(date)
	echo
	echo "Suspend to memory testing times: ${count}"
	echo
	
	let "delay = 3 "

	echo
	echo "Suspend to Standby: ${delay} seconds"
	echo
	
	rtcwake -m standby -s ${delay}
	
	let "delay = $RANDOM % 2 + 1 "

	echo
	echo "Active State: ${delay} seconds"
	echo
	
	sleep ${delay}
done
