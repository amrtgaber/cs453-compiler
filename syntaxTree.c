/* File: syntaxTree.c
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 4/11/2010
 * Purpose: Contains the syntax tree functions.
 */

#include "utilities.h"
#include "syntaxTree.h"

/* Function: createTree
 * Parameters: Operator operation, Symbol *symbol, SyntaxNode *left,
 *				SyntaxNode *right
 * Description: Creates a new syntax tree node.
 * Returns: A pointer to the created syntax tree.
 * Preconditions: none
 */
SyntaxTree *createTree(Operator operation, Symbol *symbol, SyntaxTree *left,
						SyntaxTree *right) {
	
	SyntaxTree *newTree = NULL;
	
	if (!(newTree = malloc(sizeof(SyntaxTree))))
		ERROR("", __LINE__, TRUE);					// out of memory
	
	newTree->operation = operation;
	newTree->symbol = symbol;
	newTree->code = NULL;
	newTree->left = left;
	newTree->right = right;
	newTree->elseOpt = NULL;
	
	return newTree;
}

/* Function: destroyTree
 * Parameters: SyntaxNode *tree
 * Description: Deallocates the given tree and all children.
 * Returns: none
 * Preconditions: none
 */
void destroyTree(SyntaxTree *tree) {
	if (!tree)
		return;
	
	destroyTree(tree->left);
	destroyTree(tree->right);
	destroyTree(tree->elseOpt);
	
	free(tree);
}