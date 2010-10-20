/*
 * File: utilities.c
 * Author: Amr Gaber
 * Created: 11/4/2010
 * Last Modified: 20/10/2010
 * Purpose: Executes utility operations
 */

#include "utilities.h"

int errno;
char _errorMessage[ERROR_MSG_SIZE];

/*
 * void ERROR(char *message, unsigned int lineNum, char perrorFlag) -- prints
 * error message then exits program with status -1
 */
void ERROR(char *message, unsigned int lineNum, char perrorFlag) {
#ifdef DEBUG
	fprintf(stderr, "%u:", lineNum);
#endif
	if (perrorFlag)
		perror(message);
	else
		fprintf(stderr, "ERROR: %s\n", message);

	exit(-1);
}
