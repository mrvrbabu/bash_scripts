#!/bin/bash

# Author 	: RameshBabu
# Date 		: Sep 2016
# Purpose       : Kernel compilation to upgrade the kernel from 2.x(2.6) to 3.x(3.19) on rhel6/centos6, mininum disk required is 8GB for compilation


# Install kernel source which provide the compilation directories 
yum install tree -y 
tree /usr/src 

echo 
echo 
echo "Installing kernel source" 
echo 
yum install kernel-devel -y 
tree /usr/src 

echo 
yum install wget -y

echo "Downloading kernel version - https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.19.tar.gz" 
#wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.19.tar.xz
#tar -Jxvf linux-3.19.tar.xz -C /usr/src/kernels

wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.19.tar.gz
tar -xvzf linux-3.19.tar.gz -C /usr/src/kernels
ln -s /usr/src/kernels/linux-3.19 /usr/src/linux

echo "Installing Pre-requesite softwares" 
yum groupinstall "Development Tools" -y 
yum install ncurses-devel -y 
yum install -y bc

cd /usr/src/linux
pwd 

make clean
make mrproper
make dist clean

echo 
echo 
echo "#######In the below menu please unselect any unwanted packages to removed from kernel##########"
echo 
echo 
echo "#######The final kernel modules config will be saved as .config in current directory######"
sleep 3

make menuconfig
echo "			Compiling kernel		" 
echo 
echo "######Compiling all loadable modules, may take time depending on number of modules, sometimes about 20 minutes#######"
sleep 3

make bzImage
echo "######Add the modules into the correct directory - /usr/lib/kernel-version############"
sleep 3 
echo "######Compiling all loadable modules, may take time depending on number of modules, sometimes about 20 minutes#######"

make modules
make modules_install

cat /etc/grub.conf
echo "###########Final step - copying the kernel and initrd to /boot and updating grub.conf file ###############" 
make install

sed -i.backup 's/default=1/default=0/g' /boot/grub/grub.conf
echo "/etc/grub.conf file updated" 
cat /etc/grub.conf 
ls -l /boot 
echo "Please verify the kernel version under /boot, if /etc/grub.conf is pointing to the latest kernel and reboot the host to start using new kernel"

# EnD 
