#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    VALUE_NUMBER,
    VALUE_STRING
} ValueType;

typedef struct {
    ValueType type;
    double number;
    char *string;
} Value;

typedef struct {
    char *name;
    Value value;
} Variable;

typedef struct {
    Variable *items;
    size_t count;
    size_t capacity;
} Environment;

static char *pom_strdup(const char *src) {
    size_t len = strlen(src);
    char *copy = (char *)malloc(len + 1);
    if (!copy) {
        fprintf(stderr, "Pomidor: out of memory\n");
        exit(1);
    }
    memcpy(copy, src, len + 1);
    return copy;
}

static void value_free(Value *value) {
    if (value->type == VALUE_STRING) {
        free(value->string);
        value->string = NULL;
    }
}

static Value value_number(double number) {
    Value value;
    value.type = VALUE_NUMBER;
    value.number = number;
    value.string = NULL;
    return value;
}

static Value value_string(const char *text) {
    Value value;
    value.type = VALUE_STRING;
    value.number = 0;
    value.string = pom_strdup(text);
    return value;
}

static Value value_clone(const Value *source) {
    if (source->type == VALUE_STRING) {
        return value_string(source->string);
    }
    return value_number(source->number);
}

static void env_init(Environment *env) {
    env->items = NULL;
    env->count = 0;
    env->capacity = 0;
}

static void env_free(Environment *env) {
    for (size_t i = 0; i < env->count; i++) {
        free(env->items[i].name);
        value_free(&env->items[i].value);
    }
    free(env->items);
    env->items = NULL;
    env->count = 0;
    env->capacity = 0;
}

static Variable *env_find(Environment *env, const char *name) {
    for (size_t i = 0; i < env->count; i++) {
        if (strcmp(env->items[i].name, name) == 0) {
            return &env->items[i];
        }
    }
    return NULL;
}

static void env_set(Environment *env, const char *name, Value value) {
    Variable *existing = env_find(env, name);
    if (existing) {
        value_free(&existing->value);
        existing->value = value;
        return;
    }

    if (env->count == env->capacity) {
        size_t new_capacity = env->capacity == 0 ? 8 : env->capacity * 2;
        Variable *new_items = (Variable *)realloc(env->items, new_capacity * sizeof(Variable));
        if (!new_items) {
            value_free(&value);
            fprintf(stderr, "Pomidor: out of memory\n");
            exit(1);
        }
        env->items = new_items;
        env->capacity = new_capacity;
    }

    env->items[env->count].name = pom_strdup(name);
    env->items[env->count].value = value;
    env->count++;
}

static char *read_file(const char *path) {
    FILE *file = fopen(path, "rb");
    if (!file) {
        fprintf(stderr, "Pomidor: cannot open file: %s\n", path);
        return NULL;
    }

    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    rewind(file);

    if (length < 0) {
        fclose(file);
        fprintf(stderr, "Pomidor: cannot read file size\n");
        return NULL;
    }

    char *buffer = (char *)malloc((size_t)length + 1);
    if (!buffer) {
        fclose(file);
        fprintf(stderr, "Pomidor: out of memory\n");
        return NULL;
    }

    size_t read = fread(buffer, 1, (size_t)length, file);
    buffer[read] = '\0';
    fclose(file);
    return buffer;
}

static char *trim(char *text) {
    while (isspace((unsigned char)*text)) {
        text++;
    }

    if (*text == '\0') {
        return text;
    }

    char *end = text + strlen(text) - 1;
    while (end > text && isspace((unsigned char)*end)) {
        *end = '\0';
        end--;
    }

    return text;
}

static int starts_with_word(const char *line, const char *word) {
    size_t len = strlen(word);
    if (strncmp(line, word, len) != 0) {
        return 0;
    }
    char next = line[len];
    return next == '\0' || isspace((unsigned char)next);
}

static int is_number_text(const char *text) {
    if (*text == '-' || *text == '+') {
        text++;
    }
    int has_digit = 0;
    while (*text) {
        if (isdigit((unsigned char)*text)) {
            has_digit = 1;
        } else if (*text != '.') {
            return 0;
        }
        text++;
    }
    return has_digit;
}

static Value eval_expression(Environment *env, const char *expression);

static Value eval_simple(Environment *env, char *text) {
    text = trim(text);

    size_t len = strlen(text);
    if (len >= 2 && text[0] == '"' && text[len - 1] == '"') {
        text[len - 1] = '\0';
        return value_string(text + 1);
    }

    if (is_number_text(text)) {
        return value_number(strtod(text, NULL));
    }

    Variable *var = env_find(env, text);
    if (!var) {
        fprintf(stderr, "Pomidor: unknown variable: %s\n", text);
        return value_number(0);
    }

    return value_clone(&var->value);
}

