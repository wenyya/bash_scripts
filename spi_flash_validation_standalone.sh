#!/bin/sh

echo "validating the spi flash"
echo

cat /proc/mtd > mtd.log && grep -q "spi" mtd.log && i=1 || i=0

if [ $i = 0 ]; then
	echo "spi is not enbled or no dataflash probed"
	exit 1
fi

mtd_path=`grep "spi" mtd.log | awk -F: '{print $1}'`
dev_mtd="/dev/$mtd_path"

echo "flash is erasing, please waiting ..."
flash_erase "$dev_mtd" 0 0
echo "flash erasing done"
echo 

sed -e '/spi/s/mtd/mtdblock/g' mtd.log > mtd1.log
mtdblock_path=`grep "spi" mtd1.log | awk -F: '{print $1}'`
mtdblock_path="/dev/$mtdblock_path"

rm mtd.log mtd1.log

mount > mount.log && grep -q "$mtdblock_path" mount.log && i=1 || i=0
if [ $i = 1 ]; then
	umount $mtdblock_path
fi

mount_path="/mnt"
src_path="/bin"
file_name="busybox"
size=`ls -l $src_path/$file_name | awk '{print $5}'`
md5_src=`md5sum $src_path/$file_name | awk '{print $1}'`
target_path="./"

# Preparation for copying file to ./ 
mount -t jffs2 "$mtdblock_path" "$mount_path"
mount > mount.log && grep -q "$mtdblock_path" mount.log && i=1 || i=0
if [ $i = 1 ]; then
echo "mount $mtdblock_path to $mount_path successfully"
	echo
else
	echo "mount $mtdblock_path to $mount_path failed"
	exit 1
fi

rm mount.log

#Testtimes="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"
Testtimes="1 2 3 4 5 6"
for i in ${Testtimes};
do
	echo "Test time is: $i"
	
	#Copying the file to the spi-flash
	echo "Copying the file: $file_name to the spi-flash: $mtdblock_path"

	CURTIME1=`date +"%Y-%m-%d %H:%M:%S"`
	copy=`cp $src_path/$file_name $mount_path`
	CURTIME2=`date +"%Y-%m-%d %H:%M:%S"`
	md5_dst=`md5sum $mount_path/$file_name | awk '{print $1}'`
	if [ "$md5_src" = "$md5_dst" ]; then
		echo "copy the file $src_path/$file_name to $mount_path successfully"
		echo
	else
		echo "copy the file $src_path/$file_name to $mount_path failed"

		umount "$mount_path"
		exit 1
	fi

	begin=`date -d "$CURTIME1" +%s`
	end=`date -d "$CURTIME2" +%s`
	interval=`expr $end - $begin`

	echo "file size: $size bytes, copy time is: $interval s"
	speed=`expr $size / $interval \* 8`
	echo "copy speed is: $speed bps"
	echo

	#Copying the file from spi-flash
	echo "Copying the file: $file_name from spi-flash: $mtdblock_path"

	echo "the file $mount_path/$file_name is copying to $target_path ... "
	CURTIME1=`date +"%Y-%m-%d %H:%M:%S"`
	copy=`cp $mount_path/$file_name .`
	CURTIME2=`date +"%Y-%m-%d %H:%M:%S"`
	md5_dst=`md5sum $target_path/$file_name | awk '{print $1}'`
	if [ "$md5_src" = "$md5_dst" ]; then
		echo "copy the file $mount_path/$file_name to $target_path successfully"
		echo
	else
		echo "copy the file $mount_path/$file_name to $target_path failed"
		umount "$mount_path"
		exit 1
	fi

	begin=`date -d "$CURTIME1" +%s`
	end=`date -d "$CURTIME2" +%s`
	interval=`expr $end - $begin`

	echo "file size: $size bytes, copy time is: $interval s"
	speed=`expr $size / $interval \* 8`
	echo "copy speed is: $speed bps"
	echo

done
	echo "umounting $mount_path"
	umount "$mount_path"
	echo
