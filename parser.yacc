/* File: parser.yacc 
 * Author: Amr Gaber
 * Created: 24/9/2010
 * Last Modified: 6/11/2010
 * Purpose: Parser for the C-- compiler. Used with scanner.lex and makefile to
 * 				construct the C-- compiler.
 */

%{
#include "utilities.h"
#include "symbolTable.h"
#include "syntaxTree.h"
#include "code.h"
#include "functionCall.h"

/************************
 *						*
 * 		prototypes		*
 *						*
 ************************/

void 	typeError(char *errorMessage),
		generateNewTempID(),
		generateNewLabelID(),
		declareGlobalVariables(SyntaxTree *tree);

/************************
 *						*
 *	global variables	*
 *						*
 ************************/

extern int yylineno;
extern char *yytext;
extern FunctionCall	*_callStack;
char	*_currID = NULL,
		*_currFID = NULL,
		_returnedValue = FALSE,
		_generateCode = TRUE,
		_errorMessage[255],
		_tempID[15],				// up to 10 billion temps > unsigned int max
		_labelID[16];				// up to 10 billion labels > unsigned int max
unsigned int	_tempNum = 0,
				_labelNum = 0;
Type	_currType = UNKNOWN,
		_currPType = UNKNOWN;
FunctionType _currFType = F_UNKNOWN;
Parameter *_currParam = NULL;
%}

%union {
	char character;
	int integer;
	char *string;
	SyntaxTree *tree;
	struct exprReturn {
		Type type;
		SyntaxTree *tree;
	} exprReturn;
}

%start program

%token ID INTCON CHARCON STRCON CHAR INT VOID IF ELSE WHILE	FOR	RETURN EXTERN
			UMINUS DBLEQ NOTEQ LTEQ GTEQ LOGICAND LOGICOR OTHER

%type	<character>		CHARCON
%type	<integer>		exprOpt INTCON
%type 	<string>		ID storeID STRCON
%type 	<tree>			assignment statement statementOpt paramTypes arrayTypeOpt
							args varDcl multiVarDcl
%type	<exprReturn>	expr multiFuncOpt

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
			{
			  declareGlobalVariables(createTree(DECLARATION, NULL, $2, $3));
			}
			| storeExtern type storeFID '(' insertFunc paramTypes ')'
			      multiProtDcl makeProt // TODO reset _currFType
			| type storeFID '(' insertFunc paramTypes ')' multiProtDcl makeProt
			| storeExtern storeVoid storeFID '(' insertFunc paramTypes ')'
			      multiProtDcl makeProt // TODO reset _currFType
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

multiVarDcl:  multiVarDcl ',' varDcl { $$ = createTree(DECLARATION, NULL, $3, $1); }
			| /* empty */ { $$ = NULL; }
			;

