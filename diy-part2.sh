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

#!/bin/bash
###仓库单独拉一个文件夹 替代SVN
# $1=被拉文件夹路径  $2=仓库地址 $3=BRANCH
SVN_PACKAGE() {
 local PKG_PATH=$1
 local PKG_REPO=$2
 local PKG_BRANCH=$3
 local REPO_NAME=$(echo $PKG_REPO | rev | cut -d'/' -f 1 | rev)

 git clone --depth=1 --single-branch --branch $PKG_BRANCH $PKG_REPO
   
 mv $REPO_NAME/$PKG_PATH ./svn-package/
    rm -rf $REPO_NAME
}
mkdir ./svn-package
#SVN_PACKAGE "openwrt/aliyundrive-webdav" "https://github.com/messense/aliyundrive-webdav" "main"
#SVN_PACKAGE "openwrt/luci-app-aliyundrive-webdav" "https://github.com/messense/aliyundrive-webdav" "main"

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

# 内核替换 kernel xxx
#sed -i 's/LINUX_KERNEL_HASH-6.1.67 = 7537db7289ca4854a126bc1237c47c5b21784bcbf27b4e571d389e3528c59285/LINUX_KERNEL_HASH-6.1.66 = 419e62cd6c4239e6950b688db9e8753eb1e99c216dc3204f7932398a3fef1a0c/g' ./include/kernel-6.1
#sed -i 's/LINUX_VERSION-6.1 = .67/LINUX_VERSION-6.1 = .66/g' ./include/kernel-6.1

# alist
git clone https://github.com/sbwml/luci-app-alist package/alist

# DDNS GO
#svn export -q https://github.com/immortalwrt/luci/branches/master/applications/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
#ln -sf ../../../feeds/luci/applications/luci-app-ddns-go ./package/feeds/luci/luci-app-ddns-go
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/ddns-go package/new/ddns-go
#svn export -q https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/ddns-go package/new/ddns-go

# OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/luci-app-openclash

# Daed
SVN_PACKAGE "applications/luci-app-daed" "https://github.com/0118Add/luci-immortalwrt" "master"
SVN_PACKAGE "net/daed" "https://github.com/immortalwrt/packages" "master"
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/daed package/new/daed

# Dae
SVN_PACKAGE "net/dae" "https://github.com/immortalwrt/packages" "master"
#SVN_PACKAGE "dae" "https://github.com/kiddin9/openwrt-packages" "master"

# Shared for PassWall and ShadowsocksR Plus+
#svn export -q https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus
SVN_PACKAGE "luci-app-passwall" "https://github.com/kiddin9/openwrt-packages" "master"
SVN_PACKAGE "luci-app-passwall2" "https://github.com/kiddin9/openwrt-packages" "master"
SVN_PACKAGE "brook" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "dns2socks" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "ipt2socks" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "net/kcptun" "https://github.com/immortalwrt/packages" "openwrt-21.02"
SVN_PACKAGE "hysteria" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "sing-box" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "chinadns-ng" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "trojan-go" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "trojan-plus" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "microsocks" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "pdnsd-alt" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
SVN_PACKAGE "net/redsocks2" "https://github.com/immortalwrt/packages" "openwrt-21.02"
SVN_PACKAGE "gn" "https://github.com/xiaorouji/openwrt-passwall-packages" "main"
git clone https://github.com/fw876/helloworld package/helloworld

# bypass
SVN_PACKAGE "lua-maxminddb" "https://github.com/kiddin9/openwrt-packages" "master"
#SVN_PACKAGE "luci-app-bypass" "https://github.com/kiddin9/openwrt-packages" "master"

# vssr
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-vssr package/new/luci-app-vssr

# UPX 可执行软件压缩
SVN_PACKAGE "tools/ucl" "https://github.com/Lienol/openwrt" "23.05"
SVN_PACKAGE "tools/upx" "https://github.com/Lienol/openwrt" "23.05"
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile

# homeproxy
git clone https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy

# Release Ram
SVN_PACKAGE "applications/luci-app-ramfree" "https://github.com/immortalwrt/luci" "master"

# Scheduled Reboot
SVN_PACKAGE "applications/luci-app-autoreboot" "https://github.com/immortalwrt/luci" "master"

# frpc
#rm -rf feeds/luci/applications/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc feeds/luci/applications/luci-app-frpc
#ln -sf ../../../feeds/luci/applications/luci-app-frpc ./package/feeds/luci/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc package/new/luci-app-frpc 

# ttyd
#rm -rf feeds/luci/applications/luci-app-ttyd
SVN_PACKAGE "applications/luci-app-ttyd" "https://github.com/immortalwrt/luci" "master"

# vlmcsd
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-vlmcsd feeds/luci/applications/luci-app-vlmcsd
#ln -sf ../../../feeds/luci/applications/luci-app-vlmcsd ./package/feeds/luci/luci-app-vlmcsd
#svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/vlmcsd package/new/vlmcsd

# luci-app-firewall
#rm -rf feeds/luci/applications/luci-app-firewall
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-firewall feeds/luci/applications/luci-app-firewall
#ln -sf ../../../feeds/luci/applications/luci-app-firewall ./package/feeds/luci/luci-app-firewall

# Filetransfer
SVN_PACKAGE "luci-app-filetransfer" "https://github.com/kiddin9/openwrt-packages" "master"
SVN_PACKAGE "libs/luci-lib-fs" "https://github.com/immortalwrt/luci" "master"

# AutoCore
SVN_PACKAGE "package/emortal/autocore" "https://github.com/immortalwrt/immortalwrt" "master"
SVN_PACKAGE "package/utils/mhz" "https://github.com/immortalwrt/immortalwrt" "master"

# default settings and translation
SVN_PACKAGE "package/emortal/default-settings" "https://github.com/immortalwrt/immortalwrt" "master"

# fullconenat
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat-nft package/new/fullconenat-nft
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat package/new/fullconenat-nft

# Zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
SVN_PACKAGE "applications/luci-app-zerotier" "https://github.com/0118Add/luci-immortalwrt" "master"

# unblockneteasemusic
SVN_PACKAGE "applications/luci-app-unblockneteasemusic" "https://github.com/immortalwrt/luci" "master"

# wechatpush
SVN_PACKAGE "applications/luci-app-wechatpush" "https://github.com/0118Add/luci-immortalwrt" "master"

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's#net.netfilter.nf_conntrack_max=16384#net.netfilter.nf_conntrack_max=65535#g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# R8168驱动
git clone -b master --depth 1 https://github.com/BROBIRD/openwrt-r8168.git package/new/r8168
# R8152驱动
SVN_PACKAGE "r8152" "https://github.com/0118Add/openwrt-packages" "master"
# r8125驱动
SVN_PACKAGE "r8125" "https://github.com/0118Add/openwrt-packages" "master"

#sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/new/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
#sed -i 's/Frp 内网穿透/内网穿透/g' package/new/luci-app-frpc/po/zh-cn/frp.po
#sed -i 's/解除网易云音乐播放限制/音乐解锁/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
#sed -i 's/UPnP/UPnP设置/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po

# 修改系统文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# 替换文件
#wget -O ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js
