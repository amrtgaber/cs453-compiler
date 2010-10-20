/* File: symbalTable.c 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Last Modified: 20/10/2010
 * Purpose: Symbol table for use with the C-- compiler.
 */

#include "symbolTable.h"
#include "utilities.h"

extern _errorMessage[ERROR_MSG_SIZE];
StackTop _stackTop = NULL;

Symbol *recall(char *identifier) {
	Symbol *symbol = NULL, *currSymbol = NULL;
	SymbolTable currTable = _stackTop->top;
	
	for (currSymbol = currTable->head; currSymbol; currSymbol = currSymbol->next)
		if (strcmp(currSymbol->identifier, identifier) == 0)
			return currSymbol;
	
	return NULL;
}

Symbol *insert(char *identifier, Type type, Value value) {
	Symbol *toInsert = null;
	SymbolTable currTable = _stackTop->top;
	
	if (!(toInsert = malloc(sizeof(Symbol))))
		ERROR(NULL, __LINE__, TRUE); 				// out of memory
	
	toInsert->identifier = strdup(identifier);
	toInsert->type = type;
	toInsert->value = value;
	
	toInsert->next = currTable->next;
	currTable = toInsert;
	
	return toInsert;
}

SymbolTable *pushSymbolTable() {
	if (!_stackTop) {
		if (!(_stackTop = malloc(sizeof(StackTop))))
			ERROR(NULL, __LINE__, TRUE);
		
		_stackTop->top = NULL;
	}
	
	SymbolTable *newTable = NULL;
	
	if (!(newTable = malloc(sizeof(SymbolTable))))
		ERROR(NULL, __LINE__, TRUE);				// out of memory
		
	newTable->next = _stackTop->top;
	_stackTop->top = newTable;
	
}