varDcl:	  	  ID
			{
			  _currID = $1;
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
				  $$ = NULL;
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
				  currSymbol->functionType = NON_FUNCTION;
				  $$ = createTree(SYMBOL, currSymbol, NULL, NULL);
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
				  $$ = NULL;
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
			      currSymbol->functionType = NON_FUNCTION;
				  $$ = createTree(SYMBOL, currSymbol, NULL, NULL);
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
			  
			  $$ = NULL;
			}
			| initParam arrayTypeOpt multiParam
			{
			  if (_currParam)
				  typeError("Type mismatch: missing previously declared types");
			  
			  _currParam = NULL;
			
			  $$ = $2;
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
				  $$ = NULL;
			    } else {
			  	  	if (_currParam) {
					  	if (_currParam->type != _currPType) {
							sprintf(_errorMessage, "%s does not match previous declaration",
								typeAsString(_currPType));
							typeError(_errorMessage);
							$$ = NULL;
						} else {
							Symbol *currSymbol = insert(_currID, _currPType);
						    currSymbol->functionType = NON_FUNCTION;
							$$ = createTree(SYMBOL, currSymbol, NULL, NULL);
						}
			  	 	} else {
				  		Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					    currSymbol->functionType = NON_FUNCTION;
						$$ = createTree(SYMBOL, currSymbol, NULL, NULL);
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
				  $$ = NULL;
			  } else {
			  	  if (_currParam) {
					  if (_currParam->type != _currPType) {
						  if (_currPType == CHAR_ARRAY)
							  typeError("CHAR_ARRAY does not match previous declaration");
						  else
							  typeError("INT_ARRAY does not match previous declaration");
						  
						  $$ = NULL;
					  } else {
						  Symbol *currSymbol = insert(_currID, _currPType);
						  currSymbol->functionType = NON_FUNCTION;
						  $$ = createTree(SYMBOL, currSymbol, NULL, NULL);
					  }
			  	  } else {
				  	  Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					  currSymbol->functionType = NON_FUNCTION;
					  $$ = createTree(SYMBOL, currSymbol, NULL, NULL);
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
			  
			  SyntaxTree *function = createTree(FUNCTION_ROOT, recallGlobal(_currFID), $5, $9);
			  //printf("\nSYNTAX TREE:\n\n");
			  //printSyntaxTree(function, 0);
			
			  #ifdef DEBUG
			  printSymbolTable();
			  #endif
					
			  popSymbolTable();
			}
			| storeVoid storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
				  statementOpt '}' 
			{ 
			  SyntaxTree *function = createTree(FUNCTION_ROOT, recallGlobal(_currFID), $5, $9);
			  //printf("\nSYNTAX TREE:\n\n");
			  //printSyntaxTree(function, 0);
			
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
			  if ($3.type != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
			| IF '(' expr ')' statement ELSE statement
			{
			  if ($3.type != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
			| WHILE '(' expr ')' statement
			{
			  if ($3.type != BOOLEAN)
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
				  if (currSymbol->type != $2.type) {
				      if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  || ($2.type != INT_TYPE && $2.type != CHAR_TYPE)) {
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
			| assignment ';' { $$ = $1; }
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
				  
				  $$ = createTree(FUNCTION_CALL, currSymbol, NULL, NULL);
			  } else {
				  sprintf(_errorMessage, "%s undefined", _currID);
			      typeError(_errorMessage);
				  $$ = NULL;
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
				
				  $$ = createTree(FUNCTION_CALL, recallGlobal(_callStack->identifier), $4, NULL);
				
		      	  popFunctionCall();
		      }
			}
			| '{' statementOpt '}' { $$ = $2; }
			| ';' { $$ = NULL; }

			/* error productions */
			| error ';' { yyerrok; }
			;

statementOpt: statementOpt statement
			{
			  if ($2) {
			  	  $$ = createTree(STATEMENT, NULL, $2, $1);
			  }
			}
			| /* empty */ { $$ = NULL; }
			;

exprOpt:	  expr { $$ = $1.type; }
			| /* empty */ { $$ = BOOLEAN; }
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
				  if (currSymbol->type != $3.type) {
					  if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  && ($3.type != INT_TYPE && $3.type != CHAR_TYPE)) {
						sprintf(_errorMessage, "incompatible types for assignment of %s",
							_currID);
						typeError(_errorMessage);
					  }
				  }
			  }
			
			  SyntaxTree *leftHandSide = createTree(SYMBOL, currSymbol, NULL, NULL);
			  $$ = createTree(ASSIGNMENT, NULL, leftHandSide, $3.tree);
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
				  
				  if ($3.type != INT_TYPE && $3.type != CHAR_TYPE) {
					  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
						  _currID);
					  typeError(_errorMessage);
				  }
				  
				  if ($6.type != INT_TYPE && $6.type != CHAR_TYPE)  {
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
			  if ($2.type != INT_TYPE && $2.type != CHAR_TYPE)
				  typeError("incompatible expression for operator '-'");
			
			  $$.type = $2.type;
			}
			| '!' expr
			{
			  if ($2.type != BOOLEAN)
				  typeError("incompatible expression for operator '!'");
			
			  $$.type = $2.type;
			}
			| expr '+' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE)
				  || ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '+'");
			
			  $$.type = $1.type;
			}
			| expr '-' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE)
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '-'");
			
			  $$.type = $1.type;
			}
			| expr '*' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '*'");
			
			  $$.type = $1.type;
			}
			| expr '/' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '/'");
			
			  $$.type = $1.type;
			}
			| expr DBLEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '=='");
			
			  $$.type = BOOLEAN;
			}
			| expr NOTEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '!='");
			
			  $$.type = BOOLEAN;
			}
			| expr LTEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '<='");
			
			  $$.type = BOOLEAN;
			}
			| expr '<' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '<'");
			
			  $$.type = BOOLEAN;
			}
			| expr GTEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '>='");
			
			  $$.type = BOOLEAN;
			}
			| expr '>' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '>'");
			
			  $$.type = BOOLEAN;
			}
			| expr LOGICAND expr
			{
			  if ($1.type != BOOLEAN || $3.type != BOOLEAN)
				  typeError("incompatible expression for operator '&&'");
			
			  $$.type = BOOLEAN;
			}
			| expr LOGICOR expr
			{
			  if ($1.type != BOOLEAN || $3.type != BOOLEAN)
				  typeError("incompatible expression for operator '||'");
			
			  $$.type = BOOLEAN;
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
				$$.type = $3.type;
				$$.tree = $3.tree;
			}
			| '(' expr ')'	{ $$.type = $2.type; }
			| INTCON
			{
			  $$.type = INT_TYPE;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  newSymbol->value.intVal = $1;
			  newSymbol->functionType = NON_FUNCTION;
			  $$.tree = createTree(SYMBOL, newSymbol, NULL, NULL);
			}
			| CHARCON
			{
			  $$.type = CHAR_TYPE;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, CHAR_TYPE);
			  newSymbol->value.charVal = $1;
			  newSymbol->functionType = NON_FUNCTION;
			  $$.tree = createTree(SYMBOL, newSymbol, NULL, NULL);
			}
			| STRCON
			{
			  $$.type = CHAR_ARRAY;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, CHAR_ARRAY);
			  newSymbol->value.string = $1;
			  newSymbol->functionType = NON_FUNCTION;
			  $$.tree = createTree(SYMBOL, newSymbol, NULL, NULL);
			}
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
				  $$.type = currSymbol->type;
			  } else {
				  $$.type = UNKNOWN;
			  }
			}
			| '('
			{
			  Symbol *currSymbol = recallGlobal(_currID);

			  if (currSymbol) {
			      if (currSymbol->functionType == NON_FUNCTION) {
				      sprintf(_errorMessage, "%s is not a function", _currID);
			          typeError(_errorMessage);
				  } else if (currSymbol->type == VOID_TYPE) {
				  	  sprintf(_errorMessage, "void function %s in expression", _currID);
					  typeError(_errorMessage);
				  }
				  pushFunctionCall(currSymbol);
			  }
			}
			  args multiExprOpt ')'
			{ 
			  if (_callStack) {
			  	  if (_callStack->currParam) {
				  	  sprintf(_errorMessage, "more arguments expected for function %s",
					  	  _callStack->identifier);
				  	  typeError(_errorMessage);
			  	  }
			  	  $$.type = (recallGlobal(_callStack->identifier))->type;
			      popFunctionCall();
			  } else {
			      $$.type = UNKNOWN;
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
			  if ($3.type != INT_TYPE && $3.type != CHAR_TYPE) {
				  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
					  _currID);
			  	  typeError(_errorMessage);
			  }
			
			  if (!_callStack) {
				  $$.type = UNKNOWN;
			  } else {
				  $$.type = (recall(_callStack->identifier))->type;
					
				  if ($$.type == CHAR_ARRAY)
					  $$.type = CHAR_TYPE;
				  else
					  $$.type = INT_TYPE;
				
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
				  $$.type = currSymbol->type;
				  $$.tree = createTree(SYMBOL, currSymbol, NULL, NULL);
			  } else {
				  $$.type = UNKNOWN;
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
					  $$ = NULL;
				  } else if (_callStack->currParam->type != $1.type) {
					  if ((_callStack->currParam->type != INT_TYPE
					          && _callStack->currParam->type != CHAR_TYPE)
						      || ($1.type != INT_TYPE && $1.type != CHAR_TYPE)) {
			  	          typeError("type mismatch in arguments to function");
						  $$ = NULL;
					  } else {
						  $$ = $1.tree;
					  }
				  } else {
					  $$ = $1.tree;
				  }
			  } else {
				  $$ = NULL;
			  }
		  	  
		      if (_callStack->currParam)
			      _callStack->currParam = _callStack->currParam->next;
			}
			;

