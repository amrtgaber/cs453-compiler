/*
 * File: utilities.h
 * Author: Amr Gaber
 * Created: 11/4/2010
 * Last Modified: 20/10/2010
 * Purpose: Stores utility data
 */
 
#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define FALSE 			0
#define TRUE 			1
#define ERROR_MSG_SIZE 	100

void ERROR(char *message, unsigned int lineNum, char perrorFlag);

#endif
