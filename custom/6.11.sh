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

# golang 1.23
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# node - prebuilt
# rm -rf feeds/packages/lang/node
# git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# 移除 SNAPSHOT 标签
#sed -i 's,-SNAPSHOT,,g' include/version.mk
#sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

# 更改固件版本信息
#sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION=''|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt %V'|g" package/base-files/files/etc/openwrt_release

# 替换banner
wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/banner

# alist
#git clone https://github.com/sbwml/luci-app-alist package/alist

# Default settings
git clone https://github.com/sbwml/default-settings package/default-settings

# autoCore
merge_package https://github.com/0118Add/openwrt-packages openwrt-packages/autocore-arm

# DDNS GO
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# OpenClash
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash package/OpenClash

# Daed
#git clone https://github.com/QiuSimons/luci-app-daed-next package/new/luci-app-daed-next
#git clone https://github.com/QiuSimons/luci-app-daed package/luci-app-daed

# Dae
#git clone https://github.com/8688Add/luci-app-dae package/luci-app-dae

# Shared for PassWall and ShadowsocksR Plus+
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/helloworld -b v5
rm -rf package/helloworld/{luci-app-ssr-plus,luci-app-homeproxy,luci-app-passwall}
git clone -b luci-smartdns-dev --single-branch https://github.com/lwb1978/openwrt-passwall package/passwall-luci

# SmartDNS zerotier
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/net/zerotier

# homeproxy
git clone --depth 1 -b test https://github.com/m0eak/homeproxy package/homeproxy
rm -rf package/homeproxy/{chinadns-ng,sing-box}
#git clone https://github.com/immortalwrt/homeproxy package/homeproxy
sed -i "s/ImmortalWrt/OpenWrt/g" package/homeproxy/po/zh_Hans/homeproxy.po
sed -i "s/ImmortalWrt proxy/OpenWrt proxy/g" package/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

# neko
git clone -b neko --depth 1 https://github.com/Thaolga/luci-app-nekoclash package/nekoclash

# mihomo
git clone https://github.com/morytyann/OpenWrt-mihomo  package/openwrt-mihomo

# custom packages
rm -rf feeds/packages/utils/coremark
merge_package https://github.com/8688Add/openwrt_pkgs openwrt_pkgs/coremark

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

# zerotier
merge_package https://github.com/8688Add/openwrt_pkgs openwrt_pkgs/luci-app-zerotier

# AutoCore
#rm -rf feeds/packages/utils/coremark
#merge_package https://github.com/immortalwrt/packages packages/utils/coremark
#merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/emortal/autocore
#merge_package https://github.com/immortalwrt/immortalwrt immortalwrt/package/utils/mhz
#rm -rf feeds/luci/modules/luci-base
#rm -rf feeds/luci/modules/luci-mod-status
# 克隆immortalwrt-luci仓库
git clone --depth=1 -b master https://github.com/immortalwrt/luci.git immortalwrt-luci
#cp -rf immortalwrt-luci/modules/luci-base feeds/luci/modules/luci-base
#cp -rf immortalwrt-luci/modules/luci-mod-status feeds/luci/modules/luci-mod-status
cp -rf immortalwrt-luci/applications/luci-app-smartdns feeds/luci/applications/luci-app-smartdns
ln -sf ../../../feeds/luci/applications/luci-app-smartdns ./package/feeds/luci/luci-app-smartdns
# 克隆immortalwrt-packages仓库
git clone --depth=1 -b master https://github.com/immortalwrt/packages.git immortalwrt-packages
#cp -rf immortalwrt-packages/utils/coremark feeds/packages/utils/coremark
cp -rf immortalwrt-packages/net/smartdns feeds/packages/net/smartdns
ln -sf ../../../feeds/packages/net/smartdns ./package/feeds/packages/smartdns
cp -rf immortalwrt-packages/net/zerotier feeds/packages/net/zerotier
ln -sf ../../../feeds/packages/net/zerotier ./package/feeds/packages/zerotier

# unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/音乐云解锁/g' package/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# wechatpush
# merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-wechatpush
# merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/wrtbwmon

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 修复编译时提示 freeswitch 缺少 libpcre 依赖
sed -i 's/+libpcre \\$/+libpcre2 \\/g' package/feeds/telephony/freeswitch/Makefile

# 修改系统文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/25_storage.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/25_storage.js
sed -i 's/WireGuard/WiGd状态/g' feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/luci-proto-wireguard.json
rm -rf feeds/packages/lang/ruby
cp -rf $GITHUB_WORKSPACE/general/ruby feeds/packages/lang/ruby

