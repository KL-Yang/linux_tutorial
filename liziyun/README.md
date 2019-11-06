# U-boot USB 启动 (boot)
如果刷入原装armbian自带的U-Boot和启动脚本，只需一点小改动即可实现从USB启动。
理论上有好几种方式可以实现这个功能，下面我们一一讨论。

## 更改启动脚本(boot.scr)
可以实现插入USB启动镜像的时候使用USB的系统，拔出USB的时候启动EMMC的系统。
U-Boot在启动的时候会按照一定的顺序扫描EMMC/SD/USB寻找boot.scr或者extlinux系统，
扫描顺序和寻找目标是可以配置的，armbian使用boot.scr来加载Linux内核，
我们可以从它下手。

TODO:加入更改方法

## 重新编译U-Boot
可以实现插入USB启动镜像的时候优先使用USB的系统。
需要重新配置并编译U-Boot，更改搜索启动脚本的顺序，这个比较复杂。
可以参考armbian的z28pro更改启动顺序的补丁。
build/patch/u-boot/u-boot-rockchip64-default/board_z28pro/
