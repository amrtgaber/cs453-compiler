/* File: parser.yacc 
 * Author: Amr Gaber
 * Created: 24/9/2010
 * Last Modified: 27/11/2010
 * Purpose: Parser for the C-- compiler. Used with scanner.lex and makefile to
 * 				construct the C-- compiler.
 */

%{
#include "utilities.h"
#include "symbolTable.h"
#include "syntaxTree.h"
#include "code.h"
#include "functionCall.h"

typedef struct TempVariable {
	Symbol *symbol;
	struct TempVariable *next;
} TempVariable;

typedef struct StringLiteral {
	Symbol 	*symbol;
	struct StringLiteral *next;
} StringLiteral;

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
		insertStringLiteral(Symbol *stringLiteral),
		popStringLiterals(StringLiteral *stringLiteral),
		insertTempVariable(Symbol *tempVariable),
		popTempVariables(TempVariable *tempVariable),
		writeExpressionCode(char *mnemonic, char *operator, Code *code);
char	isStringLiteral(Symbol *target);
int		allocateStackSpace(SyntaxTree *declaration, int offset);
Symbol	*recallStringLiteral(char *string);
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
				_offset = 0,
				_stackSize = 0;
Type	_currType = UNKNOWN,
		_currPType = UNKNOWN;
FunctionType _currFType = F_UNKNOWN;
Parameter *_currParam = NULL;
StringLiteral *_stringLiterals = NULL;
TempVariable *_tempVariables = NULL;
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
%type	<integer>		INTCON
%type 	<string>		ID storeID STRCON
%type 	<tree>			assignment statement statementOpt paramTypes arrayTypeOpt
							args varDcl multiVarDcl multiParam multiExprOpt
							multiTypeDcl assgOpt
%type	<exprReturn>	expr multiFuncOpt exprOpt

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
			  SyntaxTree *declarations = createTree(DECLARATION, NULL, $2, $3);
			  declareGlobalVariables(declarations);
			  printf("\n");
			  destroyTree(declarations);
			}
			| storeExtern type storeFID '(' insertFunc paramTypes ')'
				multiProtDcl makeProt { _currFType = F_UNKNOWN; }
			| type storeFID '(' insertFunc paramTypes ')' multiProtDcl makeProt { _currFType = F_UNKNOWN; }
			| storeExtern storeVoid storeFID '(' insertFunc paramTypes ')'
			    multiProtDcl makeProt { _currFType = F_UNKNOWN; }
			| storeVoid storeFID '(' insertFunc paramTypes ')' multiProtDcl makeProt { _currFType = F_UNKNOWN; }
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

multiVarDcl:  multiVarDcl ',' varDcl { $3->left = $1; $$ = $3; }
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
				  $$ = createTree(DECLARATION, currSymbol, NULL, NULL);
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
				  $$ = createTree(DECLARATION, currSymbol, NULL, NULL);
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
			
			
			  SyntaxTree *tree = $3;
			
			  if (tree) {
				  while (tree->left)
					  tree = tree->left;
			  
			  	  tree->left = $2;
			      $$ = $3;
			  } else {
				  $$ = $2;
			  }
			  
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
							$$ = createTree(FORMAL, currSymbol, NULL, NULL);
						}
			  	 	} else {
				  		Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					    currSymbol->functionType = NON_FUNCTION;
						$$ = createTree(FORMAL, currSymbol, NULL, NULL);
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
						  $$ = createTree(FORMAL, currSymbol, NULL, NULL);
					  }
			  	  } else {
				  	  Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					  currSymbol->functionType = NON_FUNCTION;
					  $$ = createTree(FORMAL, currSymbol, NULL, NULL);
			  	  }
			  }
			
			 if (_currParam)
			   _currParam = _currParam->next;
			}
			;

multiParam:   multiParam ',' arrayTypeOpt { $3->left = $1; $$ = $3; }
			| /* empty */ { $$ = NULL; }
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
			  
			  Symbol *currFunction = recallGlobal(_currFID);

			  SyntaxTree *declarations = $8;

			  if (declarations) {
				  while (declarations->left)
					  declarations = declarations->left;

				  declarations->left = $5;
			  } else {
				  $8 = $5;
			  }

			  SyntaxTree *function = createTree(FUNCTION_ROOT, currFunction, $8, $9);

			  printf("\n.text\n\n");

			  #if defined(DEBUG_SYNTAX) || defined(DEBUG_ALL)
			  	  printf("\nSYNTAX TREE:\n\n");
			  	  printSyntaxTree(function, 0);
			  #endif

			  #if defined(DEBUG_SYMBOLS) || defined(DEBUG_ALL)
			  	  printSymbolTable();
			  #endif

			  if (strcmp("main", _currFID) == 0)
				  printf("main:\n");
			  else
				  printf("_%s:\n", _currFID);

			  _stackSize = 8;
			  _stackSize += allocateStackSpace(function, 0);

			  printf("\tsubu\t$sp, $sp, %d\n", _stackSize);
			  printf("\tsw\t\t$ra, %d($sp)\n", _stackSize - 4);
			  printf("\tsw\t\t$fp, %d($sp)\n", _stackSize - 8);
			  printf("\taddu\t$fp, $sp, %d\n", _stackSize);

			  SyntaxTree *parameter = $5;
			  SyntaxTree *parameterName = $5;
			  int i, j, k, l;
			  i = j = k = l = 0;
			  for(i = 12, j = 0; parameter; i += 4, j += 4) {

					// this 'if' is just to get the parameter names in order
					l = 0;
					parameterName = $5;
				    if (k == 0 && parameterName == parameter) {
						while (parameterName->left) {
							parameterName = parameterName->left;
							k++;
						}
						k--;
					} else {
						while (l < k) {
							parameterName = parameterName->left;
							l++;
						}
						k--;
					}

					if (parameter->symbol->type == CHAR_TYPE) {
						printf("\tlb\t\t$t0, %d($fp)\t\t# storing parameter %s\n", j, parameterName->symbol->identifier);
						printf("\tsb\t\t$t0, %d($sp)\n", _stackSize - i);
					} else {
						printf("\tlw\t\t$t0, %d($fp)\t\t# storing parameter %s\n", j, parameterName->symbol->identifier);
						printf("\tsw\t\t$t0, %d($sp)\n", _stackSize - i);
					}
					
					if (parameter->symbol->type == CHAR_ARRAY || parameter->symbol->type == INT_ARRAY)
						parameter->symbol->reference = TRUE;

					parameter = parameter->left;
			  }

			  if (i <= _stackSize) {
			  	  printf("\t# initializing local variables\n");

				  for( ; i <= _stackSize; i += 4)
					  printf("\tsw\t\t$0, %d($sp)\n", _stackSize - i);
			  }

			  Code *code = constructCode(function);

			  writeCode(code);

			  #if defined(DEBUG_CODE) || defined(DEBUG_ALL)
			      printf("\nTHREE ADDRESS CODE:\n\n");
			      printCode(code);
			  #endif

			  printf("\n__%sReturn:\n", _currFID);
			  printf("\tlw\t\t$fp, %d($sp)\n", _stackSize - 8);
			  printf("\tlw\t\t$ra, %d($sp)\n", _stackSize - 4);
			  printf("\taddu\t$sp, $sp, %d\n", _stackSize);
			  printf("\tjr\t\t$ra\n");

			  destroyTree(function);
			  destroyCode(code);
			  popSymbolTable();
			}
			| storeVoid storeFID '(' insertFunc paramTypes ')' '{' multiTypeDcl
				  statementOpt '}' 
			{ 
			  Symbol *currFunction = recallGlobal(_currFID);
							
			  SyntaxTree *declarations = $8;
			
			  if (declarations) {
				  while (declarations->left)
					  declarations = declarations->left;
					
				  declarations->left = $5;
			  } else {
				  $8 = $5;
			  }
			
			  SyntaxTree *function = createTree(FUNCTION_ROOT, currFunction, $8, $9);
			
			  printf("\n.text\n\n");
			
			  #if defined(DEBUG_SYNTAX) || defined(DEBUG_ALL)
			  	  printf("\nSYNTAX TREE:\n\n");
			  	  printSyntaxTree(function, 0);
			  #endif

			  #if defined(DEBUG_SYMBOLS) || defined(DEBUG_ALL)
			  	  printSymbolTable();
			  #endif
			
			  if (strcmp("main", _currFID) == 0)
				  printf("main:\n");
			  else
				  printf("_%s:\n", _currFID);
			
			  _stackSize = 8;
			  _stackSize += allocateStackSpace(function, 0);

			  printf("\tsubu\t$sp, $sp, %d\n", _stackSize);
			  printf("\tsw\t\t$ra, %d($sp)\n", _stackSize - 4);
			  printf("\tsw\t\t$fp, %d($sp)\n", _stackSize - 8);
			  printf("\taddu\t$fp, $sp, %d\n", _stackSize);
			  
			  SyntaxTree *parameter = $5;
			  SyntaxTree *parameterName = $5;
			  int i, j, k, l;
			  i = j = k = l = 0;
			  for(i = 12, j = 0; parameter; i += 4, j += 4) {
					
					// this 'if' is just to get the parameter names in order
					l = 0;
					parameterName = $5;
				    if (k == 0 && parameterName == parameter) {
						while (parameterName->left) {
							parameterName = parameterName->left;
							k++;
						}
						k--;
					} else {
						while (l < k) {
							parameterName = parameterName->left;
							l++;
						}
						k--;
					}
				
					if (parameter->symbol->type == CHAR_TYPE) {
						printf("\tlb\t\t$t0, %d($fp)\t\t# storing parameter %s\n", j, parameterName->symbol->identifier);
						printf("\tsb\t\t$t0, %d($sp)\n", _stackSize - i);
					} else {
						printf("\tlw\t\t$t0, %d($fp)\t\t# storing parameter %s\n", j, parameterName->symbol->identifier);
						printf("\tsw\t\t$t0, %d($sp)\n", _stackSize - i);
					}
					
					if (parameter->symbol->type == CHAR_ARRAY || parameter->symbol->type == INT_ARRAY)
						parameter->symbol->reference = TRUE;
						
					parameter = parameter->left;
			  }
			  
			  if (i <= _stackSize) {
			  	  printf("\t# initializing local variables\n");
			
				  for( ; i <= _stackSize; i += 4)
					  printf("\tsw\t\t$0, %d($sp)\n", _stackSize - i);
			  }

			  Code *code = constructCode(function);
			
			  writeCode(code);
			  
			  #if defined(DEBUG_CODE) || defined(DEBUG_ALL)
			      printf("\nTHREE ADDRESS CODE:\n\n");
			      printCode(code);
			  #endif
			
			  printf("\n__%sReturn:\n", _currFID);
			  printf("\tlw\t\t$fp, %d($sp)\n", _stackSize - 8);
			  printf("\tlw\t\t$ra, %d($sp)\n", _stackSize - 4);
			  printf("\taddu\t$sp, $sp, %d\n", _stackSize);
			  printf("\tjr\t\t$ra\n");

			  destroyTree(function);
			  destroyCode(code);
			  popSymbolTable();
			}
			;

