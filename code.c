/* File: code.c 
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 4/11/2010
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