multiExprOpt: multiExprOpt ',' args
			| /* empty */
			;

%%

/* Function: main
 * Parameters: none
 * Description: Program execution begins here.
 * Returns: 0 for success, 1 if errors were found (syntactic or semantic).
 * Preconditions: none
 */
main() {
	pushSymbolTable();				// initialize global symbol table
	yyparse();
	popSymbolTable();				// free global symbol table
	
	if (_generateCode)
		return 0;					// success
	return 1;						// failure
}

/* Function: yyError
 * Parameters: char *errorMessage
 * Description: Called when syntax errors are found. Prints error message and
 *					turns code generation off.
 * Returns: void
 * Preconditions: none
 */
yyerror(char* errorMessage) {
	fprintf(stderr, "SYNTAX ERROR: line %d: Near token (%s)\n", yylineno, yytext);
	_generateCode = FALSE;
}

yywrap() {
	return 1;
}

void declareGlobalVariables(SyntaxTree *tree) {
	
}

/* Function: typeError
 * Parameters: char *errorMessage
 * Description: Called when semantic errors are found. Prints error message and
 *					turns code generation off.
 * Returns: void
 * Preconditions: none
 */
void typeError(char *errorMessage) {
	fprintf(stderr, "TYPE ERROR: line %d: %s\n", yylineno, errorMessage);
	_generateCode = FALSE;
}

/* Function: generateNewTempID
 * Parameters: none
 * Description: Updates to a new unique temporary variable ID.
 * Returns: none
 * Preconditions: none
 */
void generateNewTempID() {
	sprintf(_tempID, "_temp%d", _tempNum++);
}

/* Function: generateNewLabelID
 * Parameters: none
 * Description: Updates to a new unique label ID.
 * Returns: none
 * Preconditions: none
 */
void generateNewLabelID() {
	sprintf(_labelID, "_label%d", _labelNum++);
}
