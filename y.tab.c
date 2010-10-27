/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



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




/* Copy the first part of user declarations.  */
#line 9 "parser.yacc"

#include "symbolTable.h"
#include "utilities.h"

typedef struct FunctionCall {
	char *identifier;
	Parameter *currParam;
	struct FunctionCall *below;
} FunctionCall;

void typeError(char *errorMessage);
FunctionCall *pushFunctionCall(Symbol *function);
FunctionCall *peekFunctionCall();
void popFunctionCall();

extern int yylineno;
extern char *yytext;
char *_currID = NULL, *_currFID = NULL, _returnedValue = FALSE, _errorMessage[255];
Type _currType = -1;
FunctionType _currFType = -1;
Parameter *_currParam = NULL;
FunctionCall *_callStack = NULL;


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 33 "parser.yacc"
{
	int integer;
	char* string;
}
/* Line 193 of yacc.c.  */
#line 171 "y.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 184 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   320

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  40
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  32
/* YYNRULES -- Number of rules.  */
#define YYNRULES  87
/* YYNRULES -- Number of states.  */
#define YYNSTATES  191

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   278

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    30,     2,     2,     2,     2,     2,     2,
      32,    33,    28,    26,    34,    27,     2,    29,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    31,
      24,    39,    25,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    35,     2,    36,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    37,     2,    38,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     7,    10,    14,    17,    18,    22,    32,
      41,    51,    60,    62,    64,    66,    68,    69,    78,    79,
      83,    84,    86,    91,    93,    95,    96,    99,   103,   106,
     111,   115,   116,   117,   128,   139,   145,   150,   151,   157,
     165,   171,   181,   185,   188,   191,   196,   197,   205,   209,
     211,   214,   217,   218,   222,   229,   231,   232,   235,   238,
     242,   246,   250,   254,   258,   262,   266,   270,   274,   278,
     282,   286,   287,   291,   295,   297,   299,   301,   304,   305,
     311,   312,   317,   318,   320,   322,   323,   327
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      41,     0,    -1,    41,    42,    31,    -1,    41,    57,    -1,
      41,    42,     1,    -1,     1,    31,    -1,    -1,    51,    50,
      49,    -1,    45,    51,    43,    32,    56,    53,    33,    48,
      47,    -1,    51,    43,    32,    56,    53,    33,    48,    47,
      -1,    45,    46,    43,    32,    56,    53,    33,    48,    47,
      -1,    46,    43,    32,    56,    53,    33,    48,    47,    -1,
       3,    -1,     3,    -1,    15,    -1,     9,    -1,    -1,    48,
      34,    47,    43,    32,    56,    53,    33,    -1,    -1,    49,
      34,    50,    -1,    -1,     3,    -1,     3,    35,     4,    36,
      -1,     7,    -1,     8,    -1,    -1,    52,     9,    -1,    52,
      54,    55,    -1,    51,     3,    -1,    51,     3,    35,    36,
      -1,    55,    34,    54,    -1,    -1,    -1,    51,    43,    32,
      56,    53,    33,    37,    58,    61,    38,    -1,    46,    43,
      32,    56,    53,    33,    37,    58,    61,    38,    -1,    58,
      51,    50,    49,    31,    -1,    58,    51,     1,    31,    -1,
      -1,    10,    32,    64,    33,    59,    -1,    10,    32,    64,
      33,    59,    11,    59,    -1,    12,    32,    64,    33,    59,
      -1,    13,    32,    63,    31,    70,    31,    63,    33,    59,
      -1,    14,    64,    31,    -1,    14,    31,    -1,    62,    31,
      -1,    44,    32,    33,    31,    -1,    -1,    44,    32,    60,
      69,    71,    33,    31,    -1,    37,    61,    38,    -1,    31,
      -1,     1,    31,    -1,    61,    59,    -1,    -1,    44,    39,
      64,    -1,    44,    35,    64,    36,    39,    64,    -1,    62,
      -1,    -1,    27,    64,    -1,    30,    64,    -1,    64,    26,
      64,    -1,    64,    27,    64,    -1,    64,    28,    64,    -1,
      64,    29,    64,    -1,    64,    17,    64,    -1,    64,    18,
      64,    -1,    64,    19,    64,    -1,    64,    24,    64,    -1,
      64,    20,    64,    -1,    64,    25,    64,    -1,    64,    21,
      64,    -1,    64,    22,    64,    -1,    -1,     3,    65,    66,
      -1,    32,    64,    33,    -1,     4,    -1,     5,    -1,     6,
      -1,    32,    33,    -1,    -1,    32,    67,    69,    71,    33,
      -1,    -1,    35,    68,    64,    36,    -1,    -1,    64,    -1,
      64,    -1,    -1,    71,    34,    69,    -1,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    56,    56,    57,    60,    61,    63,    66,    67,    69,
      70,    72,    75,    80,    86,    91,    96,   114,   115,   118,
     119,   122,   135,   160,   164,   170,   178,   191,   199,   228,
     264,   265,   268,   299,   316,   326,   329,   331,   334,   339,
     344,   349,   354,   375,   389,   390,   418,   417,   450,   451,
     454,   457,   458,   461,   486,   515,   516,   519,   526,   533,
     540,   547,   554,   561,   568,   575,   582,   589,   596,   603,
     610,   618,   617,   631,   632,   633,   634,   637,   659,   658,
     690,   689,   725,   741,   761,   762,   765,   766
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "ID", "INTCON", "CHARCON", "STRCON",
  "CHAR", "INT", "VOID", "IF", "ELSE", "WHILE", "FOR", "RETURN", "EXTERN",
  "UMINUS", "DBLEQ", "NOTEQ", "LTEQ", "GTEQ", "LOGICAND", "LOGICOR",
  "OTHER", "'<'", "'>'", "'+'", "'-'", "'*'", "'/'", "'!'", "';'", "'('",
  "')'", "','", "'['", "']'", "'{'", "'}'", "'='", "$accept", "program",
  "declaration", "storeFID", "storeID", "storeExtern", "storeVoid",
  "makeProt", "multiProtDcl", "multiVarDcl", "varDcl", "type", "initParam",
  "paramTypes", "arrayTypeOpt", "multiParam", "insertFunc", "function",
  "multiTypeDcl", "statement", "@1", "statementOpt", "assignment",
  "assgOpt", "expr", "@2", "multiFuncOpt", "@3", "@4", "args", "exprOpt",
  "multiExprOpt", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,    60,    62,    43,    45,    42,    47,
      33,    59,    40,    41,    44,    91,    93,   123,   125,    61
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    40,    41,    41,    41,    41,    41,    42,    42,    42,
      42,    42,    43,    44,    45,    46,    47,    48,    48,    49,
      49,    50,    50,    51,    51,    52,    53,    53,    54,    54,
      55,    55,    56,    57,    57,    58,    58,    58,    59,    59,
      59,    59,    59,    59,    59,    59,    60,    59,    59,    59,
      59,    61,    61,    62,    62,    63,    63,    64,    64,    64,
      64,    64,    64,    64,    64,    64,    64,    64,    64,    64,
      64,    65,    64,    64,    64,    64,    64,    66,    67,    66,
      68,    66,    66,    69,    70,    70,    71,    71
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     3,     2,     3,     2,     0,     3,     9,     8,
       9,     8,     1,     1,     1,     1,     0,     8,     0,     3,
       0,     1,     4,     1,     1,     0,     2,     3,     2,     4,
       3,     0,     0,    10,    10,     5,     4,     0,     5,     7,
       5,     9,     3,     2,     2,     4,     0,     7,     3,     1,
       2,     2,     0,     3,     6,     1,     0,     2,     2,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     0,     3,     3,     1,     1,     1,     2,     0,     5,
       0,     4,     0,     1,     1,     0,     3,     0
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     5,     1,    23,    24,    15,    14,     0,
       0,     0,     0,     3,     4,     2,     0,     0,    12,     0,
      21,     0,    20,     0,     0,    32,     0,    32,     7,    32,
      32,    25,     0,    25,     0,    25,    25,     0,     0,    22,
       0,    21,    19,     0,     0,    26,     0,    31,    18,    18,
      18,    18,    28,    27,    37,    16,    37,    16,    16,    16,
       0,     0,    52,    16,    11,    52,     9,    10,     8,    29,
      30,     0,     0,     0,     0,     0,    20,     0,    13,     0,
       0,     0,     0,    49,    52,    34,     0,    51,     0,     0,
      33,    36,     0,    50,     0,     0,    56,    71,    74,    75,
      76,     0,     0,    43,     0,     0,     0,    46,     0,     0,
      44,    32,    35,     0,     0,     0,    55,     0,    82,    57,
      58,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    42,    48,     0,     0,     0,    53,
      25,     0,     0,    85,    78,    80,    72,    73,    63,    64,
      65,    67,    69,    70,    66,    68,    59,    60,    61,    62,
      45,    83,    87,     0,     0,    38,    40,    84,     0,    77,
       0,     0,     0,     0,    17,     0,    56,    87,     0,     0,
       0,    54,    39,     0,     0,    81,    47,    86,     0,    79,
      41
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     9,    19,    86,    10,    11,    64,    55,    28,
      22,    46,    37,    38,    47,    53,    31,    13,    62,    87,
     137,    72,    88,   117,   161,   118,   146,   170,   171,   162,
     168,   172
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -159
static const yytype_int16 yypact[] =
{
     227,   -20,    72,  -159,  -159,  -159,  -159,  -159,  -159,     9,
      75,    55,    66,  -159,  -159,  -159,    55,    55,  -159,    42,
      35,    59,  -159,    64,    77,  -159,   112,  -159,    84,  -159,
    -159,  -159,    86,  -159,   108,  -159,  -159,   186,    95,  -159,
     102,   115,  -159,   104,   110,  -159,   144,  -159,   123,   166,
    -159,  -159,   117,   195,  -159,   199,  -159,   199,   199,   199,
     184,    31,    31,  -159,  -159,    31,  -159,  -159,  -159,  -159,
    -159,    16,    23,    55,    63,   210,  -159,   218,  -159,   224,
     232,   244,   109,  -159,  -159,  -159,    24,  -159,   246,   256,
    -159,  -159,   111,  -159,   121,   121,   286,  -159,  -159,  -159,
    -159,   121,   121,  -159,   121,   226,    92,   257,   121,   121,
    -159,  -159,  -159,   163,   180,    18,  -159,   268,   114,  -159,
    -159,   197,   121,   121,   121,   121,   121,   121,   121,   121,
     121,   121,   121,   121,  -159,  -159,   269,   121,   137,   241,
    -159,   107,   107,   121,   275,  -159,  -159,  -159,   278,   278,
     105,   105,   267,   254,   105,   105,   203,   203,  -159,  -159,
    -159,   241,  -159,   262,   276,   299,  -159,   241,   280,  -159,
     121,   121,   204,   121,  -159,   107,   286,  -159,   150,   281,
     121,   241,  -159,   282,   206,  -159,  -159,  -159,   107,  -159,
    -159
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -159,  -159,  -159,    13,   -91,  -159,   303,    40,   161,   238,
     -16,     6,  -159,   -33,   255,  -159,   -23,  -159,   261,  -110,
    -159,   -50,   -87,   142,   -81,  -159,  -159,  -159,  -159,  -158,
    -159,   143
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -13
static const yytype_int16 yytable[] =
{
      40,   105,    43,    44,    33,   115,    35,    36,    12,   116,
      14,     3,   177,   113,   114,    74,    17,    75,    42,    41,
     119,   120,   187,   121,    77,    21,    78,   138,   139,    23,
      24,   165,   166,    79,   106,    80,    81,    82,     5,     6,
      15,   148,   149,   150,   151,   152,   153,   154,   155,   156,
     157,   158,   159,   108,    83,    76,   107,   109,    18,   108,
      84,    85,   167,   109,    77,   182,    78,   -12,    71,    20,
      26,    71,     4,    79,    25,    80,    81,    82,   190,     5,
       6,     7,     5,     6,     7,   115,    89,     8,   140,   116,
     178,    27,   181,    77,    83,    78,    29,    66,    67,    68,
      84,    90,    79,    73,    80,    81,    82,   164,    77,    30,
      78,    41,    97,    98,    99,   100,    32,    79,    34,    80,
      81,    82,    39,    83,    97,    98,    99,   100,    48,    84,
     135,   130,   131,   132,   133,    49,   101,    50,    83,   102,
     103,   104,   112,    51,    84,    34,   144,    52,   101,   145,
      26,   102,    60,   104,   122,   123,   124,   125,   126,   127,
      54,   128,   129,   130,   131,   132,   133,   122,   123,   124,
     125,   126,   127,   163,   128,   129,   130,   131,   132,   133,
     122,   123,   124,   125,   126,   127,   185,   128,   129,   130,
     131,   132,   133,     5,     6,    45,   141,   122,   123,   124,
     125,   126,   127,    56,   128,   129,   130,   131,   132,   133,
      57,    58,    59,   142,   122,   123,   124,   125,   126,   127,
      69,   128,   129,   130,   131,   132,   133,    -6,     1,    61,
     147,   132,   133,    63,    -6,    -6,    -6,   179,   180,   189,
     180,    91,    -6,   122,   123,   124,   125,   126,   127,    93,
     128,   129,   130,   131,   132,   133,    94,   134,   122,   123,
     124,   125,   126,   127,    95,   128,   129,   130,   131,   132,
     133,   122,   123,   124,   125,   126,    96,   110,   128,   129,
     130,   131,   132,   133,   122,   123,   124,   125,   111,    78,
     136,   128,   129,   130,   131,   132,   133,   124,   125,   143,
     160,   173,   128,   129,   130,   131,   132,   133,   169,   174,
     175,   176,   186,    16,    92,   188,    70,    65,   183,     0,
     184
};

static const yytype_int16 yycheck[] =
{
      33,    82,    35,    36,    27,    96,    29,    30,     2,    96,
       1,    31,   170,    94,    95,    65,    10,     1,    34,     3,
     101,   102,   180,   104,     1,    12,     3,   108,   109,    16,
      17,   141,   142,    10,    84,    12,    13,    14,     7,     8,
      31,   122,   123,   124,   125,   126,   127,   128,   129,   130,
     131,   132,   133,    35,    31,    71,    32,    39,     3,    35,
      37,    38,   143,    39,     1,   175,     3,    32,    62,     3,
      35,    65,     0,    10,    32,    12,    13,    14,   188,     7,
       8,     9,     7,     8,     9,   176,    73,    15,   111,   176,
     171,    32,   173,     1,    31,     3,    32,    57,    58,    59,
      37,    38,    10,    63,    12,    13,    14,   140,     1,    32,
       3,     3,     3,     4,     5,     6,     4,    10,    34,    12,
      13,    14,    36,    31,     3,     4,     5,     6,    33,    37,
      38,    26,    27,    28,    29,    33,    27,    33,    31,    30,
      31,    32,    31,    33,    37,    34,    32,     3,    27,    35,
      35,    30,    35,    32,    17,    18,    19,    20,    21,    22,
      37,    24,    25,    26,    27,    28,    29,    17,    18,    19,
      20,    21,    22,    36,    24,    25,    26,    27,    28,    29,
      17,    18,    19,    20,    21,    22,    36,    24,    25,    26,
      27,    28,    29,     7,     8,     9,    33,    17,    18,    19,
      20,    21,    22,    37,    24,    25,    26,    27,    28,    29,
      49,    50,    51,    33,    17,    18,    19,    20,    21,    22,
      36,    24,    25,    26,    27,    28,    29,     0,     1,    34,
      33,    28,    29,    34,     7,     8,     9,    33,    34,    33,
      34,    31,    15,    17,    18,    19,    20,    21,    22,    31,
      24,    25,    26,    27,    28,    29,    32,    31,    17,    18,
      19,    20,    21,    22,    32,    24,    25,    26,    27,    28,
      29,    17,    18,    19,    20,    21,    32,    31,    24,    25,
      26,    27,    28,    29,    17,    18,    19,    20,    32,     3,
      33,    24,    25,    26,    27,    28,    29,    19,    20,    31,
      31,    39,    24,    25,    26,    27,    28,    29,    33,    33,
      11,    31,    31,    10,    76,    33,    61,    56,   176,    -1,
     177
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     1,    41,    31,     0,     7,     8,     9,    15,    42,
      45,    46,    51,    57,     1,    31,    46,    51,     3,    43,
       3,    43,    50,    43,    43,    32,    35,    32,    49,    32,
      32,    56,     4,    56,    34,    56,    56,    52,    53,    36,
      53,     3,    50,    53,    53,     9,    51,    54,    33,    33,
      33,    33,     3,    55,    37,    48,    37,    48,    48,    48,
      35,    34,    58,    34,    47,    58,    47,    47,    47,    36,
      54,    51,    61,    47,    61,     1,    50,     1,     3,    10,
      12,    13,    14,    31,    37,    38,    44,    59,    62,    43,
      38,    31,    49,    31,    32,    32,    32,     3,     4,     5,
       6,    27,    30,    31,    32,    64,    61,    32,    35,    39,
      31,    32,    31,    64,    64,    44,    62,    63,    65,    64,
      64,    64,    17,    18,    19,    20,    21,    22,    24,    25,
      26,    27,    28,    29,    31,    38,    33,    60,    64,    64,
      56,    33,    33,    31,    32,    35,    66,    33,    64,    64,
      64,    64,    64,    64,    64,    64,    64,    64,    64,    64,
      31,    64,    69,    36,    53,    59,    59,    64,    70,    33,
      67,    68,    71,    39,    33,    11,    31,    69,    64,    33,
      34,    64,    59,    63,    71,    36,    31,    69,    33,    33,
      59
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:
#line 60 "parser.yacc"
    { yyerrok; }
    break;

  case 5:
#line 61 "parser.yacc"
    { yyerrok; }
    break;

  case 12:
#line 76 "parser.yacc"
    {
			  _currFID = (yyvsp[(1) - (1)].string);
			}
    break;

  case 13:
#line 81 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (1)].string);
			  (yyval.string) = (yyvsp[(1) - (1)].string);
			}
    break;

  case 14:
#line 87 "parser.yacc"
    {
			  _currFType = EXTERN_TYPE;
			}
    break;

  case 15:
#line 92 "parser.yacc"
    {
			  _currType = VOID_TYPE;
			}
    break;

  case 16:
#line 96 "parser.yacc"
    {
			  Symbol *prevDcl = recallGlobal(_currFID);
	
			  if (prevDcl->functionType == PROTOTYPE || prevDcl->functionType == EXTERN_TYPE) {
				  sprintf(_errorMessage, "prototype %s previously declared",
					  _currFID);
			      typeError(_errorMessage);
			  } else {
				  if (_currFType == EXTERN_TYPE)
					  prevDcl->functionType = EXTERN_TYPE;
				  else
				      prevDcl->functionType = PROTOTYPE;
			  }
			
			  popSymbolTable();
			}
    break;

  case 21:
#line 123 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (1)].string);
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
				  currSymbol->functionType = NON_FUNCTION;
			  }
			}
    break;

  case 22:
