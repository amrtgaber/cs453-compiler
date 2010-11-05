/* File: code.h 
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 4/11/2010
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
	EQUAL_OP,
	NOT_EQUAL_OP,
	GREATER_THAN_OP,
	GREATER_EQUAL_OP,
	LESS_THAN_OP,
	LESS_EQUAL_OP,
	AND_OP,
	OR_OP,
	ASSIGNMENT_OP,
	BRANCH_EQUAL,
	BRANCH_NOT_EQUAL,
	BRANCH_LESS,
	BRANCH_LESS_EQUAL,
	BRANCH_GREATER,
	BRANCH_GREATER_EQUAL,
	JUMP,
	ENTER,
	LEAVE,
	PUSH_PARAM,
	POP_PARAM,
	WHILE_OP,
	RETURN_OP
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


#endif