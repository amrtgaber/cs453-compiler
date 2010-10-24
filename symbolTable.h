/* File: symbalTable.h 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Last Modified: 22/10/2010
 * Purpose: Header file for symbolTable.c.
 */

#ifndef __SYMBOLTABLE_H__
#define __SYMBOLTABLE_H__

/************************
 *						*
 * 	type definitions	* 
 *						*
 ************************/

/* Enum: Type
 * Description: Enumerates the different acceptable types in C--.
 */
typedef enum Type {
	CHAR = 0xDEADBEEF,
	INT,
	CHAR_ARRAY,
	INT_ARRAY,
	VOID
	BOOLEAN
} Type;

/* Enum: FunctionType
 * Description: Enumerates the different types of functions.
 */
typedef enum FunctionType {
	EXTERN = 0xEA7FECE5,
	PROTOTYPE,
	DEFINITION,
	NON_FUNCTION
} FunctionType;

/* Union: Value
 * Description: Each symbol must have exactly one of these values.
 */
typedef union Value {
	int		intVal;
	char 	charVal;
	int 	*intArray;
	char 	*string;
} Value;

/* Struct: Parameter
 * Description: Node for parameter list
 */
typedef struct Parameter {
	Type 				type;
	struct Parameter 	*next;
} Parameter;

/* Struct: Symbol
 * Description: Represents a symbol in the symbol table.
 */
typedef struct Symbol {
	char			*identifier;
	Type 			type;		// also stands as the return type for functions
	Value 			value;
	FunctionType 	functionType;
	Parameter 		*parameterListHead;
	struct Symbol 	*next;
} Symbol;

/* Struct: SymbolTable
 * Description: The head node of the symbol table.
 */
typedef struct SymbolTable {
	Symbol					*listHead;
	struct SymbolTable	 	*below;
} SymbolTable;

/************************
 *						*
 * 	exported functions	* 
 *						*
 ************************/

/* Function: recall
 * Parameters: char *identifier
 * Description: Recalls a symbol from the symbol table.
 * Returns: A pointer to the symbol if found, NULL otherwise.
 * Preconditions: The stack must not be empty.
 */
Symbol *recall(char *identifier);

/* Function: recallLocal
 * Parameters: char *identifier
 * Description: Recalls a symbol from the symbol table on top of the stack.
 * Returns: A pointer to the symbol if found, NULL otherwise.
 * Preconditions: The stack must not be empty.
 */
Symbol *recallLocal(char *identifier);

/* Function: recallGlobal
 * Parameters: char *identifier
 * Description: Recalls a symbol from the global symbol table.
 * Returns: A pointer to the symbol if found, NULL otherwise.
 * Preconditions: The stack must not be empty.
 */
Symbol *recallGlobal(char *identifier);

/* Function: insert
 * Parameters: char *identifier, Type type
 * Description: Inserts a symbol into the symbol table.
 * Returns: A pointer to the inserted symbol.
 * Preconditions: The stack must not be empty.
 */
Symbol *insert(char *identifier, Type type);

/* Function: addParameter
 * Parameters: char *identifier, Type type
 * Description: Adds a parameter to the most recently inserted function then 
 *					declares it as a local variable on the local stack.
 * Returns: void
 * Preconditions: The most recently inserted symbol must have been a function.
 */
void addParameter(char *identifier, Type type);

/* Function: pushSymbolTable
 * Parameters: void
 * Description: Pushes a new symbol table onto the stack.
 * Returns: void
 * Preconditions: none
 */
void pushSymbolTable();

/* Function: popSymbolTable
 * Parameters: void
 * Description: Pops the symbol table on the top of the stack.
 * Returns: void
 * Preconditions: The stack must not be empty.
 */
void popSymbolTable();

#endif