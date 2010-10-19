/* File: scanner.lex
 * Author: Amr Gaber
 * Created: 24/9/2010
 * Purpose: Tokenizer for parser.yacc. Used with the makefile to construct
 * 				the C-- compiler.
 */

%{
#include <string.h>
#include "y.tab.h"
extern int errorCount;
%}

%option yylineno

identifier		[a-zA-Z][a-zA-Z0-9_]*
intCon			[0-9]+
charCon			'[\x20-\x26\x28-\x5B\x5D-\x7E]'|'\\n'|'\\0'
strCon			\"[\x20\x21\x23-\x7E]*\"
comment			\x2F\x2A[\x00-\x7E]*?\x2A\x2F
wspace			[ \t\n]
catchAll		[\x00-\x7E]

/* Citation: This comment state machine was found in Flex & Bison written by 
 * John Levine, published by O'Reilly. Pages 93 & 94.
 */
%x COMMENT

%%

"/*"				{ BEGIN(COMMENT); }
<COMMENT>"*/"		{ BEGIN(INITIAL); }
<COMMENT>([^*]|\x0A)+|.
<COMMENT><<EOF>>	{ fprintf(stderr, 
							"ERROR #%d: Unexpected EOF inside comment\n",
							++errorCount);
 					  exit(1);
					}

"char"			return(CHAR);
"int"			return(INT);
"void"			return(VOID);
"if"			return(IF);
"else"			return(ELSE);
"while"			return(WHILE);
"for"			return(FOR);
"return"		return(RETURN);
"extern"		return(EXTERN);
"=="			return(DBLEQ);
"!="			return(NOTEQ);
"<="			return(LTEQ);
">="			return(GTEQ);
"&&"			return(LOGICAND);
"||"			return(LOGICOR);
";"				return(yytext[0]);
","				return(yytext[0]);
"("				return(yytext[0]);
")"				return(yytext[0]);
"["				return(yytext[0]);
"]"				return(yytext[0]);
"{"				return(yytext[0]);
"}"				return(yytext[0]);
"="				return(yytext[0]);
"+"				return(yytext[0]);
"-"				return(yytext[0]);
"*"				return(yytext[0]);
"/"				return(yytext[0]);
"!"				return(yytext[0]);
"<"				return(yytext[0]);
">"				return(yytext[0]);
{wspace}		;
{identifier}	{ yylval.str = strdup(yytext); } return(ID);
{intCon}		{ yylval.str = strdup(yytext); } return(INTCON);
{charCon}		{ yylval.str = strdup(yytext); } return(CHARCON);
{strCon}		{ yylval.str = strdup(yytext); } return(STRCON);
{catchAll}		return(OTHER);

%%
