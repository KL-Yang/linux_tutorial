# U-boot USB 启动 (boot)
如果刷入原装armbian自带的U-Boot和启动脚本，只需一点小改动即可实现从USB启动。
理论上有好几种方式可以实现这个功能，下面我们一一讨论。

## 更改启动脚本(boot.scr)
可以实现插入USB启动镜像的时候使用USB的系统，拔出USB的时候启动EMMC的系统。
U-Boot在启动的时候会按照一定的顺序扫描EMMC/SD/USB寻找boot.scr或者extlinux系统，
扫描顺序和寻找目标是可以配置的，armbian使用boot.scr来加载Linux内核，
我们可以从它下手。Ayufan的镜像使用extlinux配置，暂时还未尝试如何使用extlinux启动USB镜像。

## USB boot environment
在Armbian和/boot/boot.cmd文件内加载armbianEnv.txt区块后面尝试从USB重新加载环境变量，
实现从USB启动的目的。要寻找的区块如下：
```bash
if test -e ${devtype} ${devnum} ${prefix}armbianEnv.txt; then
        load ${devtype} ${devnum} ${load_addr} ${prefix}armbianEnv.txt
        env import -t ${load_addr} ${filesize}
fi
```
在其后加入如下一段代码，首先启动USB模块，如果目标文件存在，尝试重新加载环境变量。
```bash
usb start
if test -e usb 0 /boot/armbianEnv.txt; then
      load usb 0 ${load_addr} ${prefix}armbianEnv.txt
      env import -t ${load_addr} ${filesize}
fi
```
修改完毕后，根据提示，需要重新生成boot.scr
```bash
mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
```

```bash
verbosity=1
overlay_prefix=rockchip
rootdev=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
rootfstype=ext4
usbstoragequirks=0x2537:0x1066:u,0x2537:0x1068:u
fdtfile=rockchip/rk3328-rock64.dtb.test1
devtype=usb
devnum=0
overlays=
```

TODO:加入更改方法

## 重新编译U-Boot
可以实现插入USB启动镜像的时候优先使用USB的系统。
需要重新配置并编译U-Boot，更改搜索启动脚本的顺序，这个比较复杂。
在没有串口(UART-Serial Port)的情况下不想尝试了。
感兴趣的朋友可以参考armbian的z28pro更改启动顺序的补丁。
build/patch/u-boot/u-boot-rockchip64-default/board_z28pro/

# 风扇控制(Fan Control)
根据恩山用户rush(Ref:[1])提供的GPIO信息，
可以配置fancontrol包，根据CPU或硬盘温度调节风扇转速。
TODO:加入配置方法

# 使用BTRFS类型的ROOT分区
可以使用压缩等高级功能，充分利用EMMC。
TODO:加入配置方法


[1]. https://www.right.com.cn/forum/thread-1007957-1-1.html

experiment:
gradually remove unused part from dts!

[    4.360551] sdmmc-regulator GPIO handle specifies active low - ignored
[    4.361082] vcc-host-5v-regulator GPIO handle specifies active low - ignored
[    4.361849] iommu: Default domain type: Translated

