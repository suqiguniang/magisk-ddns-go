#!/system/bin/sh
# ddns-go 守护进程:进程不在就拉起,退出后自动重启
MODDIR="$(dirname "$(readlink -f "$0")")"
MODDIR="$(dirname "$MODDIR")"
export MODDIR

# 加载环境变量(PATH / 日志 / 配置路径 / busybox)
. "$MODDIR/script/init_env.sh"
export EXTRA_LOG_SAVE_PATH
export DDNS_GO_CONFIG_FILE_PATH
export DDNS_GO_LOG_FILE="$EXTRA_LOG_SAVE_PATH/ddns-go.log"

while true; do
    if ! pgrep -f "$MODDIR/bin/ddns-go" >/dev/null 2>&1; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ddns-go process is not found. Starting.." >> "$DDNS_GO_LOG_FILE"
        "$MODDIR/bin/ddns-go" -l 127.0.0.1:9876 -dns 223.5.5.5 -c "$DDNS_GO_CONFIG_FILE_PATH" >> "$DDNS_GO_LOG_FILE" 2>&1
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ddns-go exited, will restart." >> "$DDNS_GO_LOG_FILE"
    fi
    sleep 3
done