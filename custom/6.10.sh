#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part02.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)

echo "开始配置……"
echo "========================="

function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    # find package/ -follow -name $pkg -not -path "package/custom/*" | xargs -rt rm -rf
    git clone --depth=1 --single-branch $1
    mv $2 package/custom/
    rm -rf $repo
}
function drop_package(){
    find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}
function merge_feed(){
    if [ ! -d "feed/$1" ]; then
        echo >> feeds.conf.default
        echo "src-git $1 $2" >> feeds.conf.default
    fi
    ./scripts/feeds update $1
    ./scripts/feeds install -a -p $1
}
rm -rf package/custom; mkdir package/custom

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# golang 1.22
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# node - prebuilt
# rm -rf feeds/packages/lang/node
# git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# 移除 SNAPSHOT 标签
#sed -i 's,-SNAPSHOT,,g' include/version.mk
#sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

# 更改固件版本信息
#sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION=''|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt 23.05'|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt SNAPSHOT'|g" package/base-files/files/etc/openwrt_release

# alist
#git clone https://github.com/sbwml/luci-app-alist package/alist

# DDNS GO
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# OpenClash
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash package/OpenClash

# Daed
git clone https://github.com/QiuSimons/luci-app-daed-next package/new/luci-app-daed-next
#git clone https://github.com/sbwml/luci-app-daed package/new/luci-app-daed

# Dae
#git clone https://github.com/8688Add/luci-app-dae package/luci-app-dae

# Shared for PassWall and ShadowsocksR Plus+
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/new/helloworld -b v5

# bypass
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb

# homeproxy
git clone --depth=1 https://github.com/immortalwrt/homeproxy package/homeproxy

# Release Ram
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-ramfree

# Scheduled Reboot
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-autoreboot

# ttyd
#rm -rf feeds/luci/applications/luci-app-ttyd
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-ttyd

# partexp
git clone https://github.com/sirpdboy/luci-app-partexp package/luci-app-partexp

# Filetransfer
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-filetransfer
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-lib-fs

# AutoCore
rm -rf feeds/packages/utils/coremark
merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/emortal/autocore
merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/utils/mhz
rm -rf feeds/luci/modules/luci-base
rm -rf feeds/luci/modules/luci-mod-status
# 克隆immortalwrt-luci仓库
git clone --depth=1 -b master https://github.com/immortalwrt/luci.git immortalwrt-luci
cp -rf immortalwrt-luci/modules/luci-base feeds/luci/modules/luci-base
cp -rf immortalwrt-luci/modules/luci-mod-status feeds/luci/modules/luci-mod-status
# 克隆immortalwrt-packages仓库
git clone --depth=1 -b master https://github.com/immortalwrt/packages.git immortalwrt-packages
cp -rf immortalwrt-packages/utils/coremark feeds/packages/utils/coremark

# Zerotier
# rm -rf feeds/luci/applications/luci-app-zerotier
#rm -rf feeds/packages/net/zerotier
# merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-zerotier
#sed -i 's/vpn/services/g' package/custom/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json

# unblockneteasemusic
# merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-unblockneteasemusic
# merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/UnblockNeteaseMusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# wechatpush
# merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-wechatpush
# merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/wrtbwmon

# turboacc
#git clone https://github.com/chenmozhijin/turboacc package/new/luci-app-turboacc
#git clone https://github.com/fullcone-nat-nftables/nft-fullcone package/new/nft-fullcone
#git clone --depth=1 -b package https://github.com/chenmozhijin/turboacc package/new/turboacc
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
#sed -i 's/Turbo ACC 网络加速/网络加速/g' package/new/luci-app-turboacc/luci-app-turboacc/po/zh-cn/turboacc.po

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 修改系统文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/25_storage.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/25_storage.js
sed -i 's/WireGuard/WiGd状态/g' feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/luci-proto-wireguard.json

# 替换文件
#wget -O ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js
