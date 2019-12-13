#!/usr/bin/ruby
# Parser for toy language.
# Humam Rashid
# CISC 7120X, Fall 2019.
#
# This file includes the Parser class.
#
# Grammar for toy language with left-recursion removed.
#
# Let e = epsilon, then:
#
# Program       -> Assignment*
# Assignment    -> Identifier = Exp;
# Exp           -> Term ExpPrime
# ExpPrime      -> e | + Term ExpPrime | - Term ExpPrime
# Term          -> Fact TermPrime
# TermPrime     -> e | * Fact TermPrime
# Fact          -> ( Exp ) | - Fact | + Fact | Literal | Identifier
# Identifier    -> Letter [ Letter | Digit ]*
# Letter        -> a | ... | z | A | ... | Z | _
# Literal       -> 0 | NonZeroDigit Digit*
# NonZeroDigit  -> 1 | ... | 9
# Digit         -> 0 | 1 | ... | 9

require_relative 'toy_lexer'

class ParserException < StandardError
end

class Parser
  def parse(input)
      @lexer = Lexer.new(input)
      assignments
  end

  protected

  def assignments
    matching, value = @lexer.match?(Token::IDENTIFIER)
    if matching
      puts value
    end
    @lexer.advance
    matching, value = @lexer.match?(Token::EQUAL)
    if matching
      puts value
    end
  end

  def expression
    term
    expression_prime
  end

  def expression_prime
    if @lexer.match?(Token::PLUS) ||
        @lexer.match?(Token::MINUS)
      @lexer.advance
      term
      expression_prime
    end
  end

  def term
    fact
    term_prime
  end

  def term_prime
    if @lexer.match?(Token::TIMES)
      @lexer.advance
      fact
      term_prime
    end
  end

  def fact
    if @lexer.match?(Token::L_PAREN)
      @lexer.advance
      expression
      if @lexer.match?(Token::R_PAREN)
        @lexer.advance
      end
    elsif @lexer.match?(Token::PLUS) ||
      @lexer.match?(Token::MINUS)
      @lexer.advance
      fact
    elsif @lexer.match?(Token::INT_LITERAL)
      @lexer.advance
    elsif @lexer.match?(Token::IDENTIFIER)
      @lexer.advance
    end
  end
end

# EOF.
