/* File: parser.yacc 
 * Author: Amr Gaber
 * Created: 24/9/2010
 * Last Modified: 25/10/2010
 * Purpose: Parser for the C-- compiler. Used with scanner.lex and makefile to
 * 				construct the C-- compiler.
 */

%{
#include "symbolTable.h"
#include "utilities.h"

typedef struct FunctionCall {
	char *identifier;
	Parameter *currParam;
	struct FunctionCall *below;
} FunctionCall;

void typeError(char *errorMessage);
FunctionCall *pushFunctionCall(Symbol *function);
FunctionCall *peekFunctionCall();
void popFunctionCall();

extern int yylineno;
extern char *yytext;
char *_currID = NULL, *_currFID = NULL, _returnedValue = FALSE, _errorMessage[255];
Type _currType = -1, _currPType = -1;
FunctionType _currFType = -1;
Parameter *_currParam = NULL;
FunctionCall *_callStack = NULL;
%}

%union {
	int integer;
	char* string;
}

%start program

%type	<integer>	expr multiFuncOpt exprOpt
%type 	<string>	ID storeID

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

storeID:	  ID
			{
			  _currID = $1;
			  $$ = $1;
			};

storeExtern:  EXTERN
			{
			  _currFType = EXTERN_TYPE;
			};

storeVoid:	  VOID
			{
			  _currType = VOID_TYPE;
			};

makeProt:	{
			  Symbol *prevDcl = recallGlobal(_currFID);
	
			  if (prevDcl->functionType == PROTOTYPE || prevDcl->functionType == EXTERN_TYPE) {
				  sprintf(_errorMessage, "prototype %s previously declared",
					  _currFID);
			      typeError(_errorMessage);
			  } else {
				  if (_currFType == EXTERN_TYPE)
					  prevDcl->functionType = EXTERN_TYPE;
				  else
				      prevDcl->functionType = PROTOTYPE;
			  }
			
			  popSymbolTable();
			}
			;

multiProtDcl: multiProtDcl ',' makeProt storeFID '(' insertFunc paramTypes ')'
			| /* empty */
			;

multiVarDcl:  multiVarDcl ',' varDcl
			| /* empty */
			;

varDcl:	  	  ID
			{
			  _currID = $1;
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
				  currSymbol->functionType = NON_FUNCTION;
			  }
			}
			| ID '[' INTCON ']'
			{
			  _currID = $1;
			
			  if (_currType == CHAR_TYPE)
				  _currType = CHAR_ARRAY;
			  else
			      _currType = INT_ARRAY;
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
			      currSymbol->functionType = NON_FUNCTION;
			  }
			
			  if (_currType == CHAR_ARRAY)
				  _currType = CHAR_TYPE;
			  else
			      _currType = INT_TYPE;
			}
			;

type:		  CHAR
			{
			  _currType = CHAR_TYPE;
			}
			| INT
			{
			  _currType = INT_TYPE;
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
		 		  if (_currParam->type != VOID_TYPE)
				  	  typeError("Type mismatch: non-VOID parameter(s) expected");
			  } else {
				  addParameter(NULL, VOID_TYPE, currentFunction);
			  }

			  _currParam = NULL;
			}
			| initParam arrayTypeOpt multiParam
			{
			  if (_currParam)
				  typeError("Type mismatch: missing previously declared types");
			  
			  _currParam = NULL;
			};

storePType: CHAR
			{
				_currPType = CHAR_TYPE;
			}
			| INT
			{
				_currPType = INT_TYPE;
			}
			;

