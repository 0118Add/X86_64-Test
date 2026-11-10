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

mirror="https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master"
github="github.com"
gitea="git.cooluc.com"

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 移除 SNAPSHOT 标签
#sed -i 's,-SNAPSHOT,,g' include/version.mk
#sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
#sed -i '/CONFIG_BUILDBOT/d' include/feeds.mk
#sed -i 's/;)\s*\\/; \\/' include/feeds.mk

# 修改连接数
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
# 修正连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 替换内核
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' target/linux/x86/Makefile

# 更改固件版本信息
#sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION=''|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt 23.05'|g" package/base-files/files/etc/openwrt_release
#sed -i "s|DISTRIB_DESCRIPTION='.*'|DISTRIB_DESCRIPTION='OpenWrt SNAPSHOT'|g" package/base-files/files/etc/openwrt_release

# 内核替换 kernel xxx
#sed -i 's/LINUX_KERNEL_HASH-5.15.139 = 9c68c10dfe18e59b892e940436dea6a18d167160d55e62563cf7282244d8044e/LINUX_KERNEL_HASH-5.15.138 = af84e54164e1c01f59764ba528448ed36b377d22aafbd81b4b0cf47792ef4aaa/g' ./include/kernel-5.15
#sed -i 's/LINUX_VERSION-5.15 = .139/LINUX_VERSION-5.15 = .138/g' ./include/kernel-5.15

# 替换banner
#wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/banner

# autoCore
#git clone https://github.com/8688Add/autocore package/autocore
git clone https://github.com/sbwml/autocore-arm -b openwrt-25.12 package/autocore
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > package/autocore/files/generic/10_system.js

# Default settings
merge_package https://github.com/8688Add/openwrt_pkgs openwrt_pkgs/default-settings

# golang 27.x
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 27.x feeds/packages/lang/golang

# 预编译 node
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node feeds/packages/lang/node -b packages-25.12

# OpenClash
git clone -b dev --depth 1 https://github.com/vernesong/OpenClash package/OpenClash

# Shared for PassWall and ShadowsocksR Plus+
rm -rf feeds/packages/net/{xray-core,sing-box,v2ray-geodata}
#git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages -b main
#git clone -b main --single-branch https://github.com/lwb1978/openwrt-passwall package/passwall-luci
merge_package https://github.com/Openwrt-Passwall/openwrt-passwall-packages openwrt-passwall-packages/sing-box
merge_package https://github.com/Openwrt-Passwall/openwrt-passwall-packages openwrt-passwall-packages/xray-core
merge_package https://github.com/Openwrt-Passwall/openwrt-passwall-packages openwrt-passwall-packages/v2ray-geodata

# homeproxy
#git clone --depth 1 -b master https://github.com/fun200/homeproxy_plus package/luci-app-homeproxy
git clone --depth 1 -b master https://github.com/sjnhnp/homeproxy package/luci-app-homeproxy
#merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/luci-app-homeproxy
#merge_package https://github.com/VIKINGYFY/packages packages/luci-app-homeproxy
#merge_package https://github.com/VIKINGYFY/packages packages/sing-box
sed -i "s/ImmortalWrt/OpenWrt/g" package/luci-app-homeproxy/po/zh_Hans/homeproxy.po
sed -i "s/ImmortalWrt proxy/OpenWrt proxy/g" package/luci-app-homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

# mihomo
#git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/OpenWrt-nikki
#git clone https://github.com/nikkinikki-org/OpenWrt-momo package/OpenWrt-momo

# dae daed
#git clone https://github.com/kenzok8/openwrt-daede package/daede
#git clone https://github.com/kenzok8/openwrt-clashoo package/clashoo
#git clone -b kix --depth 1 https://github.com/QiuSimons/luci-app-dae package/dae
#git clone https://github.com/ntbowen/luci-app-honk package/honk
git clone -b master --depth 1 https://github.com/QiuSimons/luci-app-honk package/honk
git clone https://github.com/QiuSimons/vmlinux-btf package/vmlinux-btf
#sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2026.06.14/g' package/daed/daed/Makefile
#sed -i 's/DAED_VERSION:=.*/DAED_VERSION:=daed-4d6a433/g' package/daed/daed/Makefile
#sed -i 's/WING_VERSION:=.*/WING_VERSION:=wing-dc50308/g' package/daed/daed/Makefile
#sed -i 's/CORE_VERSION:=.*/CORE_VERSION:=core-5a51cc7/g' package/daed/daed/Makefile
#sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=4d6a43331f2f6e25961935b9e7ac09a7568bb2b4/g' package/daed/daed/Makefile

