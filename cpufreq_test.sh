#!/bin/sh
cd /sys/devices/system/cpu/cpu0/cpufreq/
echo userspace > scaling_governor

for i in 'seq 1 50'
do
	echo 396000 > scaling_setspeed
	sleep 5
	echo 300000 > scaling_setspeed
	sleep 5
	echo 264000 > scaling_setspeed
	sleep 5
	echo 528000 > scaling_setspeed
	sleep 5
	echo 300000 > scaling_setspeed
	sleep 5
	echo 528000 > scaling_setspeed
	sleep 5
done

while true
do
	echo 132000 > scaling_setspeed
	sleep 5
	echo 66000 > scaling_setspeed
	sleep 5
	echo 33000 > scaling_setspeed
	sleep 5
	echo 132000 > scaling_setspeed
	sleep 5
	echo 33000 > scaling_setspeed
	sleep 5
	echo 66000 > scaling_setspeed
	sleep 5
done
