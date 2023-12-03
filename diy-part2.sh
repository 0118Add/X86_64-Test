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

# 替换内核
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/g' target/linux/x86/Makefile

# 删除插件
rm -rf package/feeds/luci/luci-app-apinger

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# 更改固件版本信息
#sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION=''|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt 23.05'|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt SNAPSHOT'|g" package/base-files/files/etc/openwrt_release

# alist
#git clone https://github.com/sbwml/luci-app-alist package/alist
svn export -q https://github.com/0118Add/luci-immortalwrt/branches/master/applications/luci-app-alist feeds/luci/applications/luci-app-alist
ln -sf ../../../feeds/luci/applications/luci-app-alist ./package/feeds/luci/luci-app-alist
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/alist package/new/alist

# ADBYBY Plus +
#svn export -q https://github.com/0118Add/openwrt-packages/trunk/adbyby package/new/adbyby
#svn export -q https://github.com/0118Add/openwrt-packages/trunk/luci-app-adbyby-plus package/new/luci-app-adbyby-plus

# DDNS GO
svn export -q https://github.com/immortalwrt/luci/branches/master/applications/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
ln -sf ../../../feeds/luci/applications/luci-app-ddns-go ./package/feeds/luci/luci-app-ddns-go
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/ddns-go package/new/ddns-go
#svn export -q https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/ddns-go package/new/ddns-go

# OpenClash
svn export -q  https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/new/luci-app-openclash

# Daed
svn export -q https://github.com/0118Add/luci-immortalwrt/branches/master/applications/luci-app-daed feeds/luci/applications/luci-app-daed
ln -sf ../../../feeds/luci/applications/luci-app-daed ./package/feeds/luci/luci-app-daed
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/daed package/new/daed

# Dae
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/dae package/new/dae

# Shared for PassWall and ShadowsocksR Plus+
#svn export -q https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-passwall package/new/luci-app-passwall
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-passwall2 package/new/luci-app-passwall2
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/brook package/new/brook
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/dns2socks package/new/dns2socks
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/ipt2socks package/new/ipt2socks
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/kcptun package/new/kcptun
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/hysteria package/new/hysteria
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/sing-box package/new/sing-box
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/chinadns-ng package/new/chinadns-ng
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/trojan-go package/new/trojan-go
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/trojan-plus package/new/trojan-plus
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/microsocks package/new/microsocks
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/pdnsd-alt package/new/pdnsd-alt
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/redsocks2 package/new/redsocks2
svn export -q https://github.com/xiaorouji/openwrt-passwall-packages/trunk/gn package/new/gn
git clone -b main https://github.com/fw876/helloworld package/helloworld

# bypass
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/lua-maxminddb package/new/lua-maxminddb
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/new/luci-app-bypass

# vssr
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-vssr package/new/luci-app-vssr

# UPX 可执行软件压缩
svn export -q https://github.com/Lienol/openwrt/branches/23.05/tools/ucl ./tools/ucl
svn export -q https://github.com/Lienol/openwrt/branches/23.05/tools/upx ./tools/upx
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile

# homeproxy
svn export -q https://github.com/0118Add/luci/branches/master/applications/luci-app-homeproxy feeds/luci/applications/luci-app-homeproxy
ln -sf ../../../feeds/luci/applications/luci-app-homeproxy ./package/feeds/luci/luci-app-homeproxy

# Release Ram
svn export -q https://github.com/immortalwrt/luci/branches/master/applications/luci-app-ramfree feeds/luci/applications/luci-app-ramfree
ln -sf ../../../feeds/luci/applications/luci-app-ramfree ./package/feeds/luci/luci-app-ramfree

# Scheduled Reboot
svn export -q https://github.com/immortalwrt/luci/branches/master/applications/luci-app-autoreboot feeds/luci/applications/luci-app-autoreboot
ln -sf ../../../feeds/luci/applications/luci-app-autoreboot ./package/feeds/luci/luci-app-autoreboot

# frpc
#rm -rf feeds/luci/applications/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc feeds/luci/applications/luci-app-frpc
#ln -sf ../../../feeds/luci/applications/luci-app-frpc ./package/feeds/luci/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc package/new/luci-app-frpc 