# ttyd
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# partexp
git clone https://github.com/sirpdboy/luci-app-partexp package/luci-app-partexp

# luci-app-filemanager
rm -rf feeds/luci/applications/luci-app-filemanager
git clone https://github.com/sbwml/luci-app-filemanager package/luci-app-filemanager

# tailscale
#git clone https://github.com/Jaykwok2999/luci-app-tailscale  package/luci-app-tailscale
#sed -i 's/vpn/services/g' package/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale.json

# zerotier
rm -rf feeds/packages/utils/coremark
rm -rf feeds/luci/applications/luci-app-mjpg-streamer
rm -rf feeds/luci/applications/luci-app-zerotier
git clone https://github.com/8688Add/luci-app-zerotier package/luci-app-zerotier
merge_package https://github.com/8688Add/openwrt_pkgs openwrt_pkgs/coremark
sed -i 's/vpn/services/g' package/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json

# unblockneteasemusic
#git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
#sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# 克隆lean仓库
#git clone --depth=1 -b master https://github.com/coolsnowwolf/lede lean
#cp -rf lean/package/kernel/r8152 package/kernel/r8152
#ln -sf ../../../package/kernel/r8152 ./package/kernel/r8152
#merge_package https://github.com/coolsnowwolf/lede lede/package/kernel/r8152

# 克隆immortalwrt-luci packages仓库
git clone --depth=1 -b openwrt-25.12 https://github.com/immortalwrt/luci.git immortalwrt-luci
cp -rf immortalwrt-luci/applications/luci-app-diskman feeds/luci/applications/luci-app-diskman
ln -sf ../../../feeds/luci/applications/luci-app-diskman ./package/feeds/luci/luci-app-diskman
#cp -rf immortalwrt-luci/applications/luci-app-homeproxy feeds/luci/applications/luci-app-homeproxy
#ln -sf ../../../feeds/luci/applications/luci-app-homeproxy ./package/feeds/luci/luci-app-homeproxy
cp -rf immortalwrt-luci/applications/luci-app-msd_lite feeds/luci/applications/luci-app-msd_lite
ln -sf ../../../feeds/luci/applications/luci-app-msd_lite ./package/feeds/luci/luci-app-msd_lite
cp -rf immortalwrt-luci/applications/luci-app-ramfree feeds/luci/applications/luci-app-ramfree
ln -sf ../../../feeds/luci/applications/luci-app-ramfree ./package/feeds/luci/luci-app-ramfree
cp -rf immortalwrt-luci/applications/luci-app-unblockneteasemusic feeds/luci/applications/luci-app-unblockneteasemusic
ln -sf ../../../feeds/luci/applications/luci-app-unblockneteasemusic ./package/feeds/luci/luci-app-unblockneteasemusic
git clone --depth=1 -b openwrt-25.12 https://github.com/immortalwrt/packages.git immortalwrt-packages
cp -rf immortalwrt-packages/net/msd_lite feeds/packages/net/msd_lite
ln -sf ../../../feeds/packages/net/msd_lite ./package/feeds/packages/msd_lite
#cp -rf immortalwrt-packages/net/sing-box feeds/packages/net/sing-box
#ln -sf ../../../feeds/packages/net/sing-box ./package/feeds/packages/sing-box
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
#sed -i "s/ImmortalWrt/OpenWrt/g" feeds/luci/applications/luci-app-homeproxy/po/zh_Hans/homeproxy.po
#sed -i "s/ImmortalWrt proxy/OpenWrt proxy/g" feeds/luci/applications/luci-app-homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

# Dockerman
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://github.com/sbwml/luci-app-dockerman feeds/luci/applications/luci-app-dockerman
#rm -rf feeds/packages/utils/{docker,dockerd,containerd,runc}
#git clone https://github.com/sbwml/packages_utils_docker feeds/packages/utils/docker
#git clone https://github.com/sbwml/packages_utils_dockerd feeds/packages/utils/dockerd
#git clone https://github.com/sbwml/packages_utils_containerd feeds/packages/utils/containerd
#git clone https://github.com/sbwml/packages_utils_runc feeds/packages/utils/runc
sed -i 's/"admin/"admin\/services/g' feeds/luci/applications/luci-app-dockerman/root/usr/share/luci/menu.d/luci-app-dockerman.json
#sed -i 's/"admin",/"admin","services",/g' package/dockerman/applications/luci-app-dockerman/luasrc/controller/*.lua
#sed -i 's/"admin/"admin\/services/g' package/dockerman/applications/luci-app-dockerman/luasrc/model/*.lua
#sed -i 's/"admin/"admin\/services/g' package/dockerman/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
#sed -i 's/"admin/"admin\/services/g' package/dockerman/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
#sed -i 's/"admin/"admin\/services/g' package/dockerman/applications/luci-app-dockerman/luasrc/view/dockerman/cbi/*.htm

