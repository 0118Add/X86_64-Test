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

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

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
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-daed
git_sparse_clone master https://github.com/immortalwrt/packages net/daed
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/daed package/new/daed

# Dae
git_sparse_clone master https://github.com/immortalwrt/packages net/dae

# Shared for PassWall and ShadowsocksR Plus+
#svn export -q https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-passwall
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-passwall2
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages brook
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages dns2socks
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages ipt2socks
git_sparse_clone openwrt-21.02 https://github.com/immortalwrt/packages net/kcptun
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages hysteria
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages sing-box
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages chinadns-ng
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages trojan-go
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages trojan-plus
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages microsocks
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages pdnsd-alt
git_sparse_clone openwrt-21.02 https://github.com/immortalwrt/packages net/redsocks2
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages gn
git clone https://github.com/fw876/helloworld package/helloworld

# bypass
git_sparse_clone master https://github.com/xiaorouji/openwrt-passwall-packages lua-maxminddb

# vssr
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-vssr package/new/luci-app-vssr

# UPX 可执行软件压缩
git_sparse_clone 23.05 https://github.com/Lienol/openwrt tools/ucl
git_sparse_clone 23.05 https://github.com/Lienol/openwrt tools/upx
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile

# homeproxy
git clone https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy

# Release Ram
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-ramfree

# Scheduled Reboot
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-autoreboot

# frpc
#rm -rf feeds/luci/applications/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc feeds/luci/applications/luci-app-frpc
#ln -sf ../../../feeds/luci/applications/luci-app-frpc ./package/feeds/luci/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc package/new/luci-app-frpc 

# ttyd
#rm -rf feeds/luci/applications/luci-app-ttyd
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-ttyd

# vlmcsd
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-vlmcsd feeds/luci/applications/luci-app-vlmcsd
#ln -sf ../../../feeds/luci/applications/luci-app-vlmcsd ./package/feeds/luci/luci-app-vlmcsd
#svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/vlmcsd package/new/vlmcsd

# luci-app-firewall
#rm -rf feeds/luci/applications/luci-app-firewall
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-firewall feeds/luci/applications/luci-app-firewall
#ln -sf ../../../feeds/luci/applications/luci-app-firewall ./package/feeds/luci/luci-app-firewall

# Filetransfer
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-filetransfer
git_sparse_clone master https://github.com/immortalwrt/luci libs/luci-lib-fs

# AutoCore
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/emortal/autocore
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/utils/mhz


# default settings and translation
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/emortal/default-settings

# fullconenat
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat-nft package/new/fullconenat-nft
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat package/new/fullconenat-nft

# Zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
git_sparse_clone master https://github.com/0118Add/luci-immortalwrt applications/luci-app-zerotier

# unblockneteasemusic
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-unblockneteasemusic

# wechatpush
git_sparse_clone master https://github.com/0118Add/luci-immortalwrt applications/luci-app-wechatpush

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's#net.netfilter.nf_conntrack_max=16384#net.netfilter.nf_conntrack_max=65535#g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# R8168驱动
git clone -b master --depth 1 https://github.com/BROBIRD/openwrt-r8168.git package/new/r8168
# R8152驱动
git_sparse_clone master https://github.com/kiddin9/openwrt-packages r8152
# r8125驱动
git_sparse_clone master https://github.com/kiddin9/openwrt-packages r8125

#sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/new/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
#sed -i 's/Frp 内网穿透/内网穿透/g' package/new/luci-app-frpc/po/zh-cn/frp.po
#sed -i 's/解除网易云音乐播放限制/音乐解锁/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
#sed -i 's/UPnP/UPnP设置/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po

# 修改系统文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# 替换文件
#wget -O ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js