multiTypeDcl: multiTypeDcl type varDcl multiVarDcl ';'
			{
				SyntaxTree *tree = $4;
				
				if (tree) {
					
					while (tree->left)
						tree = tree->left;
					
					tree->left = $3;
					$3->left = $1;
					$$ = $4;
				} else {
					$3->left = $1;
					$$ = $3;
				}
			}

			/* error productions */
			| multiTypeDcl type error ';' { yyerrok; $$ = NULL; }

			| /* empty */ { $$ = NULL; }
			;

statement:	  IF '(' expr ')' statement
			{
			  if ($3.type != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			  
			  $$ = createTree(IF_TREE, NULL, $3.tree, $5);
			}
			| IF '(' expr ')' statement ELSE statement
			{
			  if ($3.type != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
				
				$$ = createTree(IF_TREE, NULL, $3.tree, $5);
				$$->opt = $7;
			}
			| WHILE '(' expr ')' statement
			{
			  if ($3.type != BOOLEAN)
				  typeError("conditional in while loop must be a boolean");
				
			  $$ = createTree(WHILE_TREE, NULL, $3.tree, $5);
			}
			| FOR '(' assgOpt ';' exprOpt ';' assgOpt ')' statement
			{
			  if ($5.type != BOOLEAN)
				  typeError("conditional in for loop must be a boolean");
				
			SyntaxTree *tree = createTree(WHILE_TREE, NULL, $5.tree, $9);
			tree->opt = $7;
			$$ = createTree(STATEMENT, NULL, tree, $3);
			}
			| RETURN expr ';'
			{
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
				  $$ = NULL;
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
				
				  $$ = createTree(RETURN_TREE, currSymbol, $2.tree, NULL);
			  }
			}
			| RETURN ';'
			{
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
				  $$ = NULL;
			  } else {
				  if (currSymbol->type != VOID_TYPE) {
					  sprintf(_errorMessage, "return type for function %s does not match declared type",
						  _currFID);
					  typeError(_errorMessage);
				  }
				
				  $$ = createTree(RETURN_TREE, currSymbol, NULL, NULL);
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
				
				  SyntaxTree *tree = $5;

				  if (tree) {
					  while (tree->left)
						  tree = tree->left;

				  	  tree->left = $4;
				      $$ = createTree(FUNCTION_CALL, recallGlobal(_callStack->identifier), $5, NULL);
				  } else {
					  $$ = createTree(FUNCTION_CALL, recallGlobal(_callStack->identifier), $4, NULL);
				  }

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

exprOpt:	  expr { $$.type = $1.type; $$.tree = $1.tree; }
			| /* empty */ { $$.type = BOOLEAN; $$.tree = NULL; }
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
				
				SyntaxTree *symbolTree = createTree(SYMBOL, currSymbol, NULL, NULL);
				generateNewTempID();
				Symbol *newSymbol = insert(_tempID, currSymbol->type);
				SyntaxTree *array = createTree(ARRAY, newSymbol, symbolTree, $3.tree);
				$$ = createTree(ASSIGNMENT, NULL, array, $6.tree);
			  }
			}
			;

assgOpt:	  assignment { $$ = $1; }
			| /* empty */ { $$ = NULL; }
			;

