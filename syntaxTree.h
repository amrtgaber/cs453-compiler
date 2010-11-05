/* File: syntaxTree.h 
 * Author: Amr Gaber
 * Created: 3/11/2010
 * Last Modified: 4/11/2010
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
	STATEMENT
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
 * Parameters: Operator operation, Symbol *symbol, SyntaxNode *left,
 *				SyntaxNode *right
 * Description: Creates a new syntax tree node.
 * Returns: A pointer to the created syntax tree.
 * Preconditions: none
 */
SyntaxTree *createTree(Operator operation, Symbol *symbol, SyntaxTree *left,
						SyntaxTree *right);

/* Function: destroyTree
 * Parameters: SyntaxNode *tree
 * Description: Deallocates the given tree and all children.
 * Returns: none
 * Preconditions: none
 */
void destroyTree(SyntaxTree *tree);

#endif