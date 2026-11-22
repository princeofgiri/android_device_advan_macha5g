#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import os
import sys

# Device tree lives outside the source tree (symlinked), so the relative
# PYTHONPATH from the shebang may not resolve; add the source tree fallback.
extract_utils_path = os.environ.get('EXTRACT_UTILS_PATH')
if not extract_utils_path:
    for cand in (
        '/home/haris/android-source/SymbiotOS/tools/extract-utils',
        os.path.realpath(os.path.join(os.getcwd(), '..', '..', '..', 'tools', 'extract-utils')),
    ):
        cand = os.path.realpath(cand)
        if os.path.isdir(cand):
            extract_utils_path = cand
            break
if extract_utils_path and extract_utils_path not in sys.path:
    sys.path.insert(0, extract_utils_path)

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/advan/macha5g',
    'hardware/mediatek',
    'hardware/mediatek/libmtkperf_client',
]

def lib_fixup_libvibrator(lib: str, partition: str, *args, **kwargs):
    # The platform only builds libvibrator for /system, so vendor blobs must
    # depend on the renamed blob module (same installed file name).
    return 'libvibrator_v31' if partition == 'vendor' else lib


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'libvibrator': lib_fixup_libvibrator,
}

blob_fixups: blob_fixups_user_type = {
    # Trustonic KeyMint: Android 12 (VNDK 31) blobs on Android 16 platform
    'vendor/bin/hw/android.hardware.security.keymint-service.trustonic': blob_fixup()
        .replace_needed('android.hardware.security.keymint-V1-ndk_platform.so', 'android.hardware.security.keymint-V3-ndk.so')
        .replace_needed('android.hardware.security.secureclock-V1-ndk_platform.so', 'android.hardware.security.secureclock-V1-ndk.so')
        .replace_needed('android.hardware.security.sharedsecret-V1-ndk_platform.so', 'android.hardware.security.sharedsecret-V1-ndk.so')
        .add_needed('android.hardware.security.rkp-V3-ndk.so'),
    # GNSS AIDL: ndk_platform no longer exists on Android 16
    ('vendor/bin/hw/android.hardware.gnss-service.mediatek', 'vendor/lib64/hw/android.hardware.gnss-impl-mediatek.so'): blob_fixup()
        .replace_needed('android.hardware.gnss-V1-ndk_platform.so', 'android.hardware.gnss-V1-ndk.so'),
    # Lights AIDL
    'vendor/bin/hw/android.hardware.lights-service.mediatek': blob_fixup()
        .replace_needed('android.hardware.light-V1-ndk_platform.so', 'android.hardware.light-V1-ndk.so'),
    # Memtrack AIDL
    'vendor/bin/hw/android.hardware.memtrack-service.mediatek': blob_fixup()
        .replace_needed('android.hardware.memtrack-V1-ndk_platform.so', 'android.hardware.memtrack-V1-ndk.so'),
    # Sensors Multihal: libbase WriteStringToFd symbol drift
    'vendor/bin/hw/android.hardware.sensors@2.0-service.multihal-mediatek': blob_fixup()
        .add_needed('libbase_shim.so'),
    # Libbase Basename/Dirname symbol drift (MTK bootctrl, nvram, sysenv, tflite)
    (
        'vendor/lib64/hw/android.hardware.boot@1.0-impl-1.2-mtkimpl.so',
        'vendor/lib/hw/android.hardware.boot@1.0-impl-1.2-mtkimpl.so',
        'vendor/lib64/libnvram.so',
        'vendor/lib/libnvram.so',
        'vendor/lib64/libsysenv.so',
        'vendor/lib/libsysenv.so',
        'vendor/lib64/libtflite_mtk.so',
        'vendor/lib/libtflite_mtk.so',
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
    # HWComposer MTK: SetTaskProfiles shim
    (
        'vendor/lib64/hw/hwcomposer.mtk_common.so',
        'vendor/lib64/hw/hwcomposer.mtk_fold.so',
    ): blob_fixup()
        .add_needed('libprocessgroup_shim.so'),
    # HWComposer service: use composer@2.1-resources-v34 to match prebuilt ABI
    (
        'vendor/bin/hw/android.hardware.graphics.composer@2.1-service',
        'vendor/bin/hw/android.hardware.graphics.composer@2.3-service',
        'vendor/bin/hw/android.hardware.graphics.composer@2.4-service',
    ): blob_fixup()
        .replace_needed('android.hardware.graphics.composer@2.1-resources.so', 'android.hardware.graphics.composer@2.1-resources-v34.so'),
    # WPA supplicant: use libcrypto-v33 for legacy OpenSSL/BoringSSL sk_* symbols
    'vendor/bin/hw/wpa_supplicant': blob_fixup()
        .replace_needed('libcrypto.so', 'libcrypto-v33.so'),
    # USB HAL and NFC tools: libbase Trim symbol drift
    (
        'vendor/bin/hw/android.hardware.usb@1.2-service-mediatekv2',
        'vendor/bin/nfcstackp-vendor',
        'vendor/bin/STFlashTool',
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
    # Power AIDL
    ('vendor/bin/hw/vendor.mediatek.hardware.mtkpower@1.0-service', 'vendor/lib64/android.hardware.power-service-mediatek.so'): blob_fixup()
        .replace_needed('android.hardware.power-V2-ndk_platform.so', 'android.hardware.power-V2-ndk.so'),
    'vendor/lib64/libpowerhal.so': blob_fixup()
        .sig_replace('e0 03 80 3d 68 00 00 36', '28 00 80 52 c8 02 1b 39'),
    # Minijail: libbase WriteStringToFd symbol drift
    (
        'vendor/lib64/libavservices_minijail_vendor.so',
        'vendor/lib/libavservices_minijail_vendor.so',
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
    # GPS daemons: BoringSSL CBS_* symbols shim
    (
        'vendor/bin/mnld',
        'vendor/bin/mtk_agpsd',
    ): blob_fixup()
        .add_needed('libcrypto_shim.so'),
    # Vibrator AIDL
    'vendor/bin/hw/android.hardware.vibrator-service.mediatek': blob_fixup()
        .replace_needed('android.hardware.vibrator-V2-ndk_platform.so', 'android.hardware.vibrator-V2-ndk.so'),
    # Biometrics fingerprint (keymaster AIDL)
    'vendor/lib64/android.hardware.biometrics.fingerprint-V1-ndk_platform.so': blob_fixup()
        .replace_needed('android.hardware.keymaster-V3-ndk_platform.so', 'android.hardware.keymaster-V3-ndk.so'),
    # Keystore2 (wifi keystore HIDL bridge)
    ('vendor/lib64/libkeystore-engine-wifi-hidl.so', 'vendor/lib/libkeystore-engine-wifi-hidl.so'): blob_fixup()
        .replace_needed('android.system.keystore2-V1-ndk_platform.so', 'android.system.keystore2-V1-ndk.so'),
    # Biometrics fingerprint AIDL
    ('vendor/bin/hw/vendor.pri.hardware.biometrics.fingerprint-service', 'vendor/lib64/android.hardware.biometrics.fingerprint-V1-ndk_platform.so'): blob_fixup()
        .replace_needed('android.hardware.biometrics.common-V1-ndk_platform.so', 'android.hardware.biometrics.common-V1-ndk.so')
        .replace_needed('android.hardware.biometrics.fingerprint-V1-ndk_platform.so', 'android.hardware.biometrics.fingerprint-V1-ndk.so'),
    # MTK factory test binary
    'vendor/bin/factory': blob_fixup()
        .replace_needed('android.hardware.light-V1-ndk_platform.so', 'android.hardware.light-V1-ndk.so'),
    # Audio HAL: platform libalsautils ABI changed -> use renamed blob copy
    (
        'vendor/lib64/hw/audio.primary.mediatek.so',
        'vendor/lib64/hw/audio.primary.mt6855.so',
        'vendor/lib64/hw/audio.usb.default.so',
        'vendor/lib/hw/audio.primary.mediatek.so',
        'vendor/lib/hw/audio.primary.mt6855.so',
        'vendor/lib/hw/audio.usb.default.so',
    ): blob_fixup()
        .add_needed('libstagefright_foundation-v33.so')
        .replace_needed('libalsautils.so', 'libalsautils-v31.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    # Camera provider: libcamera_metadata shim
    (
        'vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so',
        'vendor/lib64/hw/mt6855/android.hardware.camera.provider@2.6-impl-mediatek.so',
    ): blob_fixup()
        .add_needed('libcamera_metadata_shim.so'),
    # PQ impl: libutils + libtinyxml2 ABI drift
    (
        'vendor/lib64/hw/vendor.mediatek.hardware.pq@2.15-impl.so',
        'vendor/lib64/hw/mt6855/vendor.mediatek.hardware.pq@2.15-impl.so',
    ): blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    # External amp intf: libtinyxml2 ABI drift
    (
        'vendor/lib64/librt_extamp_intf.so',
        'vendor/lib/librt_extamp_intf.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    # RIL: libutils ABI drift
    'vendor/bin/hw/mtkfusionrild': blob_fixup()
        .add_needed('libutils-v32.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'macha5g',
    'advan',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