# turboacc
#git clone https://github.com/chenmozhijin/turboacc package/turboacc
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/main/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
sed -i '/PKG_INSTALL:=/iPKG_FIXUP:=autoreconf' package/libs/libnftnl/Makefile
#curl -sSL https://raw.githubusercontent.com/mufeng05/openwrt-sonic-fullcone/master/add_sonic_fullcone.sh -o add_sonic_fullcone.sh && bash add_sonic_fullcone.sh
curl -sSL https://raw.githubusercontent.com/mufeng05/turboacc/main/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
sed -i 's/Turbo ACC 网络加速/网络加速/g' package/turboacc/luci-app-turboacc/po/zh_Hans/turboacc.po

# 移除luci-app-attendedsysupgrade
sed -i '18d' feeds/luci/collections/luci-nginx/Makefile
sed -i '17d' feeds/luci/collections/luci/Makefile
sed -i '16s/ \\$//' feeds/luci/collections/luci/Makefile

# 替换文件
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/10_system.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/general/25_storage.js > ./feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/25_storage.js
curl -fsSL https://raw.githubusercontent.com/immortalwrt/luci/master/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js > ./package/autocore/files/generic/29_ports.js
#sed -i 's/WireGuard/WiGd状态/g' feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/luci-proto-wireguard.json
#rm -rf feeds/packages/net/onionshare-cli
rm -rf feeds/luci/applications/luci-app-advanced-reboot

# rust
#wget https://github.com/rust-lang/rust/commit/cdae267.patch -O feeds/packages/lang/rust/patches/cdae267.patch
#sed -i 's/--set=llvm\.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' feeds/packages/lang/rust/Makefile

# comment out the following line to restore the full description
#sed -i '/# timezone/i grep -q '\''/tmp/sysinfo/model'\'' /etc/rc.local || sudo sed -i '\''/exit 0/i [ "$(cat /sys\\/class\\/dmi\\/id\\/sys_vendor 2>\\/dev\\/null)" = "Default string" ] \&\& echo "x86_64" > \\/tmp\\/sysinfo\\/model'\'' /etc/rc.local\n' package/default-settings/default/zzz-default-settings
#sed -i '/# timezone/i sed -i "s/\\(DISTRIB_DESCRIPTION=\\).*/\\1'\''OpenWrt $(sed -n "s/DISTRIB_DESCRIPTION='\''OpenWrt \\([^ ]*\\) .*/\\1/p" /etc/openwrt_release)'\'',/" /etc/openwrt_release\nsource /etc/openwrt_release \&\& sed -i -e "s/distversion\\s=\\s\\".*\\"/distversion = \\"$DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_REVISION)\\"/g" -e '\''s/distname    = .*$/distname    = ""/g'\'' /usr/lib/lua/luci/version.lua\nsed -i "s/luciname    = \\".*\\"/luciname    = \\"LuCI openwrt-25.12\\"/g" /usr/lib/lua/luci/version.lua\nsed -i "s/luciversion = \\".*\\"/luciversion = \\"\\"/g" /usr/lib/lua/luci/version.lua\necho "export const revision = '\''\'\'', branch = '\''LuCI openwrt-25.12'\'';" > /usr/share/ucode/luci/version.uc\n/etc/init.d/rpcd restart\n' package/default-settings/default/zzz-default-settings
#sed -i '/# timezone/i sed -i "s/\\(DISTRIB_DESCRIPTION=\\).*/\\1'\''OpenWrt $(sed -n "s/DISTRIB_DESCRIPTION='\''OpenWrt \\([^ ]*\\) .*/\\1/p" /etc/openwrt_release)'\'',/" /etc/openwrt_release\nsource /etc/openwrt_release \&\& sed -i -e "s/distversion\\s=\\s\\".*\\"/distversion = \\"$DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_REVISION)\\"/g" -e '\''s/distname    = .*$/distname    = ""/g'\'' /usr/lib/lua/luci/version.lua\nsed -i "s/luciname    = \\".*\\"/luciname    = \\"LuCI openwrt-24.10\\"/g" /usr/lib/lua/luci/version.lua\nsed -i "s/luciversion = \\".*\\"/luciversion = \\"v'$(date +%Y%m%d)'\\"/g" /usr/lib/lua/luci/version.lua\necho "export const revision = '\''v'$(date +%Y%m%d)'\'\'', branch = '\''LuCI openwrt-24.10'\'';" > /usr/share/ucode/luci/version.uc\n/etc/init.d/rpcd restart\n' package/default-settings/default/zzz-default-settings
#curl -fsSL https://raw.githubusercontent.com/0118Add/X86_64-Test/main/patch/release-os > package/base-files/files/etc/os-release

