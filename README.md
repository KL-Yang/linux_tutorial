# linux_tutorial
Linux related tutorial
Add my inphic-i5 sun8i-h3 TV box support file, Debian Buster armhf runs file.


联想粒子云dtb和dts文件，提取步骤
1. dump the original firmware
2. find and extract the boot partition
3. use abootimg -x extract parts from the image
4. find the dtb finger print tag in stage2.img and dump the dtb
5. convert to dts use dtc
