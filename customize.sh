#!/system/bin/sh

if [ "$BOOTMODE" != true ]; then
  ui_print "! Please install in Magisk Manager"
  ui_print "! Install from recovery is NOT supported"
  abort "-----------------------------------------------------------"
fi

MODDIR=$MODPATH
mkdir -p $MODPATH/text
echo "$ARCH" > $MODPATH/text/the_arch
chmod 755 -R $MODPATH/script/
chmod 755 -R $MODPATH/bin/
. $MODPATH/script/init_env.sh

cat /dev/null > "${EXTRA_LOG_SAVE_PATH}/info.log"
cat /dev/null > "${EXTRA_LOG_SAVE_PATH}/debug.log"

ui_print "- Detected architecture: $ARCH"
ui_print "- Installing built-in binaries (offline)"

# 本模块已内置各架构的 curl / jq / ddns-go,无需联网下载
case "$ARCH" in
    arm)
        cp -f $MODPATH/bin/arm/curl    $MODPATH/bin/curl
        cp -f $MODPATH/bin/arm/jq      $MODPATH/bin/jq
        cp -f $MODPATH/bin/arm/ddns-go $MODPATH/bin/ddns-go
    ;;
    arm64)
        cp -f $MODPATH/bin/arm64/curl    $MODPATH/bin/curl
        cp -f $MODPATH/bin/arm64/jq      $MODPATH/bin/jq
        cp -f $MODPATH/bin/arm64/ddns-go $MODPATH/bin/ddns-go
    ;;
    x86)
        cp -f $MODPATH/bin/x86/curl    $MODPATH/bin/curl
        cp -f $MODPATH/bin/x86/jq      $MODPATH/bin/jq
        cp -f $MODPATH/bin/x86/ddns-go $MODPATH/bin/ddns-go
    ;;
    x64)
        cp -f $MODPATH/bin/x64/curl    $MODPATH/bin/curl
        cp -f $MODPATH/bin/x64/jq      $MODPATH/bin/jq
        cp -f $MODPATH/bin/x64/ddns-go $MODPATH/bin/ddns-go
    ;;
    *)
        ui_print "! Mission failed due to no suitable binary. CPU architecture is not supported."
        abort
    ;;
esac

chmod 755 $MODPATH/bin/curl $MODPATH/bin/jq $MODPATH/bin/ddns-go

if [ ! -x $MODPATH/bin/ddns-go ] || [ ! -x $MODPATH/bin/curl ] || [ ! -x $MODPATH/bin/jq ]; then
    ui_print "! Built-in binaries are missing. Installation aborted."
    abort
fi

# 仅保留当前架构的二进制,删除所有架构子目录以节省空间
for the_tmp in arm arm64 x86 x64; do
    rm -rf $MODPATH/bin/$the_tmp
done

if [ -e /system/etc/resolv.conf ]; then
	ui_print "- File [/system/etc/resolv.conf] already exist. Merging..."
	cat $MODPATH/my_res/resolv.conf /system/etc/resolv.conf > /system/etc/resolv.conf
else
	ui_print "- File [/system/etc/resolv.conf] did not exist. Setting..."
	mkdir -p /system/etc
	cat $MODPATH/my_res/resolv.conf > /system/etc/resolv.conf
fi

if [ -d "$DDNS_GO_CONFIG_OLD_SAVE_PATH" ]; then
    ui_print "- Found old config. Migrating.."
    mv $DDNS_GO_CONFIG_OLD_SAVE_PATH/* $DDNS_GO_CONFIG_SAVE_PATH/
    if [ $? -ne 0 ]; then
        ui_print "Mission failed due to migrate configuration directory failed."
        abort
    fi
    rm -rf $DDNS_GO_CONFIG_OLD_SAVE_PATH/
fi