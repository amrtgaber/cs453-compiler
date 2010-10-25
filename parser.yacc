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
char _returnedValue = FALSE;
%}

%union {
	int integer;
	char* string;
}

%start program

%type	<int>	expr multiFuncOpt

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
			  Symbol *prevDcl = recallGlobal(_currFID);
	
			  if (prevDcl->functionType == PROTOTYPE || prevDcl->functionType == EXTERN) {
			      typeError(sprintf("prototype %s previously declared",
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
			  Symbol *currSymbol = recallGlobal(_currFID);
			  
			  if (currSymbol)
				  _currParam = currSymbol->parameterListHead;
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
			          typeError(sprintf("function %s previously defined",
				          prevDcl->identifier));
			      } else if (prevDcl->functionType == EXTERN) {
			          typeError(sprintf("function %s previously declared as extern",
				          prevDcl->identifier));
				  } else if (prevDcl->functionType == NON_FUNCTION) {
					  typeError(sprintf("function %s previously declared",
						  prevDcl->identifier));
				  } else if (prevDcl->type != _currType) {
				      typeError(sprintf("return type of function %s doesn't match previous declaration",
						  prevDcl->identifier));
				  }
			  } else {
				      Symbol *currFunction = insert(_currID, _currType);
					  currFunction->functionType = DEFINITION;
					  currFunction->type = _currType;
			  }
			
			  pushSymbolTable();
			}
			;

function:	  type storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
			  	  statementOpt '}' 
			{ 
			  if (!_returnedValue)
				  typeError(sprintf("function %s must have at least one return statement",
					  _currFID));
					
			  popSymbolTable();
			}
			| storeVOID storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
				  statementOpt '}' { popSymbolTable(); }
			;

multiTypeDcl: multiTypeDcl type varDcl multiVarDcl ';'

			/* error productions */
			| multiTypeDcl type error ';' { yyerrok; }

			| /* empty */
			;

statement:	  IF '(' expr ')' statement
			{
			  if ($3 != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
			| IF '(' expr ')' statement ELSE statement
			{
			  if ($3 != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
			| WHILE '(' expr ')' statement
			{
			  if ($3 != BOOLEAN)
				  typeError("conditional in while loop must be a boolean");
			}
			| FOR '(' assgOpt ';' exprOpt ';' assgOpt ')' statement
			| RETURN expr ';'
			{
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
			  } else {
				  if (currSymbol->type != $2)
					typeError(sprintf("return type for function %s does not match declared type",
						_currFID));
			  	  else
					  _returnedValue = TRUE;
			  }
			}
			| RETURN ';'
			{
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
			  } else {
				  if (currSymbol->type != VOID)
					typeError(sprintf("return type for function %s does not match declared type",
						_currFID));
			  }
			}
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
			{
			  _currID = $1;
			  Symbol *currSymbol = recall(_currID);
			
			  if (!currSymbol) {
				  typeError(sprintf("%s undefined", _currID));
		  	  } else {
				  if (currSymbol->type != expr)
					  if ((currSymbol->type != INT || currSymbol->type != CHAR)
						  && (expr != INT && expr != CHAR))
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
				  if ($3) {
				  	  if (currSymbol->type == CHAR_ARRAY)
					  	  $$ = CHAR;
				  	  else if (currSymbol->type == INT_ARRAY)
					  	  $$ = INT;
				  } else {
			  	  	  $$ = currSymbol->type;
				  }
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
			  
			  if (currSymbol) {
			      if (!currSymbol->parameterListHead)
				      typeError(sprintf("%s is not a function", _currID));
			
			      else if (currSymbol->parameterListHead->type != VOID)
			          typeError(sprintf("function %s takes non-VOID arguments",
					      _currID));
			  }
			
			  $$ = FALSE;
			}
			| '(' initParam args multiExprOpt ')'
			{
			  Symbol *currSymbol = recallGlobal(_currID);

			  if (currSymbol)
			      if (currSymbol->functionType == NON_FUNCTION)
			          typeError(sprintf("%s is not a function", _currID));
			
			  if (_currParam)
				  typeError(sprintf("more arguments expected for function %s",
					  _currID));
			  
			  $$ = FALSE;
			}
			| '[' expr ']'
			{
			  Symbol *currSymbol = recallGlobal(_currID);

			  if (currSymbol)
				  if (currSymbol->type != CHAR_ARRAY && currSymbol->type != INT_ARRAY)
					  typeError(sprintf("%s must be an ARRAY to be indexed",
						  _currID));
				  if ($2 != INT && $2 != CHAR)
				  	  typeError(sprintf("ARRAY index for %s must be INT or CHAR",
				      	  _currID));
				
			  $$ = TRUE;
			}
			| /* empty */ { $$ = FALSE; }
			;

args:		  expr
			{
			  Symbol *currSymbol = recallGlobal(_currID);

			  if (currSymbol) {
		  	  	  if (!_currParam && currSymbol->type != NON_FUNCTION)
				      typeError(sprintf("extra arguments passed to function %s",
				          _currID));
		  	      else if (_currParam && _currParam->type != $2)
			  	      typeError(sprintf("type mismatch in arguments to function %s",
			      	      _currID));
			  }
		  	  
		      if (_currParam)
			      _currParam = _currParam->next;
			}
			;

exprOpt:	  expr
			| /* empty */
			;

multiExprOpt: multiExprOpt ',' args
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
