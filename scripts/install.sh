#!/usr/bin/env sh
set -e

REPO="MihailKashintsev/pomidor-c"
INSTALL_DIR="$HOME/.pomidor"
BIN_DIR="$INSTALL_DIR/bin"
TMP_DIR="${TMPDIR:-/tmp}/pomidor-install"

OS="linux"
case "$(uname -s)" in
  Darwin*) OS="macos" ;;
  Linux*) OS="linux" ;;
  *) echo "Unsupported OS" >&2; exit 1 ;;
esac

ARCH="x64"
case "$(uname -m)" in
  x86_64|amd64) ARCH="x64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

ASSET="pomidor-$OS-$ARCH.tar.gz"
URL="https://github.com/$REPO/releases/latest/download/$ASSET"

mkdir -p "$BIN_DIR"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "Pomidor: установка/обновление..."
curl -L -f "$URL" -o "$TMP_DIR/$ASSET"
tar -xzf "$TMP_DIR/$ASSET" -C "$TMP_DIR"

POMIDOR_BIN="$(find "$TMP_DIR" -type f -name pomidor | head -n 1)"
if [ -z "$POMIDOR_BIN" ]; then
  echo "pomidor не найден в архиве релиза" >&2
  exit 1
fi

cp "$POMIDOR_BIN" "$BIN_DIR/pomidor"
chmod +x "$BIN_DIR/pomidor"

echo "Pomidor установлен в $BIN_DIR"
echo "Добавь в PATH, если ещё не добавлено:"
echo "  export PATH=\"$BIN_DIR:\$PATH\""
echo "Проверка: pomidor --version"
