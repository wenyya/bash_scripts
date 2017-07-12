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
	echo "Suspend to memory: ${delay} seconds"
	echo
	
	let "select = $RANDOM % 2"
	if [ "${select}" = "1" ]; then
		rtcwake -m mem -s ${delay}
	else
		rtcwake -m standby -s ${delay}
	fi

	let "delay = $RANDOM % 2 + 1 "

	echo
	echo "Active State: ${delay} seconds"
	echo
	
	sleep ${delay}
done