#line 136 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (4)].string);
			
			  if (_currType == CHAR_TYPE)
				  _currType = CHAR_ARRAY;
			  else
			      _currType = INT_ARRAY;
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
			      currSymbol->functionType = NON_FUNCTION;
			  }
			
			  if (_currType == CHAR_ARRAY)
				  _currType = CHAR_TYPE;
			  else
			      _currType = INT_TYPE;
			}
    break;

  case 23:
#line 161 "parser.yacc"
    {
			  _currType = CHAR_TYPE;
			}
    break;

  case 24:
#line 165 "parser.yacc"
    {
			  _currType = INT_TYPE;
			}
    break;

  case 25:
#line 170 "parser.yacc"
    { 
			  Symbol *currSymbol = recallGlobal(_currFID);
			  
			  if (currSymbol)
				  _currParam = currSymbol->parameterListHead;
				
			}
    break;

  case 26:
#line 179 "parser.yacc"
    {
			  Symbol *currentFunction = recallGlobal(_currFID);
			
		      if (_currParam) {
		 		  if (_currParam->type != VOID_TYPE)
				  	  typeError("Type mismatch: non-VOID parameter(s) expected");
			  } else {
				  addParameter(NULL, VOID_TYPE, currentFunction);
			  }

			  _currParam = NULL;
			}
    break;

  case 27:
