#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/advan/macha5g

# Inherit generic ramdisk product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# GSI AVB keys (stock fstab references /avb/*-gsi.avbpubkey)
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Enable 64-bit for non-zygote.
ZYGOTE_FORCE_64 := true

# Screen
TARGET_SCREEN_DENSITY := 480

# Shipping API level (stock vendor BSP: API 31)
PRODUCT_SHIPPING_API_LEVEL := 31

# A/B
AB_OTA_UPDATER := true

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_RETROFIT_DYNAMIC_PARTITIONS := false

# Boot Control HAL
PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery \
    charger.recovery

# IMS
$(call inherit-product, vendor/mediatek/ims/ims.mk)

# Init
PRODUCT_PACKAGES += \
    fstab.mt6855 \
    fstab.mt6855.vendor_ramdisk \
    init.connectivity.rc \
    init.macha5g.rc \
    init.modem.rc \
    init.mt6855.rc \
    init.mt6855.usb.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.recovery.mt6855.rc \
    init.sensor_2_0.rc \
    ueventd.mt6855.rc

# Ensure first_stage_ramdisk fstab and recovery init rc match stock locations
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/init/fstab.mt6855:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6855 \
    $(DEVICE_PATH)/init/init.recovery.mt6855.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.mt6855.rc \
    $(DEVICE_PATH)/init/init.recovery.mt6855.rc:recovery/root/init.recovery.mt6855.rc \
    $(DEVICE_PATH)/init/mtk_plpath_utils:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/system/bin/mtk_plpath_utils \
    $(DEVICE_PATH)/init/mtk-plpath-utils.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/system/etc/init/mtk-plpath-utils.rc

# A/B update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PROPERTY_OVERRIDES += \
    ro.ota.allow_downgrade=true \
    persist.vendor.recovery_allow_spl_downgrade=1

# Dynamic partition support in recovery
PRODUCT_PACKAGES += \
    fastbootd

# VNDK legacy compat (Android 12 vendor blobs on Android 16 platform)
PRODUCT_PACKAGES += \
    vndservicemanager

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/mediatek
