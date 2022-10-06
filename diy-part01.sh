#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part01.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

git clone -b master --depth 1 --single-branch https://github.com/coolsnowwolf/lede lede
git clone -b master --single-branch https://github.com/immortalwrt/immortalwrt immortalwrt
git clone -b master --depth 1 --single-branch https://github.com/immortalwrt/packages immortalwrt-packages
git clone -b master --depth 1 --single-branch https://github.com/immortalwrt/luci immortalwrt-luci