#line 192 "parser.yacc"
    {
			  if (_currParam)
				  typeError("Type mismatch: missing previously declared types");
			  
			  _currParam = NULL;
			}
    break;

  case 28:
#line 200 "parser.yacc"
    {
			  _currID = (yyvsp[(2) - (2)].string);
			
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			    if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			    } else {
			  	  	if (_currParam) {
					  	if (_currParam->type != _currType) {
							sprintf(_errorMessage, "%s does not match previous declaration",
								typeAsString(_currType));
							typeError(_errorMessage);
						} else {
							Symbol *currSymbol = insert(_currID, _currType);
						    currSymbol->functionType = NON_FUNCTION;
						}
			  	 	} else {
				  		Symbol *currSymbol = addParameter(_currID, _currType, currentFunction);
					    currSymbol->functionType = NON_FUNCTION;
			  		}
				}
				
			  if (_currParam)
			  	  _currParam = _currParam->next;
			}
    break;

  case 29:
#line 229 "parser.yacc"
    {
			  _currID = (yyvsp[(2) - (4)].string);
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			  if (_currType == CHAR_TYPE)
				  _currType = CHAR_ARRAY;
			  else
			      _currType = INT_ARRAY;
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
			  } else {
			  	  if (_currParam) {
					  if (_currParam->type != _currType) {
						  if (_currType == CHAR_ARRAY)
							  typeError("CHAR_ARRAY does not match previous declaration");
						  else
							  typeError("INT_ARRAY does not match previous declaration");
					  } else {
						  Symbol *currSymbol = insert(_currID, _currType);
						  currSymbol->functionType = NON_FUNCTION;
					  }
			  	  } else {
				  	  Symbol *currSymbol = addParameter(_currID, _currType, currentFunction);
					  currSymbol->functionType = NON_FUNCTION;
			  	  }
			  }
			
			 if (_currParam)
			   _currParam = _currParam->next;
			}
    break;

  case 32:
