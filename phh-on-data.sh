#!/system/bin/sh

vndk="$(getprop persist.sys.vndk)"
[ -z "$vndk" ] && vndk="$(getprop ro.vndk.version |grep -oE '^[0-9]+')"

if getprop persist.sys.phh.no_vendor_overlay |grep -q true;then
	for part in odm vendor;do
		mount /mnt/phh/empty_dir/ /$part/overlay
	done
fi

if getprop persist.sys.phh.caf.media_profile |grep -q true;then
    setprop media.settings.xml "/vendor/etc/media_profiles_vendor.xml"
fi


minijailSrc=/system/system_ext/apex/com.android.vndk.v28/lib/libminijail.so
minijailSrc64=/system/system_ext/apex/com.android.vndk.v28/lib64/libminijail.so
if [ "$vndk" = 27 ];then
    mount $minijailSrc64 /vendor/lib64/libminijail_vendor.so
    mount $minijailSrc /vendor/lib/libminijail_vendor.so
fi

if [ "$vndk" = 28 ];then
    mount $minijailSrc64 /vendor/lib64/libminijail_vendor.so
    mount $minijailSrc /vendor/lib/libminijail_vendor.so
    mount $minijailSrc64 /system/lib64/vndk-28/libminijail.so
    mount $minijailSrc /system/lib/vndk-28/libminijail.so
    mount $minijailSrc64 /vendor/lib64/libminijail.so
    mount $minijailSrc /vendor/lib/libminijail.so
fi

# LOKMAT APPLLP 9 MAX, board YZL_C30_TFT_JL. The panel is 480x640 and is worn
# at rotation 270. fixedToUserRotation 2 is FIXED_TO_USER_ROTATION_ENABLED.
# The angle comes from the fingerprint SettingsProvider overlay: this file
# cannot set user rotation on the default display. Leave an existing file
# alone so a later size or density override is kept. /data/system is absent
# until userdata is mounted, and both early-boot and
# vold.decrypt=trigger_restart_framework run this script.
if getprop ro.vendor.build.fingerprint | grep -q '^alps/vnd_YZL_C30_TFT_JL/YZL_C30_TFT_JL:'; then
    settings=/data/system/display_settings.xml
    if [ -d /data/system ] && [ ! -e "$settings" ]; then
        tmp="${settings}.tmp"
        if cat > "$tmp" <<'EOF'
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<display-settings>
    <config identifier="1" />
    <display name="port:0" fixedToUserRotation="2" />
</display-settings>
EOF
        then
            if [ ! -e "$settings" ]; then
                chown system:system "$tmp"
                chmod 600 "$tmp"
                mv "$tmp" "$settings"
                restorecon "$settings"
            else
                rm -f "$tmp"
            fi
        else
            rm -f "$tmp"
        fi
    fi
fi
