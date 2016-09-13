#include <stdio.h>
#include <stdlib.h>

#include <editline/readline.h>
#include <editline/history.h>

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
