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

# 删除插件
rm -rf package/feeds/luci/luci-app-ntpc
#rm -rf package/feeds/packages/glib2
#cp -rf $GITHUB_WORKSPACE/general/mbedtls package/feeds/packages/glib2

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# golang 1.22
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# node - prebuilt
#rm -rf feeds/packages/lang/node
#git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# 替换内核
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' target/linux/x86/Makefile

# 修改连接数
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
# 修正连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 移除 SNAPSHOT 标签
#sed -i 's,-SNAPSHOT,,g' include/version.mk
#sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

# 更改固件版本信息
#sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION=''|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt 23.05'|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt SNAPSHOT'|g" package/base-files/files/etc/openwrt_release

# 内核替换 kernel xxx
#sed -i 's/LINUX_KERNEL_HASH-5.15.139 = 9c68c10dfe18e59b892e940436dea6a18d167160d55e62563cf7282244d8044e/LINUX_KERNEL_HASH-5.15.138 = af84e54164e1c01f59764ba528448ed36b377d22aafbd81b4b0cf47792ef4aaa/g' ./include/kernel-5.15
#sed -i 's/LINUX_VERSION-5.15 = .139/LINUX_VERSION-5.15 = .138/g' ./include/kernel-5.15

# alist
#git clone https://github.com/sbwml/luci-app-alist package/alist

# DDNS GO
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/luci-app-openclash

# Daed
#git clone https://github.com/QiuSimons/luci-app-daed-next package/new/luci-app-daed-next
#git clone https://github.com/sbwml/luci-app-daed package/new/luci-app-daed

# Dae
#git clone https://github.com/8688Add/luci-app-dae package/luci-app-dae

# Shared for PassWall and ShadowsocksR Plus+
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,hysteria}
git clone https://github.com/sbwml/openwrt_helloworld package/new/helloworld -b v5
#merge_package https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-passwall
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-passwall2
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/brook
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/dns2socks
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/ipt2socks
#merge_package https://github.com/immortalwrt/packages packages/net/kcptun
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/hysteria
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/sing-box
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/chinadns-ng
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/trojan-go
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/trojan-plus
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/microsocks
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/pdnsd-alt
#merge_package https://github.com/immortalwrt/packages packages/net/redsocks2
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/gn
sed -i 's/ +libopenssl-legacy//g' package/new/helloworld/shadowsocksr-libev/Makefile
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/new/helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

# lua-maxminddb
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb

# homeproxy
#git clone --depth=1 https://github.com/immortalwrt/homeproxy package/homeproxy

# Release Ram
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-ramfree

# Scheduled Reboot
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-autoreboot

 # ttyd
#rm -rf feeds/luci/applications/luci-app-ttyd
#sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-ttyd

# partexp
git clone https://github.com/sirpdboy/luci-app-partexp package/luci-app-partexp
sed -i 's/一键分区扩容/分区扩容/g' package/luci-app-partexp/po/zh-cn/partexp.po

# Filetransfer
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-filetransfer
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-lib-fs

# Zerotier
#rm -rf feeds/luci/applications/luci-app-zerotier
#rm -rf feeds/packages/net/zerotier
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-zerotier
#sed -i 's/vpn/services/g' package/custom/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json

# unblockneteasemusic
git clone -b master https://github.com/0118Add/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua

# wechatpush
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-wechatpush
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/wrtbwmon
