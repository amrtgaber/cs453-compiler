/* File: symbalTable.h 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Last Modified: 20/10/2010
 * Purpose: Header file for symbolTable.c.
 */

#ifndef __SYMBOLTABLE_H__
#define __SYMBOLTABLE_H__

/************************
 *						*
 * 	type definitions	* 
 *						*
 ************************/

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
	SymbolTable	 	*below;
} SymbolTable;

/************************
 *						*
 * 	exported functions	* 
 *						*
 ************************/

Symbol *recall(char *identifier);
Symbol *insert(char *identifier, Type type, Value value);

void pushSymbolTable();
void popSymbolTable();

#endif