arrayTypeOpt: storePType ID
			{
			  _currID = $2;
			
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			    if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			    } else {
			  	  	if (_currParam) {
					  	if (_currParam->type != _currPType) {
							sprintf(_errorMessage, "%s does not match previous declaration",
								typeAsString(_currPType));
							typeError(_errorMessage);
						} else {
							Symbol *currSymbol = insert(_currID, _currPType);
						    currSymbol->functionType = NON_FUNCTION;
						}
			  	 	} else {
				  		Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					    currSymbol->functionType = NON_FUNCTION;
			  		}
				}
				
			  if (_currParam)
			  	  _currParam = _currParam->next;
			}
			| storePType ID '['']'
			{
			  _currID = $2;
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			  if (_currPType == CHAR_TYPE)
				  _currPType = CHAR_ARRAY;
			  else
			      _currPType = INT_ARRAY;
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			  } else {
			  	  if (_currParam) {
					  if (_currParam->type != _currPType) {
						  if (_currPType == CHAR_ARRAY)
							  typeError("CHAR_ARRAY does not match previous declaration");
						  else
							  typeError("INT_ARRAY does not match previous declaration");
					  } else {
						  Symbol *currSymbol = insert(_currID, _currPType);
						  currSymbol->functionType = NON_FUNCTION;
					  }
			  	  } else {
				  	  Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					  currSymbol->functionType = NON_FUNCTION;
			  	  }
			  }
			
			 if (_currParam)
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
				      sprintf(_errorMessage, "function %s previously defined",
						  prevDcl->identifier);
			          typeError(_errorMessage);
			      } else if (prevDcl->functionType == EXTERN_TYPE) {
					  sprintf(_errorMessage, "function %s previously declared as extern",
						  prevDcl->identifier);
			          typeError(_errorMessage);
				  } else if (prevDcl->functionType == NON_FUNCTION) {
					  sprintf(_errorMessage, "function %s previously declared",
						  prevDcl->identifier);
					  typeError(_errorMessage);
				  } else if (prevDcl->type != _currType) {
					  sprintf(_errorMessage, "return type of function %s doesn't match previous declaration",
						  prevDcl->identifier);
				      typeError(_errorMessage);
				  }
			  } else {
				      Symbol *currFunction = insert(_currFID, _currType);
					  currFunction->functionType = DEFINITION;
			  }
			
			  pushSymbolTable();
			}
			;

function:	  type storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
			  	  statementOpt '}' 
			{ 
			  if (!_returnedValue) {
				  sprintf(_errorMessage, "function %s must have at least one return statement",
					  _currFID);
				  typeError(_errorMessage);
			  } else {
				  _returnedValue = FALSE;
			  }
			  
			  #ifdef DEBUG	
			  printSymbolTable();
			  #endif
					
			  popSymbolTable();
			}
			| storeVoid storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
				  statementOpt '}' 
			{ 
				#ifdef DEBUG
				printSymbolTable();
				#endif
				
				popSymbolTable(); }
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
			{
			  if ($5 != BOOLEAN)
				  typeError("conditional in for loop must be a boolean");
			}
			| RETURN expr ';'
			{
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
			  } else {
				  if (currSymbol->type != $2) {
				      if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  || ($2 != INT_TYPE && $2 != CHAR_TYPE)) {
						  	sprintf(_errorMessage, "return type for function %s does not match declared type",
								_currFID);
						  typeError(_errorMessage);
					  } else {
						_returnedValue = TRUE;
					  }
			  	  } else {
					  _returnedValue = TRUE;
				  }
			  }
			}
			| RETURN ';'
			{
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
			  } else {
				  if (currSymbol->type != VOID_TYPE) {
					  sprintf(_errorMessage, "return type for function %s does not match declared type",
						  _currFID);
					  typeError(_errorMessage);
				  }
			  }
			}
			| assignment ';'
			| storeID '('')' ';'
			{
			  Symbol *currSymbol = recallGlobal(_currID);
			  
			  if (currSymbol) {
			      if (!currSymbol->parameterListHead) {
					  sprintf(_errorMessage, "%s is not a function", _currID);
				      typeError(_errorMessage);
				  }
			
			      else if (currSymbol->parameterListHead->type != VOID_TYPE) {
			          sprintf(_errorMessage, "function %s takes non-VOID arguments",
						  _currID);
			   	      typeError(_errorMessage);
				  }
				  
				  if (currSymbol->type != VOID_TYPE) {
					  sprintf(_errorMessage, "function %s must return VOID to be used as a statement",
						  _currID);
				      typeError(_errorMessage);
				  }
			  } else {
				  sprintf(_errorMessage, "%s undefined", _currID);
			      typeError(_errorMessage);
			  }
			
			}
			| storeID '('
			{
			  Symbol *currSymbol = recallGlobal(_currID);

			  if (!currSymbol) {
				  	sprintf(_errorMessage, "%s undefined", _currID);
			        typeError(_errorMessage);
			  } else {
				  if (currSymbol->functionType == NON_FUNCTION) {
					  sprintf(_errorMessage, "%s is not a function", _currID);
			          typeError(_errorMessage);
				  } else {
					  if (currSymbol->type != VOID_TYPE) {
						  sprintf(_errorMessage, "function %s must return VOID to be used as a statement",
							  _currID);
					      typeError(_errorMessage);
					  }
					  pushFunctionCall(currSymbol);
				  }
			  }
			}
			  args multiExprOpt ')' ';'
			{
			  if (_callStack) {
			  	  if (_callStack->currParam) {
				  	  sprintf(_errorMessage, "more arguments expected for function %s",
					  	  _callStack->identifier);
				  	  typeError(_errorMessage);
			  	  }
				
		      	  popFunctionCall();
		      }
			}
			| '{' statementOpt '}'
			| ';'

			/* error productions */
			| error ';' { yyerrok; }
			;

