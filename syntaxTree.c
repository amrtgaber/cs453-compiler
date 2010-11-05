/* File: syntaxTree.c
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 4/11/2010
 * Purpose: Contains the syntax tree functions.
 */

#include "utilities.h"
#include "syntaxTree.h"

SyntaxTree *createTree(Operator operation, Symbol *symbol, Code *code,
						SyntaxNode *left, SyntaxNode *right) {
	
	SyntaxTree *newTree = NULL;
	
	if (!(newTree = malloc(sizeof(SyntaxTree))))
		ERROR("", __LINE__, TRUE);					// out of memory
	
	newTree->operation = operation;
	newTree->symbol = symbol;
	newTree->code = code;
	newTree->left = left;
	newTree->right = right;
	newTree->elseOpt = NULL;
	
	return newTree;
}

void destroyTree(SyntaxNode *tree) {
	if (!tree)
		return;
	
	destroyTree(tree->left);
	destroyTree(tree->right);
	destroyTree(tree->elseOpt);
	
	free(tree);
}