#!/usr/bin/env perl

# Attempt to apply the learnings of "Create a Lisp in C" to the language I know best
# How hard can it be? :)

use strict;
use warnings;
use feature 'say';
use Data::Dumper;

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
    my $tokens = tokenize($line);
    return Dumper parse($tokens);
}

sub tokenize {
    my $line = shift;
    my @chars = ($line =~ /./g);
    my $index = 0;

    my $ast = get_tokens(\@chars, \$index, [], '');
    return $ast;
}

sub get_tokens {
    my ($chars, $index, $ast, $word) = @_;

    while ($$index < @$chars) {
        my $char = $chars->[$$index];
        $$index++;

        if ($char eq '(') {
            push @$ast, get_tokens($chars, $index, [], '');
        }
        elsif ($char eq ')') {
            if ($word) {
                push @$ast, $word;
                $word = '';
            }
            return $ast;
        }
        elsif ($char =~ /\s/) {
            if ($word) {
                push @$ast, $word;
                $word = '';
            }
        }
        else {
            $word .= $char;
        }
    }
    push @$ast, $word if $word;
    return $ast;
}

sub parse {
    my $tokens = shift;
    my $tree = [];
    for my $i (@$tokens) {
        if (ref $i eq 'ARRAY') {
            push @$tree, {expr => parse($i) };
        }
        else {
            if ($i =~ /\+|-|\*|\//) {
                push @$tree, { op => $i }
            }
            elsif ($i =~ /\d+(\.\d+)?/) {
                push @$tree, { num => $i }
            }
            else {
                push @$tree, { symbol => $i }
            }
        }
    }
    return $tree;
}