statementOpt: statementOpt statement
			| /* empty */
			;

assignment:	  storeID '=' expr
			{
			  _currID = $1;
			  Symbol *currSymbol = recall(_currID);
			
			  if (!currSymbol) {
				  sprintf(_errorMessage, "%s undefined", _currID);
				  typeError(_errorMessage);
		  	  } else {
				  if (currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE
						|| currSymbol->functionType != NON_FUNCTION) {
					sprintf(_errorMessage, "%s has incompatible type for assignment",
						_currID);
					typeError(_errorMessage);
				}
				  if (currSymbol->type != $3) {
					  if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  && ($3 != INT_TYPE && $3 != CHAR_TYPE)) {
						sprintf(_errorMessage, "incompatible types for assignment of %s",
							_currID);
						typeError(_errorMessage);
					  }
				  }
			  }
			}
			| storeID '[' expr ']' '=' expr
			{
			  _currID = $1;
			  Symbol *currSymbol = recall(_currID);
			
			  if (!currSymbol) {
				  sprintf(_errorMessage, "%s undefined", _currID);
				  typeError(_errorMessage);
		  	  } else {
				  if (currSymbol->type != INT_ARRAY && currSymbol->type != CHAR_ARRAY) {
					  sprintf(_errorMessage, "%s must be an ARRAY to be indexed", _currID);
					  typeError(_errorMessage);
				  }
				  
				  if ($3 != INT_TYPE && $3 != CHAR_TYPE) {
					  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
						  _currID);
					  typeError(_errorMessage);
				  }
				  
				  if ($6 != INT_TYPE && $6 != CHAR_TYPE)  {
					    sprintf(_errorMessage, "incompatible types for assignment of %s",
							_currID);
						typeError(_errorMessage);
				  }
			  }
			}
			;

assgOpt:	  assignment
			| /* empty */
			;

