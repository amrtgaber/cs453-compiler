/* File: symbalTable.h 
 * Author: Amr Gaber
 * Created: 19/10/2010
 * Last Modified: 24/10/2010
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
	CHAR_TYPE = 0xDEADBEEF,
	INT_TYPE,
	CHAR_ARRAY,
	INT_ARRAY,
	VOID_TYPE,
	BOOLEAN,
	UNKNOWN
} Type;

/* Enum: FunctionType
 * Description: Enumerates the different types of functions.
 */
typedef enum FunctionType {
	EXTERN_TYPE = 0xEA7FECE5,
	PROTOTYPE,
	DEFINITION,
	NON_FUNCTION,
	F_UNKNOWN
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
 * Parameters: char *identifier, Type type, Symbol *currentFunction
 * Description: Adds a parameter to the given function then inserts it into the
 *					 local symbol table.
 * Returns: The parameter that was inserted if not void. If void returns NULL.
 * Preconditions: none
 */
Symbol *addParameter(char *identifier, Type type, Symbol *currentFunction);

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

/* Function: printSymbolTable
 * Parameters: none
 * Description: Prints the symbol table to the screen.
 * Returns: none
 * Preconditions: The stack must not be empty.
 */
void printSymbolTable();

/* Function: typeAsString
 * Parameters: Type type
 * Description: Converts the enum Type to a string.
 * Returns: Returns the given type as a string.
 * Preconditions: none
 */
char *typeAsString(Type type);

/* Function: functionTypeAsString
 * Parameters: FunctionType functionType
 * Description: Converts the enum FunctionType to a string.
 * Returns: Returns the given functionType as a string.
 * Preconditions: none
 */
char *functionTypeAsString(FunctionType functionType);

/* Function: printParamList
 * Parameters: Parameter *parameterListHead
 * Description: Prints the given parameter list to the screen.
 * Returns: none
 * Preconditions: none
 */
void printParamList(Parameter *parameterListHead);

#endif