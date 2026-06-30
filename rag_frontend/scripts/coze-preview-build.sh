#!/usr/bin/env bash
set -euo pipefail

# 基于脚本位置定位项目根目录（scripts/ 的上一级）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

echo "[coze-preview-build] Installing dependencies..."
pnpm install

echo "[coze-preview-build] Build completed successfully."
