#!/usr/bin/env sh
set -e

VERSION="0.3.0"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build-release"
DIST="$ROOT/dist"

rm -rf "$BUILD" "$DIST"
mkdir -p "$DIST"

cmake -S "$ROOT" -B "$BUILD" -DCMAKE_BUILD_TYPE=Release
cmake --build "$BUILD"

OS="linux"
case "$(uname -s)" in
  Darwin*) OS="macos" ;;
  Linux*) OS="linux" ;;
esac

ARCH="x64"
case "$(uname -m)" in
  arm64|aarch64) ARCH="arm64" ;;
esac

PKG="$DIST/pomidor-$OS-$ARCH"
mkdir -p "$PKG/bin" "$PKG/examples"
cp "$BUILD/pomidor" "$PKG/bin/pomidor"
cp "$ROOT/examples"/*.pom "$PKG/examples/"
cp "$ROOT/README.md" "$PKG/"
cp "$ROOT/LICENSE" "$PKG/"

(cd "$DIST" && tar -czf "pomidor-$OS-$ARCH.tar.gz" "pomidor-$OS-$ARCH")
cp "$ROOT/scripts/install.sh" "$DIST/install.sh"

echo "Готово: $DIST"
