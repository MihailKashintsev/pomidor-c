# Pomidor Language

Pomidor is a small experimental programming language written in C.
It supports Russian and English commands.

## Examples

Russian:

```pomidor
пусть имя = "Михаил"
выведи "Привет, " + имя
```

English:

```pomidor
let name = "Render"
print "Hello, " + name
```

## Build

### Windows with CMake

```bash
cmake -S . -B build
cmake --build build --config Release
```

Run:

```bash
build\Release\pomidor.exe examples\hello_ru.pom
```

### Linux/macOS

```bash
cmake -S . -B build
cmake --build build
./build/pomidor examples/hello_en.pom
```

## Install locally

```bash
cmake --install build --prefix install
```

Then add `install/bin` to PATH.

## Memory checking

### GCC/Clang AddressSanitizer

```bash
cmake -S . -B build-asan -DCMAKE_C_FLAGS="-fsanitize=address -g"
cmake --build build-asan
./build-asan/pomidor examples/hello_ru.pom
```

### Valgrind on Linux

```bash
valgrind --leak-check=full ./build/pomidor examples/hello_ru.pom
```

## Current features

- `пусть` / `let`
- `выведи` / `print`
- numbers
- strings
- variables
- `+` for numbers and strings
- comments with `#`

## Planned features

- `если` / `if`
- `иначе` / `else`
- `пока` / `while`
- functions
- arrays
- modules
