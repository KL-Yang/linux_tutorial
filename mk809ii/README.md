Tutorial of running mainline linux on MK809II (rk3188).

A precreated image with Debian Stretch (9.3) and Kernel 4.9.73 can be found here,
https://drive.google.com/open?id=18oCkW_7d4t-oWLc45B-Fxnca2pj9PXuH
md5sum: c030becb075f6810714a116415517767.
Root password is password, and hostname is mk809, dhcp is enabled on eth0, 
ssh login of root is allowed.
Minimum 1GB micro SD card required to write this image, then resize the partition 
and the F2FS filesystem to fill up the card.

Note, when update kernel image, UPDATE kernel module accordingly, otherwise the
usb ethernet will not be brought up properly. And udev may name the network interface
to something other than eth0.

The following tutorial is just a collection of resources, detail information and rational 
can be found by following links provided. I am using this tutorial to run debian stretch 
on my little mk809ii as headless armhf linux server, 
   which has 4 Cortex-A9 cores and 2GB RAM.

1. U-Boot (reference: http://wiki.radxa.com/Rock/U-Boot)

    git clone -b u-boot-rk3188 https://github.com/radxa/u-boot-rockchip.git
    cd u-boot-rockchip
    make rk30xx

Note: the code base is very old, I made a cross build on Debian Jessie on x86-64.
With patch "0001-make-it-compile-on-debian-jessie.patch", a working u-boot is provided 
as "u-boot-sd.img", md5sum:cb3e921a9f389c6aaff9b3b025d14555. 
Write u-boot to SD card with command:

    dd if=u-boot-sd.img of=/dev/sdx seek=64

2. The parameter file (This is rockchip specific, provided by Radxa):

    wget http://dl.radxa.com/rock/images/parameter/parameter_linux_sd
    rkcrc -p parameter_linux_sd parameter.img
    dd if=parameter.img of=/dev/sdx conv=sync seek=$((0x2000))

Note: rkcrc is part of the rockchip tool to flash image, Radxa provide the source on github. 
Here also provide a copy of working parameter.img, it's not need be changed anyway.

3. Mainline Kernel (linux-4.9.y) and dts and initramfs.
    
    make zImage dtb targz-pkg
	cat arch/arm/boot/zImage arch/arm/boot/dts/rk3188-mk809iii.dtb > zImage-dtb
    dd if=/dev/zero of=initrd.zero bs=1M count=1
	abootimg --create aboot.img -k zImage-dtb -r initrd.zero
	dd if=aboot.img of=1GB.img conv=notrunc seek=16384

Note: usb and sd card works, and with a usb ethernet card, it can be used as headless server, 
with 4 cores and 2GB RAM. Example kernel configuration is provided. 
By default, this kernel expect rootfs to be the first partition of SD card of type F2FS.
Guess the lagacy u-boot is meant for Android, here we provide an empty initram fs.
