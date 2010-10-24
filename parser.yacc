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
	Type type;
}

%start program

%type <type> expr

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
			| storeExtern type storeFID '(' insertFunc paramTypes ')' 
			      multiProtDcl makeProt
			| type storeFID '(' insertFunc paramTypes ')' multiProtDcl makeProt
			| storeExtern storeVoid storeFID '(' insertFunc paramTypes ')'
			      multiProtDcl makeProt
			| storeVoid storeFID '(' insertFunc paramTypes ')' multiProtDcl makeProt
			;
			
storeFID:	  ID
			{
			  _currFID = $1;
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
			  Symbol *prevDcl = recallGloabl(_currFID);
	
			  if (prevDcl->functionType == PROTOTYPE) {
			      typeError(sprintf("Prototype %s previously declared",
				      _currFID));
			  } else {
				  if (_currFType = EXTERN)
					  prevDcl->functionType = EXTERN;
				  else
				      prevDcl->functionType = PROTOTYPE;
			  }
			  
			  popSymbolTable();
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
			  _currID = $1;
			
			  if (recallLocal(_currID)) {
			      typeError(sprintf("%s previously declared in this function",
					      _currID));
			  } else {
			  	  insert(_currID, _currType, NULL);
			  }
			}
			| ID '[' INTCON ']'
			{
			  _currID = $1;
			
			  if (_currType == CHAR)
				  _currType = CHAR_ARRAY;
			  else
			      _currType = INT_ARRAY;
			
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
			  _currParam = (recallGlobal(_currFID))->parameterListHead;
			};

paramTypes:   initParam VOID 
			{
			  Symbol *currentFunction = recallGlobal(_currFID);
			
		      if (_currParam) {
		 		  if (_currParam->type != VOID)
				  	  typeError("Type mismatch: non-VOID parameter(s) expected");
			  } else {
				  addParameter(NULL, VOID, currentFunction);
			  }

			  _currParam = NULL;
			}
			| initParam arrayTypeOpt multiParam
			{
			  if (_currParam)
				  typeError("Type mismatch: missing previously declared types");
			  
			  _currParam = NULL;
			};

arrayTypeOpt: type ID
			{
			  _currID = $2;
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			    if (recallLocal(_currID)) {
			      typeError(sprintf("%s previously declared in this function",
					      _currID));
			    } else {
			  	  	if (_currParam) {
					  	if (_currParam->type != _currType) {
						  	if (_currType == CHAR)
							  	typeError("CHAR does not match previous declaration");
						  	else
							  	typeError("INT does not match previous declaration");
						} else {
							insert(_currID, _currType);
						}
			  	 	} else {
				  		addParameter(_currID, _currType, currentFunction);
			  		}
				}
						
			  _currParam = _currParam->next;
			}
			| type ID '['']'
			{
			  _currID = $2;
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			  if (_currType == CHAR)
				  _currType = CHAR_ARRAY;
			  else
			      _currType = INT_ARRAY;
			
			  if (recallLocal(_currID)) {
			      typeError(sprintf("%s previously declared in this function",
					      _currID));
			  } else {
			  	  if (_currParam) {
					  if (_currParam->type != _currType) {
						  if (_currType == CHAR_ARRAY)
							  typeError("CHAR_ARRAY does not match previous declaration");
						  else
							  typeError("INT_ARRAY does not match previous declaration");
					  } else {
						  insert(_currID, _currType);
					  }
			  	  } else {
				  	  addParameter(_currID, _currType, currentFunction);
			  	  }
			  }
			
			  _currParam = _currParam->next;
			}
			;

multiParam:   multiParam ',' arrayTypeOpt
			| /* empty */
			;

insertFunc:	{
			  Symbol *prevDcl = recallGlobal(_currFID);

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
				      Symbol *currFunction = insert(_currID, _currType);
					  currFunction->functionType = DEFINITION;
			  }
			
			  pushSymbolTable();
			}
			;

function:	  type storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
			      statementOpt '}' popTable
			| storeVOID storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
				  statementOpt '}' popTable
			;

popTable:	{
			  popSymbolTable();
			};

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
			{
			  if ($2 != INT && $2 != CHAR)
				  typeError("incompatible expression for operator '-'");
			
			  $$ = $2;
			}
			| '!' expr
			{
			  if ($2 != BOOLEAN)
				  typeError("incompatible expression for operator '!'");
			
			  $$ = $2;
			}
			| expr '+' expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '+'");
			
			  $$ = $1;
			}
			| expr '-' expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '-'");
			
			  $$ = $1;
			}
			| expr '*' expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '*'");
			
			  $$ = $1;
			}
			| expr '/' expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '/'");
			
			  $$ = $1;
			}
			| expr DBLEQ expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '=='");
			
			  $$ = BOOLEAN;
			}
			| expr NOTEQ expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '!='");
			
			  $$ = BOOLEAN;
			}
			| expr LTEQ expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '<='");
			
			  $$ = BOOLEAN;
			}
			| expr '<' expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '<'");
			
			  $$ = BOOLEAN;
			}
			| expr GTEQ expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '>='");
			
			  $$ = BOOLEAN;
			}
			| expr '>' expr
			{
			  if (($1 != INT && $1 != CHAR) || ($3 != INT && $3 != CHAR))
				  typeError("incompatible expression for operator '>'");
			
			  $$ = BOOLEAN;
			}
			| expr LOGICAND expr
			{
			  if ($1 != BOOLEAN || $3 != BOOLEAN)
				  typeError("incompatible expression for operator '&&'");
			
			  $$ = BOOLEAN;
			}
			| expr LOGICOR expr
			{
			  if ($1 != BOOLEAN || $3 != BOOLEAN)
				  typeError("incompatible expression for operator '||'");
			
			  $$ = BOOLEAN;
			}
			| ID { _currID = $1; } multiFuncOpt
			{
			  Symbol *currSymbol = recall(_currID);
			  
			  if (!currSymbol) {
				  typeError(sprintf("%s undefined", _currID));
				  $$ = -1;
			  } else {
			  	  $$ = currSymbol->type;
			  }
			}
			| '(' expr ')'	{ $$ = $2; }
			| INTCON	{ $$ = INT; }
			| CHARCON	{ $$ = CHAR; }
			| STRCON	{ $$ = CHAR_ARRAY; }
			;
			
multiFuncOpt: '('')'
			{
			  Symbol *currSymbol = recallGlobal(_currID);
			
			  if (currSymbol && currSymbol->parameterListHead 
			 	      && currSymbol->parameterListHead->type != VOID)
			      typeError(sprintf("function %s takes no arguments",
					   _currID));
			}
			| '(' expr
			{
			  _currParam = recallGlobal(_currID)->parameterListHead;
			  
			  if (_currParam->type != $2)
				  typeError(sprintf("type mismatch in arguments to function %s",
				      _currID));
			
			  _currParam = _currParam->next;
			}
			multiExprOpt ')'
			{
			  if (_currParam)
				  typeError(sprintf("more arguments expected for function %s",
					  _currID));
			}
			| '[' expr ']'
			{
			  if ($2 != INT && $2 != CHAR)
				  typeError(sprintf("array index for %s must be INT or CHAR",
				      _currID));
			}
			| /* empty */
			;

exprOpt:	  expr
			| /* empty */
			;

multiExprOpt: multiExprOpt ',' expr
			{
			  if (!_currParam)
				  typeError(sprintf("extra arguments passed to function %s",
				      _currID));
			  else if (_currParam->type != $3)
				  typeError(sprintf("type mismatch in arguments to function %s",
					  _currID));
			  
			  _currParam = _currParam->next;
			}
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
