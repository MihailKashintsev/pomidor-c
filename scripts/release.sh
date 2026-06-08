#!/usr/bin/env bash
set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
  echo "Usage: ./scripts/release.sh 0.4.1"
  exit 1
fi

VERSION="${VERSION#v}"

if ! echo "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Version must be like 0.4.1 or v0.4.1"
  exit 1
fi

TAG="v$VERSION"

if [ ! -f "src/main.c" ]; then
  echo "src/main.c not found. Run from repository root."
  exit 1
fi

echo "Preparing Pomidor release $TAG"

# Update version in src/main.c if macro already exists.
if grep -qE '#define[[:space:]]+POMIDOR_VERSION[[:space:]]+"[^"]+"' src/main.c; then
  sed -i -E "s/#define[[:space:]]+POMIDOR_VERSION[[:space:]]+\"[^\"]+\"/#define POMIDOR_VERSION \"$VERSION\"/" src/main.c
else
  tmp_file="$(mktemp)"
  printf '#define POMIDOR_VERSION "%s"\n' "$VERSION" > "$tmp_file"
  cat src/main.c >> "$tmp_file"
  mv "$tmp_file" src/main.c
fi

git add .
git commit -m "Release $TAG" || echo "Nothing to commit."

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Tag $TAG already exists locally."
  echo "Use another version or delete the tag:"
  echo "  git tag -d $TAG"
  echo "  git push origin :refs/tags/$TAG"
  exit 1
fi

git tag "$TAG"
git push origin main
git push origin "$TAG"

echo ""
echo "Done."
echo "GitHub Actions will now build and publish:"
echo "  pomidor-windows-x64.zip"
echo ""
echo "Open:"
echo "  https://github.com/MihailKashintsev/pomidor-c/actions"
echo "Release will appear here:"
echo "  https://github.com/MihailKashintsev/pomidor-c/releases/tag/$TAG"
