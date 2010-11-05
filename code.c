/* File: code.c 
 * Author: Amr Gaber
 * Created: 4/11/2010
 * Last Modified: 4/11/2010
 * Purpose: Contains functions for the three address codes.
 */

#include "utilities.h"
#include "code.h"

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

void destroyCode(Code *code) {
	if (!code)
		return;
	
	destroyCode(code->next);	
	free(code);
}