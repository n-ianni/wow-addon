#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ADDONS_DIR="${WOW_ADDONS_DIR:-/Applications/World of Warcraft/_retail_/Interface/AddOns}"

mkdir -p "$ADDONS_DIR/$ADDON_NAME"
rsync -a --delete "$ROOT_DIR/.build/$ADDON_NAME/" "$ADDONS_DIR/$ADDON_NAME/"