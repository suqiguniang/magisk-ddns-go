#!/system/bin/sh

MODDIR="$(dirname "$(readlink -f "$0")")"

chmod 755 $MODDIR/bin/ddns-go

while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5s
done

chmod 755 -R $MODDIR/script/

# ddns-go 守护进程(此版本不自动从云端更新,已内置最新二进制)
. "$MODDIR/script/init_env.sh"
export EXTRA_LOG_SAVE_PATH=$EXTRA_LOG_SAVE_PATH
export DDNS_GO_CONFIG_FILE_PATH=$DDNS_GO_CONFIG_FILE_PATH
ASH_STANDALONE=1 busybox sh -c "$MODDIR/script/ddns_go_daemon.sh" &

# 定时清理超过 1MB 的日志文件
while true; do
    sleep 24h
    for the_log in $(busybox ls ${EXTRA_LOG_SAVE_PATH}/*.log -1 2>/dev/null); do
        the_size=$(wc -c < "$the_log" 2>/dev/null)
        if [ "$the_size" -gt 1048576 ]; then
            cat /dev/null > "$the_log"
        fi
    done
done