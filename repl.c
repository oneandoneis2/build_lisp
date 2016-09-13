#include <stdio.h>
#include <stdlib.h>

// If compiling under Windows:
#ifdef _WIN32
#include <string.h>

static char buffer[2048];

// Fake readline function
char* readline(char* prompt) {
    fputs(prompt, stdout);
    fgets(buffer, 2048, stdin);
    char* cpy = malloc(strlen(buffer)+1);
    strcpy(cpy, buffer);
    cpy[strlen(cpy)-1] = '\0';
    return cpy;
}

// Fake history
void add_history(char* unused) {}

#else
#include <editline/readline.h>
#include <editline/history.h>
#endif

int main(int argc, char** argv) {
    puts("Lispy version 0.0.0.0.1");
    puts("Press Ctrl+c to Exit");

    while (1) {
        // Prompt & save input
        char* input = readline("\nlispy> ");

        // Save to history
        add_history(input);

        // Echo
        printf("You said: %s\n", input);

        // Free up input
        free(input);
    }
    return 0;
}
