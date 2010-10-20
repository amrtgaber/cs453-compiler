/* File: symbalTable.h 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Purpose: Header file for symbolTable.c.
 */

#ifndef __SYMBOLTABLE_H__
#define __SYMBOLTABLE_H__

typedef enum Type {
	INT = 0xDEADBEEF,
	CHAR,
	INTARRAY,
	CHARARRAY
} Type;

typedef union Value {
	int		intVal;
	char 	charVal;
	int 	*intArray;
	char 	*string;
} Value;

typedef struct Symbol {
	char	*identifier;
	Type 	type;
	Symbol 	*next;
	Value 	value;
} Symbol;

typedef struct SymbolTable {
	Symbol			*head;
	SymbolTable	 	*next;
} SymbolTable;

typedef struct StackTop {
	SymbolTable		*top;
} StackTop;

#define FALSE	0
#define TRUE	1

Symbol *recall(char *identifier);
Symbol *insert(char *identifier, Type type, Value value);

SymbolTable *pushSymbolTable();
void *popSymbolTable();

#endif