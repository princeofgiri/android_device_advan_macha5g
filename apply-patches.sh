#!/bin/bash
# Script to apply device-specific platform patches for Advan Macha 5G (mt6855)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCHES_DIR="${SCRIPT_DIR}/patches"

# Determine Android root directory
if [ -n "$1" ]; then
    ROOT_DIR="$1"
elif [ -n "${ANDROID_BUILD_TOP}" ]; then
    ROOT_DIR="${ANDROID_BUILD_TOP}"
elif [ -d "${SCRIPT_DIR}/../../../build/make" ]; then
    ROOT_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
elif [ -d "/home/haris/android-source/SymbiotOS/build/make" ]; then
    ROOT_DIR="/home/haris/android-source/SymbiotOS"
else
    echo "ERROR: Could not locate Android build top. Please run from within envsetup or pass ROOT_DIR as \$1."
    exit 1
fi

echo "=== Applying platform patches for Advan Macha 5G ==="
echo "Android Root: ${ROOT_DIR}"

apply_patch() {
    local target_dir="$1"
    local patch_file="$2"
    local name="$(basename "${patch_file}")"

    echo -n "Checking ${name} on ${target_dir}... "
    if [ ! -d "${ROOT_DIR}/${target_dir}" ]; then
        echo "SKIPPED (Directory ${target_dir} not found)"
        return 0
    fi

    cd "${ROOT_DIR}/${target_dir}"

    if git apply --check --reverse "${patch_file}" >/dev/null 2>&1; then
        echo "ALREADY APPLIED"
    elif git apply --check "${patch_file}" >/dev/null 2>&1; then
        git apply "${patch_file}"
        echo "APPLIED SUCCESSFULLY"
    else
        echo "FAILED TO APPLY (Conflict?)"
        return 1
    fi
}

apply_patch "frameworks/native" "${PATCHES_DIR}/frameworks_native.patch"
apply_patch "system/core" "${PATCHES_DIR}/system_core.patch"
apply_patch "frameworks/av" "${PATCHES_DIR}/frameworks_av.patch"
apply_patch "packages/modules/common" "${PATCHES_DIR}/packages_modules_common.patch"
apply_patch "packages/apps/Aperture" "${PATCHES_DIR}/packages_apps_Aperture.patch"

echo "=== All patches processed successfully ==="
