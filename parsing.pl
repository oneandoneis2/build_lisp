#!/usr/bin/env perl

# Attempt to apply the learnings of "Create a Lisp in C" to the language I know best
# How hard can it be? :)

use strict;
use warnings;
use feature 'say';

say "Plisp - Lisp in Perl";

# REPL me up!
while (<>) {
    chomp;
    my $line = $_;

    say "Your input was: '$line'...";
}
