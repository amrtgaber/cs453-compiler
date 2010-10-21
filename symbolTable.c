/* File: symbalTable.c 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Last Modified: 20/10/2010
 * Purpose: Symbol table for use with the C-- compiler.
 */

#include "symbolTable.h"
#include "utilities.h"

extern _errorMessage[ERROR_MSG_SIZE];
SymbolTable *_stack = NULL;

/* Function: recall
 * Parameters: char *identifier
 * Description: Recalls a symbol from the symbol table.
 * Returns: A pointer to the symbol if found, NULL otherwise.
 * Preconditions: The stack must not be empty.
 */
Symbol *recall(char *identifier) {
	if (!_stack)
		ERROR("Recall called on empty stack.", __LINE__, FALSE);

	Symbol *symbol = NULL, *currSymbol = NULL;
	SymbolTable currTable = NULL;
	
	for(currTable = _stack; currTable; currTable = currTable->below)
		for (currSymbol = currTable->head; currSymbol; currSymbol = currSymbol->next)
			if (strcmp(currSymbol->identifier, identifier) == 0)
				return currSymbol;
	
	return NULL;
}

/* Function: insert
 * Parameters: char *identifier, Type type, Value value
 * Description: Inserts a symbol into the symbol table.
 * Returns: A pointer to the inserted symbol.
 * Preconditions: The stack must not be empty.
 */
Symbol *insert(char *identifier, Type type, Value value) {
	if (!_stack)
		ERROR("Insert called on emtpy stack.", __LINE__, FALSE);

	Symbol *toInsert = null;
	SymbolTable currTable = _stack;
	
	if (!(toInsert = malloc(sizeof(Symbol))))
		ERROR(NULL, __LINE__, TRUE); 				// out of memory
	
	toInsert->identifier = strdup(identifier);
	toInsert->type = type;
	toInsert->value = value;
	
	toInsert->next = currTable->head;
	currTable->head = toInsert;
	
	return toInsert;
}

/* Function: pushSymbolTable
 * Parameters: void
 * Description: Pushes a new symbol table onto the stack.
 * Returns: void
 * Preconditions: none
 */
void pushSymbolTable() {
	SymbolTable *newTable = NULL;
	
	if (!(newTable = malloc(sizeof(SymbolTable))))
		ERROR(NULL, __LINE__, TRUE);				// out of memory
	
	newTable->head = NULL;
	newTable->below = _stack;
	_stack = newTable;
}

/* Function: popSymbolTable
 * Parameters: void
 * Description: Pops the symbol table on the top of the stack.
 * Returns: void
 * Preconditions: The stack must not be empty.
 */
void popSymbolTable() {
	if (!_stack)
		ERROR("Pop called on empty stack.", __LINE__, FALSE);
	
	Symbol *rear = NULL, *front = NULL;
	SymbolTable *newStackTop = _stack->below;
	
	// if the symbol table at the top has symbols, free them first
	if (_stack->head) {
		for(rear = _stack->head, front = rear->next; front; front = front->next) {
			free(rear->identifier);
			free(rear);
			rear = front;
		}
		free(rear->identifier);
		free(rear);
	}
	
	free(_stack);
	_stack = newStackTop;
}
