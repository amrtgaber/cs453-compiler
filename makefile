# File: makefile
# Author: Amr Gaber
# Created: 24/9/2010
# Last Modified: 4/11/2010
# Prupose: Build the C-- compiler using flex, yacc, and gcc.

CFLAGS = 

compile: scanner.lex parser.yacc utilities.o symbolTable.o code.o syntaxTree.o functionCall.o
	yacc -d parser.yacc
	flex scanner.lex
	gcc $(CFLAGS) lex.yy.c y.tab.c utilities.o symbolTable.o syntaxTree.o code.o functionCall.o -o compile

utilities.o: utilities.c utilities.h
	gcc utilities.c -c

symbolTable.o: symbolTable.c symbolTable.h
	gcc symbolTable.c -c
	
code.o: code.c code.h
	gcc code.c -c

syntaxTree.o: syntaxTree.c syntaxTree.h
	gcc syntaxTree.c -c

functionCall.o: functionCall.c functionCall.h
	gcc functionCall.c -c

scanner.lex:

parser.yacc:

.PHONY: clean
clean:
	rm -rf compile lex.yy.c y.tab.c y.tab.h *.o compile.dSYM