expr:		  '-' expr %prec UMINUS
			{
			  if ($2.type != INT_TYPE && $2.type != CHAR_TYPE)
				  typeError("incompatible expression for operator '-'");
			
			  $$.type = $2.type;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  $$.tree = createTree(NEG, newSymbol, $2.tree, NULL);
			}
			| '!' expr
			{
			  if ($2.type != BOOLEAN)
				  typeError("incompatible expression for operator '!'");
			
			  $$.type = $2.type;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(NOT, newSymbol, $2.tree, NULL);
			}
			| expr '+' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE)
				  || ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '+'");
			
			  $$.type = $1.type;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  $$.tree = createTree(ADD, newSymbol, $3.tree, $1.tree);
			}
			| expr '-' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE)
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '-'");
			
			  $$.type = $1.type;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  $$.tree = createTree(SUB, newSymbol, $3.tree, $1.tree);
			}
			| expr '*' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '*'");
			
			  $$.type = $1.type;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  $$.tree = createTree(MULT, newSymbol, $3.tree, $1.tree);
			}
			| expr '/' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '/'");
			
			  $$.type = $1.type;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  $$.tree = createTree(DIV, newSymbol, $3.tree, $1.tree);
			}
			| expr DBLEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '=='");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(EQUAL, newSymbol, $3.tree, $1.tree);
			}
			| expr NOTEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '!='");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(NOT_EQUAL, newSymbol, $3.tree, $1.tree);
			}
			| expr LTEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '<='");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(LESS_EQUAL, newSymbol, $3.tree, $1.tree);
			}
			| expr '<' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '<'");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(LESS_THAN, newSymbol, $3.tree, $1.tree);
			}
			| expr GTEQ expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '>='");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(GREATER_EQUAL, newSymbol, $3.tree, $1.tree);
			}
			| expr '>' expr
			{
			  if (($1.type != INT_TYPE && $1.type != CHAR_TYPE) 
					|| ($3.type != INT_TYPE && $3.type != CHAR_TYPE))
				  typeError("incompatible expression for operator '>'");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(GREATER_THAN, newSymbol, $3.tree, $1.tree);
			}
			| expr LOGICAND expr
			{
			  if ($1.type != BOOLEAN || $3.type != BOOLEAN)
				  typeError("incompatible expression for operator '&&'");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(AND, newSymbol, $3.tree, $1.tree);
			}
			| expr LOGICOR expr
			{
			  if ($1.type != BOOLEAN || $3.type != BOOLEAN)
				  typeError("incompatible expression for operator '||'");
			
			  $$.type = BOOLEAN;
			
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, BOOLEAN);
			  $$.tree = createTree(OR, newSymbol, $3.tree, $1.tree);
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
			| '(' expr ')'	{ $$.type = $2.type; $$.tree = $2.tree; }
			| INTCON
			{
			  $$.type = INT_TYPE;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  newSymbol->value.intVal = $1;
			  newSymbol->functionType = NON_FUNCTION;
			  $$.tree = createTree(LITERAL, newSymbol, NULL, NULL);
			}
			| CHARCON
			{
			  $$.type = CHAR_TYPE;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, CHAR_TYPE);
			  newSymbol->value.charVal = $1;
			  newSymbol->functionType = NON_FUNCTION;
			  $$.tree = createTree(LITERAL, newSymbol, NULL, NULL);
			}
			| STRCON
			{
			  $$.type = CHAR_ARRAY;
			  
			  Symbol *currSymbol = recallStringLiteral($1);
			  
			  if (!currSymbol) {
			      generateNewTempID();
				  currSymbol = insertGlobal(_tempID, CHAR_ARRAY);
				  currSymbol->value.strVal = $1;
				  currSymbol->functionType = NON_FUNCTION;

				  if (!(currSymbol->location = malloc(strlen(currSymbol->identifier) + 2)))
					  ERROR(NULL, __LINE__, TRUE);				//out of memory


				  sprintf(currSymbol->location, "_%s", currSymbol->identifier);
				  insertStringLiteral(currSymbol);
			  }
			  
			  $$.tree = createTree(LITERAL, currSymbol, NULL, NULL);
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
				  generateNewTempID();
				  Symbol *newSymbol = insert(_tempID, currSymbol->type);
				  SyntaxTree *tree = createTree(FUNCTION_CALL, currSymbol, NULL, NULL);
				  $$.tree = createTree(RETRIEVE, newSymbol, tree, NULL);
			  } else {
				  $$.type = UNKNOWN;
				  $$.tree = NULL;
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
				
				  SyntaxTree *tree = $4;

				  if (tree) {
					  while (tree->left)
						  tree = tree->left;

				  	  tree->left = $3;
					  
					  generateNewTempID();
					  Symbol *newSymbol = insert(_tempID, $$.type);
					  SyntaxTree *tree = createTree(FUNCTION_CALL, recallGlobal(_callStack->identifier), $4, NULL);
					  $$.tree = createTree(RETRIEVE, newSymbol, tree, NULL);
				  } else {
					  generateNewTempID();
					  Symbol *newSymbol = insert(_tempID, $$.type);
					  SyntaxTree *tree = createTree(FUNCTION_CALL, recallGlobal(_callStack->identifier), $3, NULL);
					  $$.tree = createTree(RETRIEVE, newSymbol, tree, NULL);
				  }
				
			      popFunctionCall();
			  } else {
			      $$.type = UNKNOWN;
				  $$.tree = NULL;
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
				  sprintf(_errorMessage, "array index for %s must be INT or CHAR",
					  _currID);
			  	  typeError(_errorMessage);
			  }
			
			  if (!_callStack) {
				  $$.type = UNKNOWN;
				  $$.tree = NULL;
			  } else {
				  $$.type = (recall(_callStack->identifier))->type;
				
				  generateNewTempID();
				  Symbol *newSymbol = insert(_tempID, $$.type);
				  SyntaxTree *tree = createTree(SYMBOL, recall(_callStack->identifier), NULL, NULL);
				  $$.tree = createTree(ARRAY, newSymbol, tree, $3.tree);
				
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
				  $$.tree = NULL;
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
						  $$ = createTree(PARAMETER, NULL, NULL, $1.tree);
					  }
				  } else {
					  $$ = createTree(PARAMETER, NULL, NULL, $1.tree);
				  }
			  } else {
				  $$ = NULL;
			  }
		  	  
		      if (_callStack->currParam)
			      _callStack->currParam = _callStack->currParam->next;
			}
			;

multiExprOpt: multiExprOpt ',' args { $3->left = $1; $$ = $3; }
			| /* empty */ { $$ = NULL; }
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
	
	printf("\n.data\n");
	popTempVariables(_tempVariables);
	popStringLiterals(_stringLiterals);
	
	popSymbolTable();				// free global symbol table
	
	printf("\n.text\n\n");
	printf("_print_int:\n");
	printf("\tli\t\t$v0, 1\n");
	printf("\tlw\t\t$a0, 0($sp)\n");
	printf("\tsyscall\n");
	printf("\tjr\t\t$ra\n");
	
	printf("\n_print_string:\n");
	printf("\tli\t\t$v0, 4\n");
	printf("\tlw\t\t$a0, 0($sp)\n");
	printf("\tsyscall\n");
	printf("\tjr\t\t$ra\n");
	
	printf("_read_int:\n");
	printf("\tli\t\t$v0, 5\n");
	printf("\tsyscall\n");
	printf("\tjr\t\t$ra\n");
	
	printf("\n_read_string:\n");
	printf("\tli\t\t$v0, 8\n");
	printf("\tsyscall\n");
	printf("\tlw\t\t$t0, 0($sp)\n");
	printf("__read_string_copy:\n");
	printf("\tlb\t\t$t1, 0($a0)\n");
	printf("\tsb\t\t$t1, 0($t0)\n");
	printf("\taddi\t$t0, $t0, 1\n");
	printf("\taddi\t$a0, $a0, 1\n");
	printf("\tbgtz\t$t1, __read_string_copy\n");
	printf("\tjr\t\t$ra\n");
	
	if (_generateCode)
		return 0;					// success
	return 1;						// failure
}

/* Function: insertTempVariable
 * Parameters: Symbol *tempVariable
 * Description: Adds the given temp variable to the list of temp variables.
 * Returns: none
 * Preconditions: none
 */
