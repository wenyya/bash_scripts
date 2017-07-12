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

Times="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"
for i in ${Times};
do
	echo "Time is ${i}"
	
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

	echo "copying $src_path/$file_name ..."
	md5_src=`md5sum $src_path/$file_name | awk '{print $1}'`
	echo "the file $src_path/$file_name is copying ... "
	copy=`cp $src_path/$file_name $mount_path`
	md5_dst=`md5sum $mount_path/$file_name | awk '{print $1}'`

	if [ "$md5_src" = "$md5_dst" ]; then
		echo "copy the file $src_path/$file_name to $mount_path successfully"
		echo
	else
		echo "copy the file $src_path/$file_name to $mount_path failed"
		exit 1
fi
	umount "$mount_path"
	echo "umouting $mount_path, Successful"
	echo
done
