#!/system/bin/sh

# 模块根目录(优先使用外部传入的 MODDIR/MODPATH,否则按脚本位置推断)
if [ -z "$MODDIR" ]; then
    if [ -n "$MODPATH" ]; then
        MODDIR="$MODPATH"
    else
        MODDIR="$(dirname "$(readlink -f "$0")")"
    fi
fi

# busybox 的路径(同时兼容 Magisk 与 KernelSU)
BUSYBOX_SEARCH_PATH="/data/adb/ksu/bin/busybox:/data/adb/magisk/busybox"
if command -v magisk >/dev/null 2>&1; then
    MAGISK_BUSYBOX="$(magisk --path 2>/dev/null)/.magisk/busybox/busybox"
    BUSYBOX_SEARCH_PATH="${MAGISK_BUSYBOX}:${BUSYBOX_SEARCH_PATH}"
fi
BUSYBOX_PARENT_PATH=""
BUSYBOX_PATH=""

for the_path in $(echo "$BUSYBOX_SEARCH_PATH" | tr ":" "\n"); do
    if [ -f "$the_path" ]; then
        BUSYBOX_PATH="$the_path"
        BUSYBOX_PARENT_PATH=$(echo "$the_path" | sed 's#/busybox$##g')
        break
    fi
done

if [ -z "$ARCH" ]; then
    ARCH="$(cat "$MODDIR/text/the_arch" 2>/dev/null)"
fi

DDNS_GO_CONFIG_OLD_SAVE_PATH="/data/adb/modules/ddns_go/config"
DDNS_GO_CONFIG_SAVE_PATH="/data/adb/ddns_go/config"
DDNS_GO_CONFIG_FILE_PATH="$DDNS_GO_CONFIG_SAVE_PATH/ddns_go_config.yaml"
mkdir -p "$DDNS_GO_CONFIG_SAVE_PATH"

EXTRA_SAVE_PATH=/sdcard/Download/ddnsgo
EXTRA_BIN_SAVE_PATH="$EXTRA_SAVE_PATH/bin"
EXTRA_LOG_SAVE_PATH="$EXTRA_SAVE_PATH/log"
mkdir -p "$EXTRA_BIN_SAVE_PATH"
mkdir -p "$EXTRA_LOG_SAVE_PATH"

export PATH="$MODDIR/bin:$EXTRA_BIN_SAVE_PATH:/data/data/com.termux/files/usr/bin:$BUSYBOX_PARENT_PATH:$PATH"
