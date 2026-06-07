# Pomidor

**Pomidor** — экспериментальный язык программирования на **C**.

Цель проекта — сделать простой, быстрый и лёгкий язык программирования с поддержкой русского и английского синтаксиса.

Файлы Pomidor используют расширение:

```text
.pom
```

## Возможности языка

Сейчас Pomidor поддерживает:

- `пусть` / `let` — создание переменных
- `выведи` / `print` — вывод в консоль
- `если` / `if`
- `иначе` / `else`
- `пока` / `while`
- `истина` / `true`
- `ложь` / `false`
- `и` / `and`
- `или` / `or`
- `не` / `not`
- числа
- строки
- переменные
- присваивание
- арифметику: `+`, `-`, `*`, `/`, `%`
- сравнения: `>`, `>=`, `<`, `<=`, `==`, `!=`
- скобки в выражениях
- комментарии через `#`
- встроенные функции:
  - `длина()` / `len()`
  - `строка()` / `str()`
  - `число()` / `num()`

## Пример на русском

```pomidor
пусть имя = "Михаил"
пусть x = 1
пусть сумма = 0

выведи "Привет, " + имя
выведи "Длина имени: " + строка(длина(имя))

пока x <= 5 {
    сумма = сумма + x
    выведи "x = " + строка(x)
    x = x + 1
}

если сумма == 15 и истина {
    выведи "Сумма правильная: " + строка(сумма)
} иначе {
    выведи "Ошибка"
}
```

## Пример на английском

```pomidor
let name = "Render"
let x = 1
let sum = 0

print "Hello, " + name
print "Name length: " + str(len(name))

while x <= 5 {
    sum = sum + x
    print "x = " + str(x)
    x = x + 1
}

if sum == 15 and true {
    print "Correct sum: " + str(sum)
} else {
    print "Error"
}
```

## Установка для пользователей

После публикации релиза на GitHub пользователи смогут установить Pomidor одной командой.

### Windows

Откройте PowerShell и выполните:

```powershell
irm https://github.com/MihailKashintsev/pomidor-c/releases/latest/download/install.ps1 | iex
```

### Linux/macOS

```bash
curl -fsSL https://github.com/MihailKashintsev/pomidor-c/releases/latest/download/install.sh | sh
```

После установки будет доступна команда:

```bash
pomidor
```

Проверка версии:

```bash
pomidor --version
```

Запуск файла:

```bash
pomidor examples/hello_ru.pom
```

или:

```bash
pomidor my_script.pom
```

## Обновление Pomidor

Проверить наличие обновлений:

```bash
pomidor update-check
```

Установить последнюю версию:

```bash
pomidor update
```

Обновление работает через GitHub Releases этого репозитория.

## Команды Pomidor CLI

```bash
pomidor файл.pom
```

Запускает `.pom` файл.

```bash
pomidor --version
```

Показывает текущую версию Pomidor.

```bash
pomidor --help
```

Показывает справку.

```bash
pomidor update-check
```

Проверяет наличие новой версии.

```bash
pomidor update
```

Скачивает и устанавливает последнюю версию из GitHub Releases.

```bash
pomidor --mem файл.pom
```

Запускает файл и показывает информацию о выделенной и освобождённой памяти.

## Сборка из исходников

Для сборки нужны:

- Git
- CMake
- компилятор C

На Windows удобно использовать **Visual Studio Build Tools** или **Visual Studio Community** с компонентом C++.

### Windows

```powershell
cmake -S . -B build
cmake --build build --config Release
```

Запуск:

```powershell
build\Release\pomidor.exe examples\hello_ru.pom
```

### Linux/macOS

```bash
cmake -S . -B build
cmake --build build
```

Запуск:

```bash
./build/pomidor examples/hello_ru.pom
```

## Локальная установка из исходников

```bash
cmake --install build --prefix install
```

После этого исполняемый файл будет находиться здесь:

```text
install/bin/pomidor
```

На Windows:

```text
install/bin/pomidor.exe
```

Чтобы запускать `pomidor` из любого места, добавьте папку `install/bin` в переменную окружения `PATH`.

## Релизы для разработчика

Обычным пользователям этот раздел не нужен.

Чтобы выпустить новую версию Pomidor, используется скрипт:

### Windows

```powershell
Unblock-File .\scripts\release.ps1
.\scripts\release.ps1 0.4.0
```

### Linux/macOS

```bash
chmod +x ./scripts/release.sh
./scripts/release.sh 0.4.0
```

Скрипт делает:

1. Обновляет версию в `src/main.c`.
2. Создаёт commit.
3. Создаёт git tag вида `v0.4.0`.
4. Отправляет `main` на GitHub.
5. Отправляет tag на GitHub.
6. GitHub Actions автоматически собирает релиз.

После запуска скрипта нужно открыть:

```text
https://github.com/MihailKashintsev/pomidor-c/actions
```

Там можно увидеть процесс сборки.

## GitHub Actions

В проекте используется workflow:

```text
.github/workflows/release.yml
```

Он запускается при отправке тега:

```text
v*
```

Например:

```text
v0.4.0
v0.4.1
v1.0.0
```

GitHub Actions собирает файлы релиза:

```text
pomidor-windows-x64.zip
pomidor-linux-x64.tar.gz
pomidor-macos-x64.tar.gz
pomidor-macos-arm64.tar.gz
install.ps1
install.sh
```

Эти файлы автоматически прикрепляются к GitHub Release.

## Ручная сборка релиза

Если нужно собрать релиз вручную:

### Windows

```powershell
.\scripts\build-release.ps1
```

### Linux/macOS

```bash
./scripts/build-release.sh
```

После сборки файлы появятся в папке:

```text
dist/
```

## Проверка памяти

Так как Pomidor написан на C, важно следить за памятью.

Главное правило:

```text
malloc / calloc / realloc / strdup → обязательно free
```

Запуск с внутренней проверкой памяти:

```bash
pomidor --mem examples/hello_ru.pom
```

Пример хорошего результата:

```text
[memory] allocations: 92, frees: 92, alive: 0
```

`alive: 0` значит, что в этом запуске не осталось неосвобождённой памяти.

### AddressSanitizer для GCC/Clang

```bash
cmake -S . -B build-asan -DCMAKE_C_FLAGS="-fsanitize=address -g"
cmake --build build-asan
./build-asan/pomidor examples/hello_ru.pom
```

### Valgrind на Linux

```bash
valgrind --leak-check=full ./build/pomidor examples/hello_ru.pom
```

## Структура проекта

```text
pomidor-c/
│
├── .github/
│   └── workflows/
│       └── release.yml
│
├── examples/
│   ├── hello_ru.pom
│   └── hello_en.pom
│
├── scripts/
│   ├── build-release.ps1
│   ├── build-release.sh
│   ├── install.ps1
│   ├── install.sh
│   ├── release.ps1
│   └── release.sh
│
├── src/
│   ├── main.c
│   ├── lexer.c
│   ├── lexer.h
│   ├── parser.c
│   ├── parser.h
│   ├── interpreter.c
│   ├── interpreter.h
│   ├── value.c
│   └── value.h
│
├── CMakeLists.txt
├── README.md
├── LICENSE
└── .gitignore
```

## Планы развития

В будущих версиях планируется добавить:

- функции пользователя
- массивы
- модули
- импорт файлов
- улучшенные сообщения об ошибках
- установщик для Windows
- расширение для VS Code
- пакетный менеджер Pomidor
- стандартную библиотеку

## Лицензия

Проект распространяется под лицензией MIT.
