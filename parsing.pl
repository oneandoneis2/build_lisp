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
    # Prompt for input
    print "\nPlisp> ";

    my $input = <>;
    exit unless $input;
    chomp $input;
    input_eval($input);
    prompt();
}

sub input_eval {
    # Print results of evaluating input
    my $line = shift;
    # Split input up into tokens
    my $tokens = tokenize($line);
    # Turn tokens into proper AST
    my $ast = parse($tokens);
    # Print the results of evaluating the AST(s)
    for my $tree (@$ast) {
        say lisp_eval($tree);
    }
}

sub tokenize {
    my $line = shift;
    # Split string into characters
    my @chars = ($line =~ /./g);
    my $index = 0;
    # Tokenize
    get_tokens(\@chars, \$index, [], undef);
}

sub get_tokens {
    my ($chars, $index, $ast, $word) = @_;

    # The actual S-expr parse!
    while ($$index < @$chars) {
        my $char = $chars->[$$index];
        $$index++;

        if ($char eq '(') {
            push @$ast, get_tokens($chars, $index, [], undef);
        }
        elsif ($char eq ')') {
            if (defined $word) {
                push @$ast, $word;
                $word = undef;
            }
            return $ast;
        }
        elsif ($char =~ /\s/) {
            if (defined $word) {
                push @$ast, $word;
                $word = undef;
            }
        }
        else {
            $word = '' unless defined $word;
            $word .= $char;
        }
    }
    push @$ast, $word if defined $word;
    return $ast;
}

sub parse {
    # Label the tokens correctly for the AST
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

sub lisp_eval {
    # The eval part of eval-apply
    # Right now, only handles calculator basics
    # Numbers & primitive maths operators - no symbols etc.
    my $exp = shift;
    my ($type) = keys %$exp;

    # Numbers are self-evaluating
    if ($type eq 'num') {
        return $exp->{num}
    }
    # If we got here, then it's an expression
    my $elems = $exp->{expr};
    my ($op, @args) = @$elems;
    return lisp_apply($op, \@args);
}

sub lisp_apply {
    # Apply - right now can only apply primitive procedures
    my ($op, $args) = @_;

    my @evald_args = map { lisp_eval($_) } @$args;

    if      ($op->{op} eq '+') { prim_add(@evald_args) }
    elsif   ($op->{op} eq '-') { prim_subtract(@evald_args) }
    elsif   ($op->{op} eq '/') { prim_divide(@evald_args) }
    elsif   ($op->{op} eq '*') { prim_multiply(@evald_args) }
}

# The primitive operators
sub prim_add        { my $total = shift; map { $total += $_ } @_; $total }
sub prim_multiply   { my $total = shift; map { $total *= $_ } @_; $total }
sub prim_subtract   { my $total = shift; map { $total -= $_ } @_; $total }
sub prim_divide     { my $total = shift; map { $total /= $_ } @_; $total }
