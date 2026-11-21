#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

$(INSTALLED_BOOTIMAGE_TARGET): $(KERNEL_PATH)/boot.img
	$(call pretty,"Using stock signed GKI boot image: $@")
	$(hide) mkdir -p $(dir $@)
	$(hide) cp -fp $< $@

