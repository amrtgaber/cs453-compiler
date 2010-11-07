/* File: syntaxTree.h 
 * Author: Amr Gaber
 * Created: 3/11/2010
 * Last Modified: 6/11/2010
 * Purpose: Header file for syntaxTree.c.
 */

#ifndef __SYNTAXTREE_H__
#define __SYNTAXTREE_H__

#include "symbolTable.h"
#include "code.h"

/************************
 *						*
 * 	type definitions	* 
 *						*
 ************************/

/* Enum: Operator
 * Description: Enumerates the different syntax node types.
 */
typedef enum Operator {
	ADD = 0xCAFEBABE,
	SUB,
	MULT,
	DIV,
	NEG,
	EQUAL,
	NOT_EQUAL,
	GREATER_THAN,
	GREATER_EQUAL,
	LESS_THAN,
	LESS_EQUAL,
	AND,
	OR,
	ASSIGNMENT,
	IF_TREE,
	WHILE_TREE,
	RETURN_TREE,
	SYMBOL,
	DECLARATION,
	PARAMETER_TREE,
	STATEMENT,
	FUNCTION_ROOT,
	FUNCTION_CALL
} Operator;

/* Struct: SyntaxTree
 * Description: Represents a syntax tree node.
 */
typedef struct SyntaxTree {
	Operator 	operation;
	Symbol		*symbol;
	Code 		*code;
	struct SyntaxTree *left, *right, *elseOpt;
} SyntaxTree;

/************************
 *						*
 * 	exported functions	*
 *						*
 ************************/

/* Function: createTree
 * Parameters: Operator operation, Symbol *symbol, SyntaxTree *left,
 *				SyntaxTree *right
 * Description: Creates a new syntax tree node.
 * Returns: A pointer to the created syntax tree.
 * Preconditions: none
 */
SyntaxTree *createTree(Operator operation, Symbol *symbol, SyntaxTree *left,
						SyntaxTree *right);

/* Function: destroyTree
 * Parameters: SyntaxTree *tree
 * Description: Deallocates the given tree and all children.
 * Returns: none
 * Preconditions: none
 */
void destroyTree(SyntaxTree *tree);

/* Function: printSyntaxTree
 * Parameters: SyntaxTree *tree, int tabs
 * Description: Prints the given syntax tree to the screen.
 * Returns: none
 * Preconditions: none
 */
void printSyntaxTree(SyntaxTree *tree, int tabs);

/* Function: operatorAsString
 * Parameters: Operator operation
 * Description: Converts the enum Operator to a string.
 * Returns: Returns the given operation as a string.
 * Preconditions: none
 */
char *operatorAsString(Operator operation);

#endif