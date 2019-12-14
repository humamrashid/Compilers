#!/usr/bin/ruby
# Parser for toy language.
# Humam Rashid
# CISC 7120X, Fall 2019.
#
# Design partially based on L. Wrobel's 'Math Parser' and
# A. Holub's 'Compiler Design in C' chapter 1.
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
#
# In this implementation, some productions are combined
# together in one method. Right-recursions are also replaced
# with loops.

require_relative 'toy_lexer'

# Exception type specific to the parser.
class ParserException < StandardError
end

# A parser is an instance of class Parser.
class Parser
  def parse(input)
    if input != "\n"
      @lexer = Lexer.new(input)
      assignment
    end
  end

  # Prints out assignment values in order of entry.
  def print_vals
    @@symtab.each {|k,v| puts "#{k} = #{v}"}
  end

  protected

  # Symbol table for assignments.
  @@symtab = {}

  # Assignment -> Identifier = Exp;
  def assignment
    reached_eoi = false
    while !reached_eoi do
      ident = @lexer.match_and_value?([Token::IDENTIFIER])
      raise ParserException,
        'Identifier expected!' if ident.nil?
      @lexer.advance
      raise ParserException,
        'Equal sign expected!'
          if !@lexer.match?([Token::EQUAL])
      @lexer.advance
      exp_val = expression()
      @@symtab[ident] = exp_val
      raise ParserException,
        'Semicolon Missing!'
          if !@lexer.match?([Token::SEMI])
      @lexer.advance
      reached_eoi = @lexer.match?([Token::EOI])
      puts @@symtab
    end
  end

  # Exp -> Term ExpPrime
  # ExpPrime -> e | + Term ExpPrime | - Term ExpPrime
  # The above productions are combined together in this
  # method.
  def expression
    temp1 = term()
    add_ops = [Token::PLUS, Token::MINUS]
    while !(token_type =
        @lexer.match_and_type?(add_ops)).nil? do
      @lexer.advance
      temp2 = term()
      temp1 += (token_type == Token::PLUS) ? temp2 : -temp2
    end
    temp1
  end

  # Term -> Fact TermPrime
  # TermPrime -> e | * Fact TermPrime
  # The above productions are combined together in this
  # method.
  def term
    temp1 = fact()
    mult_ops = [Token::TIMES]
    while !(token_type =
        @lexer.match_and_type?(mult_ops)).nil? do
      @lexer.advance
      temp2 = fact()
      temp1 *= temp2
    end
    temp1
  end

  # Fact -> ( Exp ) | - Fact | + Fact | Literal | Identifier
  def fact
    add_ops = [Token::PLUS, Token::MINUS]
    if @lexer.match?([Token::L_PAREN])
      @lexer.advance
      temp1 = expression()
      raise ParserException,
        'Mismatched parenthesis!'
          if !@lexer.match?([Token::R_PAREN])
      @lexer.advance
    elsif !(token_type =
        @lexer.match_and_type?(add_ops)).nil?
      @lexer.advance
      temp2 = fact()
      temp1 += (token_type == Token::PLUS) ? temp2 : -temp2
    else
      rhs = [Token::INT_LITERAL, Token::IDENTIFIER]
      both = @lexer.match_and_both?(rhs)
      raise ParserException,
        'Literal or identifier expected!' if both.nil?
      token_type, token_value = both[0], both[1]
      if token_type == Token::INT_LITERAL
        temp1 = token_value
      else
        temp1 = @@symtab[token_value]
        raise ParserException,
          "#{token_value} is uninitialized!" if temp1.nil?
      end
      @lexer.advance
    end
    temp1
  end

end

# EOF.