#line 268 "parser.yacc"
    {
			  Symbol *prevDcl = recallGlobal(_currFID);

			  if (prevDcl) {
			      if (prevDcl->functionType == DEFINITION) {
				      sprintf(_errorMessage, "function %s previously defined",
						  prevDcl->identifier);
			          typeError(_errorMessage);
			      } else if (prevDcl->functionType == EXTERN_TYPE) {
					  sprintf(_errorMessage, "function %s previously declared as extern",
						  prevDcl->identifier);
			          typeError(_errorMessage);
				  } else if (prevDcl->functionType == NON_FUNCTION) {
					  sprintf(_errorMessage, "function %s previously declared",
						  prevDcl->identifier);
					  typeError(_errorMessage);
				  } else if (prevDcl->type != _currType) {
					  sprintf(_errorMessage, "return type of function %s doesn't match previous declaration",
						  prevDcl->identifier);
				      typeError(_errorMessage);
				  }
			  } else {
				      Symbol *currFunction = insert(_currFID, _currType);
					  currFunction->functionType = DEFINITION;
					  currFunction->type = _currType;
			  }
			
			  pushSymbolTable();
			}
    break;

  case 33:
#line 301 "parser.yacc"
    { 
			  if (!_returnedValue) {
				  sprintf(_errorMessage, "function %s must have at least one return statement",
					  _currFID);
				  typeError(_errorMessage);
			  } else {
				  _returnedValue = FALSE;
			  }
			  
			  #ifdef DEBUG	
			  printSymbolTable();
			  #endif
					
			  popSymbolTable();
			}
    break;

  case 34:
