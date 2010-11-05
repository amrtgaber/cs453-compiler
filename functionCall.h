/* File: functionCall.h 
 * Author: Amr Gaber
 * Created: 5/11/2010
 * Last Modified: 5/11/2010
 * Purpose: Header file for functionCall.c.
 */

#ifndef __FUNCTIONCALL_H__
#define __FUNCTIONCALL_H__

#include "symbolTable.h"

/************************
 *						*
 * 	type definitions	*
 *						*
 ************************/

/* Struct: FunctionCall
 * Description: FunctionCall stack node
 */
typedef struct FunctionCall {
	char *identifier;
	Parameter *currParam;
	struct FunctionCall *below;
} FunctionCall;

/************************
 *						*
 * 	external variables	*
 *						*
 ************************/

extern FunctionCall *_callStack;

/************************
 *						*
 * 	exported functions	*
 *						*
 ************************/

/* Function: pushFunctionCall
 * Parameters: Symbol *function
 * Description: Pushes a function call onto the call stack.
 * Returns: The function call pushed.
 * Preconditions: The given function symbol is not NULL.
 */
FunctionCall *pushFunctionCall(Symbol *function);

/* Function: popFunctionCall
 * Parameters: none
 * Description: Pops a function call from the call stack.
 * Returns: none
 * Preconditions: The call stack is not empty.
 */
void popFunctionCall();

#endif