# ttyd
rm -rf feeds/luci/applications/luci-app-ttyd
svn export -q https://github.com/immortalwrt/luci/branches/master/applications/luci-app-ttyd feeds/luci/applications/luci-app-ttyd
ln -sf ../../../feeds/luci/applications/luci-app-ttyd ./package/feeds/luci/luci-app-ttyd

# vlmcsd
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-vlmcsd feeds/luci/applications/luci-app-vlmcsd
#ln -sf ../../../feeds/luci/applications/luci-app-vlmcsd ./package/feeds/luci/luci-app-vlmcsd
#svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/vlmcsd package/new/vlmcsd

# luci-app-firewall
#rm -rf feeds/luci/applications/luci-app-firewall
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-firewall feeds/luci/applications/luci-app-firewall
#ln -sf ../../../feeds/luci/applications/luci-app-firewall ./package/feeds/luci/luci-app-firewall

# Filetransfer
svn export -q https://github.com/0118Add/luci/branches/master/applications/luci-app-filetransfer feeds/luci/applications/luci-app-filetransfer
ln -sf ../../../feeds/luci/applications/luci-app-filetransfer ./package/feeds/luci/luci-app-filetransfer
svn export -q https://github.com/0118Add/luci/branches/master/libs/luci-lib-fs feeds/luci/libs/luci-lib-fs
ln -sf ../../../feeds/luci/libs/luci-lib-fs ./package/feeds/luci/luci-lib-fs

# AutoCore
#svn export -q https://github.com/padavanonly/immortalwrtARM/branches/master/package/emortal/autocore package/new/autocore
#svn export -q https://github.com/8688Add/OpenWrt-CI/trunk/autocore package/new/autocore
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/master/package/utils/mhz package/new/mhz

# default settings and translation
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/master/package/emortal/default-settings package/new/default-settings
#svn export -q https://github.com/jinlife/OpenWrt-Autobuild/trunk/default-settings package/new/default-settings

# fullconenat
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat-nft package/new/fullconenat-nft
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat package/new/fullconenat-nft

# Zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
#rm -rf feeds/packages/net/zerotier
#svn export -q https://github.com/0118Add/openwrt-packages/trunk/zerotier package/new/zerotier
#svn export -q https://github.com/0118Add/openwrt-packages/trunk/luci-app-zerotier package/new/luci-app-zerotier
svn export -q https://github.com/0118Add/luci-immortalwrt/branches/master/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
ln -sf ../../../feeds/luci/applications/luci-app-zerotier ./package/feeds/luci/luci-app-zerotier

# unblockneteasemusic
svn export -q https://github.com/immortalwrt/luci/branches/master/applications/luci-app-unblockneteasemusic feeds/luci/applications/luci-app-unblockneteasemusic
ln -sf ../../../feeds/luci/applications/luci-app-unblockneteasemusic ./package/feeds/luci/luci-app-unblockneteasemusic

# wechatpush
svn export -q https://github.com/0118Add/luci-immortalwrt/branches/master/applications/luci-app-wechatpush feeds/luci/applications/luci-app-wechatpush
ln -sf ../../../feeds/luci/applications/luci-app-wechatpush ./package/feeds/luci/luci-app-wechatpush

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's#net.netfilter.nf_conntrack_max=16384#net.netfilter.nf_conntrack_max=65535#g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# R8168驱动
git clone -b master --depth 1 https://github.com/BROBIRD/openwrt-r8168.git package/new/r8168
# R8152驱动
svn export -q https://github.com/0118Add/openwrt-packages/trunk/r8152 package/new/r8152
# r8125驱动
svn export -q https://github.com/0118Add/openwrt-packages/trunk/r8125 package/new/r8125

#sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/new/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
#sed -i 's/Frp 内网穿透/内网穿透/g' package/new/luci-app-frpc/po/zh-cn/frp.po
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
#sed -i 's/UPnP/UPnP设置/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po

# 修改系统文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# 替换文件
#wget -O ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js