static Value value_add(Value left, Value right) {
    if (left.type == VALUE_NUMBER && right.type == VALUE_NUMBER) {
        double result = left.number + right.number;
        value_free(&left);
        value_free(&right);
        return value_number(result);
    }

    char left_buffer[64];
    char right_buffer[64];
    const char *left_text = left.type == VALUE_STRING ? left.string : left_buffer;
    const char *right_text = right.type == VALUE_STRING ? right.string : right_buffer;

    if (left.type == VALUE_NUMBER) {
        snprintf(left_buffer, sizeof(left_buffer), "%g", left.number);
    }
    if (right.type == VALUE_NUMBER) {
        snprintf(right_buffer, sizeof(right_buffer), "%g", right.number);
    }

    size_t total = strlen(left_text) + strlen(right_text) + 1;
    char *joined = (char *)malloc(total);
    if (!joined) {
        value_free(&left);
        value_free(&right);
        fprintf(stderr, "Pomidor: out of memory\n");
        exit(1);
    }

    strcpy(joined, left_text);
    strcat(joined, right_text);

    value_free(&left);
    value_free(&right);

    Value result;
    result.type = VALUE_STRING;
    result.number = 0;
    result.string = joined;
    return result;
}

static char *find_plus_outside_string(char *text) {
    int inside_string = 0;
    for (char *p = text; *p; p++) {
        if (*p == '"') {
            inside_string = !inside_string;
        } else if (*p == '+' && !inside_string) {
            return p;
        }
    }
    return NULL;
}

static Value eval_expression(Environment *env, const char *expression) {
    char *copy = pom_strdup(expression);
    char *plus = find_plus_outside_string(copy);

    if (plus) {
        *plus = '\0';
        Value left = eval_expression(env, copy);
        Value right = eval_expression(env, plus + 1);
        free(copy);
        return value_add(left, right);
    }

    Value result = eval_simple(env, copy);
    free(copy);
    return result;
}

static void print_value(Value value) {
    if (value.type == VALUE_STRING) {
        printf("%s\n", value.string);
    } else {
        printf("%g\n", value.number);
    }
    value_free(&value);
}

static void execute_line(Environment *env, char *line, int line_number) {
    char *clean = trim(line);

    if (*clean == '\0' || *clean == '#') {
        return;
    }

    if (starts_with_word(clean, "print")) {
        char *expr = trim(clean + strlen("print"));
        print_value(eval_expression(env, expr));
        return;
    }

    if (starts_with_word(clean, "выведи")) {
        char *expr = trim(clean + strlen("выведи"));
        print_value(eval_expression(env, expr));
        return;
    }

    if (starts_with_word(clean, "let") || starts_with_word(clean, "пусть")) {
        char *rest = starts_with_word(clean, "let")
            ? trim(clean + strlen("let"))
            : trim(clean + strlen("пусть"));

        char *equals = strchr(rest, '=');
        if (!equals) {
            fprintf(stderr, "Pomidor line %d: expected '='\n", line_number);
            return;
        }

        *equals = '\0';
        char *name = trim(rest);
        char *expr = trim(equals + 1);

        if (*name == '\0') {
            fprintf(stderr, "Pomidor line %d: expected variable name\n", line_number);
            return;
        }

        env_set(env, name, eval_expression(env, expr));
        return;
    }

    char *equals = strchr(clean, '=');
    if (equals) {
        *equals = '\0';
        char *name = trim(clean);
        char *expr = trim(equals + 1);
        env_set(env, name, eval_expression(env, expr));
        return;
    }

    fprintf(stderr, "Pomidor line %d: unknown command: %s\n", line_number, clean);
}

static int run_code(const char *code) {
    Environment env;
    env_init(&env);

    char *copy = pom_strdup(code);
    char *line = strtok(copy, "\n");
    int line_number = 1;

    while (line) {
        execute_line(&env, line, line_number);
        line = strtok(NULL, "\n");
        line_number++;
    }

    free(copy);
    env_free(&env);
    return 0;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Pomidor Language\n");
        printf("Usage: pomidor file.pom\n");
        return 0;
    }

    char *code = read_file(argv[1]);
    if (!code) {
        return 1;
    }

    int result = run_code(code);
    free(code);
    return result;
}
