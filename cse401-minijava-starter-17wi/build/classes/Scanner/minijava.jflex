/*
 * JFlex specification for the lexical analyzer for a simple demo language.
 * Change this into the scanner for your implementation of MiniJava.
 * CSE 401/P501 Au11
 */


package Scanner;

import java_cup.runtime.*;
import Parser.sym;


%%

%public
%final
%class scanner
%unicode
%cup
%line
%column

/* Code copied into the generated scanner class.  */
/* Can be referenced in scanner action code. */
%{
  // Return new symbol objects with line and column numbers in the symbol 
  // left and right fields. This abuses the original idea of having left 
  // and right be character positions, but is   // is more useful and 
  // follows an example in the JFlex documentation.
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }

  // Return a readable representation of symbol s (aka token)
  public String symbolToString(Symbol s) {
    String rep;
    switch (s.sym) {
      case sym.LBRACE: return "LBRACE";
      case sym.RBRACE: return "RBRACE";
      case sym.LFREEBRACE: return "LFREEBRACE";
      case sym.RFREEBRACE: return "RFREEBRACE";
      case sym.LPAREN: return "LPAREN";
      case sym.RPAREN: return "RPAREN";
      case sym.COMMA: return "COMMA";
      case sym.PERIOD: return "PERIOD";
      case sym.SEMICOLON: return "SEMICOLON";
      case sym.IDENTIFIER: return "ID(" + (String)s.value + ")";
      case sym.INTEGERLITERAL: return "INT(" + (String) s.value + ")";
      case sym.DOUBLELITERAL: return "DOUBLE(" + (String) s.value + ")";
      case sym.PUBLIC: return "PUBLIC";
      case sym.MAIN: return "MAIN";
      case sym.CLASS: return "CLASS";
      case sym.EXTENDS: return "EXTENDS";
      case sym.INTTYPE: return "INTTYPE";
      case sym.DOUBLETYPE: return "DOUBLETYPE";
      case sym.BOOLEANTYPE: return "BOOLEANTYPE";
      case sym.LENGTH: return "LENGTH";
      case sym.NEW: return "NEW";
      case sym.RETURN: return "RETURN";
      case sym.THIS: return "THIS";
      case sym.TRUE: return "TRUE";
      case sym.FALSE: return "FALSE";
      case sym.IF: return "IF";
      case sym.ELSE: return "ELSE";
      case sym.WHILE: return "WHILE";
      case sym.PRINTLN: return "PRINTLN";
      case sym.AND: return "AND";
      case sym.BECOMES: return "BECOMES";
      case sym.LT: return "LT";
      case sym.MINUS: return "MINUS";
      case sym.TIMES: return "TIMES";
      case sym.PLUS: return "PLUS";
      case sym.BANG: return "BANG";

      case sym.EOF: return "<EOF>";
      case sym.error: return "<ERROR>";
      default: return "<UNEXPECTED TOKEN " + s.toString() + ">";
    }
  }
%}

/* Helper definitions */
letter = [a-zA-Z]
digit = [0-9]
eol = [\r\n]
white = {eol}|[ \t]
commentchar = ({letter}|{digit}|{white}|[^\/\*])

%%

/* Token definitions */

/* reserved words */
/* (put here so that reserved words take precedence over identifiers) */

"public" { return symbol(sym.PUBLIC); }
"public"{white}+"static"{white}+"void"{white}+"main"{white}*"("{white}*"String"{white}*"["{white}*"]" { return symbol(sym.MAIN); }
// {white}+"\["{white}+"\]" { return symbol(sym.MAIN); }
"class" { return symbol(sym.CLASS); }
"extends" { return symbol(sym.EXTENDS); }
"int" { return symbol(sym.INTTYPE); }
"double" { return symbol(sym.DOUBLETYPE); }
"boolean" { return symbol(sym.BOOLEANTYPE); }
"if" { return symbol(sym.IF); }
"else" { return symbol(sym.ELSE); }
"while" { return symbol(sym.WHILE); }
"System.out.println" { return symbol(sym.PRINTLN); }
"length" { return symbol(sym.LENGTH); }
"new" { return symbol(sym.NEW); }
"return" { return symbol(sym.RETURN); }
"this" { return symbol(sym.THIS); }
"true" { return symbol(sym.TRUE); }
"false" { return symbol(sym.FALSE); }

/* operators */
"+" { return symbol(sym.PLUS); }
"=" { return symbol(sym.BECOMES); }
"&&" { return symbol(sym.AND); }
"<" { return symbol(sym.LT); }
"-" { return symbol(sym.MINUS); }
"*" { return symbol(sym.TIMES); }
"!" { return symbol(sym.BANG); }

/* delimiters */
"[" { return symbol(sym.LBRACE); }
"]" { return symbol(sym.RBRACE); }
"{" { return symbol(sym.LFREEBRACE); }
"}" { return symbol(sym.RFREEBRACE); }
"(" { return symbol(sym.LPAREN); }
")" { return symbol(sym.RPAREN); }
";" { return symbol(sym.SEMICOLON); }
"," { return symbol(sym.COMMA); }
"." { return symbol(sym.PERIOD); }

/* identifiers */
{letter} ({letter}|{digit}|_)* { return symbol(sym.IDENTIFIER, yytext()); }

/* integer literal */
([1-9]({digit})*|0) { return symbol(sym.INTEGERLITERAL, yytext()); } 

/* double literal */
([1-9]({digit})*|0)\.?({digit}*)?(e|E)?-?{digit}* { return symbol(sym.DOUBLELITERAL, yytext()); }

/* whitespace */
{white}+ { /* ignore whitespace */ }

/* comments */
\/\/({letter}|{digit}|[ \t]|_|.|,)*{eol} { /* ignore comments */ }
\/\*({commentchar}|\**{commentchar}|\/)*\*+\/ { /* ignore comments */ }

/* lexical errors (put last so other matches take precedence) */
. {  System.err.println(
               "Unexpected non-MiniJava symbol in input: '" + yytext() +
               "' at line " + (yyline+1) + " column " + (yycolumn+1) );
     ScannerErrorHandler.handleScannerError(); }
