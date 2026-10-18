#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/.build/$ADDON_NAME"
CACHE_DIR="$ROOT_DIR/.build/cache/Ace3"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/Libs"
rsync -a --exclude '/addon.toc' --exclude '/modules/todo/' "$ROOT_DIR/src/" "$BUILD_DIR/"

# Lists src/<dir>/*.lua as .toc entries (backslash separators, stable order).
list() { (cd "$ROOT_DIR/src" && find "$1" -name '*.lua' ! -path '*/todo/*' | LC_ALL=C sort | tr '/' '\\'); }

# Fills every @NAME@ in the toc from the environment variable NAME.
VERSION="$(git -C "$ROOT_DIR" describe --tags --always 2>/dev/null || echo dev)" \
CORE="$(list core)" LOCALES="$(list locales)" FACTORIES="$(list factories)" \
FRAMEWORK="$(list framework)" MODULES="$(list modules)" \
perl -pe 's/\@(\w+)\@/$ENV{$1}/g' "$ROOT_DIR/src/addon.toc" > "$BUILD_DIR/$ADDON_NAME.toc"

cp -R "$CACHE_DIR"/{LibStub,CallbackHandler-1.0,AceAddon-3.0,AceEvent-3.0,AceHook-3.0,AceDB-3.0,AceLocale-3.0} "$BUILD_DIR/Libs/"