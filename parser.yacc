/* File: parser.yacc 
 * Author: Amr Gaber
 * Created: 24/9/2010
 * Last Modified: 20/10/2010
 * Purpose: Parser for the C-- compiler. Used with scanner.lex and makefile to
 * 				construct the C-- compiler.
 */

%{
#include "symbolTable.h"
#include "utilities.h"
extern int yylineno;
extern char* yytext;
int errorCount = 0;
%}

%union
{
	int n;
	char* str;
}

%start program

%token ID INTCON CHARCON STRCON CHAR INT VOID IF ELSE WHILE	FOR	RETURN EXTERN
			UMINUS DBLEQ NOTEQ LTEQ GTEQ LOGICAND LOGICOR OTHER

%left LOGICOR
%left LOGICAND
%left DBLEQ NOTEQ
%left '<' LTEQ '>' GTEQ
%left '+' '-'
%left '*' '/'
%right '!' UMINUS

%%

program:	  program declaration ';'
			| program function
			
			/* error productions */
			| program declaration error { yyerrok; } /* missing semicolon */
			| error ';' { yyerrok; }

			| /* empty */
	    	;

declaration:  type varDcl multiVarDcl
			| EXTERN type ID '(' paramTypes ')' multiProtDcl
			| type ID '(' paramTypes ')' multiProtDcl
			| EXTERN VOID ID '(' paramTypes ')' multiProtDcl
			| VOID ID '(' paramTypes ')' multiProtDcl
			;

multiProtDcl: multiProtDcl ',' ID '(' paramTypes ')'
			| /* empty */
			;

multiVarDcl:  multiVarDcl ',' varDcl
			| /* empty */
			;

varDcl:	  	  ID 
			| ID '[' INTCON ']'
			;

type:		  CHAR
			| INT
			;

paramTypes:   VOID
			| arrayTypeOpt multiParam
			;

arrayTypeOpt: type ID
			| type ID '['']'
			;

multiParam:   multiParam ',' arrayTypeOpt
			| /* empty */
			;

function:	  type ID '(' paramTypes ')' '{' multiTypeDcl statementOpt '}'
			| VOID ID '(' paramTypes ')' '{' multiTypeDcl statementOpt '}'
			;

multiTypeDcl: multiTypeDcl type varDcl multiVarDcl ';'

			/* error productions */
			| multiTypeDcl type error ';' { yyerrok; }

			| /* empty */
			;

statement:	  IF '(' expr ')' statement
			| IF '(' expr ')' statement ELSE statement
			| WHILE '(' expr ')' statement
			| FOR '(' assgOpt ';' exprOpt ';' assgOpt ')' statement
			| RETURN expr ';'
			| RETURN ';'
			| assignment ';'
			| ID '('')'
			| ID '(' expr multiExprOpt ')' ';'
			| '{' statementOpt '}'
			| ';'

			/* error productions */
			| error ';' { yyerrok; }
			;

statementOpt: statementOpt statement
			| /* empty */
			;

assignment:	  ID '=' expr
			| ID '[' expr ']' '=' expr
			;

assgOpt:	  assignment
			| /* empty */
			;

expr:		  '-' expr %prec UMINUS
			| '!' expr
			| expr '+' expr
			| expr '-' expr
			| expr '*' expr
			| expr '/' expr
			| expr DBLEQ expr
			| expr NOTEQ expr
			| expr LTEQ expr
			| expr '<' expr
			| expr GTEQ expr
			| expr '>' expr
			| expr LOGICAND expr
			| expr LOGICOR expr
			| ID multiFuncOpt
			| '(' expr ')'
			| INTCON
			| CHARCON
			| STRCON
			;
			
multiFuncOpt: '('')'
			| '(' expr multiExprOpt ')'
			| '[' expr ']'
			| /* empty */
			;

exprOpt:	  expr
			| /* empty */
			;

multiExprOpt: multiExprOpt ',' expr
			| /* empty */
			;

%%

main() {
	return yyparse();
}

yyerror(char* errorMessage) {
	fprintf(stderr, "ERROR #%d: line %d: Near token (%s)\n", ++errorCount,
			yylineno, yytext);
}

yywrap() {
	return 1;
}