#line 318 "parser.yacc"
    { 
				#ifdef DEBUG
				printSymbolTable();
				#endif
				
				popSymbolTable(); }
    break;

  case 36:
#line 329 "parser.yacc"
    { yyerrok; }
    break;

  case 38:
#line 335 "parser.yacc"
    {
			  if ((yyvsp[(3) - (5)].integer) != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
    break;

  case 39:
#line 340 "parser.yacc"
    {
			  if ((yyvsp[(3) - (7)].integer) != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
    break;

  case 40:
#line 345 "parser.yacc"
    {
			  if ((yyvsp[(3) - (5)].integer) != BOOLEAN)
				  typeError("conditional in while loop must be a boolean");
			}
    break;

  case 41:
#line 350 "parser.yacc"
    {
			  if ((yyvsp[(5) - (9)].integer) != BOOLEAN)
				  typeError("conditional in for loop must be a boolean");
			}
    break;

  case 42:
#line 355 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
			  } else {
				  if (currSymbol->type != (yyvsp[(2) - (3)].integer)) {
				      if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  || ((yyvsp[(2) - (3)].integer) != INT_TYPE && (yyvsp[(2) - (3)].integer) != CHAR_TYPE)) {
						  	sprintf(_errorMessage, "return type for function %s does not match declared type",
								_currFID);
						  typeError(_errorMessage);
					  } else {
						_returnedValue = TRUE;
					  }
			  	  } else {
					  _returnedValue = TRUE;
				  }
			  }
			}
    break;

  case 43:
#line 376 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
			  } else {
				  if (currSymbol->type != VOID_TYPE) {
					  sprintf(_errorMessage, "return type for function %s does not match declared type",
						  _currFID);
					  typeError(_errorMessage);
				  }
			  }
			}
    break;

  case 45:
