#!/usr/bin/env sh
set -e

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Использование: ./scripts/release.sh 0.4.0" >&2
  exit 1
fi

case "$VERSION" in
  v*) TAG="$VERSION"; CLEAN_VERSION="${VERSION#v}" ;;
  *) TAG="v$VERSION"; CLEAN_VERSION="$VERSION" ;;
esac

case "$CLEAN_VERSION" in
  [0-9]*.[0-9]*.[0-9]*) ;;
  *) echo "Версия должна быть в формате 0.4.0 или v0.4.0" >&2; exit 1 ;;
esac

echo "Pomidor: подготовка релиза $TAG"

if command -v python3 >/dev/null 2>&1; then
python3 - <<PY
from pathlib import Path
import re
p = Path('src/main.c')
s = p.read_text(encoding='utf-8')
s = re.sub(r'#define POMIDOR_VERSION "[^"]+"', '#define POMIDOR_VERSION "$CLEAN_VERSION"', s)
p.write_text(s, encoding='utf-8')
PY
fi

git add .
if [ -n "$(git status --porcelain)" ]; then
  git commit -m "Release $TAG"
else
  echo "Нет изменений для коммита. Создаю только тег."
fi

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Тег $TAG уже существует. Выбери новую версию." >&2
  exit 1
fi

git tag -a "$TAG" -m "Pomidor $TAG"
git push origin main
git push origin "$TAG"

echo "Готово. GitHub Actions сам соберёт релиз: https://github.com/MihailKashintsev/pomidor-c/actions"
