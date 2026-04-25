#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_LINK="$ROOT_DIR/CLIProxyAPI"
DEFAULT_SOURCE="$ROOT_DIR/../CLIProxyAPI"
SOURCE_DIR="${CLI_PROXYAPI_DIR:-$DEFAULT_SOURCE}"
REPO_URL="${CLI_PROXYAPI_URL:-https://github.com/router-for-me/CLIProxyAPI.git}"

if [ -n "${CLI_PROXYAPI_DIR:-}" ]; then
    LINK_TARGET="$SOURCE_DIR"
else
    LINK_TARGET="../CLIProxyAPI"
fi

if [ -d "$SOURCE_DIR/.git" ]; then
    git -C "$SOURCE_DIR" pull --ff-only
elif [ -e "$SOURCE_DIR" ]; then
    printf 'Refusing non-git path for CLIProxyAPI: %s\n' "$SOURCE_DIR" >&2
    exit 1
else
    git clone "$REPO_URL" "$SOURCE_DIR"
fi

if [ -L "$TARGET_LINK" ]; then
    CURRENT_LINK="$(readlink "$TARGET_LINK")"
    if [ "$CURRENT_LINK" != "$LINK_TARGET" ]; then
        ln -sfn "$LINK_TARGET" "$TARGET_LINK"
    fi
elif [ -e "$TARGET_LINK" ]; then
    printf 'Refusing to overwrite existing path: %s\n' "$TARGET_LINK" >&2
    exit 1
else
    ln -s "$LINK_TARGET" "$TARGET_LINK"
fi

printf 'Ready: %s -> %s\n' "$TARGET_LINK" "$LINK_TARGET"
printf 'Source this file from ~/.bashrc:\nsource "%s/shell/claude_code_proxy.sh"\n' "$ROOT_DIR"