#line 391 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currID);
			  
			  if (currSymbol) {
			      if (!currSymbol->parameterListHead) {
					  sprintf(_errorMessage, "%s is not a function", _currID);
				      typeError(_errorMessage);
				  }
			
			      else if (currSymbol->parameterListHead->type != VOID_TYPE) {
			          sprintf(_errorMessage, "function %s takes non-VOID arguments",
						  _currID);
			   	      typeError(_errorMessage);
				  }
				  
				  if (currSymbol->type != VOID_TYPE) {
					  sprintf(_errorMessage, "function %s must return VOID to be used as a statement",
						  _currID);
				      typeError(_errorMessage);
				  }
			  } else {
				  sprintf(_errorMessage, "%s undefined", _currID);
			      typeError(_errorMessage);
			  }
			
			}
    break;

  case 46:
#line 418 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currID);

			  if (!currSymbol) {
				  	sprintf(_errorMessage, "%s undefined", _currID);
			        typeError(_errorMessage);
			  } else {
				  if (currSymbol->functionType == NON_FUNCTION) {
					  sprintf(_errorMessage, "%s is not a function", _currID);
			          typeError(_errorMessage);
				  } else {
					  if (currSymbol->type != VOID_TYPE) {
						  sprintf(_errorMessage, "function %s must return VOID to be used as a statement",
							  _currID);
					      typeError(_errorMessage);
					  }
					  pushFunctionCall(currSymbol);
				  }
			  }
			}
    break;

  case 47:
#line 439 "parser.yacc"
    {
			  if (_callStack) {
			  	  if (_callStack->currParam) {
				  	  sprintf(_errorMessage, "more arguments expected for function %s",
					  	  _callStack->identifier);
				  	  typeError(_errorMessage);
			  	  }
				
		      	  popFunctionCall();
		      }
			}
    break;

  case 50:
#line 454 "parser.yacc"
    { yyerrok; }
    break;

  case 53:
#line 462 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (3)].string);
			  Symbol *currSymbol = recall(_currID);
			
			  if (!currSymbol) {
				  sprintf(_errorMessage, "%s undefined", _currID);
				  typeError(_errorMessage);
		  	  } else {
				  if (currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE
						|| currSymbol->functionType != NON_FUNCTION) {
					sprintf(_errorMessage, "%s has incompatible type for assignment",
						_currID);
					typeError(_errorMessage);
				}
				  if (currSymbol->type != (yyvsp[(3) - (3)].integer)) {
					  if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  && ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE)) {
						sprintf(_errorMessage, "incompatible types for assignment of %s",
							_currID);
						typeError(_errorMessage);
					  }
				  }
			  }
			}
    break;

  case 54:
