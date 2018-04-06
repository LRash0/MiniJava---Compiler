/*
 * JFlex specification for the lexical analyzer for a simple demo language
 * Change this into the scanner for your implementation of MiniJava.
 */


package Scanner;

import java_cup.runtime.*;
import Parser.sym;
import Throwables.*;

%%

%public
%final
%class scanner
%yylexthrow CompilerException
%unicode
%cup
%line
%column

%{
  // note that these Symbol constructors are abusing the Symbol
  // interface to use Symbol's left and right fields as line and column
  // fields instead
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }

  // print out a symbol (aka token) nicely
  public String symbolToString(Symbol s) {
    switch (s.sym) {
      case sym.BECOMES: return "BECOMES";
      case sym.SEMICOLON: return "SEMICOLON";
      case sym.PLUS: return "PLUS";
      case sym.LPAREN: return "LPAREN";
      case sym.RPAREN: return "RPAREN";
      case sym.RETURN: return "RETURN";
      case sym.IDENTIFIER: return "ID(" + (String)s.value + ")";
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


/* COMENTARIOS */
COMMENT_SIMPLELINE = "//" [^\r\n] * {eol}?
COMMENT_MULTLINE = "/*" [^*] ~"*/" | "*/" "*"+ "/"
COMMENT_JAVADOC = "/*" "*"+ [^/*] ~"*/"
COMMENT = {COMMENT_MULTLINE} | {COMMENT_SIMPLELINE} | {COMMENT_JAVADOC}


%%

/* Token definitions */

/* reserved words */
/* (put here so that reserved words take precedence over identifiers) */
"return" 				{ 	return 	symbol(sym.RETURN); 	}
"class"  				{ 	return 	symbol(sym.CLASS);  	}
"public" 				{	return 	symbol(sym.PUBLIC);		}
"static"				{	return	symbol(sym.STATIC);		}
"void" 					{	return 	symbol(sym.VOID);		}
"main"					{	return 	symbol(sym.MAIN);		}
"extends"				{	return 	symbol(sym.EXTENDS);	}
"this"					{	return 	symbol(sym.THIS);		}
"new"					{	return 	symbol(sym.NEW);		}
"length"				{	return 	symbol(sym.LENGTH);		}
"System.out.println"	{	return 	symbol(sym.PRINTLN);	}

/* Tipo de dados*/
"int"		{	return 	symbol(sym.TYPE_INT);		}
"boolean" 	{	return 	symbol(sym.TYPE_BOOL);		}
"string"	{	return 	symbol(sym.TYPE_STRING);	}

/* Condicionais */
"if" 	{	return 	symbol(sym.COND_IF);	}
"else"	{	return 	symbol(sym.COND_ELSE);	}
"while"	{	return 	symbol(sym.COND_WHILE);	}

/* Valores booleanos */
"true"	{	return 	symbol(sym.BOOL_LITERAL, new Boolean(true));	}
"false"	{	return 	symbol(sym.BOOL_LITERAL, new Boolean(false));	}

/* Identificadores */
{IDENTIFIER}		{	return symbol(sym.IDENTIFIER, yytext());					}
{INTEGER_LITERAL}	{ 	return symbol(sys.INTEGER_LITERAL, new Integer(yytext())); 	}

/*Linhas em branco*/
{WHITE}+ { /* Pular espaco em branco */ }

/* Ignorar comentarios */
{COMMENT} { /* Ignorar comentarios */}


/* operators */
"+" { return symbol(sym.PLUS); 		}
"-" { return symbol(sym.MINUS);		}
"=" { return symbol(sym.EQUAL); 	}
"!" { return symbol(sym.NOT);		}
"*" { return symbol(sym.MULT);		}
"&&"{ return symbol(sym.AND);		}
"<"	{ return symbol(sym.LT);		}

/* Separadorez */
"(" { return symbol(sym.LPAREN); 	}
")" { return symbol(sym.RPAREN); 	}
";" { return symbol(sym.SEMICOLON); }
","	{ return symbol(sym.COMMA);		}
"." { return symbol(sym.DOT);		}
"{" { return symbol(sym.LBRACE);	}
"}" { return symbol(sym.RBRACE);	}
"[" { return symbol(sym.LBRACK);	}
"]"	{ return symbol(sym.RBRACK);	}


/* lexical errors (put last so other matches take precedence) */
. { throw new LexicalCompilerException(
	"unexpected character in input: '" + yytext() + "'", 
	yyline+1, yycolumn+1);
  }
