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

# Modify default IP
#sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 修正连接数（by ベ七秒鱼ベ）
#sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# themes添加（svn co 命令意思：指定版本如https://github）
#git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
#git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
#git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
#git clone https://github.com/kiddin9/luci-app-dnsfilter.git package/luci-app-dnsfilter

#软件合集
#git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages
#git clone https://github.com/kiddin9/openwrt-packages.git package/openwrt-packages
#git clone https://github.com/sirpdboy/sirpdboy-package.git package/sirpdboy-package

#添加额外软件包
#git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
#git clone https://github.com/garypang13/luci-app-bypass package/luci-app-bypass
#git clone https://github.com/vernesong/OpenClash.git package/OpenClash
#git clone https://github.com/sirpdboy/luci-theme-opentopd.git package/luci-theme-opentopd
#git clone https://github.com/sirpdboy/luci-app-advanced.git package/luci-app-advanced
#git clone https://github.com/sirpdboy/netspeedtest.git package/netspeedtest
#git clone https://github.com/sirpdboy/luci-app-netdata.git package/luci-app-netdata
#git clone https://github.com/sirpdboy/luci-app-poweroffdevice.git package/luci-app-poweroffdevice
#git clone https://github.com/sirpdboy/luci-app-autotimeset.git package/luci-app-autotimeset

#git clone https://github.com/rufengsuixing/luci-app-zerotier.git package/luci-app-zerotier
#git clone https://github.com/rufengsuixing/luci-app-syncdial.git package/luci-app-syncdial
#git clone https://github.com/kiddin9/luci-app-xlnetacc.git package/luci-app-xlnetacc
#git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
#git clone https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot
#git clone https://github.com/riverscn/openwrt-iptvhelper.git package/openwrt-iptvhelper
#git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus

#添加smartdns
#git clone https://github.com/pymumu/openwrt-smartdns package/smartdns
#git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns








# OpenClash
svn export -q  https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/new/luci-app-openclash

# Shared for PassWall and ShadowsocksR Plus+
svn export -q https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/new/luci-app-ssr-plus
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/dns2socks package/new/dns2socks
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/dns2tcp package/new/dns2tcp
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/ipt2socks package/new/ipt2socks
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/kcptun package/new/kcptun
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/hysteria package/new/hysteria
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/microsocks package/new/microsocks
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/pdnsd-alt package/new/pdnsd-alt
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/redsocks2 package/new/redsocks2
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/sagernet-core package/new/sagernet-core
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/xray-plugin package/new/xray-plugin
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/shadowsocks-libev package/new/shadowsocks-libev
svn export -q https://github.com/fw876/helloworld/trunk/lua-neturl package/new/lua-neturl
svn export -q https://github.com/fw876/helloworld/trunk/naiveproxy package/new/naiveproxy
svn export -q https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/new/shadowsocks-rust
svn export -q https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/new/shadowsocksr-libev
svn export -q https://github.com/fw876/helloworld/trunk/simple-obfs package/new/simple-obfs
svn export -q https://github.com/fw876/helloworld/trunk/tcping package/new/tcping
svn export -q https://github.com/fw876/helloworld/trunk/trojan package/new/trojan
svn export -q https://github.com/fw876/helloworld/trunk/v2ray-core package/new/v2ray-core
svn export -q https://github.com/fw876/helloworld/trunk/v2ray-plugin package/new/v2ray-plugin
svn export -q https://github.com/fw876/helloworld/trunk/xray-core package/new/xray-core

# bypass
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/lua-maxminddb package/new/lua-maxminddb
svn export -q https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/new/luci-app-bypass

# upx & ucl
svn export -q https://github.com/coolsnowwolf/lede/trunk/tools/ucl tools/ucl
svn export -q https://github.com/coolsnowwolf/lede/trunk/tools/upx tools/upx
sed -i '/builddir dependencies/i\tools-y += ucl upx' tools/Makefile
sed -i '/builddir dependencies/a\$(curdir)/upx/compile := $(curdir)/ucl/compile' tools/Makefile

# vlmcsd
svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-vlmcsd feeds/luci/applications/luci-app-vlmcsd
ln -sf ../../../feeds/luci/applications/luci-app-vlmcsd ./package/feeds/luci/luci-app-vlmcsd
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/vlmcsd package/new/vlmcsd

# Filetransfer
svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-filetransfer feeds/luci/applications/luci-app-filetransfer
ln -sf ../../../feeds/luci/applications/luci-app-filetransfer ./package/feeds/luci/luci-app-filetransfer
svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/libs/luci-lib-fs feeds/luci/libs/luci-lib-fs
ln -sf ../../../feeds/luci/libs/luci-lib-fs ./package/feeds/luci/luci-lib-fs

# AutoCore
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/package/emortal/autocore package/new/autocore
svn export -q https://github.com/jinlife/OpenWrt-Autobuild/trunk/autocore package/new/autocore

# default settings and translation
#svn export -q https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/package/emortal/default-settings package/new/default-settings
svn export -q https://github.com/jinlife/OpenWrt-Autobuild/trunk/default-settings package/new/default-settings

# Zerotier
svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
ln -sf ../../../feeds/luci/applications/luci-app-zerotier ./package/feeds/luci/luci-app-zerotier
svn export -q https://github.com/immortalwrt/packages/branches/openwrt-21.02/net/zerotier package/new/zerotier

# unblockneteasemusic
svn export -q https://github.com/immortalwrt/luci/branches/openwrt-21.02/applications/luci-app-unblockneteasemusic feeds/luci/applications/luci-app-unblockneteasemusic
ln -sf ../../../feeds/luci/applications/luci-app-unblockneteasemusic ./package/feeds/luci/luci-app-unblockneteasemusic