#line 487 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (6)].string);
			  Symbol *currSymbol = recall(_currID);
			
			  if (!currSymbol) {
				  sprintf(_errorMessage, "%s undefined", _currID);
				  typeError(_errorMessage);
		  	  } else {
				  if (currSymbol->type != INT_ARRAY && currSymbol->type != CHAR_ARRAY) {
					  sprintf(_errorMessage, "%s must be an ARRAY to be indexed", _currID);
					  typeError(_errorMessage);
				  }
				  
				  if ((yyvsp[(3) - (6)].integer) != INT_TYPE && (yyvsp[(3) - (6)].integer) != CHAR_TYPE) {
					  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
						  _currID);
					  typeError(_errorMessage);
				  }
				  
				  if ((yyvsp[(6) - (6)].integer) != INT_TYPE && (yyvsp[(6) - (6)].integer) != CHAR_TYPE)  {
					    sprintf(_errorMessage, "incompatible types for assignment of %s",
							_currID);
						typeError(_errorMessage);
				  }
			  }
			}
    break;

  case 57:
#line 520 "parser.yacc"
    {
			  if ((yyvsp[(2) - (2)].integer) != INT_TYPE && (yyvsp[(2) - (2)].integer) != CHAR_TYPE)
				  typeError("incompatible expression for operator '-'");
			
			  (yyval.integer) = (yyvsp[(2) - (2)].integer);
			}
    break;

  case 58:
#line 527 "parser.yacc"
    {
			  if ((yyvsp[(2) - (2)].integer) != BOOLEAN)
				  typeError("incompatible expression for operator '!'");
			
			  (yyval.integer) = (yyvsp[(2) - (2)].integer);
			}
    break;

  case 59:
#line 534 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '+'");
			
			  (yyval.integer) = (yyvsp[(1) - (3)].integer);
			}
    break;

  case 60:
#line 541 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '-'");
			
			  (yyval.integer) = (yyvsp[(1) - (3)].integer);
			}
    break;

  case 61:
#line 548 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '*'");
			
			  (yyval.integer) = (yyvsp[(1) - (3)].integer);
			}
    break;

  case 62:
#line 555 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '/'");
			
			  (yyval.integer) = (yyvsp[(1) - (3)].integer);
			}
    break;

  case 63:
#line 562 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '=='");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 64:
#line 569 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '!='");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 65:
#line 576 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '<='");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 66:
#line 583 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '<'");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 67:
#line 590 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '>='");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 68:
#line 597 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].integer) != INT_TYPE && (yyvsp[(1) - (3)].integer) != CHAR_TYPE) || ((yyvsp[(3) - (3)].integer) != INT_TYPE && (yyvsp[(3) - (3)].integer) != CHAR_TYPE))
				  typeError("incompatible expression for operator '>'");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 69:
#line 604 "parser.yacc"
    {
			  if ((yyvsp[(1) - (3)].integer) != BOOLEAN || (yyvsp[(3) - (3)].integer) != BOOLEAN)
				  typeError("incompatible expression for operator '&&'");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 70:
#line 611 "parser.yacc"
    {
			  if ((yyvsp[(1) - (3)].integer) != BOOLEAN || (yyvsp[(3) - (3)].integer) != BOOLEAN)
				  typeError("incompatible expression for operator '||'");
			
			  (yyval.integer) = BOOLEAN;
			}
    break;

  case 71:
#line 618 "parser.yacc"
    { 
			  _currID = (yyvsp[(1) - (1)].string);
			  Symbol *currSymbol = recall(_currID);
			  
			  if (!currSymbol) {
				  sprintf(_errorMessage, "%s undefined", _currID);
				  typeError(_errorMessage);
			  }
			}
    break;

  case 72:
#line 628 "parser.yacc"
    {
				(yyval.integer) = (yyvsp[(3) - (3)].integer);
			}
    break;

  case 73:
#line 631 "parser.yacc"
    { (yyval.integer) = (yyvsp[(2) - (3)].integer); }
    break;

  case 74:
#line 632 "parser.yacc"
    { (yyval.integer) = INT_TYPE; }
    break;

  case 75:
#line 633 "parser.yacc"
    { (yyval.integer) = CHAR_TYPE; }
    break;

  case 76:
#line 634 "parser.yacc"
    { (yyval.integer) = CHAR_ARRAY; }
    break;

  case 77:
#line 638 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currID);
			  
			  if (currSymbol) {
			      if (!currSymbol->parameterListHead) {
					  sprintf(_errorMessage, "%s is not a function", _currID);
				      typeError(_errorMessage);
			      } else if (currSymbol->type == VOID_TYPE) {
					  sprintf(_errorMessage, "void function %s in expression", _currID);
					  typeError(_errorMessage);
				  }	else if (currSymbol->parameterListHead->type != VOID_TYPE) {
					  sprintf(_errorMessage, "function %s takes non-VOID arguments",
						  _currID);
			          typeError(_errorMessage);
			      }
				  (yyval.integer) = currSymbol->type;
			  } else {
				  (yyval.integer) = -1;
			  }
			}
    break;

  case 78:
