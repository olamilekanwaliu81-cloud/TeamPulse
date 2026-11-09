#!/bin/bash
# Builds everything in the right order: the site, the Mac app, the Windows package, then the site again
# so the download buttons show the real file sizes.
#
#   bash scripts/build_all.sh
set -euo pipefail
cd "$(dirname "$0")/.."
python3 scripts/build_site.py
bash macos/build_mac.sh
python3 windows/build_windows.py
python3 scripts/build_site.py
echo
echo "Downloads for the website:"
ls -lh site/downloads
