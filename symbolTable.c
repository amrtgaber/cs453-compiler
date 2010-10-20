/* File: symbalTable.c 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Purpose: Symbol table for use with the C-- compiler.
 */

#include "symbolTable.h"

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
	
	// Remember to check for out of memory error
	toInsert = malloc(sizeof(Symbol));
	
	toInsert->identifier = strdup(identifier);
	toInsert->type = type;
	toInsert->value = value;
	
	toInsert->next = currTable->next;
	currTable = toInsert;
	
	return toInsert;
}