# File: makefile
# Author: Amr Gaber
# Created: 24/9/2010
# Last Modified: 22/10/2010
# Prupose: Build the C-- compiler using flex, yacc, and gcc.

CFLAGS = 

compile: scanner.lex parser.yacc utilities.o symbolTable.o
	yacc -d parser.yacc
	flex scanner.lex
	gcc $(CFLAGS) lex.yy.c y.tab.c utilities.o symbolTable.o -o compile

utilities.o: utilities.c utilities.h
	gcc utilities.c -c

symbolTable.o: symbolTable.c symbolTable.h
	gcc symbolTable.c -c

scanner.lex:

parser.yacc:

.PHONY: clean
clean:
	rm -f compile lex.yy.c y.tab.c y.tab.h *.o
