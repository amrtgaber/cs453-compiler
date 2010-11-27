/* File: code.c 
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 27/11/2010
 * Purpose: Contains functions for the three address codes.
 */

#include "utilities.h"
#include "code.h"

/* Function: createCode
 * Parameters: Opcode opcode, Symbol *source1, Symbol *source2, Symbol *destination
 * Description: Creates a new three address code atom.
 * Returns: A pointer to the created three address code.
 * Preconditions: none
 */
Code *createCode(Opcode opcode, Symbol *source1, Symbol *source2, Symbol *destination) {
	
	Code *newCode = NULL;
	
	if (!(newCode = malloc(sizeof(Code))))
		ERROR("", __LINE__, TRUE);				// out of memory
		
	newCode->opcode = opcode;
	newCode->source1 = source1;
	newCode->source2 = source2;
	newCode->destination = destination;
	newCode->next = NULL;
	
	return newCode;
}

/* Function: destroyCode
 * Parameters: Code *code
 * Description: Deallocates the given three address code and ones following.
 * Returns: none
 * Preconditions: none
 */
void destroyCode(Code *code) {
	if (!code)
		return;
	
	destroyCode(code->next);	
	free(code);
}

/* Function: printCode
 * Parameters: Code *code
 * Description: Prints the code list starting at the given code.
 * Returns: none
 * Preconditions: none
 */
void printCode(Code *code) {
	if (!code)
		return;
		
	printf("Opcode: %s\n", opcodeAsString(code->opcode));
	printf("-----------------------\n");
	
	if (code->source1) {
		printf("Source1: %s\n", code->source1->identifier);
		printf("\tType: %s\n", typeAsString(code->source1->type));
		
		switch (code->source1->type) {
			case CHAR_TYPE:
				printf("\tValue: %c\n", code->source1->value.charVal);
				break;
			case INT_TYPE:
				printf("\tValue: %d\n", code->source1->value.intVal);
				break;
			default:
				break;
		}
		
		printf("\tFunctionType: %s\n", functionTypeAsString(code->source1->functionType));
		printf("\tParameters: ");
		printParamList(code->source1->parameterListHead);
		printf("\n");
	} else {
		printf("Source1: NONE\n");
	}
	
	if (code->source2) {
		printf("Source2: %s\n", code->source2->identifier);
		printf("\tType: %s\n", typeAsString(code->source2->type));
		
		switch (code->source2->type) {
			case CHAR_TYPE:
				printf("\tValue: %c\n", code->source2->value.charVal);
				break;
			case INT_TYPE:
				printf("\tValue: %d\n", code->source2->value.intVal);
				break;
			default:
				break;
		}
		
		printf("\tFunctionType: %s\n", functionTypeAsString(code->source2->functionType));
		printf("\tParameters: ");
		printParamList(code->source2->parameterListHead);
		printf("\n");
	} else {
		printf("Source2: NONE\n");
	}
	
	if (code->destination) {
		printf("Destination: %s\n", code->destination->identifier);
		printf("\tType: %s\n", typeAsString(code->destination->type));
		
		switch (code->destination->type) {
			case CHAR_TYPE:
				printf("\tValue: %c\n", code->destination->value.charVal);
				break;
			case INT_TYPE:
				printf("\tValue: %d\n", code->destination->value.intVal);
				break;
			default:
				break;
		}
		
		printf("\tFunctionType: %s\n", functionTypeAsString(code->destination->functionType));
		printf("\tParameters: ");
		printParamList(code->destination->parameterListHead);
		printf("\n");
	} else {
		printf("Destination: NONE\n");
	}
	
	printf("\n");
	printCode(code->next);
}

/* Function: opcodeAsString
 * Parameters: Opcode opcode
 * Description: Converts the enum Opcode to a string.
 * Returns: Returns the given opcode as a string.
 * Preconditions: none
 */
char *opcodeAsString(Opcode opcode) {
	switch (opcode) {
		case ADD_OP:
			return "+";
	 	case SUB_OP:
			return "-";
		case MULT_OP:
			return "*";
		case DIV_OP:
			return "/";
		case NEG_OP:
			return "NEGATION";
		case NOT_OP:
			return "!";
		case EQUAL_OP:
			return "==";
		case NOT_EQUAL_OP:
			return "!=";
		case GREATER_THAN_OP:
			return ">";
		case GREATER_EQUAL_OP:
			return ">=";
		case LESS_THAN_OP:
			return "<";
		case LESS_EQUAL_OP:
			return "<=";
		case AND_OP:
			return "&&";
		case OR_OP:
			return "||";
		case ASSIGNMENT_OP:
			return "=";
		case BRANCH:
			return "BRANCH";
		case JUMP:
			return "JUMP";
		case LABEL:
			return "LABEL";
		case ENTER:
			return "ENTER";
		case LEAVE:
			return "LEAVE";
		case PUSH_PARAM:
			return "PUSH PARAMETER";
		case DECLARATION_OP:
			return "DECLARATION";
		case ARRAY_OP:
			return "ARRAY INDEXING";
		case WHILE_OP:
			return "WHILE";
		case RETURN_OP:
			return "RETURN";
		case RETRIEVE_OP:
			return "RETRIEVE";
		default:
			return "MISSING/UNRECOGNIZED";
	}
}