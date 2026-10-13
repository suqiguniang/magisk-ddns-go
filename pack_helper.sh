#!/bin/sh
zip magisk-ddns-go.zip ./ -9 -r -x '.git/*' -x '.github/*' -x 'bin/.gitignore' -x 'config/.gitignore' -x 'LICENSE' -x 'README.MD' -x 'magisk-ddns-go.zip' -x 'pack_helper.sh' -x 'pack.py' -x '.gitignore' -x 'version.json' -x 'changelog.md'
