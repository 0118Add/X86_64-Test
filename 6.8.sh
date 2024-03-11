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

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# golang 1.22
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# 修改连接数
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# 修正连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/luci-app-openclash

# Dae
git clone https://github.com/8688Add/luci-app-dae package/luci-app-dae

# Shared for PassWall and ShadowsocksR Plus+
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/new/helloworld -b v5
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb

# Release Ram
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-ramfree

# Scheduled Reboot
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-autoreboot

# ttyd
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json

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
git clone --depth=1 -b master https://github.com/immortalwrt/luci.git immortalwrt-luci
cp -rf immortalwrt-luci/modules/luci-base feeds/luci/modules/luci-base
cp -rf immortalwrt-luci/modules/luci-mod-status feeds/luci/modules/luci-mod-status
cp -rf immortalwrt-luci/applications/luci-app-alist feeds/luci/applications/luci-app-alist
ln -sf ../../../feeds/luci/applications/luci-app-alist ./package/feeds/luci/luci-app-alist
cp -rf immortalwrt-luci/applications/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
ln -sf ../../../feeds/luci/applications/luci-app-ddns-go ./package/feeds/luci/luci-app-ddns-go
#cp -rf immortalwrt-luci/applications/luci-app-daed feeds/luci/applications/luci-app-daed
#ln -sf ../../../feeds/luci/applications/luci-app-daed ./package/feeds/luci/luci-app-daed
# 克隆immortalwrt-packages仓库
git clone --depth=1 -b master https://github.com/immortalwrt/packages.git immortalwrt-packages
cp -rf immortalwrt-packages/utils/coremark feeds/packages/utils/coremark
cp -rf immortalwrt-packages/net/alist feeds/packages/net/alist
ln -sf ../../../feeds/packages/net/alist ./package/feeds/packages/alist
cp -rf immortalwrt-packages/net/ddns-go feeds/packages/net/ddns-go
ln -sf ../../../feeds/packages/net/ddns-go ./package/feeds/packages/ddns-go
cp -rf immortalwrt-packages/net/dae feeds/packages/net/dae
ln -sf ../../../feeds/packages/net/dae ./package/feeds/packages/dae
#cp -rf immortalwrt-packages/net/daed feeds/packages/net/daed
#ln -sf ../../../feeds/packages/net/daed ./package/feeds/packages/daed

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

# R8168驱动
git clone -b master --depth 1 https://github.com/BROBIRD/openwrt-r8168.git package/r8168
# R8152驱动
merge_package https://github.com/0118Add/openwrt-packages openwrt-packages/r8152
# r8125驱动
merge_package https://github.com/0118Add/openwrt-packages openwrt-packages/r8125

# 修改系统文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/25_storage.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/25_storage.js
