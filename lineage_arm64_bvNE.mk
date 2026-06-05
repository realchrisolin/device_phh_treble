TARGET_GAPPS_ARCH := arm64
include build/make/target/product/aosp_arm64.mk
$(call inherit-product, device/phh/treble/base.mk)


$(call inherit-product, device/phh/treble/lineage.mk)

PRODUCT_NAME := lineage_arm64_bvNE
PRODUCT_DEVICE := tdgsi_arm64_ab
PRODUCT_BRAND := google
PRODUCT_SYSTEM_BRAND := google
PRODUCT_MODEL := TrebleDroid

# Overwrite the inherited "emulator" characteristics
PRODUCT_CHARACTERISTICS := device

LINEAGE_BUILDTYPE := VANILLA
LINEAGE_BUILD := GSI

#EROFS
LINEAGE_EXTRAVERSION := -EROFS
GSI_FILE_SYSTEM_TYPE := erofs
BOARD_EROFS_COMPRESSOR := lz4hc,9
TARGET_PRODUCT_PROP += device/phh/treble/product.prop
