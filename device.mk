#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/advan/macha5g

# Inherit generic ramdisk product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)


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
PRODUCT_EXTRA_VNDK_VERSIONS := 31 32

# Compatibility shims
PRODUCT_PACKAGES += \
    libbase_shim \
    libcrypto_shim \
    libdrm

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/mediatek

# KeyMint Trustonic HAL dependencies
PRODUCT_PACKAGES += \
    libcppbor_external \
    android.hardware.security.rkp-V3-ndk \
    android.hardware.security.keymint-V3-ndk \
    android.hardware.security.sharedsecret-V1-ndk \
    android.hardware.security.secureclock-V1-ndk

# HAL & VNDK Compat Packages
PRODUCT_PACKAGES += \
    android.hardware.light-V1-ndk \
    android.hardware.biometrics.fingerprint-V1-ndk.vendor \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth@1.1.vendor \
    android.hardware.boot@1.0.vendor \
    android.hardware.boot@1.1.vendor \
    android.hardware.boot@1.2.vendor \
    android.hardware.drm@1.0.vendor \
    android.hardware.drm@1.1.vendor \
    android.hardware.drm@1.2.vendor \
    android.hardware.drm@1.3.vendor \
    android.hardware.drm@1.4.vendor \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.gnss@1.0.vendor \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.0.vendor \
    android.hardware.gnss@2.1.vendor \
    android.hardware.graphics.composer@2.1.vendor \
    android.hardware.graphics.composer@2.2.vendor \
    android.hardware.graphics.composer@2.3.vendor \
    android.hardware.graphics.composer@2.1-resources.vendor \
    android.hardware.graphics.composer@2.2-resources.vendor \
    android.hardware.ir@1.0.vendor \
    android.hardware.media.c2@1.0.vendor \
    android.hardware.media.c2@1.1.vendor \
    android.hardware.media.c2@1.2.vendor \
    android.hardware.media.omx@1.0.vendor \
    android.hardware.nfc@1.0.vendor \
    android.hardware.nfc@1.1.vendor \
    android.hardware.nfc@1.2.vendor \
    android.hardware.power@1.0.vendor \
    android.hardware.power@1.1.vendor \
    android.hardware.power@1.2.vendor \
    android.hardware.secure_element@1.0.vendor \
    android.hardware.secure_element@1.1.vendor \
    android.hardware.secure_element@1.2.vendor \
    android.hardware.sensors@1.0.vendor \
    android.hardware.sensors@2.0.vendor \
    android.hardware.sensors@2.1.vendor \
    android.frameworks.sensorservice@1.0.vendor \
    android.hardware.audio@6.0.vendor \
    android.hardware.audio@7.0.vendor \
    android.hardware.audio.common@6.0.vendor \
    android.hardware.audio.common@7.0.vendor \
    android.hardware.audio.effect@6.0.vendor \
    android.hardware.audio.effect@7.0.vendor \
    android.hardware.bluetooth.audio@2.0.vendor \
    android.hardware.bluetooth.audio@2.1.vendor \
    android.hardware.soundtrigger@2.3.vendor \
    android.hardware.thermal@2.0.vendor \
    android.hardware.usb@1.0.vendor \
    android.hardware.radio@1.0.vendor \
    android.hardware.camera.provider@2.4.vendor \
    android.hardware.gnss-V1-ndk.vendor \
    android.hardware.vibrator-V2-ndk.vendor \
    android.hardware.power-V2-ndk.vendor \
    vendor.mediatek.hardware.mtkpower@1.0.vendor \
    vendor.mediatek.hardware.mtkpower@1.1.vendor \
    vendor.mediatek.hardware.mtkpower@1.2.vendor \
    android.hidl.allocator@1.0.vendor \
    libaudiofoundation.vendor \
    libcodec2_hidl@1.0.vendor \
    libcodec2_hidl@1.1.vendor \
    libcodec2_hidl@1.2.vendor \
    libcodec2_soft_common.vendor \
    libcodec2_hal_common.vendor \
    libstagefright_bufferpool@2.0.1.vendor \
    android.hardware.media.bufferpool2-V2-ndk.vendor \
    libstagefright_aidl_bufferpool2.vendor \
    android.hardware.media.c2-V1-ndk.vendor \
    libdmabufheap.vendor \
    libavservices_minijail_vendor \
    libavservices_minijail.vendor \
    android.hardware.audio.common@5.0.vendor \
    android.hardware.audio.common@7.0-enums.vendor \
    android.hardware.audio.common@7.0-util.vendor \
    android.hardware.audio@7.0-util.vendor \
    android.hardware.audio.effect@7.0-util.vendor \
    android.hardware.thermal@1.0.vendor \
    android.hardware.usb@1.1.vendor \
    android.hardware.usb@1.2.vendor \
    android.hardware.camera.provider@2.5.vendor \
    android.hardware.camera.provider@2.6.vendor \
    libhidltransport.vendor \
    libhwbinder.vendor \
    libeffectsconfig.vendor \
    android.hardware.usb@1.3.vendor \
    android.hardware.usb.gadget@1.0.vendor \
    android.hardware.usb.gadget@1.1.vendor \
    android.hardware.wifi@1.0.vendor \
    android.hardware.wifi@1.1.vendor \
    android.hardware.wifi@1.2.vendor \
    android.hardware.wifi@1.3.vendor \
    android.hardware.wifi@1.4.vendor \
    android.hardware.wifi@1.5.vendor \
    android.hardware.radio@1.1.vendor \
    android.hardware.radio@1.2.vendor \
    android.hardware.radio@1.3.vendor \
    android.hardware.radio@1.4.vendor \
    android.hardware.radio@1.5.vendor \
    android.hardware.radio.config@1.0.vendor \
    android.hardware.radio.config@1.1.vendor \
    android.hardware.radio.config@1.2.vendor \
    android.hardware.radio.deprecated@1.0.vendor \
    libprocessgroup_shim \
    libtinyxml2-v34 \
    libutils-v32 \
    libpcap.vendor \
    android.hardware.wifi.supplicant@1.0.vendor \
    android.hardware.wifi.supplicant@1.1.vendor \
    android.hardware.wifi.supplicant@1.2.vendor \
    android.hardware.wifi.supplicant@1.3.vendor \
    android.hardware.wifi.supplicant@1.4.vendor \
    android.system.wifi.keystore@1.0.vendor \
    android.system.keystore2-V1-ndk.vendor \
    android.hardware.security.keymint-V1-ndk.vendor







