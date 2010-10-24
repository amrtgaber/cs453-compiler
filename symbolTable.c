/* File: symbalTable.c 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Last Modified: 22/10/2010
 * Purpose: Symbol table for use with the C-- compiler.
 */

#include "symbolTable.h"
#include "utilities.h"

SymbolTable *_stack = NULL;
Symbol *_currentSymbol = NULL;

/* Function: recall
 * Parameters: char *identifier
 * Description: Recalls a symbol from the symbol table.
 * Returns: A pointer to the symbol if found, NULL otherwise.
 * Preconditions: The stack must not be empty.
 */
Symbol *recall(char *identifier) {
	if (!_stack)
		ERROR("Recall called on empty stack.", __LINE__, FALSE);

	Symbol *currSymbol = NULL;
	SymbolTable *currTable = NULL;
	
	for(currTable = _stack; currTable; currTable = currTable->below)
		for(currSymbol = currTable->listHead; currSymbol; 
				currSymbol = currSymbol->next)
			if (strcmp(currSymbol->identifier, identifier) == 0)
				return currSymbol;
	
	return NULL;
}

/* Function: recallLocal
 * Parameters: char *identifier
 * Description: Recalls a symbol from the symbol table on top of the stack.
 * Returns: A pointer to the symbol if found, NULL otherwise.
 * Preconditions: The stack must not be empty.
 */
Symbol *recallLocal(char *identifier) {
	if (!_stack)
		ERROR("RecallLocal called on empty stack.", __LINE__, FALSE);

	Symbol *currSymbol = NULL;
	
	for(currSymbol = _stack->listHead; currSymbol; currSymbol = currSymbol->next)
		if (strcmp(currSymbol->identifier, identifier) == 0)
			return currSymbol;

	return NULL;
}

/* Function: insert
 * Parameters: char *identifier, Type type 
 * Description: Inserts a symbol into the symbol table.
 * Returns: A pointer to the inserted symbol.
 * Preconditions: The stack must not be empty.
 */
Symbol *insert(char *identifier, Type type) {
	if (!_stack)
		ERROR("Insert called on emtpy stack.", __LINE__, FALSE);

	Symbol *toInsert = NULL;
	
	if (!(toInsert = malloc(sizeof(Symbol))))
		ERROR("", __LINE__, TRUE); 				// out of memory
	
	toInsert->identifier = strdup(identifier); //TODO: memory check
	toInsert->type = type;
	toInsert->functionType = -1;
	toInsert->parameterListHead = NULL;
	
	toInsert->next = _stack->listHead;
	_stack->listHead = toInsert;
	
	_currentSymbol = toInsert;
	
	return toInsert;
}

/* Function: addParameter
 * Parameters: char *identifier, Type type
 * Description: Adds a parameter to the most recently inserted function then 
 *					declares it as a local variable on the local stack.
 * Returns: void
 * Preconditions: The most recently inserted symbol must have been a function.
 */
void addParameter(char *identifier, Type type) {
	Parameter *newParameter = NULL, *currParameter = NULL;
	
	if (!(newParameter = malloc(sizeof(Parameter))))
		ERROR("", __LINE__, TRUE);				// out of memory
	
	newParameter->type = type;
	newParameter->next = NULL;
	
	// if the parameter list is null add at head, if not add at end
	if (!(_currentSymbol->parameterListHead)) {
		_currentSymbol->parameterListHead = newParameter;
	} else {
		currParameter = _currentSymbol->parameterListHead;
		
		while(currParameter->next)
			currParameter = currParameter->next;
			
		currParameter->next = newParameter;
	}
	
	insert(identifier, type);
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
		ERROR("", __LINE__, TRUE);				// out of memory
	
	newTable->listHead = NULL;
	newTable->below = _stack;
	_stack = newTable;
}

/* Function: freeParameterList
 * Parameters: Parameter *parameterListHead
 * Description: Destroys the parameter list.
 * Returns: void
 * Preconditions: none
 */
void freeParameterList(Parameter *parameterListHead) {
	if (!parameterListHead)
		return;
	
	Parameter *rear = NULL, *front = NULL;
	
	for(rear = parameterListHead, front = rear->next;
			front; front = front->next) {
		free(rear);
		rear = front;
	}
	free(rear);
	
	parameterListHead = NULL;
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
	Parameter *rearp = NULL, *frontp = NULL;
	SymbolTable *newStackTop = _stack->below;
	
	// if the symbol table at the top has symbols, free them first
	if (_stack->listHead) {
		for(rear = _stack->listHead, front = rear->next; front; front = front->next) {
			free(rear->identifier);
			freeParameterList(rear->parameterListHead);
			free(rear);
			rear = front;
		}
		free(rear->identifier);
		freeParameterList(rear->parameterListHead);
		free(rear);
	}
	
	free(_stack);
	_stack = newStackTop;
}