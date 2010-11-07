/* File: syntaxTree.c
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 6/11/2010
 * Purpose: Contains the syntax tree functions.
 */

#include "utilities.h"
#include "syntaxTree.h"

/* Function: createTree
 * Parameters: Operator operation, Symbol *symbol, SyntaxTree *left,
 *				SyntaxTree *right
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
 * Parameters: SyntaxTree *tree
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

/* Function: printTabs
 * Parameters: int tabs
 * Description: Prints the given number of tabs.
 * Returns: none
 * Preconditions: none
 */
void printTabs(int tabs) {
	int i;
	for(i = 0; i < tabs; i++)
		printf("\t");
}

/* Function: printSyntaxTree
 * Parameters: SyntaxTree *tree
 * Description: Prints the given syntax tree to the screen.
 * Returns: none
 * Preconditions: none
 */
void printSyntaxTree(SyntaxTree *tree, int tabs) {
	if (!tree)
		return;
	
	// print operation
	printTabs(tabs);
	printf("Operation: %s\n", operatorAsString(tree->operation));
	printTabs(tabs);
	printf("--------------------------\n");
	
	// print symbol
	if (tree->symbol) {
		printTabs(tabs);
		printf("Symbol: %s\n", tree->symbol->identifier);
		printTabs(tabs);
		printf("Type: %s\n", typeAsString(tree->symbol->type));
		
		switch (tree->symbol->type) {
			case CHAR_TYPE:
				printTabs(tabs);
				printf("Value: %c\n", tree->symbol->value.charVal);
				break;
			case INT_TYPE:
				printTabs(tabs);
				printf("Value: %d\n", tree->symbol->value.intVal);
				break;
			default:
				break;
		}
		
		printTabs(tabs);
		printf("FunctionType: %s\n", functionTypeAsString(tree->symbol->functionType));
		printTabs(tabs);
		printf("Parameters: ");
		printParamList(tree->symbol->parameterListHead);
 		printf("\n\n");
	} else {
		printTabs(tabs);
		printf("Symbol: NULL\n\n");
	}
	
	// print children
	if (tree->left) {
		printTabs(tabs + 1);
		printf("Left child of %s\n", operatorAsString(tree->operation));
		printSyntaxTree(tree->left, tabs + 1);
	}
	if (tree->right) {
		printTabs(tabs + 1);
		printf("Right child of %s\n", operatorAsString(tree->operation));
		printSyntaxTree(tree->right, tabs + 1);
	}
}

/* Function: operatorAsString
 * Parameters: Operator operation
 * Description: Converts the enum Operator to a string.
 * Returns: Returns the given operation as a string.
 * Preconditions: none
 */
char *operatorAsString(Operator operation){
	switch (operation) {
		case ADD:
			return "+";
	 	case SUB:
			return "-";
		case MULT:
			return "*";
		case DIV:
			return "/";
		case NEG:
			return "UNARY -";
		case EQUAL:
			return "==";
		case NOT_EQUAL:
			return "!=";
		case GREATER_THAN:
			return ">";
		case GREATER_EQUAL:
			return ">=";
		case LESS_THAN:
			return "<";
		case LESS_EQUAL:
			return "<=";
		case AND:
			return "&&";
		case OR:
			return "||";
		case ASSIGNMENT:
			return "=";
		case IF_TREE:
			return "IF";
		case WHILE_TREE:
			return "WHILE_TREE";
		case RETURN_TREE:
			return "RETURN_TREE";
		case SYMBOL:
			return "SYMBOL";
		case PARAMETER_TREE:
			return "PARAMETER";
		case DECLARATION:
			return "DECLARATION";
		case STATEMENT:
			return "STATEMENT";
		case FUNCTION_ROOT:
			return "FUNCTION_ROOT";
		case FUNCTION_CALL:
			return "FUNCTION_CALL";
		default:
			return "MISSING/UNRECOGNIZED TREE OPERATOR";
	}
}