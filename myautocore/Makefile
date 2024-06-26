# 
# Copyright (C) 2010-2011 OpenWrt.org
#  2021-2022 by sirpdboy  (sirpdboy@qq.com)
#  2020  by lean
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=myautocore
PKG_VERSION:=2
PKG_RELEASE:=12

PKG_CONFIG_DEPENDS:= \
	CONFIG_TARGET_bcm27xx \
	CONFIG_TARGET_bcm53xx
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/target.mk

define Package/myautocore-arm
  TITLE:=Arm auto core loadbalance script.
  MAINTAINER:=CN_SZTL
  DEPENDS:=@(arm||aarch64||ramips) \
    +TARGET_bcm27xx:bcm27xx-userland \
    +TARGET_bcm53xx:nvram +ethtool
  VARIANT:=arm
endef

define Package/myautocore-x86
  TITLE:=x86/x64 auto core loadbalance script.
  MAINTAINER:=Lean
  DEPENDS:=@TARGET_x86 +bc +lm-sensors +ethtool
  VARIANT:=x86
endef

define Package/myautocore-arm/description
  A luci autoconfig hotplug script.
endef

define Package/myautocore-x86/description
  A usb autoconfig hotplug script.
endef

define Build/Compile
endef

define Package/myautocore-arm/install
	$(INSTALL_DIR) $(1)/etc/init.d/ $(1)/sbin $(1)/etc/uci-defaults $(1)/etc/
	$(INSTALL_BIN) ./files/generic/cntime $(1)/sbin/
	$(INSTALL_BIN) ./files/generic/cpuspeed $(1)/sbin/
	$(INSTALL_BIN) ./files/generic/ethinfo $(1)/sbin/

	$(INSTALL_DATA) ./files/arm/index.htm $(1)/etc/
	$(INSTALL_BIN) ./files/arm/090-cover-index_htm $(1)/etc/uci-defaults/
ifneq ($(filter ipq% %mt7622, $(TARGETID)),)
	$(INSTALL_BIN) ./files/arm/tempinfo $(1)/sbin/
endif
endef

define Package/myautocore-x86/install

	$(INSTALL_DIR) $(1)/etc/init.d/ $(1)/sbin

	$(INSTALL_BIN) ./files/x86/autocore $(1)/etc/init.d/
	$(INSTALL_DATA) ./files/x86/index.htm $(1)/etc/index.htm
	$(INSTALL_BIN) ./files/generic/cntime $(1)/sbin/
	$(INSTALL_BIN) ./files/generic/cpuspeed $(1)/sbin/
	$(INSTALL_BIN) ./files/generic/ethinfo $(1)/sbin/
	$(INSTALL_BIN) ./files/x86/tempinfo $(1)/sbin/
	$(INSTALL_BIN) ./files/x86/cpuinfo $(1)/sbin/
endef

$(eval $(call BuildPackage,myautocore-arm))
$(eval $(call BuildPackage,myautocore-x86))