export GOTOOLCHAIN=auto
export GOPROXY=https://proxy.golang.org,direct

echo "🔍 正在全盘扫描并解锁 Go 工具链限制..."
find . -type f -name "*.mk" -exec grep -l "GOTOOLCHAIN=local" {} + | xargs -r sed -i 's/GOTOOLCHAIN=local/GOTOOLCHAIN=auto/g'
echo "✅ 所有潜在的 Go 工具链限制已动态解除"
    
# --- 整合 luci-app-honk 的宿主机编译环境依赖 ---
echo "🔧 正在搜索并配置 luci-app-honk 所需的宿主机工具链..."
        
# 1. 安装 Rust 环境并直接设置为最新稳定版 (stable)
if ! command -v rustup &> /dev/null; then
    # 使用 --default-toolchain stable 自动获取并安装最新稳定版
    curl --retry 3 --retry-delay 2 --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal --no-modify-path
else
    # 如果环境已存在 rustup，则更新并切换到 stable
    rustup update stable
    rustup default stable
fi
export PATH="$HOME/.cargo/bin:$PATH"
        
# 验证当前的 Rust 版本，确保其满足构建要求
rustc --version

# 2. 限定在 package 和 feeds 目录下快速精准搜索 honk_toolchain.sh
HONK_TOOLCHAIN_PATH=""
for candidate in \
    "package/luci-app-honk/honk/honk_toolchain.sh" \
    "package/luci-app-honk/honk_toolchain.sh" \
    "feeds/luci/applications/luci-app-honk/honk/honk_toolchain.sh" \
    "feeds/luci/applications/luci-app-honk/honk_toolchain.sh"; do
    if [ -f "$candidate" ]; then
    HONK_TOOLCHAIN_PATH="$candidate"
    break
    fi
done
        
# 如果预置路径未命中，仅在 package 目录下浅层查找，绝不进行全盘耗时扫描
if [ -z "$HONK_TOOLCHAIN_PATH" ] && [ -d "package" ]; then
    HONK_TOOLCHAIN_PATH=$(find package -maxdepth 4 -type f -name "honk_toolchain.sh" | head -n 1)
fi
        
# 3. 如果找到了脚本，则自动执行并安装依赖
if [ -n "$HONK_TOOLCHAIN_PATH" ] && [ -f "$HONK_TOOLCHAIN_PATH" ]; then
    HONK_DIR=$(dirname "$HONK_TOOLCHAIN_PATH")
    echo "✅ 成功找到 honk 工具链脚本: $HONK_TOOLCHAIN_PATH (所在目录: $HONK_DIR)"
          
    # 执行解析脚本获取版本号
    eval "$(bash "$HONK_TOOLCHAIN_PATH")"
          
    # 安装 bpf-linker
    echo "📦 正在安装 bpf-linker v${BPF_LINKER_VERSION}..."
    curl --retry 3 --retry-delay 2 -fsSL -o /tmp/bpf-linker.tar.zst "https://github.com/aya-rs/bpf-linker/releases/download/v${BPF_LINKER_VERSION}/bpf-linker-x86_64-unknown-linux-musl.tar.zst"
    echo "${BPF_LINKER_SHA256}  /tmp/bpf-linker.tar.zst" | sha256sum -c -
    sudo tar --zstd -xf /tmp/bpf-linker.tar.zst -C /usr/local/bin
          
    # 安装 Zig 编译器
    echo "📦 正在安装 Zig v${ZIG_VERSION}..."
    curl --retry 3 --retry-delay 2 -fsSL -o /tmp/zig.tar.xz "https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz"
    sudo tar -xJf /tmp/zig.tar.xz -C /usr/local
    sudo ln -sf "/usr/local/zig-x86_64-linux-${ZIG_VERSION}/zig" /usr/local/bin/zig
    echo "✅ honk 专用宿主机工具链安装完成！"
else
    echo "⚠️ 指定目录未检测到 honk_toolchain.sh 脚本，跳过专用工具链安装。"
fi
# ---------------------------------------------

./scripts/feeds update -i
./scripts/feeds install -a
