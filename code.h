/* File: code.h 
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 27/11/2010
 * Purpose: Header file for code.c.
 */

#ifndef __CODE_H__
#define __CODE_H__

#include "symbolTable.h"

/************************
 *						*
 * 	type definitions	*
 *						*
 ************************/

/* Enum: Opcode
 * Description: Enumerates the different code types.
 */
typedef enum Opcode {
	ADD_OP = 0xFEEDFACE,
	SUB_OP,
	MULT_OP,
	DIV_OP,
	NEG_OP,
	NOT_OP,
	EQUAL_OP,
	NOT_EQUAL_OP,
	GREATER_THAN_OP,
	GREATER_EQUAL_OP,
	LESS_THAN_OP,
	LESS_EQUAL_OP,
	AND_OP,
	OR_OP,
	ASSIGNMENT_OP,
	BRANCH,
	JUMP,
	LABEL,
	ENTER,
	LEAVE,
	PUSH_PARAM,
	DECLARATION_OP,
	ARRAY_OP,
	WHILE_OP,
	RETURN_OP,
	RETRIEVE_OP
} Opcode;

/* Struct: Code
 * Description: Represents a three address code atom.
 */
typedef struct Code {
	Opcode opcode;
	Symbol *source1, *source2, *destination;
	struct Code *next;
} Code;

/************************
 *						*
 * 	exported functions	*
 *						*
 ************************/

/* Function: createCode
 * Parameters: Opcode opcode, Symbol *source1, Symbol *source2, Symbol *destination
 * Description: Creates a new three address code atom.
 * Returns: A pointer to the created three address code.
 * Preconditions: none
 */
Code *createCode(Opcode opcode, Symbol *source1, Symbol *source2, Symbol *destination);

/* Function: destroyCode
 * Parameters: Code *code
 * Description: Deallocates the given three address code and ones following.
 * Returns: none
 * Preconditions: none
 */
void destroyCode(Code *code);

/* Function: printCode
 * Parameters: Code *code
 * Description: Prints the code list starting at the given code.
 * Returns: none
 * Preconditions: none
 */
void printCode(Code *code);

/* Function: opcodeAsString
 * Parameters: Opcode opcode
 * Description: Converts the enum Opcode to a string.
 * Returns: Returns the given opcode as a string.
 * Preconditions: none
 */
char *opcodeAsString(Opcode opcode);

#endif