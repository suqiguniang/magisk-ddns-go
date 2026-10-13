#!/usr/bin/env python3
# 打包 magisk-ddns-go.zip(离线版)
# 用法: python pack.py
import os
import stat
import zipfile

ROOT = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(ROOT, "magisk-ddns-go.zip")

# 不打包进模块的文件
EXCLUDES = {
    ".git",
    ".github",
    "LICENSE",
    "README.MD",
    "magisk-ddns-go.zip",
    "pack_helper.sh",
    "pack.py",
    "version.json",
    "changelog.md",
    ".gitignore",
}

def main():
    if os.path.exists(OUT):
        os.remove(OUT)
    with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for dirpath, dirnames, filenames in os.walk(ROOT):
            dirnames[:] = [d for d in dirnames if d not in EXCLUDES and not d.endswith(".git")]
            filenames = [f for f in filenames if f not in EXCLUDES]
            for fn in filenames:
                full = os.path.join(dirpath, fn)
                rel = os.path.relpath(full, ROOT).replace(os.sep, "/")
                # Windows 上是只读/常规文件,进 zip 时统一给 755,保证 Magisk 可直接执行
                zi = zipfile.ZipInfo(rel, date_time=(1980, 1, 1, 0, 0, 0))
                zi.compress_type = zipfile.ZIP_DEFLATED
                zi.external_attr = 0o755 << 16  # -rwxr-xr-x
                with open(full, "rb") as f:
                    zf.writestr(zi, f.read())
                print(f"  added {rel}")
    size_mb = os.path.getsize(OUT) / 1024 / 1024
    print(f"\nDone: {OUT} ({size_mb:.1f} MB)")

if __name__ == "__main__":
    main()