void insertTempVariable(Symbol *tempVariable) {
	if (!tempVariable)
		return;
	
	TempVariable *newTemp = NULL;
	
	if (!(newTemp = malloc(sizeof(TempVariable))))
		ERROR(NULL, __LINE__, TRUE);					// out of memory
		
	newTemp->symbol = tempVariable;
	
	newTemp->next = _tempVariables;
	_tempVariables = newTemp;
}

/* Function: popTempVariables
 * Parameters: TempVariable *tempVariable
 * Description: Writes all global temps into mips global data and frees temp
 *					variables list.
 * Returns: none
 * Preconditions: none
 */
void popTempVariables(TempVariable *tempVariable) {
	if (!tempVariable)
		return;
	
	printf("\n");
	printf("_%s:\n", tempVariable->symbol->identifier);

	if (tempVariable->symbol->type == CHAR_TYPE)
		printf("\t.byte 0\n");
	else
		printf("\t.word 0\n");
	
	
	popTempVariables(tempVariable->next);
	free(tempVariable);
}

/* Function: insertStringLiteral
 * Parameters: Symbol *stringLiteral
 * Description: Adds the given string literal to the list of string literals.
 * Returns: none
 * Preconditions: none
 */
void insertStringLiteral(Symbol *stringLiteral) {
	if (!stringLiteral)
		return;
	
	StringLiteral *newStringLiteral = NULL;
	
	if (!(newStringLiteral = malloc(sizeof(StringLiteral))))
		ERROR(NULL, __LINE__, TRUE);						// out of memory
	
	newStringLiteral->symbol = stringLiteral;
	
	newStringLiteral->next = _stringLiterals;
	_stringLiterals = newStringLiteral;
}

/* Function: recallStringLiteral
 * Parameters: char *targetString
 * Description: Searches string literals list for target string. If found
 *					returns a reference to its symbol table entry.
 * Returns: A reference to the symbol table entry storing the specified string
 *				if found, NULL otherwise.
 * Preconditions: none
 */
Symbol	*recallStringLiteral(char *targetString) {
	if (!targetString)
		return NULL;
	
	StringLiteral *currString = _stringLiterals;
	
	while (currString) {
		if (strcmp(currString->symbol->value.strVal, targetString) == 0)
			return currString->symbol;
		
		currString = currString->next;
	}
	
	return NULL;
}

/* Function: popStringLiterals
 * Parameters: Symbol *stringLiteral
 * Description: Writes all global strings into mips global data and frees string
 *					literals list.
 * Returns: none
 * Preconditions: none
 */
void popStringLiterals(StringLiteral *stringLiteral) {
	if (!stringLiteral)
		return;
	
	printf("\n");
	printf("_%s:\n", stringLiteral->symbol->identifier);
	printf("\t.asciiz\t%s\n", stringLiteral->symbol->value.strVal);
	
	popStringLiterals(stringLiteral->next);
	free(stringLiteral->symbol->value.strVal);
	free(stringLiteral);
}

/* Function: yyerror
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
			printf("\t.byte 0\n");
			break;
		case INT_TYPE:
			printf("\t.word 0\n");
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
 * Preconditions: On the first call to this function the offset is 0.
 */
int allocateStackSpace(SyntaxTree *declaration, int offset) {
	if (!declaration)
		return offset;
	
	if (!declaration->symbol
			|| declaration->operation == LITERAL
			|| (declaration->operation != DECLARATION
			&& declaration->operation != FORMAL
			&& strncmp(declaration->symbol->identifier, "_temp", 5) != 0)) {
		offset = allocateStackSpace(declaration->right, offset);
		offset = allocateStackSpace(declaration->left, offset);
		offset = allocateStackSpace(declaration->opt, offset);
	} else {
		if (!(declaration->symbol->location = malloc(10 * sizeof(char))))
			ERROR(NULL, __LINE__, TRUE);							//out of memory
	
		sprintf(declaration->symbol->location, "%d($sp)", offset);
	
		//printf("Declaration %s has location %s\n", declaration->symbol->identifier, declaration->symbol->location);
	
		if (declaration->operation == DECLARATION) {
		
			if (declaration->symbol->type == CHAR_ARRAY) {
				offset += declaration->symbol->value.intVal;
				if (offset % 4 != 0)
					offset += 4 - (offset % 4);
				offset = allocateStackSpace(declaration->left, offset);
			} else	if (declaration->symbol->type == INT_ARRAY) {
				offset += 4 * declaration->symbol->value.intVal;
				offset = allocateStackSpace(declaration->left, offset);				
			} else {
				offset = allocateStackSpace(declaration->left, offset + 4);
			}

		} else {
			offset = allocateStackSpace(declaration->right, offset + 4);
			offset = allocateStackSpace(declaration->left, offset);
			offset = allocateStackSpace(declaration->opt, offset);
		}
	}
	return offset;
}

/* Function: constructCode
 * Parameters: SyntaxTree *tree
 * Description: Converts the given syntax tree into a three address code list.
 * Returns: The head of a code list.
 * Preconditions: none
 */
