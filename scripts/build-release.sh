#!/usr/bin/env sh
set -eu

echo "Building Pomidor release asset..."

if [ ! -f "CMakeLists.txt" ]; then
  echo "CMakeLists.txt not found. Run this script from the repository root." >&2
  exit 1
fi

rm -rf dist package
mkdir -p dist package

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)
    ASSET="pomidor-linux-x64.tar.gz"
    ;;
  Darwin)
    if [ "$ARCH" = "arm64" ]; then
      ASSET="pomidor-macos-arm64.tar.gz"
    else
      ASSET="pomidor-macos-x64.tar.gz"
    fi
    ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 1
    ;;
esac

cp build/pomidor package/pomidor
chmod +x package/pomidor
tar -czf "dist/$ASSET" -C package pomidor

if [ -f "scripts/install.sh" ]; then
  cp scripts/install.sh dist/install.sh
  chmod +x dist/install.sh
fi

echo "Done:"
echo "dist/$ASSET"
