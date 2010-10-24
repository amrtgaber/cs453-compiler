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
Scope _currScope = GLOBAL;
char *_currID = NULL, *_currFID = NULL;
Type _currType = -1;
FunctionType _currFType = -1;
Parameter *_currParam = NULL;
%}

%union {
	int integer;
	char* string;
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
			| storeExtern type storeID '(' insertFunc paramTypes ')' 
			      multiProtDcl makeProt
			| type storeID '(' insertFunc paramTypes ')' multiProtDcl makeProt
			| storeExtern storeVoid storeID '(' insertFunc paramTypes ')'
			      multiProtDcl makeProt
			| storeVoid storeID '(' insertFunc paramTypes ')' multiProtDcl makeProt
			;
			
storeID:	  ID
			{
			  _currFID = $1.string;
			};

storeExtern:  EXTERN
			{
			  _currFType = EXTERN;
			};

storeVoid:	  VOID
			{
			  _currType = VOID;
			};

makeProt:	{
			  Symbol *prevDcl = recall(_currFID);
				
			  if (prevDcl->functionType == PROTOTYPE || prevDcl->functionType == EXTERN) {
			      typeError(sprintf("Prototype %s previously declared",
				      _currFID));
			  } else {
				  if (_currFType = EXTERN)
					  prevDcl->functionType = EXTERN;
				  else
				      prevDcl->functionType = PROTOTYPE;
			  }
			}
			;

multiProtDcl: multiProtDcl ',' makeProt storeID '(' insertFunc paramTypes ')'
			| /* empty */
			;

multiVarDcl:  multiVarDcl ',' varDcl
			| /* empty */
			;

varDcl:	  	  ID
			{
			  _currID = $1.string;
			
			  if (recallLocal(_currID)) {
			      typeError(sprintf("%s previously declared in this function",
					      _currID));
			  } else {
			  	  insert(_currID, _currType, NULL);
			  }
			}
			| ID '[' INTCON ']'
			{
			  _currID = $1.string;
			
			  if (currType == CHAR)
				  currType = CHARARRAY);
			  else
			      currType = INTARRAY;
			
			  if (recallLocal(_currId)) {
			      typeError(sprintf("%s previously declared in this function",
					      _currID));
			  } else {
			  	  insert(_currID, _currType, NULL);
			  }
			}
			;

type:		  CHAR
			{
			  _currType = CHAR;
			}
			| INT
			{
			  _currType = INT;
			}
			;

initParam:	{
			  _currParam = (recall(_currFID))->parameterListHead;
			};

paramTypes:   initParam VOID
			| initParam arrayTypeOpt multiParam
			;

arrayTypeOpt: type ID
			| type ID '['']'
			;

multiParam:   multiParam ',' arrayTypeOpt
			| /* empty */
			;

insertFunc:	{
			  Symbol *prevDcl = recall(_currID);

			  if (prevDcl) {
			      if (prevDcl->functionType == DEFINITION) {
			          typeError(sprintf("Function %s previously defined",
				          prevDcl->identifier));
			      } else if (prevDcl->functionType == EXTERN) {
			          typeError(sprintf("Function %s previously declared as extern",
				          prevDcl->identifier));
				  } else if (prevDcl->functionType == NON_FUNCTION) {
					  typeError(sprintf("Function %s previously declared",
						  prevDcl->identifier));
				  }
			  } else {
				      insert(_currID, _currType);
			  }
			}
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
	pushSymbolTable();						// initialize global symbol table
	return yyparse();
}

/* Function: typeError
 * Parameters: char *message
 * Description: Prints error message and turns code generation off.
 * Returns: void
 * Preconditions: none
 */
void typeError(char *message) {
	fprintf(stderr, "TYPE ERROR: line %d: %s\n", yylineno, message);
	// TODO turn code generation off
}

yyerror(char* errorMessage) {
	fprintf(stderr, "SYNTAX ERROR: line %d: Near token (%s)\n", yylineno, yytext);
}

yywrap() {
	return 1;
}
