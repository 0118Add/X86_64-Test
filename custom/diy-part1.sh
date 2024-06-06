#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#git_sparse_clone() {
#    branch="$1" rurl="$2" repodir="$3"
#    git clone -b $branch --depth=1 --filter=blob:none --sparse $rurl package/cache
#    git -C package/cache sparse-checkout set $repodir
#    mv -f package/cache/$repodir package
#    rm -rf package/cache
#}

#git_sparse_clone main https://github.com/linkease/nas-packages-luci.git luci/luci-app-ddnsto
#git_sparse_clone master https://github.com/linkease/nas-packages.git network/services/ddnsto
#git_sparse_clone main https://github.com/ophub/luci-app-amlogic.git luci-app-amlogic
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages.git luci-app-onliner
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages.git luci-app-turboacc
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages.git luci-app-control-timewol
#git_sparse_clone master https://github.com/lisaac/luci-app-dockerman.git applications/luci-app-dockerman
#git_sparse_clone master https://github.com/vernesong/OpenClash.git luci-app-openclash
