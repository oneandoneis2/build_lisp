#include <stdio.h>
#include <stdlib.h>
#include "mpc.h"

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
    // Create some parsers
    mpc_parser_t* Number    = mpc_new("number");
    mpc_parser_t* Operator  = mpc_new("operator");
    mpc_parser_t* Expr      = mpc_new("expr");
    mpc_parser_t* Lispy     = mpc_new("lispy");

    // Define them
    mpca_lang(MPCA_LANG_DEFAULT,
        "                                                           \
            number      : /-?[0-9]+/ ;                              \
            operator    : '+' | '-' | '*' | '/' ;                   \
            expr        : <number> | '(' <operator> <expr>+ ')' ;   \
            lispy       : /^/ <operator> <expr>+ /$/ ;              \
        ",
        Number, Operator, Expr, Lispy);

    puts("Lispy version 0.0.0.0.1");
    puts("Press Ctrl+c to Exit");

    while (1) {
        // Prompt & save input
        char* input = readline("\nlispy> ");

        // Save to history
        add_history(input);

        // Attempt to parse input
        mpc_result_t r;
        if (mpc_parse("<stdin>", input, Lispy, &r)) {
            // Success! Print AST
            mpc_ast_print(r.output);
            mpc_ast_delete(r.output);
        } else {
            // Failure :( Print the error
            mpc_err_print(r.error);
            mpc_err_delete(r.error);
        }

        // Free up input
        free(input);
    }

    mpc_cleanup(4, Number, Operator, Expr, Lispy);

    return 0;
}