#line 659 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currID);
			
			  // TODO check that function does not return void

			  if (currSymbol) {
			      if (currSymbol->functionType == NON_FUNCTION) {
				      sprintf(_errorMessage, "%s is not a function", _currID);
			          typeError(_errorMessage);
				  }
				  pushFunctionCall(currSymbol);
			  }
			}
    break;

  case 79:
#line 673 "parser.yacc"
    {
			  // TODO check that _callStack is not null
				
			  if (_callStack->currParam) {
				  sprintf(_errorMessage, "more arguments expected for function %s",
					  _callStack->identifier);
				  typeError(_errorMessage);
			  }
			
			  if (!_callStack) {
				(yyval.integer) = -1;
			  } else {
				  (yyval.integer) = (recallGlobal(_callStack->identifier))->type;
			      popFunctionCall();
			  }
			}
    break;

  case 80:
#line 690 "parser.yacc"
    {
			  Symbol *currSymbol = recall(_currID);

			  if (currSymbol) {
				  if (currSymbol->type != CHAR_ARRAY && currSymbol->type != INT_ARRAY) {
					  sprintf(_errorMessage, "%s must be an ARRAY to be indexed",
						  _currID);
					  typeError(_errorMessage);
				  }
				  
				  pushFunctionCall(currSymbol);
			  }
			}
    break;

  case 81:
#line 704 "parser.yacc"
    {
			  if ((yyvsp[(3) - (4)].integer) != INT_TYPE && (yyvsp[(3) - (4)].integer) != CHAR_TYPE) {
				  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
					  _currID);
			  	  typeError(_errorMessage);
			  }
			
				if (!_callStack) {
					(yyval.integer) = -1;
				  } else {
					  (yyval.integer) = (recall(_callStack->identifier))->type;
					
					  if ((yyval.integer) == CHAR_ARRAY)
						  (yyval.integer) = CHAR_TYPE;
					  else
						  (yyval.integer) = INT_TYPE;
					
				      popFunctionCall();
				  }
			}
    break;

  case 82:
#line 725 "parser.yacc"
    {
				Symbol *currSymbol = recall(_currID);
				
				if (currSymbol) {
				    if (currSymbol->functionType != NON_FUNCTION) {
						sprintf(_errorMessage, "expected arguments for function %s",
							_currID);
						typeError(_errorMessage);
					}
					(yyval.integer) = currSymbol->type;
				} else {
					(yyval.integer) = -1;
				}
			}
    break;

  case 83:
#line 742 "parser.yacc"
    {
			  if (_callStack) {
		  	  	  if (!_callStack->currParam) {
					  sprintf(_errorMessage, "extra arguments passed to function %s",
						  _callStack->identifier);
				      typeError(_errorMessage);
				  } else if (_callStack->currParam->type != (yyvsp[(1) - (1)].integer)) {
					  if ((_callStack->currParam->type != INT_TYPE
					          && _callStack->currParam->type != CHAR_TYPE)
						      || ((yyvsp[(1) - (1)].integer) != INT_TYPE && (yyvsp[(1) - (1)].integer) != CHAR_TYPE))
			  	          typeError("type mismatch in arguments to function");
				  }
			  }
		  	  
		      if (_callStack->currParam)
			      _callStack->currParam = _callStack->currParam->next;
			}
    break;

  case 84:
#line 761 "parser.yacc"
    { (yyval.integer) = (yyvsp[(1) - (1)].integer); }
    break;

  case 85:
#line 762 "parser.yacc"
    { (yyval.integer) = BOOLEAN; }
    break;


/* Line 1267 of yacc.c.  */
#line 2392 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 769 "parser.yacc"


main() {
	pushSymbolTable();						// initialize global symbol table
	yyparse();
	popSymbolTable();
	return 0;
}

/* Function: typeError
 * Parameters: char *message
 * Description: Prints error message and turns code generation off.
 * Returns: void
 * Preconditions: none
 */
void typeError(char *message) {
	fprintf(stderr, "TYPE ERROR: line %d: %s\n", yylineno, message);
	// TODO turn code generation off
}


FunctionCall *pushFunctionCall(Symbol *function) {
	FunctionCall *toInsert = NULL;
	
	if (!(toInsert = malloc(sizeof(FunctionCall))))
		ERROR("", __LINE__, TRUE);					// out of memory
	
	toInsert->identifier = function->identifier;
	toInsert->currParam = function->parameterListHead;
	
	toInsert->below = _callStack;
	_callStack = toInsert;
	
	return toInsert;
}

void popFunctionCall() {
	if (!_callStack)
		ERROR("PopFunctionCall called on empty stack.", __LINE__, FALSE);
	
	FunctionCall *newTop = _callStack->below;
	
	free(_callStack);
	
	_callStack = newTop;
}

yyerror(char* errorMessage) {
	fprintf(stderr, "SYNTAX ERROR: line %d: Near token (%s)\n", yylineno, yytext);
}

yywrap() {
	return 1;
}

