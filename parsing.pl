#!/usr/bin/env perl

# Attempt to apply the learnings of "Create a Lisp in C" to the language I know best
# How hard can it be? :)

use strict;
use warnings;
use feature 'say';

say "Plisp - Lisp in Perl";

# REPL me up!
prompt();

sub prompt {
    print "\nPlisp> ";

    my $input = <>;
    exit unless $input;
    chomp $input;
    say input_eval($input);
    prompt();
}

sub input_eval {
    my $line = shift;
    $line;
}
