# File: makefile
# Author: Amr Gaber
# Created: 24/9/2010
# Prupose: Build the compile executable using flex, yacc, and gcc

compile: scanner.lex parser.yacc
	yacc -d parser.yacc
	flex scanner.lex
	gcc lex.yy.c y.tab.c -o compile

scanner.lex:

parser.yacc:

.PHONY: clean
clean:
	rm -f compile lex.yy.c y.tab.c y.tab.h
