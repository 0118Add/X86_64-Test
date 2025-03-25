#!/bin/bash -e

# golang 1.24
rm -rf feeds/packages/lang/golang
git clone https://$github/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://$github/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node -b packages-24.10

# default settings
git clone https://$github/sbwml/default-settings package/default-settings -b openwrt-24.10

# 设置 root 用户密码为 password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# wwan
git clone https://github.com/sbwml/wwan-packages package/wwan

# pcre - 8.45
mkdir -p package/libs/pcre
curl -s $mirror/openwrt/patch/pcre/Makefile > package/libs/pcre/Makefile
curl -s $mirror/openwrt/patch/pcre/Config.in > package/libs/pcre/Config.in

# lrzsz - 0.12.20
rm -rf feeds/packages/utils/lrzsz
git clone https://$github/sbwml/packages_utils_lrzsz package/lrzsz

# irqbalance: disable build with numa
curl -s $mirror/openwrt/patch/irqbalance/011-meson-numa.patch > feeds/packages/utils/irqbalance/patches/011-meson-numa.patch
sed -i '/-Dcapng=disabled/i\\t-Dnuma=disabled \\' feeds/packages/utils/irqbalance/Makefile

# luci-app-filemanager
rm -rf feeds/luci/applications/luci-app-filemanager
git clone https://$github/sbwml/luci-app-filemanager package/luci-app-filemanager

# SSRP & Passwall
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://$github/sbwml/openwrt_helloworld package/helloworld -b v5

# immortalwrt homeproxy
git clone https://$github/immortalwrt/homeproxy package/homeproxy
sed -i "s/ImmortalWrt/OpenWrt/g" package/homeproxy/po/zh_Hans/homeproxy.po
sed -i "s/ImmortalWrt proxy/OpenWrt proxy/g" package/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

# unblockneteasemusic
git clone https://$github/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# Theme
git clone --depth=1 -b openwrt-24.10 https://github.com/sbwml/luci-theme-argon package/luci-theme-argon
sed -i 's/Argon 主题设置/主题设置/g' package/luci-theme-argon/luci-app-argon-config/po/zh_Hans/argon-config.po

# iperf3
sed -i "s/D_GNU_SOURCE/D_GNU_SOURCE -funroll-loops/g" feeds/packages/net/iperf3/Makefile

# custom packages
rm -rf feeds/packages/utils/coremark
rm -rf feeds/packages/net/zerotier
git clone https://$github/8688Add/openwrt_pkgs package/custom --depth=1
# coremark - prebuilt with gcc15
if [ "$platform" = "rk3568" ]; then
    curl -s https://$mirror/openwrt/patch/coremark/coremark.aarch64-4-threads > package/custom/coremark/src/musl/coremark.aarch64
elif [ "$platform" = "rk3399" ]; then
    curl -s https://$mirror/openwrt/patch/coremark/coremark.aarch64-6-threads > package/custom/coremark/src/musl/coremark.aarch64
elif [ "$platform" = "armv8" ]; then
    curl -s https://$mirror/openwrt/patch/coremark/coremark.aarch64-16-threads > package/custom/coremark/src/musl/coremark.aarch64
fi

# luci-compat - fix translation
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# unzip
rm -rf feeds/packages/utils/unzip
git clone https://$github/sbwml/feeds_packages_utils_unzip feeds/packages/utils/unzip

# tcp-brutal
git clone https://$github/sbwml/package_kernel_tcp-brutal package/kernel/tcp-brutal

# 克隆Lean-luci仓库
#git clone --depth=1 -b openwrt-23.05 https://github.com/coolsnowwolf/luci lean-luci
#cp -rf lean-luci/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
#ln -sf ../../../feeds/luci/applications/luci-app-zerotier ./package/feeds/luci/luci-app-zerotier
#sed -i 's/vpn/services/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json

# 克隆immortalwrt-luci仓库
git clone --depth=1 -b openwrt-24.10 https://github.com/immortalwrt/luci.git immortalwrt-luci
#cp -rf immortalwrt-luci/applications/luci-app-daed feeds/luci/applications/luci-app-daed
#ln -sf ../../../feeds/luci/applications/luci-app-daed ./package/feeds/luci/luci-app-daed
#cp -rf immortalwrt-luci/applications/luci-app-dockerman feeds/luci/applications/luci-app-dockerman
#ln -sf ../../../feeds/luci/applications/luci-app-dockerman ./package/feeds/luci/luci-app-dockerman
#cp -rf immortalwrt-luci/applications/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
#ln -sf ../../../feeds/luci/applications/luci-app-ddns-go ./package/feeds/luci/luci-app-ddns-go
cp -rf immortalwrt-luci/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
ln -sf ../../../feeds/luci/applications/luci-app-zerotier ./package/feeds/luci/luci-app-zerotier
# 克隆immortalwrt-packages仓库
git clone --depth=1 -b openwrt-24.10 https://github.com/immortalwrt/packages.git immortalwrt-packages
#cp -rf immortalwrt-packages/net/alist feeds/packages/net/alist
#ln -sf ../../../feeds/packages/net/alist ./package/feeds/packages/alist
#cp -rf immortalwrt-packages/net/ddns-go feeds/packages/net/ddns-go
#ln -sf ../../../feeds/packages/net/ddns-go ./package/feeds/packages/ddns-go
cp -rf immortalwrt-packages/net/dae feeds/packages/net/dae
ln -sf ../../../feeds/packages/net/dae ./package/feeds/packages/dae
#cp -rf immortalwrt-packages/net/daed feeds/packages/net/daed
#ln -sf ../../../feeds/packages/net/daed ./package/feeds/packages/daed
#cp -rf immortalwrt-packages/net/smartdns feeds/packages/net/smartdns
#ln -sf ../../../feeds/packages/net/smartdns ./package/feeds/packages/smartdns
cp -rf immortalwrt-packages/net/zerotier feeds/packages/net/zerotier
ln -sf ../../../feeds/packages/net/zerotier ./package/feeds/packages/zerotier

# net.netfilter.nf_conntrack_max from 16384 to 65535
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 调整Dockerman到服务菜单
sed -i 's/"admin",/"admin","services",/g' feeds/luci/applications/luci-app-dockerman/luasrc/controller/*.lua
sed -i 's/"admin/"admin\/services/g' feeds/luci/applications/luci-app-dockerman/luasrc/model/*.lua
sed -i 's/"admin/"admin\/services/g' feeds/luci/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
sed -i 's/"admin/"admin\/services/g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
sed -i 's/"admin/"admin\/services/g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/cbi/*.htm

# 修改系统文件
sed -i 's/WireGuard/WiGd状态/g' feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/luci-proto-wireguard.json
sed -i 's/vpn/services/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json
curl -fsSL https://raw.githubusercontent.com/0118Add/Cloudbuild/main/patches/29_ports.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js
