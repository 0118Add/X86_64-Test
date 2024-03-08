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

echo "开始 DIY2 配置……"
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
rm -rf package/feeds/luci/luci-app-apinger

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

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
#git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/luci-app-openclash

# Daed
#svn export -q https://github.com/0118Add/luci-immortalwrt/branches/openwrt-23.05/applications/luci-app-daed feeds/luci/applications/luci-app-daed
#ln -sf ../../../feeds/luci/applications/luci-app-daed ./package/feeds/luci/luci-app-daed
#svn export -q https://github.com/0118Add/openwrt-packages/trunk/daed package/new/daed
#git clone https://github.com/sbwml/luci-app-daed-next package/new/luci-app-daed-next
#git clone https://github.com/sbwml/luci-app-daed package/new/luci-app-daed
# Dae
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/dae

# Shared for PassWall and ShadowsocksR Plus+
#merge_package https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-passwall
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-passwall2
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/brook
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/dns2socks
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/ipt2socks
merge_package https://github.com/immortalwrt/packages packages/net/kcptun
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/hysteria
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/sing-box
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/chinadns-ng
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/trojan-go
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/trojan-plus
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/microsocks
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/pdnsd-alt
merge_package https://github.com/immortalwrt/packages packages/net/redsocks2
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/gn
git clone https://github.com/fw876/helloworld package/helloworld

# bypass
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/new/luci-app-bypass

# vssr
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-vssr package/new/luci-app-vssr

# UPX 可执行软件压缩
#merge_package https://github.com/Lienol/openwrt openwrt/tools/ucl
#merge_package https://github.com/Lienol/openwrt openwrt/tools/upx
#sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
#sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile

# homeproxy
#git clone --depth=1 https://github.com/immortalwrt/homeproxy package/homeproxy
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-homeproxy

# Release Ram
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-ramfree

# Scheduled Reboot
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-autoreboot

# frpc
#rm -rf feeds/luci/applications/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc feeds/luci/applications/luci-app-frpc
#ln -sf ../../../feeds/luci/applications/luci-app-frpc ./package/feeds/luci/luci-app-frpc
#svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-frpc package/new/luci-app-frpc 

# ttyd
#rm -rf feeds/luci/applications/luci-app-ttyd
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-ttyd

# vlmcsd
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-vlmcsd feeds/luci/applications/luci-app-vlmcsd
#ln -sf ../../../feeds/luci/applications/luci-app-vlmcsd ./package/feeds/luci/luci-app-vlmcsd
#svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/vlmcsd package/new/vlmcsd

# luci-app-firewall
#rm -rf feeds/luci/applications/luci-app-firewall
#svn export -q https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-firewall feeds/luci/applications/luci-app-firewall
#ln -sf ../../../feeds/luci/applications/luci-app-firewall ./package/feeds/luci/luci-app-firewall

# Filetransfer
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-filetransfer
merge_package https://github.com/immortalwrt/luci luci/libs/luci-lib-fs

# AutoCore
rm -rf feeds/packages/utils/coremark
#merge_package https://github.com/immortalwrt/packages packages/utils/coremark
merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/emortal/autocore
merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/utils/mhz
rm -rf feeds/luci/modules/luci-base
rm -rf feeds/luci/modules/luci-mod-status
# 克隆immortalwrt-luci仓库
git clone --depth=1 -b openwrt-23.05 https://github.com/immortalwrt/luci.git immortalwrt-luci
cp -rf immortalwrt-luci/modules/luci-base feeds/luci/modules/luci-base
cp -rf immortalwrt-luci/modules/luci-mod-status feeds/luci/modules/luci-mod-status
cp -rf immortalwrt-luci/applications/luci-app-alist feeds/luci/applications/luci-app-alist
ln -sf ../../../feeds/luci/applications/luci-app-alist ./package/feeds/luci/luci-app-alist
cp -rf immortalwrt-luci/applications/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
ln -sf ../../../feeds/luci/applications/luci-app-ddns-go ./package/feeds/luci/luci-app-ddns-go
#cp -rf immortalwrt-luci/applications/luci-app-daed feeds/luci/applications/luci-app-daed
#ln -sf ../../../feeds/luci/applications/luci-app-daed ./package/feeds/luci/luci-app-daed
# 克隆immortalwrt-packages仓库
git clone --depth=1 -b openwrt-23.05 https://github.com/immortalwrt/packages.git immortalwrt-packages
cp -rf immortalwrt-packages/utils/coremark feeds/packages/utils/coremark
cp -rf immortalwrt-packages/net/alist feeds/packages/net/alist
ln -sf ../../../feeds/packages/net/alist ./package/feeds/packages/alist
cp -rf immortalwrt-packages/net/ddns-go feeds/packages/net/ddns-go
ln -sf ../../../feeds/packages/net/ddns-go ./package/feeds/packages/ddns-go
cp -rf immortalwrt-packages/net/dae feeds/packages/net/dae
ln -sf ../../../feeds/packages/net/dae ./package/feeds/packages/dae
#cp -rf immortalwrt-packages/net/daed feeds/packages/net/daed
#ln -sf ../../../feeds/packages/net/daed ./package/feeds/packages/daed

# default settings and translation
#cp -rf $GITHUB_WORKSPACE/general/default-settings package/new/default-settings
#merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/emortal/default-settings

# fullconenat
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat-nft package/new/fullconenat-nft
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/network/utils/fullconenat package/new/fullconenat-nft

# Zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
#rm -rf feeds/packages/net/zerotier
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-zerotier
sed -i 's/vpn/services/g' package/custom/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json

# unblockneteasemusic
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-unblockneteasemusic
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/UnblockNeteaseMusic
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/custom/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# wechatpush
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-wechatpush
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/wrtbwmon

# turboacc
git clone https://github.com/chenmozhijin/turboacc package/new/luci-app-turboacc
git clone https://github.com/fullcone-nat-nftables/nft-fullcone package/new/nft-fullcone
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
sed -i 's/Turbo ACC 网络加速/网络加速/g' package/turboacc/luci-app-turboacc/po/zh-cn/turboacc.po

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's#net.netfilter.nf_conntrack_max=16384#net.netfilter.nf_conntrack_max=65535#g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# R8168驱动
git clone -b master --depth 1 https://github.com/BROBIRD/openwrt-r8168.git package/r8168
# R8152驱动
merge_package https://github.com/0118Add/openwrt-packages openwrt-packages/r8152
# r8125驱动
merge_package https://github.com/0118Add/openwrt-packages openwrt-packages/r8125

#sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/new/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
#sed -i 's/Frp 内网穿透/内网穿透/g' package/new/luci-app-frpc/po/zh-cn/frp.po
#sed -i 's/解除网易云音乐播放限制/音乐解锁/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
#sed -i 's/UPnP/UPnP设置/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po

# 修改系统文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/25_storage.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/25_storage.js

# 替换文件
#wget -O ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js
