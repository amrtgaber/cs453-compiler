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
		declareGlobalVariables(SyntaxTree *tree),
		writeCode(Code *code),
		allocateStackSpace(SyntaxTree *declaration, int offset);
Code	*constructCode(SyntaxTree *tree);

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
				_labelNum = 0,
				_stackSize = 0;
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
			  printf(".data\n\n");
			  declareGlobalVariables(createTree(DECLARATION, NULL, $2, $3));
			  printf("\n");
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
				  currSymbol->value.intVal = $3;
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
							$$ = createTree(DECLARATION, currSymbol, NULL, NULL);
						}
			  	 	} else {
				  		Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					    currSymbol->functionType = NON_FUNCTION;
						$$ = createTree(DECLARATION, currSymbol, NULL, NULL);
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
						  $$ = createTree(DECLARATION, currSymbol, NULL, NULL);
					  }
			  	  } else {
				  	  Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					  currSymbol->functionType = NON_FUNCTION;
					  $$ = createTree(DECLARATION, currSymbol, NULL, NULL);
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
			  
			  printf(".text\n\n");
			  printf("_%s:\n", _currFID);
			  
			  // TODO function prologue
			
			  Code *code = constructCode(function);
			
			  printf("\nTHREE ADDRESS CODE:\n\n");
			  printCode(code);
			
			  // TODO function epilogue
			
			  #if defined(DEBUG_SYNTAX) || defined(DEBUG_ALL)
			  	  printf("\nSYNTAX TREE:\n\n");
			  	  printSyntaxTree(function, 0);
			  #endif
			
			  #if defined(DEBUG_SYMBOLS) || defined(DEBUG_ALL)
			  	  printSymbolTable();
			  #endif
					
			  popSymbolTable();
			}
			| storeVoid storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
				  statementOpt '}' 
			{ 
			  SyntaxTree *function = createTree(FUNCTION_ROOT, recallGlobal(_currFID), $5, $9);
			  SyntaxTree *declarations = $5;
			  
			  printf(".text\n\n");
			
			  if (strcmp("main", _currFID) == 0)
				  printf("main:\n");
			  else
				  printf("_%s:\n", _currFID);
			
			  _stackSize = 8;
			  allocateStackSpace(declarations, 8);
			  // TODO function prologue
			  printf("\tsubu\t$sp, $sp, %d\n", _stackSize);
			  printf("\tsw\t$ra, 0($sp)\n");
			  printf("\tsw\t$fp, 4($sp)\n");
			  printf("\taddu\t$fp, $sp, %d\n\n", _stackSize);
			  // store params/locals
			  // for each param/locals
			  // 	move fp to param's location on current stack
			  // 	fp += 4

			  Code *code = constructCode(function);
			
			  writeCode(code);
			  
			  //printf("\nTHREE ADDRESS CODE:\n\n");
			  //printCode(code);
			
			  // TODO function epilogue
			  // params automatically popped
			  printf("\n\tlw\t$ra, 0($sp)\n");
			  printf("\tlw\t$fp, 4($sp)\n");
			  printf("\taddu\t$sp, $sp, %d\n", _stackSize);
			  printf("\tjr\t$ra\n");
			
			  #if defined(DEBUG_SYNTAX) || defined(DEBUG_ALL)
			  	  printf("\nSYNTAX TREE:\n\n");
			  	  printSyntaxTree(function, 0);
			  #endif
			
			  #if defined(DEBUG_SYMBOLS) || defined(DEBUG_ALL)
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
			  // TODO store length of string
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
						  $$->operation = PARAMETER_TREE;
					  }
				  } else {
					  $$ = $1.tree;
					  $$->operation = PARAMETER_TREE;
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
	
	printf("\n\n_print_int:\n");
	printf("\tli\t$v0, 1\n");
	printf("\tlw\t$a0, 0($sp)\n");
	printf("\tsyscall\n");
	printf("\tjr\t$ra\n");
	
	printf("\n_print_string:\n");
	printf("\tli\t$v0, 4\n");
	printf("\tlw\t$a0, 0($sp)\n");
	printf("\tsyscall\n");
	printf("\tjr\t$ra\n");
	
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

/* Function: declareGlobalVariables
 * Parameters: SyntaxTree *tree
 * Description: Converts global declarations to assembly code.
 * Returns: none
 * Preconditions: none
 */
void declareGlobalVariables(SyntaxTree *tree) {
	if (!tree)
		return;

	Symbol *currSymbol = tree->symbol;
	
	if (!currSymbol) {
		declareGlobalVariables(tree->left);
		declareGlobalVariables(tree->right);
		return;
	}

	if (!(currSymbol->location = malloc(strlen(currSymbol->identifier) + 2)))
		ERROR(NULL, __LINE__, TRUE);				//out of memory
		
	sprintf(currSymbol->location, "_%s", currSymbol->identifier);
	printf("%s:\n", currSymbol->location);
	
	switch (currSymbol->type) {
		case CHAR_TYPE:
			printf("\t.word '\\0'\n", currSymbol->value.charVal);
			break;
		case INT_TYPE:
			printf("\t.word 0\n", currSymbol->value.intVal);
			break;
		case CHAR_ARRAY:
			printf("\t.space %d\n", currSymbol->value.intVal);
			break;
		case INT_ARRAY:
			printf("\t.space %d\n", (4 * currSymbol->value.intVal));
			break;
		default:
			break;
	}
	
	declareGlobalVariables(tree->left);
	declareGlobalVariables(tree->right);
}

/* Function: allocateStackSpace
 * Parameters: SyntaxTree *declaration, int offset
 * Description: Sets the stack offset for each declaration.
 * Returns: none
 * Preconditions: On the first call to this function the offset is 8.
 */
void allocateStackSpace(SyntaxTree *declaration, int offset) {
	if (!declaration)
		return;
	
	if (!(declaration->symbol->location = malloc(10 * sizeof(char))))
		ERROR(NULL, __LINE__, TRUE);							//out of memory
	
	sprintf(declaration->symbol->location, "%d($sp)", offset);
	
	_stackSize = offset + 4;
	allocateStackSpace(declaration->left, offset + 4);
}

/* Function: constructCode
 * Parameters: SyntaxTree *tree
 * Description: Converts the given syntax tree into a three address code list.
 * Returns: The head of a code list.
 * Preconditions: none
 */
Code *constructCode(SyntaxTree *tree) {
	if (!tree)
		return NULL;
	
	constructCode(tree->left);
	constructCode(tree->right);
	
	switch (tree->operation) {
		/*case ADD:
			break;
	 	case SUB:
			break;
		case MULT:
			break;
		case DIV:
			break;
		case NEG:
			break;
		case EQUAL:
			break;
		case NOT_EQUAL:
			break;
		case GREATER_THAN:
			break;
		case GREATER_EQUAL:
			break;
		case LESS_THAN:
			break;
		case LESS_EQUAL:
			break;
		case AND:
			break;
		case OR:
			break;
		case IF_TREE:
			break;
		case WHILE_TREE:
			break;
		case RETURN_TREE:
			break;*/
		case ASSIGNMENT:
			tree->code = createCode(ASSIGNMENT_OP, tree->right->symbol, NULL, tree->left->symbol);
			break;
		case STATEMENT:
			if (tree->right) {
				tree->code = tree->right->code;
			
				Code *tail = tree->code;
			
				while (tail->next)
					tail = tail->next;
			
				tail->next = tree->left->code;
			} else {
				tree->code = tree->left->code;
			}
			break;
		case FUNCTION_CALL:
			if (tree->left) {
				tree->code = tree->left->code;
			
				Code *tail = tree->code;
			
				while (tail->next)
					tail = tail->next;
			
				tail->next = createCode(ENTER, tree->symbol, NULL, NULL);
			} else {
				tree->code = createCode(ENTER, tree->symbol, NULL, NULL);
			}
			break;
		case PARAMETER_TREE:
			tree->code = createCode(PUSH_PARAM, tree->symbol, NULL, NULL);
			
			if (tree->left)
				tree->code->next = tree->left->code;
			break;
		case DECLARATION:
			tree->code = createCode(DECLARATION_OP, tree->symbol, NULL, NULL);
			
			if (tree->left)
				tree->code->next = tree->left->code;
			break;
		case SYMBOL:
			break;
		case FUNCTION_ROOT:
			if (tree->left) {
				tree->code = tree->left->code;

				Code *tail = tree->code;

				while (tail->next)
					tail = tail->next;

				tail->next = tree->right->code;
			} else {
				tree->code = tree->right->code;
			}
			break;
		default:
			break;
	}
	
	return tree->code;
}

/* Function: writeCode
 * Parameters: Code *code
 * Description: Converts the given three address code list into mips assemblycode.
 * Returns: none
 * Preconditions: none
 */
void writeCode(Code *code) {
	if (!code)
		return;
	
	switch (code->opcode) {
		/*case ADD_OP:
			break;
		case SUB_OP:
			break;
		case MULT_OP:
			break;
		case DIV_OP:
			break;
		case NEG_OP:
			break;
		case EQUAL_OP:
			break;
		case NOT_EQUAL_OP:
			break;
		case GREATER_THAN_OP:
			break;
		case GREATER_EQUAL_OP:
			break;
		case LESS_THAN_OP:
			break;
		case LESS_EQUAL_OP:
			break;
		case AND_OP:
			break;
		case OR_OP:
			break;
		case BRANCH_EQUAL:
			break;
		case BRANCH_NOT_EQUAL:
			break;
		case BRANCH_LESS:
			break;
		case BRANCH_LESS_EQUAL:
			break;
		case BRANCH_GREATER:
			break;
		case BRANCH_GREATER_EQUAL:
			break;
		case JUMP:
			break;
		case WHILE_OP:
			break;
		case RETURN_OP:
			break;*/
		case ASSIGNMENT_OP:
			printf("\n");
			if (code->source1->location) {
				printf("\tlw\t$t0, %s\n", code->source1->location);
				printf("\tsw\t$t0, %s\n", code->destination->location);
			} else {
				if (code->source1->type == CHAR_TYPE) {
					printf("\tli\t$t0, '%c'\n", code->source1->value.charVal);
					printf("\tsw\t$t0, %s\n", code->destination->location);
				} else if (code->source1->type == INT_TYPE) {
					printf("\tli\t$t0, %d\n", code->source1->value.intVal);
					printf("\tsw\t$t0, %s\n", code->destination->location);
				} else {
					; // arrays?
				}
			}
			break;
		case ENTER:
			printf("\n");
			printf("\tjal\t_%s\n", code->source1->identifier);
			break;
		case LEAVE:
			break;
		case PUSH_PARAM:
			printf("\n");
			if (strcmp(code->next->source1->identifier, "print_int") == 0
					|| strcmp(code->next->source1->identifier, "print_string") == 0) {
				if (code->source1->location) {
					printf("\tlw\t$a0, %s\n", code->source1->location);
				} else {
					if (code->source1->type == CHAR_TYPE)
						printf("\tli\t$a0, '%c'\n", code->source1->value.charVal);
					else if (code->source1->type == INT_TYPE)
						printf("\tli\t$a0, %d\n", code->source1->value.intVal);
					else
						;	// string param
				}
			} else {
				printf("\taddiu\t$sp, $sp, 4\n");
				_stackSize += 4;
				if (code->source1->location) {
					printf("\tlw\t$t0, %s\n", code->source1->location);
					printf("\tsw\t$t0, 0($sp)\n");
				} else {
					if (code->source1->type == CHAR_TYPE)
						printf("\tli\t$t0, '%c'\n", code->source1->value.charVal);
					else if (code->source1->type == INT_TYPE)
						printf("\tli\t0($sp), %d\n", code->source1->value.intVal);
					else
						;	// string param
				}
				printf("\tsw\t$t0, 0($sp)\n");
			}
			break;
		case DECLARATION_OP:
			break;
		default:
			break;
	}
	
	writeCode(code->next);
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
