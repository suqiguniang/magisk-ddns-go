# Magisk DDNS-GO

## Introduction

DDNS-GO Magisk Module（本地化离线版）

本模块已内置 arm / arm64 / x86 / x64 全架构的 `curl`、`jq`、`ddns-go` 二进制，
刷入过程完全离线，**无需联网下载任何依赖**，也不会在后台自动联网检查更新。
下载本仓库打包好的 `magisk-ddns-go.zip` 后，直接在 Magisk 中安装即可使用。

## Usage

1. 在 Magisk / KernelSU 中刷入 `magisk-ddns-go.zip`
2. 重启手机
3. 等待片刻，ddns-go 会自动启动
4. 浏览器访问 [http://127.0.0.1:9876](http://127.0.0.1:9876) 进行配置

## Notes

- 安装时会自动识别设备架构，只保留对应架构的二进制，其余架构会被删除以节省空间。
- 配置保存在 `/data/adb/ddns_go/config/ddns_go_config.yaml`。

## Credits

- [Magisk](https://github.com/topjohnwu/Magisk/): makes all these possible
- [ddns-go](https://github.com/jeessy2/ddns-go): the main body
- [magisk-ddns-go](https://github.com/suqiguniang/magisk-ddns-go): 本模块上游