Code *constructCode(SyntaxTree *tree) {
	if (!tree || !_generateCode)
		return NULL;
	
	constructCode(tree->left);
	constructCode(tree->right);
	constructCode(tree->opt);
	
	Code *code = NULL;
	
	switch (tree->operation) {
		case ADD:
		
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(ADD_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(ADD_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(ADD_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}
			
			break;
	 	case SUB:
	
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(SUB_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(SUB_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(SUB_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}
			
			break;
		case MULT:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(MULT_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(MULT_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(MULT_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}
			
			break;
		case DIV:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(DIV_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(DIV_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(DIV_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}
			
			break;
		case NEG:
			
			if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(NEG_OP, tree->left->symbol, NULL, tree->symbol);
			} else {
				tree->code = createCode(NEG_OP, tree->left->symbol, NULL, tree->symbol);
			}
			
			break;
		case NOT:
			
			if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(NOT_OP, tree->left->symbol, NULL, tree->symbol);
			} else {
				tree->code = createCode(NOT_OP, tree->left->symbol, NULL, tree->symbol);
			}

			break;
		case EQUAL:
		
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}

			break;
		case NOT_EQUAL:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(NOT_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(NOT_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(NOT_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}

			break;
		case GREATER_THAN:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(GREATER_THAN_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(GREATER_THAN_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(GREATER_THAN_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}

			break;
		case GREATER_EQUAL:
		
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(GREATER_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(GREATER_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(GREATER_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}

			break;
		case LESS_THAN:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(LESS_THAN_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(LESS_THAN_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(LESS_THAN_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}

			break;
		case LESS_EQUAL:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(LESS_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(LESS_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(LESS_EQUAL_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}

			break;
		case AND:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = createCode(NOT_OP, tree->right->symbol, NULL, tree->right->symbol);
				code = code->next;
				generateNewLabelID();
				Symbol *shortSymbol = insertGlobal(_labelID, UNKNOWN);
				code->next = createCode(BRANCH, tree->right->symbol, NULL, shortSymbol);
				code = code->next;
				code->next = createCode(NOT_OP, tree->right->symbol, NULL, tree->right->symbol);
				code = code->next;
				
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(AND_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = code->next; 
				code->next = createCode(LABEL, shortSymbol, NULL, NULL);
			} else if (tree->left->code) {
				tree->code = createCode(NOT_OP, tree->right->symbol, NULL, tree->right->symbol);
				code = tree->code;
				generateNewLabelID();
				Symbol *shortSymbol = insertGlobal(_labelID, UNKNOWN);
				code->next = createCode(BRANCH, tree->right->symbol, NULL, shortSymbol);
				code = code->next;
				code->next = createCode(NOT_OP, tree->right->symbol, NULL, tree->right->symbol);
				code = code->next;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(AND_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = code->next;
				code->next = createCode(LABEL, shortSymbol, NULL, NULL);
			} else {
				tree->code = createCode(NOT_OP, tree->right->symbol, NULL, tree->right->symbol);
				code = tree->code;
				generateNewLabelID();
				Symbol *shortSymbol = insertGlobal(_labelID, UNKNOWN);
				code->next = createCode(BRANCH, tree->right->symbol, NULL, shortSymbol);
				code = code->next;
				code->next = createCode(NOT_OP, tree->right->symbol, NULL, tree->right->symbol);
				code = code->next;
				code->next = createCode(AND_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = code->next; 
				code->next = createCode(LABEL, shortSymbol, NULL, NULL);
			}

			break;
		case OR:
		
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = createCode(OR_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = code->next;
				generateNewLabelID();
				Symbol *shortSymbol = insertGlobal(_labelID, UNKNOWN);
				code->next = createCode(BRANCH, tree->right->symbol, NULL, shortSymbol);
				code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(OR_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = code->next; 
				code->next = createCode(LABEL, shortSymbol, NULL, NULL);
			} else if (tree->left->code) {
				tree->code = createCode(OR_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = tree->code;
				generateNewLabelID();
				Symbol *shortSymbol = insertGlobal(_labelID, UNKNOWN);
				code->next = createCode(BRANCH, tree->right->symbol, NULL, shortSymbol);
				code = code->next;
				
				code->next = tree->left->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(OR_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = code->next;
				code->next = createCode(LABEL, shortSymbol, NULL, NULL);
			} else {
				tree->code = createCode(OR_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = tree->code;
				generateNewLabelID();
				Symbol *shortSymbol = insertGlobal(_labelID, UNKNOWN);
				code->next = createCode(BRANCH, tree->right->symbol, NULL, shortSymbol);
				code = code->next;
				code->next = createCode(OR_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
				code = code->next;
				code->next = createCode(LABEL, shortSymbol, NULL, NULL);
			}

			break;
		case ARRAY:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
				
				code->next = createCode(ARRAY_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			} else {
				tree->code = createCode(ARRAY_OP, tree->left->symbol, tree->right->symbol, tree->symbol);
			}

			break;
		case RETRIEVE:
			
			if (tree->left->code) {
				tree->code = tree->left->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
				
				code->next = createCode(RETRIEVE_OP, tree->left->symbol, NULL, tree->symbol);
			} else {
				tree->code = createCode(RETRIEVE_OP, tree->left->symbol, NULL, tree->symbol);
			}
			
			break;
		case IF_TREE:
			
			tree->code = tree->left->code;
		
			code = tree->code;
		
			while (code->next)
				code = code->next;
			
			generateNewLabelID();
			Symbol *trueSymbol = insertGlobal(_labelID, UNKNOWN);
			code->next = createCode(BRANCH, tree->left->symbol, NULL, trueSymbol);
			code = code->next;
			generateNewLabelID();
			Symbol *falseSymbol = insertGlobal(_labelID, UNKNOWN);
			code->next = createCode(JUMP, falseSymbol, NULL, NULL);
			code = code->next;
			code->next = createCode(LABEL, trueSymbol, NULL, NULL);
			code = code->next;
			
			if (tree->right && tree->right->code) {
				code->next = tree->right->code;
				
				while (code->next)
					code = code->next;
			}
			
			if (tree->opt) {
				generateNewLabelID();
				Symbol *afterSymbol = insertGlobal(_labelID, UNKNOWN);
				code->next = createCode(JUMP, afterSymbol, NULL, NULL);
				code = code->next;
				code->next = createCode(LABEL, falseSymbol, NULL, NULL);
				code = code->next;
				code->next = tree->opt->code;
				
				while (code->next)
					code = code->next;
					
				code->next = createCode(LABEL, afterSymbol, NULL, NULL);				
			} else {
				code->next = createCode(LABEL, falseSymbol, NULL, NULL);
			}
			
			break;
		case WHILE_TREE:
			
			generateNewLabelID();
			Symbol *conditionSymbol = insertGlobal(_labelID, UNKNOWN);
			tree->code = createCode(JUMP, conditionSymbol, NULL, NULL);
			code = tree->code;
			generateNewLabelID();
			Symbol *trueSym = insertGlobal(_labelID, UNKNOWN);
			code->next = createCode(LABEL, trueSym, NULL, NULL);
			code = code->next;
			
			if (tree->right && tree->right->code) {
				code->next = tree->right->code;
				
				while (code->next)
					code = code->next;
			}
			
			if (tree->opt) {
				code->next = tree->opt->code;
				
				while (code->next)
					code = code->next;
			}
			
			code->next = createCode(LABEL, conditionSymbol, NULL, NULL);
			code = code->next;
			if (tree->left)
				code->next = tree->left->code;
			
			while (code->next)
				code = code->next;
			
			if (tree->left)
				code->next = createCode(BRANCH, tree->left->symbol, NULL, trueSym);
			else
				code->next = createCode(JUMP, trueSym, NULL, NULL);
			
			break;
		case RETURN_TREE:
			if (!tree->left) {
				tree->code = createCode(RETURN_OP, NULL, NULL, tree->symbol);
			} else {
				
				if (tree->left->code) {
					tree->code = tree->left->code;

					code = tree->code;

					while (code->next)
						code = code->next;
					code->next = createCode(RETURN_OP, tree->left->symbol, NULL, tree->symbol);
				} else {
					tree->code = createCode(RETURN_OP, tree->left->symbol, NULL, tree->symbol);
				}
			}
			break;
		case ASSIGNMENT:
			
			if (tree->right->code) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
				
				if (tree->left->code) {
					code = tree->left->code;
					
					while(code->next)
						code = code->next;
				}
				
				code->next = createCode(ASSIGNMENT_OP, tree->right->symbol, NULL, tree->left->symbol);
			} else if (tree->left->code) {
				tree->code = tree->left->code;
				
				code = tree->code;
				
				while(code->next)
					code = code->next;
				
				code->next = createCode(ASSIGNMENT_OP, tree->right->symbol, NULL, tree->left->symbol);
			} else {
				tree->code = createCode(ASSIGNMENT_OP, tree->right->symbol, NULL, tree->left->symbol);
			}
			
			break;
		case STATEMENT:
			if (tree->right) {
				tree->code = tree->right->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = tree->left->code;
			} else {
				tree->code = tree->left->code;
			}
			break;
		case FUNCTION_CALL:
			if (tree->left) {
				tree->code = tree->left->code;
			
				code = tree->code;
			
				while (code->next)
					code = code->next;
			
				code->next = createCode(ENTER, tree->symbol, NULL, NULL);
			} else {
				tree->code = createCode(ENTER, tree->symbol, NULL, NULL);
			}
			break;
		case PARAMETER:
			code = tree->right->code;
			
			if (code) {
				tree->code = code;
				while (code->next)
					code = code->next;
				
				code->next = createCode(PUSH_PARAM, tree->right->symbol, NULL, NULL);
				code = code->next;
			} else {
				code = createCode(PUSH_PARAM, tree->right->symbol, NULL, NULL);
				tree->code = code;
			}
			
			if (tree->left)
				code->next = tree->left->code;
			
			break;
		case DECLARATION:
			break;
		case SYMBOL:
			break;
		case FORMAL:
			break;
		case FUNCTION_ROOT:
			if (tree->left && tree->left->code) {
				tree->code = tree->left->code;
					
				code = tree->code;
					
				while (code->next)
					code = code->next;

				if (tree->right)
					code->next = tree->right->code;
			} else {
				if (tree->right)
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
	if (!code || !_generateCode)
		return;
	
	switch (code->opcode) {
		case ADD_OP:
			writeExpressionCode("add", "+", code);
			break;
		case SUB_OP:
			writeExpressionCode("sub", "-", code);
			break;
		case MULT_OP:
			writeExpressionCode("mul", "*", code);
			break;
		case DIV_OP:
			writeExpressionCode("div", "/", code);
			break;
		case NEG_OP:
			printf("\n");
		
			if (code->source1->location) {
					
				printf("\t# -%s\n", code->source1->identifier);
					
				if (code->source1->type == CHAR_TYPE) {
					printf("\tlb\t\t$t0, %s\n", code->source1->location);
				} else if (code->source1->reference) {
					printf("\tlw\t\t$t0, %s\n", code->source1->location);
				} else {
					printf("\tlw\t\t$t0, %s\n", code->source1->location);
				}
				
				if (code->source1->type == CHAR_ARRAY)
					printf("\tlb\t\t$t0, 0($t0)\n");
				if (code->source1->type == INT_ARRAY)
					printf("\tlw\t\t$t0, 0($t0)\n");
					
			} else {
					
				if (code->source1->type == CHAR_TYPE) {
					if (code->source1->value.charVal == '\n') {
						printf("\t# -'\\n'\n");
						printf("\tli\t\t$t0, 10		# 10 is ascii value for '\\n'\n");
					} else if (code->source1->value.charVal == '\0') {
						printf("\t# -'\\0'\n");
						printf("\tli\t\t$t0, 0		# 0 is ascii value for '\\0'\n");
					} else {
						printf("\t# -'%c'\n", code->source1->value.charVal);
						printf("\tli\t\t$t0, '%c'\n", code->source1->value.charVal);
					}
				} else {
					printf("\t# -%d\n", code->source1->value.intVal);
					printf("\tli\t\t$t0, %d\n", code->source1->value.intVal);
				}
				
			}
			
			printf("\tneg\t\t$t0, $t0\n");
		
			if (code->destination->type == CHAR_TYPE)
				printf("\tsb\t\t$t0, ");
			else
				printf("\tsw\t\t$t0, ");
			
			if (_offset != 0 && strncmp(code->destination->location, "_", 1) != 0)
				printf("%d + %s\n", _offset, code->destination->location);
			else
				printf("%s\n", code->destination->location);
			
			break;
		case NOT_OP:
			printf("\n");
			
			printf("\tlw\t\t$t0, %s\n", code->source1->location);
			printf("\txori\t$t0, $t0, 1\n");
			printf("\tsw\t\t$t0, %s\n", code->destination->location);

			break;
		case EQUAL_OP:
			writeExpressionCode("seq", "==", code);
			break;
		case NOT_EQUAL_OP:
			writeExpressionCode("sne", "!=", code);
			break;
		case GREATER_THAN_OP:
			writeExpressionCode("sgt", ">", code);
			break;
		case GREATER_EQUAL_OP:
			writeExpressionCode("sge", ">=", code);
			break;
		case LESS_THAN_OP:
			writeExpressionCode("slt", "<", code);
			break;
		case LESS_EQUAL_OP:
			writeExpressionCode("sle", "<=", code);
			break;
		case AND_OP:
			printf("\n");
			
			printf("\tlw\t\t$t0, %s\n", code->source1->location);
			printf("\tlw\t\t$t1, %s\n", code->source2->location);
			printf("\tand\t\t$t0, $t0, $t1\n");
			printf("\tsw\t\t$t0, %s\n", code->destination->location);
			
			break;
		case OR_OP:
			printf("\n");
			
			printf("\tlw\t\t$t0, %s\n", code->source1->location);
			printf("\tlw\t\t$t1, %s\n", code->source2->location);
			printf("\tor\t\t$t0, $t0, $t1\n");
			printf("\tsw\t\t$t0, %s\n", code->destination->location);
			
			break;
		case RETRIEVE_OP:
			printf("\n");
			
			printf("\t# retrieve return value from %s\n", code->source1->identifier);
			
			if (code->destination->type == CHAR_TYPE) {
				printf("\tsb\t\t$v0, ");
			} else {
				printf("\tsw\t\t$v0, ");
			}
			
			if (_offset != 0 && strncmp(code->destination->location, "_", 1) != 0)
				printf("%d + %s\n", _offset, code->destination->location);
			else
				printf("%s\n", code->destination->location);
			
			break;
		case BRANCH:
			printf("\n");
			printf("\tlw\t\t$t0, %s\n", code->source1->location);
			printf("\tbgtz\t$t0, _%s\n", code->destination->identifier);
			break;
		case JUMP:
			printf("\n");
			printf("\tj\t\t_%s\n", code->source1->identifier);
			break;
		case LABEL:
			printf("\n");
			printf("_%s:\n", code->source1->identifier);
			break;
		case RETURN_OP:
			printf("\n");
			if (!code->source1) {
				printf("\t# return\n");
				printf("\tj\t\t__%sReturn\n", code->destination->identifier);
			} else {
				
				if (code->source1->location) {

					printf("\t# return %s\n", code->source1->identifier);

					if (code->source1->type == CHAR_ARRAY) {
						printf("\tlw\t\t$t0, %s\n", code->source1->location);
						printf("\tlb\t\t$t0, 0($t0)\n");
					} else if (code->source1->type == INT_ARRAY) {
						printf("\tlw\t\t$t0, %s\n", code->source1->location);
						printf("\tlw\t\t$t0, 0($t0)\n");
					} else if (code->source1->type == CHAR_TYPE) {
						printf("\tlb\t\t$t0, %s\n", code->source1->location);
					} else {
						printf("\tlw\t\t$t0, %s\n", code->source1->location);
					}

				} else {

					if (code->source1->type == CHAR_TYPE) {
						if (code->source1->value.charVal == '\n') {
							printf("\t# return '\\n'\n");
							printf("\tli\t\t$t0, 10		# 10 is ascii value for '\\n'\n");
						} else if (code->source1->value.charVal == '\0') {
							printf("\t# return '\\0'\n");
							printf("\tli\t\t$t0, 0		# 0 is ascii value for '\\0'\n");
						} else {
							printf("\t# return '%c'\n", code->source1->value.charVal);
							printf("\tli\t\t$t0, '%c'\n", code->source1->value.charVal);
						}
					} else {
						printf("\t# return %d\n", code->source1->value.intVal);
						printf("\tli\t\t$t0, %d\n", code->source1->value.intVal);
					}

				}
				
				printf("\tadd\t\t$v0, $t0, $0\n");
				printf("\tj\t\t__%sReturn\n", code->destination->identifier);
			}
			break;
		case ARRAY_OP:
			printf("\n");
				
			if (code->source2->location) {
				
				printf("\t# %s[%s]\n", code->source1->identifier, code->source2->identifier);
				
				if (code->source2->type == CHAR_ARRAY) {
					printf("\tlw\t\t$t1, %s\n", code->source2->location);
					printf("\tlb\t\t$t1, 0($t1)\n");
				} else if (code->source2->type == INT_ARRAY) {
					printf("\tlw\t\t$t1, %s\n", code->source2->location);
					printf("\tlw\t\t$t1, 0($t1)\n");
				} else if (code->source2->type == CHAR_TYPE) {
					printf("\tlb\t\t$t1, %s\n", code->source2->location);
				} else {
					printf("\tlw\t\t$t1, %s\n", code->source2->location);
				}
					
			} else {
					
				if (code->source2->type == CHAR_TYPE) {
					if (code->source2->value.charVal == '\n') {
						printf("\t# %s['\\n']\n", code->source1->identifier);
						printf("\tli\t\t$t1, 10		# 10 is ascii value for '\\n'\n");
					} else if (code->source2->value.charVal == '\0') {
						printf("\t# %s[\\0']\n", code->source1->identifier);
						printf("\tli\t\t$t1, 0		# 0 is ascii value for '\\0'\n");
					} else {
						printf("\t# %s['%c']\n", code->source1->identifier, code->source2->value.charVal);
						printf("\tli\t\t$t1, '%c'\n", code->source2->value.charVal);
					}
				} else {
					printf("\t# %s[%d]\n", code->source1->identifier, code->source2->value.intVal);
					printf("\tli\t\t$t1, %d\n", code->source2->value.intVal);
				}
				
			}
			
			if (code->destination->type == INT_ARRAY)
				printf("\tsll\t\t$t1, $t1, 2\t\t# index * 4 (size of int)\n");
			
			if (code->source1->reference) {
				printf("\tlw\t\t$t0, %s\n", code->source1->location);
				code->destination->reference = TRUE;
			} else {
				printf("\tla\t\t$t0, %s\n", code->source1->location);
			}
				
			printf("\tadd\t\t$t0, $t0, $t1\n");
			printf("\tsw\t\t$t0, ");
			
			if (_offset != 0 && strncmp(code->destination->location, "_", 1) != 0)
				printf("%d + %s\n", _offset, code->destination->location);
			else
				printf("%s\n", code->destination->location);
			
			break;
		case ASSIGNMENT_OP:
			printf("\n");
			
			if (code->source1->location) {
				
				printf("\t# %s = %s\n", code->destination->identifier, code->source1->identifier);

				if (code->source1->type == CHAR_ARRAY) {
					printf("\tlw\t\t$t0, %s\n", code->source1->location);
					printf("\tlb\t\t$t0, 0($t0)\n");
				} else if (code->source1->type == INT_ARRAY) {
					printf("\tlw\t\t$t0, %s\n", code->source1->location);
					printf("\tlw\t\t$t0, 0($t0)\n");
				} else if (code->source1->type == CHAR_TYPE) {
					printf("\tlb\t\t$t0, %s\n", code->source1->location);
				} else {
					printf("\tlw\t\t$t0, %s\n", code->source1->location);
				}
					
			} else {
				
				if (code->source1->type == CHAR_TYPE) {
					if (code->source1->value.charVal == '\n') {
						printf("\t# %s = '\\n'\n", code->destination->identifier);
						printf("\tli\t\t$t0, 10		# 10 is ascii value for '\\n'\n");
					} else if (code->source1->value.charVal == '\0') {
						printf("\t# %s = '\\0'\n", code->destination->identifier);
						printf("\tli\t\t$t0, 0		# 0 is ascii value for '\\0'\n");
					} else {
						printf("\t# %s = '%c'\n", code->destination->identifier, code->source1->value.charVal);
						printf("\tli\t\t$t0, '%c'\n", code->source1->value.charVal);
					}
				} else {
					printf("\t# %s = %d\n", code->destination->identifier, code->source1->value.intVal);
					printf("\tli\t\t$t0, %d\n", code->source1->value.intVal);
				}
				
			}
			
			if (code->destination->type == CHAR_ARRAY)
				printf("\tlw\t\t$t1, ");
			else if (code->destination->type == INT_ARRAY)
				printf("\tlw\t\t$t1, ");
			else if (code->destination->type == CHAR_TYPE)
				printf("\tsb\t\t$t0, ");
			else
				printf("\tsw\t\t$t0, ");
			
			if (_offset != 0 && strncmp(code->destination->location, "_", 1) != 0)
				printf("%d + %s\n", _offset, code->destination->location);
			else
				printf("%s\n", code->destination->location);
				
			if (code->destination->type == CHAR_ARRAY)
				printf("\tsb\t\t$t0, 0($t1)\n");	
				
			if (code->destination->type == INT_ARRAY)
				printf("\tsw\t\t$t0, 0($t1)\n");
				
			break;
		case ENTER:
			printf("\n");
			printf("\t# calling %s\n", code->source1->identifier);
			
			if (strcmp(code->source1->identifier, "main") == 0)
				printf("\tjal\t\tmain\n", code->source1->identifier);
			else
				printf("\tjal\t\t_%s\n", code->source1->identifier);
			
			Parameter *currParam = code->source1->parameterListHead;
			int bytesToPop = 0;

			if (currParam && currParam->type != VOID_TYPE) {
				printf("\n\t# popping pushed parameters\n");
				
				while (currParam) {
					bytesToPop += 4;
					currParam = currParam->next;
				}
				
				printf("\taddu\t$sp, $sp, %d\n", bytesToPop);
				_offset -= bytesToPop;
			}
			break;
		case LEAVE:
			break;
		case PUSH_PARAM:
			printf("\n");
			
			if (code->source1->location) {
				
				printf("\t# pushing parameter %s\n", code->source1->identifier);
				if (code->source1->type == CHAR_ARRAY) {
					if (code->source1->reference) {
						if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
							printf("\tlw\t\t$t0, %d + %s\n", _offset, code->source1->location);
						else
							printf("\tlw\t\t$t0, %s\n", code->source1->location);
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tsw\t\t$t0, 0($sp)\n");
					} else if (strncmp(code->source1->identifier, "_temp", 5) == 0
							&& !code->source1->value.strVal) {
						// char array being indexed
						if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
							printf("\tlw\t\t$t0, %d + %s\n", _offset, code->source1->location);
						else
							printf("\tlw\t\t$t0, %s\n", code->source1->location);
						printf("\tlb\t\t$t0, 0($t0)\n");
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tsw\t\t$t0, 0($sp)\n");
					} else {
						// char array being passed whole
						if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
							printf("\tla\t\t$t0, %d + %s\n", _offset, code->source1->location);
						else
							printf("\tla\t\t$t0, %s\n", code->source1->location);
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tsw\t\t$t0, 0($sp)\n");
					}
				} else if (code->source1->type == INT_ARRAY) {
					if (code->source1->reference) {
						if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
							printf("\tlw\t\t$t0, %d + %s\n", _offset, code->source1->location);
						else
							printf("\tlw\t\t$t0, %s\n", code->source1->location);
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tsw\t\t$t0, 0($sp)\n");
					} else if (strncmp(code->source1->identifier, "_temp", 5) == 0) {
						// int array being indexed
						if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
							printf("\tlw\t\t$t0, %d + %s\n", _offset, code->source1->location);
						else
							printf("\tlw\t\t$t0, %s\n", code->source1->location);
						printf("\tlw\t\t$t0, 0($t0)\n");
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tsw\t\t$t0, 0($sp)\n");
					} else {
						// int array being passed whole
						if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
							printf("\tla\t\t$t0, %d + %s\n", _offset, code->source1->location);
						else
							printf("\tla\t\t$t0, %s\n", code->source1->location);
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tsw\t\t$t0, 0($sp)\n");
					}
				} else if (code->source1->type == CHAR_TYPE) {
					if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
						printf("\tlb\t\t$t0, %d + %s\n", _offset, code->source1->location);
					else
						printf("\tlb\t\t$t0, %s\n", code->source1->location);
					printf("\tsubu\t$sp, $sp, 4\n");
					printf("\tsw\t\t$t0, 0($sp)\n");
				} else if (code->source1->type == INT_TYPE) {
					if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
						printf("\tlw\t\t$t0, %d + %s\n", _offset, code->source1->location);
					else
						printf("\tlw\t\t$t0, %s\n", code->source1->location);
					printf("\tsubu\t$sp, $sp, 4\n");
					printf("\tsw\t\t$t0, 0($sp)\n");
				} else {
					if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
						printf("\tla\t\t$t0, %d + %s\n", _offset, code->source1->location);
					else
						printf("\tla\t\t$t0, %s\n", code->source1->location);
					printf("\tsubu\t$sp, $sp, 4\n");
					printf("\tsw\t\t$t0, 0($sp)\n");
				}
				
			} else {
				
				if (code->source1->type == CHAR_TYPE) {
					if (code->source1->value.charVal == '\n') {
						printf("\t# pushing parameter '\\n'\n", code->source1->value.charVal);
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tli\t\t$t0, 10\n", code->source1->value.charVal);
						printf("\tsw\t\t$t0, 0($sp)\n");
					} else if (code->source1->value.charVal == '\0') {
						printf("\t# pushing parameter '\\0'\n", code->source1->value.charVal);
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tli\t\t$t0, 0\n", code->source1->value.charVal);
						printf("\tsw\t\t$t0, 0($sp)\n");
					} else {
						printf("\t# pushing parameter '%c'\n", code->source1->value.charVal);
						printf("\tsubu\t$sp, $sp, 4\n");
						printf("\tli\t\t$t0, '%c'\n", code->source1->value.charVal);
						printf("\tsw\t\t$t0, 0($sp)\n");
					}
					
				} else {
					printf("\t# pushing parameter %d\n", code->source1->value.intVal);
					printf("\tsubu\t$sp, $sp, 4\n");
					printf("\tli\t\t$t0, %d\n", code->source1->value.intVal);
					printf("\tsw\t\t$t0, 0($sp)\n");
				}
				
			}
			
			_offset += 4;
			break;
		case DECLARATION_OP:
			break;
		default:
			break;
	}
	
	writeCode(code->next);
}

void writeExpressionCode(char *mnemonic, char *operator, Code *code) {
	printf("\n");
	
	if (code->source1->location) {

		if (code->source2->location) {
			
			printf("\t# %s %s %s\n", code->source2->identifier, operator, code->source1->identifier);
			
			if (code->source2->type == CHAR_TYPE) {
				printf("\tlb\t\t$t1, ");
			} else if (code->source2->reference) {
				printf("\tlw\t\t$t1, ");
			} else {
				printf("\tlw\t\t$t1, ");
			}
			
			if (_offset != 0 && strncmp(code->source2->location, "_", 1) != 0)
				printf("%d + %s\n", _offset, code->source2->location);
			else
				printf("%s\n", code->source2->location);
			
			if (code->source2->type == CHAR_ARRAY)
				printf("\tlb\t\t$t1, 0($t1)\n");
			if (code->source2->type == INT_ARRAY)
				printf("\tlw\t\t$t1, 0($t1)\n");
				
		} else {
			
			if (code->source2->type == CHAR_TYPE) {
				if (code->source2->value.charVal == '\n') {
					printf("\t# '\\n' %s %s\n", operator, code->source1->identifier);
					printf("\tli\t\t$t1, 10		# 10 is ascii value for '\\n'\n");
				} else if (code->source2->value.charVal == '\0') {
					printf("\t# '\\0' %s %s\n", operator, code->source1->identifier);
					printf("\tli\t\t$t1, 0		# 0 is ascii value for '\\0'\n");
				} else {
					printf("\t# '%c' %s %s\n", code->source2->value.charVal, operator, code->source1->identifier);
					printf("\tli\t\t$t1, '%c'\n", code->source2->value.charVal);
				}
			} else {
				printf("\t# %d %s %s\n", code->source2->value.intVal, operator, code->source1->identifier);
				printf("\tli\t\t$t1, %d\n", code->source2->value.intVal);
			}
				
		}
		
		if (code->source1->type == CHAR_TYPE) {
			printf("\tlb\t\t$t0, ");
		} else if (code->source1->reference) {
			printf("\tlw\t\t$t0, ");
		} else {
			printf("\tlw\t\t$t0, ");
		}
		
		if (_offset != 0 && strncmp(code->source1->location, "_", 1) != 0)
			printf("%d + %s\n", _offset, code->source1->location);
		else
			printf("%s\n", code->source1->location);
		
		if (code->source1->type == CHAR_ARRAY)
			printf("\tlb\t\t$t0, 0($t0)\n");
		if (code->source1->type == INT_ARRAY)
			printf("\tlw\t\t$t0, 0($t0)\n");
		
	} else {
		
		if (code->source2->location) {
			
			if (code->source1->type == CHAR_TYPE) {
				if (code->source1->value.charVal == '\n') {
					printf("\t# %s %s '\\n'\n", code->source2->identifier, operator);
					printf("\tli\t\t$t0, 10		# 10 is ascii value for '\\n'\n");
				} else if (code->source1->value.charVal == '\0') {
					printf("\t# %s %s '\\0'\n", code->source2->identifier, operator);
					printf("\tli\t\t$t0, 0		# 0 is ascii value for '\\0'\n");
				} else {
					printf("\t# %s %s '%c'\n", code->source2->identifier, operator, code->source1->value.charVal);
					printf("\tli\t\t$t0, '%c'\n", code->source1->value.charVal);
				}
			} else {
				printf("\t# %s %s %d\n", code->source2->identifier, operator, code->source1->value.intVal);
				printf("\tli\t\t$t0, %d\n", code->source1->value.intVal);
			}
			
			if (code->source2->type == CHAR_TYPE) {
				printf("\tlb\t\t$t1, ");
			} else if (code->source2->reference) {
				printf("\tlw\t\t$t1, ");
			} else {
				printf("\tlw\t\t$t1, ");				
			}
			
			if (_offset != 0 && strncmp(code->source2->location, "_", 1) != 0)
				printf("%d + %s\n", _offset, code->source2->location);
			else
				printf("%s\n", code->source2->location);
			
			if (code->source2->type == CHAR_ARRAY)
				printf("\tlb\t\t$t1, 0($t1)\n");
			if (code->source2->type == INT_ARRAY)
				printf("\tlw\t\t$t1, 0($t1)\n");
		
		} else {
			
			printf("\t# %s %s %s\n", code->source2->identifier, operator, code->source1->identifier);
		
			if (code->source1->type == CHAR_TYPE) {
				if (code->source1->value.charVal == '\n') {
					printf("\tli\t\t$t0, 10		# 10 is ascii value for '\\n'\n");
				} else if (code->source1->value.charVal == '\0') {
					printf("\tli\t\t$t0, 0		# 0 is ascii value for '\\0'\n");
				} else {
					printf("\tli\t\t$t0, '%c'\n", code->source1->value.charVal);
				}
			} else {
				printf("\tli\t\t$t0, %d\n", code->source1->value.intVal);
			}
			
			if (code->source2->type == CHAR_TYPE) {
				if (code->source2->value.charVal == '\n') {
					printf("\tli\t\t$t1, 10		# 10 is ascii value for '\\n'\n");
				} else if (code->source2->value.charVal == '\0') {
					printf("\tli\t\t$t1, 0		# 0 is ascii value for '\\0'\n");
				} else {
					printf("\tli\t\t$t1, '%c'\n", code->source2->value.charVal);
				}
			} else {
				printf("\tli\t\t$t1, %d\n", code->source2->value.intVal);
			}

		}
	}
	
	printf("\t%s\t\t$t0, $t1, $t0\n", mnemonic);

	if (code->destination->type == CHAR_TYPE)
		printf("\tsb\t\t$t0, ");
	else
		printf("\tsw\t\t$t0, ");
		
	if (_offset != 0 && strncmp(code->destination->location, "_", 1) != 0)
		printf("%d + %s\n", _offset, code->destination->location);
	else
		printf("%s\n", code->destination->location);
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