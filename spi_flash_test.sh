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
	echo "Copying the files from $src_path to the spi-flash: $mtdblock_path"
	echo

	copy=`cp -r $src_path/* $mount_path`

done
	echo "umounting $mount_path"
	umount "$mount_path"
	echo
