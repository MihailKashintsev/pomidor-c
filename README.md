# Pomidor C

**Pomidor** — экспериментальный язык программирования на C с поддержкой русского и английского синтаксиса.

Цель проекта — сделать простой, быстрый и лёгкий язык, который можно постепенно развивать до полноценного ЯП.

## Что нового в этой версии

Добавлено больше функционала:

- переменные: `пусть` / `let`
- изменение переменных: `x = x + 1`
- вывод: `выведи` / `print`
- условия: `если` / `if`
- ветка иначе: `иначе` / `else`
- циклы: `пока` / `while`
- числа
- строки
- булевые значения: `истина` / `true`, `ложь` / `false`
- арифметика: `+`, `-`, `*`, `/`, `%`
- сравнения: `>`, `>=`, `<`, `<=`, `==`, `!=`
- логика: `и` / `and`, `или` / `or`, `не` / `not`
- скобки в выражениях
- комментарии через `#`
- встроенные функции:
  - `длина()` / `len()`
  - `строка()` / `str()`
  - `число()` / `num()`
- проверка памяти через `--mem`

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

## Структура проекта

```text
pomidor-c-advanced/
│
├── src/
│   └── main.c
│
├── examples/
│   ├── simple_ru.pom
│   ├── simple_en.pom
│   ├── advanced_ru.pom
│   └── advanced_en.pom
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

Команды:

```bash
cmake -S . -B build
cmake --build build --config Release
```

Запуск:

```bash
build\Release\pomidor.exe examples\advanced_ru.pom
```

Проверка памяти:

```bash
build\Release\pomidor.exe --mem examples\advanced_ru.pom
```

## Сборка на Linux/macOS

```bash
cmake -S . -B build
cmake --build build
./build/pomidor examples/advanced_ru.pom
```

Проверка памяти:

```bash
./build/pomidor --mem examples/advanced_ru.pom
```

В конце должно быть примерно так:

```text
[memory] allocations: 92, frees: 92, alive: 0
```

`alive: 0` означает, что в этом запуске не осталось неудалённой памяти.

## Установка

```bash
cmake --install build --prefix install
```

После этого исполняемый файл будет здесь:

```text
install/bin/pomidor
```

На Windows:

```text
install/bin/pomidor.exe
```

## Как заменить старую версию в репозитории

1. Скачай архив.
2. Распакуй его.
3. Скопируй файлы в свой репозиторий `pomidor-c`.
4. Выполни:

```bash
git add .
git commit -m "Add conditions loops and expressions"
git push
```

## Что добавить следующим этапом

Следующие крупные функции:

- функции пользователя:

```pomidor
функция привет(имя) {
    выведи "Привет, " + имя
}
```

- массивы:

```pomidor
пусть числа = [1, 2, 3]
```

- импорт файлов:

```pomidor
импорт "math.pom"
```

- нормальный AST
- разделение `main.c` на `lexer.c`, `parser.c`, `interpreter.c`
- установщик для Windows
- расширение VS Code с подсветкой `.pom`
