$(call inherit-product, vendor/lineage/config/common_full_tablet.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)
$(call inherit-product, vendor/lineage/config/BoardConfigSoong.mk)
$(call inherit-product, vendor/lineage/config/BoardConfigLineage.mk)
$(call inherit-product, device/lineage/sepolicy/common/sepolicy.mk)
-include vendor/lineage/build/core/config.mk

# Bootanimation
TARGET_BOOT_ANIMATION_RES := 1080

# Face unlock
TARGET_FACE_UNLOCK_SUPPORTED := true
PRODUCT_PACKAGES += FaceUnlock

# APN
PRODUCT_PACKAGES += apns-conf.xml

#Oplus fingerprint
$(call soong_config_set,surfaceflinger,udfps_lib,//hardware/oplus:libudfps_extension.oplus)