# comment out the following line to restore the full description
#sed -i '/# timezone/i grep -q '\''/tmp/sysinfo/model'\'' /etc/rc.local || sudo sed -i '\''/exit 0/i [ "$(cat /sys\\/class\\/dmi\\/id\\/sys_vendor 2>\\/dev\\/null)" = "Default string" ] \&\& echo "x86_64" > \\/tmp\\/sysinfo\\/model'\'' /etc/rc.local\n' package/default-settings/default/zzz-default-settings
sed -i '/# timezone/i sed -i "s/\\(DISTRIB_DESCRIPTION=\\).*/\\1'\''OpenWrt $(sed -n "s/DISTRIB_DESCRIPTION='\''OpenWrt \\([^ ]*\\) .*/\\1/p" /etc/openwrt_release)'\'',/" /etc/openwrt_release\nsource /etc/openwrt_release \&\& sed -i -e "s/distversion\\s=\\s\\".*\\"/distversion = \\"$DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_REVISION)\\"/g" -e '\''s/distname    = .*$/distname    = ""/g'\'' /usr/lib/lua/luci/version.lua\nsed -i "s/luciname    = \\".*\\"/luciname    = \\"LuCI openwrt-23.05\\"/g" /usr/lib/lua/luci/version.lua\nsed -i "s/luciversion = \\".*\\"/luciversion = \\"v'$(date +%Y%m%d)'\\"/g" /usr/lib/lua/luci/version.lua\necho "export const revision = '\''v'$(date +%Y%m%d)'\'\'', branch = '\''LuCI Master'\'';" > /usr/share/ucode/luci/version.uc\n/etc/init.d/rpcd restart\n' package/default-settings/default/zzz-default-settings

# Shortcut Forwarding Engine
git clone https://$gitea/sbwml/shortcut-fe package/new/shortcut-fe

# firewall4 - master
grm -rf package/network/config/firewall4
gcp -a ../master/openwrt/package/network/config/firewall4 package/network/config/firewall4
gsed -i 's|$(PROJECT_GIT)/project|https://github.com/openwrt|g' package/network/config/firewall4/Makefile
mkdir -p package/network/config/firewall4/patches
# fix ct status dnat
curl -s https://$mirror/patch/firewall4/firewall4_patches/990-unconditionally-allow-ct-status-dnat.patch > package/network/config/firewall4/patches/990-unconditionally-allow-ct-status-dnat.patch
# fullcone
curl -s https://$mirror/patch/firewall4/firewall4_patches/999-01-firewall4-add-fullcone-support.patch > package/network/config/firewall4/patches/999-01-firewall4-add-fullcone-support.patch
# bcm fullcone
curl -s https://$mirror/patch/firewall4/firewall4_patches/999-02-firewall4-add-bcm-fullconenat-support.patch > package/network/config/firewall4/patches/999-02-firewall4-add-bcm-fullconenat-support.patch
# kernel version
curl -s https://$mirror/patch/firewall4/firewall4_patches/002-fix-fw4.uc-adept-kernel-version-type-of-x.x.patch > package/network/config/firewall4/patches/002-fix-fw4.uc-adept-kernel-version-type-of-x.x.patch
# fix flow offload
curl -s https://$mirror/patch/firewall4/firewall4_patches/001-fix-fw4-flow-offload.patch > package/network/config/firewall4/patches/001-fix-fw4-flow-offload.patch
# add custom nft command support
curl -s https://$mirror/patch/firewall4/100-openwrt-firewall4-add-custom-nft-command-support.patch | patch -p1
# libnftnl
grm -rf package/libs/libnftnl
gcp -a ../master/openwrt/package/libs/libnftnl package/libs/libnftnl
mkdir -p package/libs/libnftnl/patches
curl -s https://$mirror/patch/firewall4/libnftnl/001-libnftnl-add-fullcone-expression-support.patch > package/libs/libnftnl/patches/001-libnftnl-add-fullcone-expression-support.patch
curl -s https://$mirror/patch/firewall4/libnftnl/002-libnftnl-add-brcm-fullcone-support.patch > package/libs/libnftnl/patches/002-libnftnl-add-brcm-fullcone-support.patch
sed -i '/PKG_INSTALL:=1/iPKG_FIXUP:=autoreconf' package/libs/libnftnl/Makefile
# nftables
grm -rf package/network/utils/nftables
gcp -a ../master/openwrt/package/network/utils/nftables package/network/utils/nftables
mkdir -p package/network/utils/nftables/patches
curl -s https://$mirror/patch/firewall4/nftables/002-nftables-add-fullcone-expression-support.patch > package/network/utils/nftables/patches/002-nftables-add-fullcone-expression-support.patch
curl -s https://$mirror/patch/firewall4/nftables/003-nftables-add-brcm-fullconenat-support.patch > package/network/utils/nftables/patches/003-nftables-add-brcm-fullconenat-support.patch

# hide nftables warning message
curl -s https://$mirror/patch/luci/luci-nftables.patch | patch -p1

# FullCone module
git clone https://$gitea/sbwml/nft-fullcone package/new/nft-fullcone

# IPv6 NAT
git clone https://$github/sbwml/packages_new_nat6 package/new/nat6

# natflow
git clone https://$github/sbwml/package_new_natflow package/new/natflow

# Patch Luci add nft_fullcone/bcm_fullcone & shortcut-fe & natflow & ipv6-nat & custom nft command option
pushd feeds/luci
    curl -s https://$mirror/patch/firewall4/0001-luci-app-firewall-add-nft-fullcone-and-bcm-fullcone-.patch | patch -p1
    curl -s https://$mirror/patch/firewall4/0002-luci-app-firewall-add-shortcut-fe-option.patch | patch -p1
    curl -s https://$mirror/patch/firewall4/0003-luci-app-firewall-add-ipv6-nat-option.patch | patch -p1
    curl -s https://$mirror/patch/firewall4/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
    curl -s https://$mirror/patch/firewall4/0005-luci-app-firewall-add-natflow-offload-support.patch | patch -p1
popd
