#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Disable legacy HIDL CAS HAL and vendor dumpsys before base_vendor.mk is included
TARGET_REQUIRES_HIDL_CAS_HAL := false
TARGET_EXCLUDE_DUMPSYS_VENDOR := true

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from macha5g device
$(call inherit-product, device/advan/macha5g/device.mk)

# Inherit proprietary vendor
$(call inherit-product, vendor/advan/macha5g/macha5g-vendor.mk)

# Force insecure ADB for recovery debugging
WITH_ADB_INSECURE := true

# Inherit some common SymbiotOS stuff.
$(call inherit-product, vendor/symbiot/config/common_full_phone.mk)

PRODUCT_NAME := symbiot_macha5g
PRODUCT_DEVICE := macha5g
PRODUCT_MANUFACTURER := ADVAN
PRODUCT_BRAND := ADVAN
PRODUCT_MODEL := S50

PRODUCT_GMS_CLIENTID_BASE := android-advan

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildFingerprint=ADVAN/ADVAN_MACHA/ADVAN_MACHA:15/AP3A.240905.015.A2/1772789785:user/release-keys \
    DeviceProduct=ADVAN_MACHA \
    SystemDevice=ADVAN_MACHA \
    SystemName=ADVAN_MACHA

# SymbiotOS: persempit PRODUCT_LOCALES (pola fogos 0293)
PRODUCT_LOCALES := en
