#!/bin/bash

make zImage -j3
make targz-pkg -j3
make dtbs
cat arch/arm/boot/zImage arch/arm/boot/dts/rk3188-mk809iii.dtb > zImage-dtb
if [ ! -e initrd.zero ]; then
	dd if=/dev/zero of=initrd.zero bs=1M count=1
fi
abootimg --create aboot.img -k zImage-dtb -r initrd.zero

#cmdline="pti=off spectre_v2=off l1tf=off nospec_store_bypass_disable no_stf_barrier"
