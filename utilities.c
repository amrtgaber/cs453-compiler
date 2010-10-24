/* File: utilities.c
 * Author: Amr Gaber
 * Created: 11/4/2010
 * Last Modified: 21/10/2010
 * Purpose: Executes utility operations
 */

#include "utilities.h"

extern int errno;

/* void ERROR(char *message, unsigned int lineNum, char systemError) -- prints
 * error message then exits program with status -1
 */
void ERROR(char *message, unsigned int lineNum, char systemError) {
#ifdef DEBUG
	fprintf(stderr, "%u:", lineNum);
#endif
	if (systemError)
		perror(message);
	else
		fprintf(stderr, "ERROR: %s\n", message);

	exit(-1);
}