expr:		  '-' expr %prec UMINUS
			{
			  if ($2 != INT_TYPE && $2 != CHAR_TYPE)
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
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '+'");
			
			  $$ = $1;
			}
			| expr '-' expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '-'");
			
			  $$ = $1;
			}
			| expr '*' expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '*'");
			
			  $$ = $1;
			}
			| expr '/' expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '/'");
			
			  $$ = $1;
			}
			| expr DBLEQ expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '=='");
			
			  $$ = BOOLEAN;
			}
			| expr NOTEQ expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '!='");
			
			  $$ = BOOLEAN;
			}
			| expr LTEQ expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '<='");
			
			  $$ = BOOLEAN;
			}
			| expr '<' expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '<'");
			
			  $$ = BOOLEAN;
			}
			| expr GTEQ expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
				  typeError("incompatible expression for operator '>='");
			
			  $$ = BOOLEAN;
			}
			| expr '>' expr
			{
			  if (($1 != INT_TYPE && $1 != CHAR_TYPE) || ($3 != INT_TYPE && $3 != CHAR_TYPE))
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
			| ID 
			{ 
			  _currID = $1;
			  Symbol *currSymbol = recall(_currID);
			  
			  if (!currSymbol) {
				  sprintf(_errorMessage, "%s undefined", _currID);
				  typeError(_errorMessage);
			  }
			}
			multiFuncOpt
			{
				$$ = $3;
			}
			| '(' expr ')'	{ $$ = $2; }
			| INTCON	{ $$ = INT_TYPE; }
			| CHARCON	{ $$ = CHAR_TYPE; }
			| STRCON	{ $$ = CHAR_ARRAY; }
			;
			
multiFuncOpt: '('')'
			{
			  Symbol *currSymbol = recallGlobal(_currID);
			  
			  if (currSymbol) {
			      if (!currSymbol->parameterListHead) {
					  sprintf(_errorMessage, "%s is not a function", _currID);
				      typeError(_errorMessage);
			      } else if (currSymbol->type == VOID_TYPE) {
					  sprintf(_errorMessage, "void function %s in expression", _currID);
					  typeError(_errorMessage);
				  }	else if (currSymbol->parameterListHead->type != VOID_TYPE) {
					  sprintf(_errorMessage, "function %s takes non-VOID arguments",
						  _currID);
			          typeError(_errorMessage);
			      }
				  $$ = currSymbol->type;
			  } else {
				  $$ = -1;
			  }
			}
			| '('
			{
			  Symbol *currSymbol = recallGlobal(_currID);
			
			  // TODO check that function does not return void

			  if (currSymbol) {
			      if (currSymbol->functionType == NON_FUNCTION) {
				      sprintf(_errorMessage, "%s is not a function", _currID);
			          typeError(_errorMessage);
				  }
				  pushFunctionCall(currSymbol);
			  }
			}
			  args multiExprOpt ')'
			{
			  // TODO check that _callStack is not null
				
			  if (_callStack->currParam) {
				  sprintf(_errorMessage, "more arguments expected for function %s",
					  _callStack->identifier);
				  typeError(_errorMessage);
			  }
			
			  if (!_callStack) {
				$$ = -1;
			  } else {
				  $$ = (recallGlobal(_callStack->identifier))->type;
			      popFunctionCall();
			  }
			}
			| '['
			{
			  Symbol *currSymbol = recall(_currID);

			  if (currSymbol) {
				  if (currSymbol->type != CHAR_ARRAY && currSymbol->type != INT_ARRAY) {
					  sprintf(_errorMessage, "%s must be an ARRAY to be indexed",
						  _currID);
					  typeError(_errorMessage);
				  }
				  
				  pushFunctionCall(currSymbol);
			  }
			}
			  expr ']'
			{
			  if ($3 != INT_TYPE && $3 != CHAR_TYPE) {
				  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
					  _currID);
			  	  typeError(_errorMessage);
			  }
			
				if (!_callStack) {
					$$ = -1;
				  } else {
					  $$ = (recall(_callStack->identifier))->type;
					
					  if ($$ == CHAR_ARRAY)
						  $$ = CHAR_TYPE;
					  else
						  $$ = INT_TYPE;
					
				      popFunctionCall();
				  }
			}
			| /* empty */
			{
				Symbol *currSymbol = recall(_currID);
				
				if (currSymbol) {
				    if (currSymbol->functionType != NON_FUNCTION) {
						sprintf(_errorMessage, "expected arguments for function %s",
							_currID);
						typeError(_errorMessage);
					}
					$$ = currSymbol->type;
				} else {
					$$ = -1;
				}
			}
			;

args:		  expr
			{
			  if (_callStack) {
		  	  	  if (!_callStack->currParam) {
					  sprintf(_errorMessage, "extra arguments passed to function %s",
						  _callStack->identifier);
				      typeError(_errorMessage);
				  } else if (_callStack->currParam->type != $1) {
					  if ((_callStack->currParam->type != INT_TYPE
					          && _callStack->currParam->type != CHAR_TYPE)
						      || ($1 != INT_TYPE && $1 != CHAR_TYPE))
			  	          typeError("type mismatch in arguments to function");
				  }
			  }
		  	  
		      if (_callStack->currParam)
			      _callStack->currParam = _callStack->currParam->next;
			}
			;

exprOpt:	  expr { $$ = $1; }
			| /* empty */ { $$ = BOOLEAN; }
			;

multiExprOpt: multiExprOpt ',' args
			| /* empty */
			;

%%

main() {
	pushSymbolTable();						// initialize global symbol table
	yyparse();
	popSymbolTable();
	return 0;
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


FunctionCall *pushFunctionCall(Symbol *function) {
	FunctionCall *toInsert = NULL;
	
	if (!(toInsert = malloc(sizeof(FunctionCall))))
		ERROR("", __LINE__, TRUE);					// out of memory
	
	toInsert->identifier = function->identifier;
	toInsert->currParam = function->parameterListHead;
	
	toInsert->below = _callStack;
	_callStack = toInsert;
	
	return toInsert;
}

void popFunctionCall() {
	if (!_callStack)
		ERROR("PopFunctionCall called on empty stack.", __LINE__, FALSE);
	
	FunctionCall *newTop = _callStack->below;
	
	free(_callStack);
	
	_callStack = newTop;
}

yyerror(char* errorMessage) {
	fprintf(stderr, "SYNTAX ERROR: line %d: Near token (%s)\n", yylineno, yytext);
}

yywrap() {
	return 1;
}
