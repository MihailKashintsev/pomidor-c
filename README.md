# Pomidor

**Pomidor** — небольшой экспериментальный язык программирования, написанный на **C**.

Цель проекта — сделать простой, быстрый и лёгкий язык, который поддерживает команды на русском и английском языке.

Расширение файлов Pomidor:

```text
.pom
```

## Возможности сейчас

На данный момент Pomidor поддерживает:

- `пусть` / `let` — создание переменных
- `выведи` / `print` — вывод в консоль
- числа
- строки
- переменные
- сложение через `+`
- комментарии через `#`

## Пример на русском

```pomidor
пусть имя = "Михаил"
пусть проект = "Pomidor"

выведи "Привет, " + имя
выведи "Язык: " + проект
выведи 10 + 5
```

## Пример на английском

```pomidor
let name = "Render"
let project = "Pomidor"

print "Hello, " + name
print "Language: " + project
print 10 + 5
```

## Структура проекта

```text
pomidor-c/
│
├── src/
│   └── main.c
│
├── examples/
│   ├── hello_ru.pom
│   └── hello_en.pom
│
├── CMakeLists.txt
├── README.md
├── LICENSE
└── .gitignore
```

## Сборка на Windows

Нужно установить:

- Git
- CMake
- Visual Studio Build Tools или Visual Studio Community с компонентом C++

Команды сборки:

```bash
cmake -S . -B build
cmake --build build --config Release
```

Запуск русского примера:

```bash
build\Release\pomidor.exe examples\hello_ru.pom
```

Запуск английского примера:

```bash
build\Release\pomidor.exe examples\hello_en.pom
```

## Сборка на Linux/macOS

```bash
cmake -S . -B build
cmake --build build
```

Запуск:

```bash
./build/pomidor examples/hello_ru.pom
```

## Локальная установка

После сборки можно установить Pomidor в отдельную папку:

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

Чтобы запускать язык из любого места, добавьте папку `install/bin` в `PATH`.

## Проверка памяти

Так как Pomidor пишется на C, важно следить за памятью.

Главное правило:

```text
malloc / calloc / realloc / strdup → обязательно free
```

### AddressSanitizer для GCC/Clang

```bash
cmake -S . -B build-asan -DCMAKE_C_FLAGS="-fsanitize=address -g"
cmake --build build-asan
./build-asan/pomidor examples/hello_ru.pom
```

Если где-то будет утечка памяти или выход за границы массива, AddressSanitizer покажет ошибку.

### Valgrind на Linux

```bash
valgrind --leak-check=full ./build/pomidor examples/hello_ru.pom
```

## План развития

В следующих версиях планируется добавить:

- `если` / `if`
- `иначе` / `else`
- `пока` / `while`
- функции
- массивы
- модули
- нормальный лексер
- парсер
- AST
- более удобные сообщения об ошибках
- установщик для Windows

## Идея синтаксиса

Русский вариант:

```pomidor
пусть x = 10

если x > 5 {
    выведи "x больше 5"
} иначе {
    выведи "x меньше или равен 5"
}
```

Английский вариант:

```pomidor
let x = 10

if x > 5 {
    print "x is greater than 5"
} else {
    print "x is less than or equal to 5"
}
```

## Зачем нужен Pomidor

Pomidor создаётся как простой учебный язык программирования, который можно постепенно развивать до полноценного языка.

Основные цели:

- понятный синтаксис
- поддержка русского и английского ввода
- высокая скорость
- маленький размер
- простая установка
- возможность изучать устройство языков программирования изнутри

## Лицензия

Проект распространяется под лицензией MIT.
