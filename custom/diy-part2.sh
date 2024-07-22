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
#rm -rf package/libs/mbedtls
#cp -rf $GITHUB_WORKSPACE/general/mbedtls package/libs/mbedtls

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

# 替换banner
wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/banner

# Default settings
git clone https://github.com/sbwml/default-settings package/default-settings

# autoCore
merge_package https://github.com/0118Add/openwrt-packages openwrt-packages/autocore-arm

# alist
#git clone https://github.com/sbwml/luci-app-alist package/alist

# DDNS GO
#git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/luci-app-openclash

# Daed
#git clone https://github.com/QiuSimons/luci-app-daed-next package/new/luci-app-daed-next
#git clone https://github.com/sbwml/luci-app-daed package/new/luci-app-daed

# Dae
#git clone https://github.com/8688Add/luci-app-dae package/luci-app-dae

# Shared for PassWall and ShadowsocksR Plus+
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/new/helloworld -b v5
rm -rf package/new/helloworld/{luci-app-ssr-plus,luci-app-passwall}
git clone -b luci-smartdns-dev --single-branch https://github.com/lwb1978/openwrt-passwall package/passwall-luci

# lua-maxminddb
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb

# homeproxy
git clone --depth=1 https://github.com/immortalwrt/homeproxy package/homeproxy
sed -i "s/ImmortalWrt/OpenWrt/g" package/homeproxy/po/zh_Hans/homeproxy.po
sed -i "s/ImmortalWrt proxy/OpenWrt proxy/g" package/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

# mihomo
#git clone https://github.com/morytyann/OpenWrt-mihomo  package/openwrt-mihomo
git clone https://github.com/morytyann/OpenWrt-mihomo  package/openwrt-mihomo
mkdir -p files/etc/mihomo/run/ui
curl -Lso files/etc/mihomo/run/Country.mmdb https://github.com/NobyDa/geoip/raw/release/Private-GeoIP-CN.mmdb
curl -Lso files/etc/mihomo/run/GeoIP.dat https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.dat
curl -Lso files/etc/mihomo/run/GeoSite.dat https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
curl -Lso metacubexd-gh-pages.tar.gz https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.tar.gz
tar zxf metacubexd-gh-pages.tar.gz
mv metacubexd-gh-pages files/etc/mihomo/run/ui/metacubexd

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

# SmartDNS zerotier
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/net/zerotier

# AutoCore
rm -rf feeds/packages/utils/coremark
#merge_package https://github.com/immortalwrt/packages packages/utils/coremark
merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/emortal/autocore
merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/utils/mhz
#rm -rf feeds/luci/modules/luci-base
#rm -rf feeds/luci/modules/luci-mod-status
# 克隆immortalwrt-luci仓库
git clone --depth=1 -b master https://github.com/immortalwrt/luci.git immortalwrt-luci
#cp -rf immortalwrt-luci/modules/luci-base feeds/luci/modules/luci-base
#cp -rf immortalwrt-luci/modules/luci-mod-status feeds/luci/modules/luci-mod-status
cp -rf immortalwrt-luci/applications/luci-app-alist feeds/luci/applications/luci-app-smartdns
ln -sf ../../../feeds/luci/applications/luci-app-alist ./package/feeds/luci/luci-app-smartdns
cp -rf immortalwrt-luci/applications/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
ln -sf ../../../feeds/luci/applications/luci-app-ddns-go ./package/feeds/luci/luci-app-ddns-go
#cp -rf immortalwrt-luci/applications/luci-app-daed feeds/luci/applications/luci-app-daed
#ln -sf ../../../feeds/luci/applications/luci-app-daed ./package/feeds/luci/luci-app-daed
# 克隆immortalwrt-packages仓库
git clone --depth=1 -b master https://github.com/immortalwrt/packages.git immortalwrt-packages
cp -rf immortalwrt-packages/utils/coremark feeds/packages/utils/coremark
cp -rf immortalwrt-packages/net/zerotier feeds/packages/net/zerotier
ln -sf ../../../feeds/packages/net/zerotier ./package/feeds/packages/zerotier
cp -rf immortalwrt-packages/net/ddns-go feeds/packages/net/ddns-go
ln -sf ../../../feeds/packages/net/ddns-go ./package/feeds/packages/ddns-go
cp -rf immortalwrt-packages/net/smartdns feeds/packages/net/smartdns
ln -sf ../../../feeds/packages/net/smartdns ./package/feeds/packages/smartdns
#cp -rf immortalwrt-packages/net/daed feeds/packages/net/daed
#ln -sf ../../../feeds/packages/net/daed ./package/feeds/packages/daed

# Zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
merge_package https://github.com/8688Add/openwrt_pkgs openwrt_pkgs/luci-app-zerotier
#sed -i 's/vpn/services/g' package/custom/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json

# unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# wechatpush
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-wechatpush
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/wrtbwmon

# turboacc
git clone https://github.com/chenmozhijin/turboacc package/new/luci-app-turboacc
git clone https://github.com/fullcone-nat-nftables/nft-fullcone package/new/nft-fullcone
#git clone --depth=1 -b package https://github.com/chenmozhijin/turboacc package/new/turboacc
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
sed -i 's/Turbo ACC 网络加速/网络加速/g' package/new/luci-app-turboacc/luci-app-turboacc/po/zh-cn/turboacc.po

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's#net.netfilter.nf_conntrack_max=16384#net.netfilter.nf_conntrack_max=65535#g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
git clone https://github.com/sbwml/package_kernel_r8168 package/kernel/r8168
git clone https://github.com/sbwml/package_kernel_r8152 package/kernel/r8152
git clone https://github.com/sbwml/package_kernel_r8101 package/kernel/r8101
git clone https://github.com/sbwml/package_kernel_r8125 package/kernel/r8125
git clone https://github.com/sbwml/package_kernel_r8126 package/kernel/r8126

# 替换文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/25_storage.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/25_storage.js
sed -i 's/WireGuard/WiGd状态/g' feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/luci-proto-wireguard.json
rm -rf feeds/packages/lang/ruby
cp -rf $GITHUB_WORKSPACE/general/ruby feeds/packages/lang/ruby

# comment out the following line to restore the full description
sed -i '/# timezone/i grep -q '\''/tmp/sysinfo/model'\'' /etc/rc.local || sudo sed -i '\''/exit 0/i [ "$(cat /sys\\/class\\/dmi\\/id\\/sys_vendor 2>\\/dev\\/null)" = "Default string" ] \&\& echo "x86_64" > \\/tmp\\/sysinfo\\/model'\'' /etc/rc.local\n' package/default-settings/default/zzz-default-settings
sed -i '/# timezone/i sed -i "s/\\(DISTRIB_DESCRIPTION=\\).*/\\1'\''OpenWrt $(sed -n "s/DISTRIB_DESCRIPTION='\''OpenWrt \\([^ ]*\\) .*/\\1/p" /etc/openwrt_release)'\'',/" /etc/openwrt_release\nsource /etc/openwrt_release \&\& sed -i -e "s/distversion\\s=\\s\\".*\\"/distversion = \\"$DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_REVISION)\\"/g" -e '\''s/distname    = .*$/distname    = ""/g'\'' /usr/lib/lua/luci/version.lua\nsed -i "s/luciname    = \\".*\\"/luciname    = \\"LuCI openwrt-23.05\\"/g" /usr/lib/lua/luci/version.lua\nsed -i "s/luciversion = \\".*\\"/luciversion = \\"v'$(date +%Y%m%d)'\\"/g" /usr/lib/lua/luci/version.lua\necho "export const revision = '\''v'$(date +%Y%m%d)'\'\'', branch = '\''LuCI Master'\'';" > /usr/share/ucode/luci/version.uc\n/etc/init.d/rpcd restart\n' package/default-settings/default/zzz-default-settings
