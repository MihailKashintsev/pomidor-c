# Pomidor

**Pomidor** — экспериментальный язык программирования на **C** с русским и английским синтаксисом.

Цель проекта — сделать простой, быстрый и лёгкий язык, который можно запускать из командной строки.

Расширение файлов:

```text
.pom
```

## Быстрая установка

### Windows

Открой PowerShell и выполни:

```powershell
irm https://github.com/MihailKashintsev/pomidor-c/releases/latest/download/install.ps1 | iex
```

После установки перезапусти терминал и проверь:

```bash
pomidor --version
```

### Linux/macOS

```bash
curl -fsSL https://github.com/MihailKashintsev/pomidor-c/releases/latest/download/install.sh | sh
```

Добавь Pomidor в `PATH`, если скрипт попросит:

```bash
export PATH="$HOME/.pomidor/bin:$PATH"
```

Проверка:

```bash
pomidor --version
```

## Обновления

Проверить наличие новой версии:

```bash
pomidor update-check
```

Обновить Pomidor:

```bash
pomidor update
```

Команды используют GitHub Releases репозитория:

```text
https://github.com/MihailKashintsev/pomidor-c/releases
```

Важно: чтобы установка и обновление работали, в последнем Release должны быть файлы:

```text
install.ps1
install.sh
pomidor-windows-x64.zip
pomidor-linux-x64.tar.gz
pomidor-macos-x64.tar.gz
```

Для macOS/ARM или Linux/ARM можно добавлять отдельные архивы:

```text
pomidor-macos-arm64.tar.gz
pomidor-linux-arm64.tar.gz
```

## Запуск программы

```bash
pomidor examples/advanced_ru.pom
```

или:

```bash
pomidor examples/advanced_en.pom
```

## Команды CLI

```bash
pomidor file.pom
pomidor --mem file.pom
pomidor --version
pomidor update-check
pomidor update
```

Описание:

| Команда | Что делает |
|---|---|
| `pomidor file.pom` | запускает файл Pomidor |
| `pomidor --mem file.pom` | запускает файл и показывает счётчик памяти |
| `pomidor --version` | показывает текущую версию |
| `pomidor update-check` | проверяет последнюю версию в GitHub Releases |
| `pomidor update` | запускает обновление через GitHub Releases |

## Возможности языка сейчас

Pomidor поддерживает:

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
- встроенные функции: `длина` / `len`, `строка` / `str`, `число` / `num`

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

## Example in English

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

## Сборка из исходников

### Windows

Нужно установить:

- Git
- CMake
- Visual Studio Build Tools или Visual Studio Community с компонентом C++

```bash
cmake -S . -B build
cmake --build build --config Release
```

Запуск:

```bash
build\Release\pomidor.exe examples\advanced_ru.pom
```

### Linux/macOS

```bash
cmake -S . -B build
cmake --build build
./build/pomidor examples/advanced_ru.pom
```

## Локальная установка из исходников

```bash
cmake --install build --prefix install
```

Исполняемый файл будет здесь:

```text
install/bin/pomidor
```

На Windows:

```text
install/bin/pomidor.exe
```

## Сборка релиза для GitHub

### Windows

```powershell
.\scripts\build-release.ps1
```

После этого в папке `dist` появятся:

```text
pomidor-windows-x64.zip
install.ps1
```

Их нужно загрузить в GitHub Release.

### Linux/macOS

```bash
./scripts/build-release.sh
```

После этого в папке `dist` появятся:

```text
pomidor-linux-x64.tar.gz
install.sh
```

или:

```text
pomidor-macos-x64.tar.gz
install.sh
```

Эти файлы нужно загрузить в GitHub Release.

## Проверка памяти

Так как Pomidor пишется на C, важно следить за памятью.

Главное правило:

```text
malloc / calloc / realloc / strdup → обязательно free
```

Запуск со счётчиком памяти:

```bash
pomidor --mem examples/advanced_ru.pom
```

Пример хорошего результата:

```text
[memory] allocations: 92, frees: 92, alive: 0
```

### AddressSanitizer для GCC/Clang

```bash
cmake -S . -B build-asan -DCMAKE_C_FLAGS="-fsanitize=address -g"
cmake --build build-asan
./build-asan/pomidor examples/advanced_ru.pom
```

### Valgrind на Linux

```bash
valgrind --leak-check=full ./build/pomidor examples/advanced_ru.pom
```

## Структура проекта

```text
pomidor-c/
│
├── src/
│   └── main.c
│
├── examples/
│   ├── advanced_ru.pom
│   ├── advanced_en.pom
│   ├── simple_ru.pom
│   └── simple_en.pom
│
├── scripts/
│   ├── install.ps1
│   ├── install.sh
│   ├── build-release.ps1
│   └── build-release.sh
│
├── CMakeLists.txt
├── README.md
├── LICENSE
└── .gitignore
```

## План развития

Дальше можно добавить:

- нормальное разделение на `lexer.c`, `parser.c`, `interpreter.c`
- массивы
- функции пользователя
- импорт модулей
- обработку ошибок без аварийного завершения
- подсветку синтаксиса для VS Code
- установщик `.exe` для Windows
- автосборку релизов через GitHub Actions

## Лицензия

MIT.
