#include <stdio.h>

/* Input buffer */
static char input[2048];

int main(int argc, char** argv) {
    puts("Lispy version 0.0.0.0.1");
    puts("Press Ctrl+c to Exit\n");

    while (1) {
        // Prompt
        fputs("\nlispy> ", stdout);

        // Read
        fgets(input, 2048, stdin);

        // Echo
        printf("You said: %s", input);
    }
    return 0;
}
