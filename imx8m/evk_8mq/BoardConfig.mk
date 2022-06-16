# -------@block_infrastructure-------
#
# Product-specific compile-time definitions.
#

include $(CONFIG_REPO_PATH)/imx8m/BoardConfigCommon.mk

# -------@block_common_config-------
#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX8MQ
BOARD_HAVE_VPU := true
BOARD_VPU_TYPE := hantro
HAVE_FSL_IMX_GPU2D := false
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_PXP := false
TARGET_USES_HWC2 := true
TARGET_HAVE_VULKAN := true
ENABLE_SEC_DMABUF_HEAP := true
CFG_SECURE_IOCTRL_REGS := true

SOONG_CONFIG_IMXPLUGIN += \
                          BOARD_VPU_TYPE \
			  ENABLE_SEC_DMABUF_HEAP \
			  CFG_SECURE_IOCTRL_REGS

SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = IMX8MQ
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_VPU = true
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_TYPE = hantro
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_ONLY = false
SOONG_CONFIG_IMXPLUGIN_PREBUILT_FSL_IMX_CODEC = true
SOONG_CONFIG_IMXPLUGIN_POWERSAVE = false
SOONG_CONFIG_IMXPLUGIN_ENABLE_SEC_DMABUF_HEAP = true
SOONG_CONFIG_IMXPLUGIN_CFG_SECURE_IOCTRL_REGS = true

# -------@block_memory-------
USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# -------@block_storage-------
TARGET_USERIMAGES_USE_EXT4 := true

# use sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

# Support gpt
ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  BOARD_BPT_INPUT_FILES += $(CONFIG_REPO_PATH)/common/partition/device-partitions-13GB-ab_super.bpt
  ADDITION_BPT_PARTITION = partition-table-28GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-28GB-ab_super.bpt \
                           partition-table-dual:$(CONFIG_REPO_PATH)/common/partition/device-partitions-13GB-ab-dual-bootloader_super.bpt \
                           partition-table-28GB-dual:$(CONFIG_REPO_PATH)/common/partition/device-partitions-28GB-ab-dual-bootloader_super.bpt
else
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    BOARD_BPT_INPUT_FILES += $(CONFIG_REPO_PATH)/common/partition/device-partitions-13GB-ab-no-product.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-28GB-ab-no-product.bpt \
                             partition-table-dual:$(CONFIG_REPO_PATH)/common/partition/device-partitions-13GB-ab-dual-bootloader-no-product.bpt \
                             partition-table-28GB-dual:$(CONFIG_REPO_PATH)/common/partition/device-partitions-28GB-ab-dual-bootloader-no-product.bpt
  else
    BOARD_BPT_INPUT_FILES += $(CONFIG_REPO_PATH)/common/partition/device-partitions-13GB-ab.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:$(CONFIG_REPO_PATH)/common/partition/device-partitions-28GB-ab.bpt \
                             partition-table-dual:$(CONFIG_REPO_PATH)/common/partition/device-partitions-13GB-ab-dual-bootloader.bpt \
                             partition-table-28GB-dual:$(CONFIG_REPO_PATH)/common/partition/device-partitions-28GB-ab-dual-bootloader.bpt
  endif
endif

BOARD_PREBUILT_DTBOIMAGE := $(OUT_DIR)/target/product/$(PRODUCT_DEVICE)/dtbo-imx8mq.img

BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

AB_OTA_PARTITIONS += bootloader
PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_DEVICE)/obj/UBOOT_COLLECTION/bootloader-imx8mq-trusty-dual.img:bootloader.img

# -------@block_security-------
ENABLE_CFI=false

BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := $(CONFIG_REPO_PATH)/common/security/testkey_rsa4096.pem

BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# -------@block_treble-------
# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(IMX_DEVICE_PATH)/device_framework_matrix.xml

# -------@block_wifi-------
BOARD_WLAN_DEVICE            := nxp
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211
BOARD_HOSTAPD_PRIVATE_LIB           := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB    := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# -------@block_bluetooth-------
# NXP 8997 BT
BOARD_HAVE_BLUETOOTH_NXP := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

# -------@block_sensor-------
BOARD_USE_SENSOR_FUSION := true

# -------@block_kernel_bootimg-------
BOARD_KERNEL_BASE := 0x40400000

ifeq ($(PRODUCT_IMX_DRM),true)
CMASIZE=736M
else
CMASIZE=1280M
endif

# NXP default config
BOARD_KERNEL_CMDLINE := init=/init firmware_class.path=/vendor/firmware loop.max_part=7 bootconfig
BOARD_BOOTCONFIG += androidboot.console=ttymxc0 androidboot.hardware=nxp

# framebuffer config
BOARD_BOOTCONFIG += androidboot.fbTileSupport=enable

# memory config
BOARD_KERNEL_CMDLINE += transparent_hugepage=never cma=$(CMASIZE)

# display config
BOARD_BOOTCONFIG += androidboot.lcd_density=240 androidboot.primary_display=imx-dcss androidboot.gui_resolution=1080p

# wifi config
BOARD_BOOTCONFIG += androidboot.wificountrycode=CN
BOARD_KERNEL_CMDLINE += moal.mod_para=wifi_mod_para.conf pci=nomsi

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_BOOTCONFIG += androidboot.vendor.sysrq=1
endif

ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-no-product.dtb
  else
    ifeq ($(IMX8MQ_USES_GKI),true)
      # imx8mq gki with HDMI display
      TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-pcie1-m2-gki.dtb
      # imx8mq with MIPI-HDMI display
      TARGET_BOARD_DTS_CONFIG += imx8mq-mipi:imx8mq-evk-lcdif-adv7535-gki.dtb
      # imx8mq with HDMI and MIPI-HDMI display
      TARGET_BOARD_DTS_CONFIG += imx8mq-dual:imx8mq-evk-dual-display-gki.dtb
      # imx8mq with rm67199 MIPI panel display
      TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-panel:imx8mq-evk-dcss-rm67199-gki.dtb
      # imx8mq with rm67191 MIPI panel display
      TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-panel-rm67191:imx8mq-evk-dcss-rm67191-gki.dtb
    else
      # imx8mq with HDMI display
      TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-pcie1-m2.dtb
      # imx8mq with MIPI-HDMI display
      TARGET_BOARD_DTS_CONFIG += imx8mq-mipi:imx8mq-evk-lcdif-adv7535.dtb
      # imx8mq with HDMI and MIPI-HDMI display
      TARGET_BOARD_DTS_CONFIG += imx8mq-dual:imx8mq-evk-dual-display.dtb
      # imx8mq with rm67199 MIPI panel display
      TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-panel:imx8mq-evk-dcss-rm67199.dtb
      # imx8mq with rm67191 MIPI panel display
      TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-panel-rm67191:imx8mq-evk-dcss-rm67191.dtb
    endif
  endif
else # no dynamic parition feature
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-no-product-no-dynamic_partition.dtb
  else
	TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-no-dynamic_partition.dtb
  endif
endif

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)

# -------@block_sepolicy-------
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    $(CONFIG_REPO_PATH)/imx8m/system_ext_pri_sepolicy

BOARD_SEPOLICY_DIRS := \
       $(CONFIG_REPO_PATH)/imx8m/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_DRM),true)
BOARD_SEPOLICY_DIRS += \
       $(IMX_DEVICE_PATH)/sepolicy_drm
endif

ifeq ($(IMX8MQ_USES_GKI),true)
    BOARD_KERNEL_CMDLINE += cpuidle.off=1
endif
