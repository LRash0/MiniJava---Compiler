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
  
  private List<Log> log = new LinkedList<Log>();
  
  public List<Log> getLogs(){
  	return log;
  }
  
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
LETTER = [a-zA-Z]
DIGIT = [0-9]
eol = [\r\n|\r|\n]
WHITE = {eol}|[ \t]
INTEGER_LITERAL = 0 | [1-9][0-9]*
IDENTIFIER = {LETTER}({LETTER}|{DIGIT}|_)*

/* COMENTARIOS */
COMMENT_SIMPLELINE = "//" [^\r\n] * {eol}?
COMMENT_MULTLINE = "/*" [^*] ~"*/" | "*/*" "*"+ "/"
COMMENT_JAVADOC = "/*" "*"+ [^/*] ~"*/"
COMMENT = {COMMENT_MULTLINE} | {COMMENT_SIMPLELINE} | {COMMENT_JAVADOC}


%%

/* Token definitions */

/* reserved words */
/* (put here so that reserved words take precedence over identifiers) */
"return" 				{ 	return 	symbol(sym.WORD_RETURN); 		}
"class"  				{ 	return 	symbol(sym.WORD_CLASS);  		}
"public" 				{	return 	symbol(sym.WORD_PUBLIC);		}
"static"				{	return	symbol(sym.WORD_STATIC);		}
"void" 					{	return 	symbol(sym.WORD_VOID);			}
"main"					{	return 	symbol(sym.WORD_MAIN);			}
"extends"				{	return 	symbol(sym.WORD_EXTENDS);		}
"this"					{	return 	symbol(sym.WORD_THIS);			}
"new"					{	return 	symbol(sym.WORD_NEW);			}
"length"				{	return 	symbol(sym.WORD_LENGTH);		}
"System.out.println"	{	return 	symbol(sym.WORD_PRINTLN);		}


/* Tipo de dados*/

"int"		{	return 	symbol(sym.TYPE_INT);		}
"boolean" 	{	return 	symbol(sym.TYPE_BOOL);		}
"String"	{	return 	symbol(sym.TYPE_STRING);	}

/* Condicionais */

"if" 	{	return 	symbol(sym.COND_IF);	}
"else"	{	return 	symbol(sym.COND_ELSE);	}
"while"	{	return 	symbol(sym.COND_WHILE);	}

/* Valores booleanos */

"true"	{	return 	symbol(sym.BOOL_LITERAL, new Boolean(true));	}
"false"	{	return 	symbol(sym.BOOL_LITERAL, new Boolean(false));	}

/* Identificadores */

{IDENTIFIER}		{	return symbol(sym.IDENTIFIER, yytext());					}
{INTEGER_LITERAL}	{ 	return symbol(sym.INTEGER_LITERAL, new Integer(yytext())); 	}

/*Linhas em branco*/

{WHITE}+ { /* Pular espaco em branco */ }

/* Ignorar comentarios */

{COMMENT} { /* Ignorar comentarios */}


/* operators */

"+"  { return symbol(sym.OPC_PLUS); 		}
"-"  { return symbol(sym.OPC_MINUS);		}
"="  { return symbol(sym.OPC_EQUAL); 		}
"!"  { return symbol(sym.OPC_NOT);			}
"*"  { return symbol(sym.OPC_MULT);			}
"&&" { return symbol(sym.OPC_AND);			}
"<"	 { return symbol(sym.OPC_LT);			}

/* Separadores */
"(" { return symbol(sym.SEP_LPAREN); 	}
")" { return symbol(sym.SEP_RPAREN); 	}
";" { return symbol(sym.SEP_SEMICOLON); }
","	{ return symbol(sym.SEP_COMMA);		}
"." { return symbol(sym.SEP_DOT);		}
"{" { return symbol(sym.SEP_LBRACE);	}
"}" { return symbol(sym.SEP_RBRACE);	}
"[" { return symbol(sym.SEP_LBRACK);	}
"]"	{ return symbol(sym.SEP_RBRACK);	}


/* lexical errors (put last so other matches take precedence) */
.|\n { throw new LexicalCompilerException(
	"unexpected character in input: '" + yytext() + "'", 
	yyline+1, yycolumn+1);
	log.add(new LexicalLog(yytext(),yyline,yycolumn));
  }
