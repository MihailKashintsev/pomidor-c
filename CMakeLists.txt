cmake_minimum_required(VERSION 3.15)
project(pomidor C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(pomidor src/main.c)

if (MSVC)
    target_compile_options(pomidor PRIVATE /W4)
else()
    target_compile_options(pomidor PRIVATE -Wall -Wextra -pedantic)
endif()

install(TARGETS pomidor RUNTIME DESTINATION bin)
