#!/system/bin/sh

MODDIR="$(dirname "$(readlink -f "$0")")"
export MODDIR

chmod 755 "$MODDIR/bin/ddns-go" 2>/dev/null

while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done

chmod 755 -R "$MODDIR/script/" 2>/dev/null

# 加载环境(PATH / 日志 / 配置路径 / busybox)
. "$MODDIR/script/init_env.sh"
export EXTRA_LOG_SAVE_PATH
export DDNS_GO_CONFIG_FILE_PATH

# ddns-go 守护进程(此版本不自动从云端更新,已内置最新二进制)
sh "$MODDIR/script/ddns_go_daemon.sh" &

# 定时清理超过 1MB 的日志文件
while true; do
    sleep 24h
    for the_log in "${EXTRA_LOG_SAVE_PATH}"/*.log; do
        [ -f "$the_log" ] || continue
        the_size=$(wc -c < "$the_log" 2>/dev/null)
        if [ "$the_size" -gt 1048576 ]; then
            cat /dev/null > "$the_log"
        fi
    done
done