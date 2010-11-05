/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     INTCON = 259,
     CHARCON = 260,
     STRCON = 261,
     CHAR = 262,
     INT = 263,
     VOID = 264,
     IF = 265,
     ELSE = 266,
     WHILE = 267,
     FOR = 268,
     RETURN = 269,
     EXTERN = 270,
     UMINUS = 271,
     DBLEQ = 272,
     NOTEQ = 273,
     LTEQ = 274,
     GTEQ = 275,
     LOGICAND = 276,
     LOGICOR = 277,
     OTHER = 278
   };
#endif
/* Tokens.  */
#define ID 258
#define INTCON 259
#define CHARCON 260
#define STRCON 261
#define CHAR 262
#define INT 263
#define VOID 264
#define IF 265
#define ELSE 266
#define WHILE 267
#define FOR 268
#define RETURN 269
#define EXTERN 270
#define UMINUS 271
#define DBLEQ 272
#define NOTEQ 273
#define LTEQ 274
#define GTEQ 275
#define LOGICAND 276
#define LOGICOR 277
#define OTHER 278




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 41 "parser.yacc"
{
	int integer;
	char *string;
	struct exprReturn {
		Type type;
		SyntaxTree *tree;
	} exprReturn;
}
/* Line 1529 of yacc.c.  */
#line 104 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

