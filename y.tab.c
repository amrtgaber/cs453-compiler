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

#include "utilities.h"
#include "symbolTable.h"
#include "syntaxTree.h"
#include "code.h"
#include "functionCall.h"

/************************
 *						*
 * 		prototypes		*
 *						*
 ************************/

void 	typeError(char *errorMessage),
		generateNewTempID(),
		generateNewLabelID(),
		declareGlobalVariables(SyntaxTree *tree);

/************************
 *						*
 *	global variables	*
 *						*
 ************************/

extern int yylineno;
extern char *yytext;
extern FunctionCall	*_callStack;
char	*_currID = NULL,
		*_currFID = NULL,
		_returnedValue = FALSE,
		_generateCode = TRUE,
		_errorMessage[255],
		_tempID[15],				// up to 10 billion temps > unsigned int max
		_labelID[16];				// up to 10 billion labels > unsigned int max
unsigned int	_tempNum = 0,
				_labelNum = 0;
Type	_currType = UNKNOWN,
		_currPType = UNKNOWN;
FunctionType _currFType = F_UNKNOWN;
Parameter *_currParam = NULL;


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
#line 51 "parser.yacc"
{
	char character;
	int integer;
	char *string;
	SyntaxTree *tree;
	struct exprReturn {
		Type type;
		SyntaxTree *tree;
	} exprReturn;
}
/* Line 193 of yacc.c.  */
#line 195 "y.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 208 "y.tab.c"

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
#define YYNNTS  33
/* YYNRULES -- Number of rules.  */
#define YYNRULES  89
/* YYNRULES -- Number of states.  */
#define YYNSTATES  193

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
      83,    84,    86,    91,    93,    95,    96,    99,   103,   105,
     107,   110,   115,   119,   120,   121,   132,   143,   149,   154,
     155,   161,   169,   175,   185,   189,   192,   195,   200,   201,
     209,   213,   215,   218,   221,   222,   224,   225,   229,   236,
     238,   239,   242,   245,   249,   253,   257,   261,   265,   269,
     273,   277,   281,   285,   289,   293,   294,   298,   302,   304,
     306,   308,   311,   312,   318,   319,   324,   325,   327,   331
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      41,     0,    -1,    41,    42,    31,    -1,    41,    58,    -1,
      41,    42,     1,    -1,     1,    31,    -1,    -1,    51,    50,
      49,    -1,    45,    51,    43,    32,    57,    53,    33,    48,
      47,    -1,    51,    43,    32,    57,    53,    33,    48,    47,
      -1,    45,    46,    43,    32,    57,    53,    33,    48,    47,
      -1,    46,    43,    32,    57,    53,    33,    48,    47,    -1,
       3,    -1,     3,    -1,    15,    -1,     9,    -1,    -1,    48,
      34,    47,    43,    32,    57,    53,    33,    -1,    -1,    49,
      34,    50,    -1,    -1,     3,    -1,     3,    35,     4,    36,
      -1,     7,    -1,     8,    -1,    -1,    52,     9,    -1,    52,
      55,    56,    -1,     7,    -1,     8,    -1,    54,     3,    -1,
      54,     3,    35,    36,    -1,    56,    34,    55,    -1,    -1,
      -1,    51,    43,    32,    57,    53,    33,    37,    59,    62,
      38,    -1,    46,    43,    32,    57,    53,    33,    37,    59,
      62,    38,    -1,    59,    51,    50,    49,    31,    -1,    59,
      51,     1,    31,    -1,    -1,    10,    32,    66,    33,    60,
      -1,    10,    32,    66,    33,    60,    11,    60,    -1,    12,
      32,    66,    33,    60,    -1,    13,    32,    65,    31,    63,
      31,    65,    33,    60,    -1,    14,    66,    31,    -1,    14,
      31,    -1,    64,    31,    -1,    44,    32,    33,    31,    -1,
      -1,    44,    32,    61,    71,    72,    33,    31,    -1,    37,
      62,    38,    -1,    31,    -1,     1,    31,    -1,    62,    60,
      -1,    -1,    66,    -1,    -1,    44,    39,    66,    -1,    44,
      35,    66,    36,    39,    66,    -1,    64,    -1,    -1,    27,
      66,    -1,    30,    66,    -1,    66,    26,    66,    -1,    66,
      27,    66,    -1,    66,    28,    66,    -1,    66,    29,    66,
      -1,    66,    17,    66,    -1,    66,    18,    66,    -1,    66,
      19,    66,    -1,    66,    24,    66,    -1,    66,    20,    66,
      -1,    66,    25,    66,    -1,    66,    21,    66,    -1,    66,
      22,    66,    -1,    -1,     3,    67,    68,    -1,    32,    66,
      33,    -1,     4,    -1,     5,    -1,     6,    -1,    32,    33,
      -1,    -1,    32,    69,    71,    72,    33,    -1,    -1,    35,
      70,    66,    36,    -1,    -1,    66,    -1,    72,    34,    71,
      -1,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    84,    84,    85,    88,    89,    91,    94,    98,   100,
     101,   103,   106,   111,   117,   122,   127,   145,   146,   149,
     150,   153,   168,   195,   199,   205,   213,   228,   238,   242,
     248,   281,   322,   323,   326,   356,   377,   391,   394,   396,
     399,   404,   409,   414,   419,   440,   454,   455,   486,   485,
     520,   521,   524,   527,   533,   536,   537,   540,   568,   597,
     598,   601,   608,   615,   623,   631,   639,   647,   655,   663,
     671,   679,   687,   695,   702,   710,   709,   725,   726,   735,
     744,   755,   777,   776,   807,   806,   842,   859,   888,   889
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
  "paramTypes", "storePType", "arrayTypeOpt", "multiParam", "insertFunc",
  "function", "multiTypeDcl", "statement", "@1", "statementOpt", "exprOpt",
  "assignment", "assgOpt", "expr", "@2", "multiFuncOpt", "@3", "@4",
  "args", "multiExprOpt", 0
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
      55,    55,    56,    56,    57,    58,    58,    59,    59,    59,
      60,    60,    60,    60,    60,    60,    60,    60,    61,    60,
      60,    60,    60,    62,    62,    63,    63,    64,    64,    65,
      65,    66,    66,    66,    66,    66,    66,    66,    66,    66,
      66,    66,    66,    66,    66,    67,    66,    66,    66,    66,
      66,    68,    69,    68,    70,    68,    68,    71,    72,    72
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     3,     2,     3,     2,     0,     3,     9,     8,
       9,     8,     1,     1,     1,     1,     0,     8,     0,     3,
       0,     1,     4,     1,     1,     0,     2,     3,     1,     1,
       2,     4,     3,     0,     0,    10,    10,     5,     4,     0,
       5,     7,     5,     9,     3,     2,     2,     4,     0,     7,
       3,     1,     2,     2,     0,     1,     0,     3,     6,     1,
       0,     2,     2,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     0,     3,     3,     1,     1,
       1,     2,     0,     5,     0,     4,     0,     1,     3,     0
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     5,     1,    23,    24,    15,    14,     0,
       0,     0,     0,     3,     4,     2,     0,     0,    12,     0,
      21,     0,    20,     0,     0,    34,     0,    34,     7,    34,
      34,    25,     0,    25,     0,    25,    25,     0,     0,    22,
       0,    21,    19,     0,     0,    28,    29,    26,     0,    33,
      18,    18,    18,    18,    30,    27,    39,    16,    39,    16,
      16,    16,     0,     0,    54,    16,    11,    54,     9,    10,
       8,    31,    32,     0,     0,     0,     0,     0,    20,     0,
      13,     0,     0,     0,     0,    51,    54,    36,     0,    53,
       0,     0,    35,    38,     0,    52,     0,     0,    60,    75,
      78,    79,    80,     0,     0,    45,     0,     0,     0,    48,
       0,     0,    46,    34,    37,     0,     0,     0,    59,     0,
      86,    61,    62,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    44,    50,     0,     0,
       0,    57,    25,     0,     0,    56,    82,    84,    76,    77,
      67,    68,    69,    71,    73,    74,    70,    72,    63,    64,
      65,    66,    47,    87,    89,     0,     0,    40,    42,     0,
      55,    81,     0,     0,     0,     0,    17,     0,    60,    89,
       0,     0,     0,    58,    41,     0,     0,    85,    49,    88,
       0,    83,    43
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     9,    19,    88,    10,    11,    66,    57,    28,
      22,    73,    37,    38,    48,    49,    55,    31,    13,    64,
      89,   139,    74,   169,    90,   119,   163,   120,   148,   172,
     173,   164,   174
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -161
static const yytype_int16 yypact[] =
{
     237,   -12,    73,  -161,  -161,  -161,  -161,  -161,  -161,     8,
      46,    35,    62,  -161,  -161,  -161,    35,    35,  -161,    40,
      64,    47,  -161,    51,    53,  -161,    63,  -161,    55,  -161,
    -161,  -161,    66,  -161,    97,  -161,  -161,   135,    77,  -161,
      84,    95,  -161,   105,   124,  -161,  -161,  -161,   116,  -161,
     119,   125,  -161,  -161,   178,   136,  -161,   186,  -161,   186,
     186,   186,   185,    24,   138,  -161,  -161,   138,  -161,  -161,
    -161,  -161,  -161,    60,    56,    35,    94,   191,  -161,   199,
    -161,   209,   210,   211,   123,  -161,  -161,  -161,    -2,  -161,
     208,   215,  -161,  -161,    67,  -161,   131,   131,   245,  -161,
    -161,  -161,  -161,   131,   131,  -161,   131,   236,   102,   216,
     131,   131,  -161,  -161,  -161,   173,   190,    25,  -161,   219,
      86,  -161,  -161,   207,   131,   131,   131,   131,   131,   131,
     131,   131,   131,   131,   131,   131,  -161,  -161,   220,   131,
     147,   251,  -161,   110,   110,   131,   226,  -161,  -161,  -161,
     288,   288,    49,    49,   277,   264,    49,    49,   120,   120,
    -161,  -161,  -161,   251,  -161,   227,   241,   275,  -161,   256,
     251,  -161,   131,   131,   118,   131,  -161,   110,   245,  -161,
     160,   267,   131,   251,  -161,   266,   126,  -161,  -161,  -161,
     110,  -161,  -161
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -161,  -161,  -161,    -1,   -94,  -161,   290,   -25,   152,   231,
     -17,    16,  -161,   -33,  -161,   247,  -161,   -22,  -161,   253,
    -119,  -161,   -57,  -161,   -92,   140,   -83,  -161,  -161,  -161,
    -161,  -160,   141
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -13
static const yytype_int16 yytable[] =
{
      40,   107,    43,    44,   117,    33,   118,    35,    36,    14,
      76,    21,   179,   115,   116,    23,    24,    42,    12,     3,
     121,   122,   189,   123,   167,   168,    17,   140,   141,   108,
     109,    45,    46,   110,    68,    69,    70,   111,    18,    15,
      75,   150,   151,   152,   153,   154,   155,   156,   157,   158,
     159,   160,   161,     5,     6,     7,    78,    79,   184,    80,
     110,    77,   170,    41,   111,    20,    81,    32,    82,    83,
      84,   192,    25,     4,    91,   132,   133,   134,   135,    27,
       5,     6,     7,    29,   117,    30,   118,    85,     8,    34,
     180,   142,   183,    86,    87,    79,   -12,    80,   114,    26,
      41,    34,    39,    79,    81,    80,    82,    83,    84,   166,
      50,    79,    81,    80,    82,    83,    84,    51,   146,    54,
      81,   147,    82,    83,    84,    85,    99,   100,   101,   102,
      26,    86,    92,    85,    99,   100,   101,   102,    52,    86,
     137,    85,    45,    46,    47,     5,     6,    86,   134,   135,
     103,   181,   182,   104,   105,   106,    56,    53,   103,   191,
     182,   104,    58,   106,   124,   125,   126,   127,   128,   129,
      63,   130,   131,   132,   133,   134,   135,   124,   125,   126,
     127,   128,   129,   165,   130,   131,   132,   133,   134,   135,
     124,   125,   126,   127,   128,   129,   187,   130,   131,   132,
     133,   134,   135,    59,    60,    61,   143,   124,   125,   126,
     127,   128,   129,    62,   130,   131,   132,   133,   134,   135,
      65,    71,    93,   144,   124,   125,   126,   127,   128,   129,
      95,   130,   131,   132,   133,   134,   135,    -6,     1,   112,
     149,    96,    97,    98,    -6,    -6,    -6,   113,    80,   138,
     145,   162,    -6,   124,   125,   126,   127,   128,   129,   171,
     130,   131,   132,   133,   134,   135,   175,   136,   124,   125,
     126,   127,   128,   129,   176,   130,   131,   132,   133,   134,
     135,   124,   125,   126,   127,   128,   177,   178,   130,   131,
     132,   133,   134,   135,   124,   125,   126,   127,   188,   190,
      16,   130,   131,   132,   133,   134,   135,   126,   127,    94,
      72,    67,   130,   131,   132,   133,   134,   135,   185,     0,
     186
};

static const yytype_int16 yycheck[] =
{
      33,    84,    35,    36,    98,    27,    98,    29,    30,     1,
      67,    12,   172,    96,    97,    16,    17,    34,     2,    31,
     103,   104,   182,   106,   143,   144,    10,   110,   111,    86,
      32,     7,     8,    35,    59,    60,    61,    39,     3,    31,
      65,   124,   125,   126,   127,   128,   129,   130,   131,   132,
     133,   134,   135,     7,     8,     9,    73,     1,   177,     3,
      35,     1,   145,     3,    39,     3,    10,     4,    12,    13,
      14,   190,    32,     0,    75,    26,    27,    28,    29,    32,
       7,     8,     9,    32,   178,    32,   178,    31,    15,    34,
     173,   113,   175,    37,    38,     1,    32,     3,    31,    35,
       3,    34,    36,     1,    10,     3,    12,    13,    14,   142,
      33,     1,    10,     3,    12,    13,    14,    33,    32,     3,
      10,    35,    12,    13,    14,    31,     3,     4,     5,     6,
      35,    37,    38,    31,     3,     4,     5,     6,    33,    37,
      38,    31,     7,     8,     9,     7,     8,    37,    28,    29,
      27,    33,    34,    30,    31,    32,    37,    33,    27,    33,
      34,    30,    37,    32,    17,    18,    19,    20,    21,    22,
      34,    24,    25,    26,    27,    28,    29,    17,    18,    19,
      20,    21,    22,    36,    24,    25,    26,    27,    28,    29,
      17,    18,    19,    20,    21,    22,    36,    24,    25,    26,
      27,    28,    29,    51,    52,    53,    33,    17,    18,    19,
      20,    21,    22,    35,    24,    25,    26,    27,    28,    29,
      34,    36,    31,    33,    17,    18,    19,    20,    21,    22,
      31,    24,    25,    26,    27,    28,    29,     0,     1,    31,
      33,    32,    32,    32,     7,     8,     9,    32,     3,    33,
      31,    31,    15,    17,    18,    19,    20,    21,    22,    33,
      24,    25,    26,    27,    28,    29,    39,    31,    17,    18,
      19,    20,    21,    22,    33,    24,    25,    26,    27,    28,
      29,    17,    18,    19,    20,    21,    11,    31,    24,    25,
      26,    27,    28,    29,    17,    18,    19,    20,    31,    33,
      10,    24,    25,    26,    27,    28,    29,    19,    20,    78,
      63,    58,    24,    25,    26,    27,    28,    29,   178,    -1,
     179
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     1,    41,    31,     0,     7,     8,     9,    15,    42,
      45,    46,    51,    58,     1,    31,    46,    51,     3,    43,
       3,    43,    50,    43,    43,    32,    35,    32,    49,    32,
      32,    57,     4,    57,    34,    57,    57,    52,    53,    36,
      53,     3,    50,    53,    53,     7,     8,     9,    54,    55,
      33,    33,    33,    33,     3,    56,    37,    48,    37,    48,
      48,    48,    35,    34,    59,    34,    47,    59,    47,    47,
      47,    36,    55,    51,    62,    47,    62,     1,    50,     1,
       3,    10,    12,    13,    14,    31,    37,    38,    44,    60,
      64,    43,    38,    31,    49,    31,    32,    32,    32,     3,
       4,     5,     6,    27,    30,    31,    32,    66,    62,    32,
      35,    39,    31,    32,    31,    66,    66,    44,    64,    65,
      67,    66,    66,    66,    17,    18,    19,    20,    21,    22,
      24,    25,    26,    27,    28,    29,    31,    38,    33,    61,
      66,    66,    57,    33,    33,    31,    32,    35,    68,    33,
      66,    66,    66,    66,    66,    66,    66,    66,    66,    66,
      66,    66,    31,    66,    71,    36,    53,    60,    60,    63,
      66,    33,    69,    70,    72,    39,    33,    11,    31,    71,
      66,    33,    34,    66,    60,    65,    72,    36,    31,    71,
      33,    33,    60
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
#line 88 "parser.yacc"
    { yyerrok; }
    break;

  case 5:
#line 89 "parser.yacc"
    { yyerrok; }
    break;

  case 7:
#line 95 "parser.yacc"
    {
			  declareGlobalVariables(createTree(DECLARATION, NULL, (yyvsp[(2) - (3)].tree), (yyvsp[(3) - (3)].tree)));
			}
    break;

  case 12:
#line 107 "parser.yacc"
    {
			  _currFID = (yyvsp[(1) - (1)].string);
			}
    break;

  case 13:
#line 112 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (1)].string);
			  (yyval.string) = (yyvsp[(1) - (1)].string);
			}
    break;

  case 14:
#line 118 "parser.yacc"
    {
			  _currFType = EXTERN_TYPE;
			}
    break;

  case 15:
#line 123 "parser.yacc"
    {
			  _currType = VOID_TYPE;
			}
    break;

  case 16:
#line 127 "parser.yacc"
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

  case 19:
#line 149 "parser.yacc"
    { (yyval.tree) = createTree(DECLARATION, NULL, (yyvsp[(3) - (3)].tree), (yyvsp[(1) - (3)].tree)); }
    break;

  case 20:
#line 150 "parser.yacc"
    { (yyval.tree) = NULL; }
    break;

  case 21:
#line 154 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (1)].string);
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
				  (yyval.tree) = NULL;
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
				  currSymbol->functionType = NON_FUNCTION;
				  (yyval.tree) = createTree(SYMBOL, currSymbol, NULL, NULL);
			  }
			}
    break;

  case 22:
#line 169 "parser.yacc"
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
				  (yyval.tree) = NULL;
			  } else {
			  	  Symbol *currSymbol = insert(_currID, _currType);
			      currSymbol->functionType = NON_FUNCTION;
				  (yyval.tree) = createTree(SYMBOL, currSymbol, NULL, NULL);
			  }
			
			  if (_currType == CHAR_ARRAY)
				  _currType = CHAR_TYPE;
			  else
			      _currType = INT_TYPE;
			}
    break;

  case 23:
#line 196 "parser.yacc"
    {
			  _currType = CHAR_TYPE;
			}
    break;

  case 24:
#line 200 "parser.yacc"
    {
			  _currType = INT_TYPE;
			}
    break;

  case 25:
#line 205 "parser.yacc"
    { 
			  Symbol *currSymbol = recallGlobal(_currFID);
			  
			  if (currSymbol)
				  _currParam = currSymbol->parameterListHead;
				
			}
    break;

  case 26:
#line 214 "parser.yacc"
    {
			  Symbol *currentFunction = recallGlobal(_currFID);
			
		      if (_currParam) {
		 		  if (_currParam->type != VOID_TYPE)
				  	  typeError("Type mismatch: non-VOID parameter(s) expected");
			  } else {
				  addParameter(NULL, VOID_TYPE, currentFunction);
			  }

			  _currParam = NULL;
			  
			  (yyval.tree) = NULL;
			}
    break;

  case 27:
#line 229 "parser.yacc"
    {
			  if (_currParam)
				  typeError("Type mismatch: missing previously declared types");
			  
			  _currParam = NULL;
			
			  (yyval.tree) = (yyvsp[(2) - (3)].tree);
			}
    break;

  case 28:
#line 239 "parser.yacc"
    {
				_currPType = CHAR_TYPE;
			}
    break;

  case 29:
#line 243 "parser.yacc"
    {
				_currPType = INT_TYPE;
			}
    break;

  case 30:
#line 249 "parser.yacc"
    {
			  _currID = (yyvsp[(2) - (2)].string);
			
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			    if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
				  (yyval.tree) = NULL;
			    } else {
			  	  	if (_currParam) {
					  	if (_currParam->type != _currPType) {
							sprintf(_errorMessage, "%s does not match previous declaration",
								typeAsString(_currPType));
							typeError(_errorMessage);
							(yyval.tree) = NULL;
						} else {
							Symbol *currSymbol = insert(_currID, _currPType);
						    currSymbol->functionType = NON_FUNCTION;
							(yyval.tree) = createTree(SYMBOL, currSymbol, NULL, NULL);
						}
			  	 	} else {
				  		Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					    currSymbol->functionType = NON_FUNCTION;
						(yyval.tree) = createTree(SYMBOL, currSymbol, NULL, NULL);
			  		}
				}
				
			  if (_currParam)
			  	  _currParam = _currParam->next;
			}
    break;

  case 31:
#line 282 "parser.yacc"
    {
			  _currID = (yyvsp[(2) - (4)].string);
			  Symbol *currentFunction = recallGlobal(_currFID);
			
			  if (_currPType == CHAR_TYPE)
				  _currPType = CHAR_ARRAY;
			  else
			      _currPType = INT_ARRAY;
			
			  if (recallLocal(_currID)) {
				  sprintf(_errorMessage, "%s previously declared in this function",
					  _currID);
			      typeError(_errorMessage);
				  (yyval.tree) = NULL;
			  } else {
			  	  if (_currParam) {
					  if (_currParam->type != _currPType) {
						  if (_currPType == CHAR_ARRAY)
							  typeError("CHAR_ARRAY does not match previous declaration");
						  else
							  typeError("INT_ARRAY does not match previous declaration");
						  
						  (yyval.tree) = NULL;
					  } else {
						  Symbol *currSymbol = insert(_currID, _currPType);
						  currSymbol->functionType = NON_FUNCTION;
						  (yyval.tree) = createTree(SYMBOL, currSymbol, NULL, NULL);
					  }
			  	  } else {
				  	  Symbol *currSymbol = addParameter(_currID, _currPType, currentFunction);
					  currSymbol->functionType = NON_FUNCTION;
					  (yyval.tree) = createTree(SYMBOL, currSymbol, NULL, NULL);
			  	  }
			  }
			
			 if (_currParam)
			   _currParam = _currParam->next;
			}
    break;

  case 34:
#line 326 "parser.yacc"
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
			  }
			
			  pushSymbolTable();
			}
    break;

  case 35:
#line 358 "parser.yacc"
    { 
			  if (!_returnedValue) {
				  sprintf(_errorMessage, "function %s must have at least one return statement",
					  _currFID);
				  typeError(_errorMessage);
			  } else {
				  _returnedValue = FALSE;
			  }
			  
			  SyntaxTree *function = createTree(FUNCTION_ROOT, recallGlobal(_currFID), (yyvsp[(5) - (10)].tree), (yyvsp[(9) - (10)].tree));
			  //printf("\nSYNTAX TREE:\n\n");
			  //printSyntaxTree(function, 0);
			
			  #ifdef DEBUG
			  printSymbolTable();
			  #endif
					
			  popSymbolTable();
			}
    break;

  case 36:
#line 379 "parser.yacc"
    { 
			  SyntaxTree *function = createTree(FUNCTION_ROOT, recallGlobal(_currFID), (yyvsp[(5) - (10)].tree), (yyvsp[(9) - (10)].tree));
			  //printf("\nSYNTAX TREE:\n\n");
			  //printSyntaxTree(function, 0);
			
			  #ifdef DEBUG
			  printSymbolTable();
			  #endif

			  popSymbolTable(); }
    break;

  case 38:
#line 394 "parser.yacc"
    { yyerrok; }
    break;

  case 40:
#line 400 "parser.yacc"
    {
			  if ((yyvsp[(3) - (5)].exprReturn).type != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
    break;

  case 41:
#line 405 "parser.yacc"
    {
			  if ((yyvsp[(3) - (7)].exprReturn).type != BOOLEAN)
				  typeError("conditional in if statement must be a boolean");
			}
    break;

  case 42:
#line 410 "parser.yacc"
    {
			  if ((yyvsp[(3) - (5)].exprReturn).type != BOOLEAN)
				  typeError("conditional in while loop must be a boolean");
			}
    break;

  case 43:
#line 415 "parser.yacc"
    {
			  if ((yyvsp[(5) - (9)].integer) != BOOLEAN)
				  typeError("conditional in for loop must be a boolean");
			}
    break;

  case 44:
#line 420 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currFID);
			
			  if (!currSymbol) {
				  typeError("unexpected return statement");
			  } else {
				  if (currSymbol->type != (yyvsp[(2) - (3)].exprReturn).type) {
				      if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  || ((yyvsp[(2) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(2) - (3)].exprReturn).type != CHAR_TYPE)) {
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

  case 45:
#line 441 "parser.yacc"
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

  case 46:
#line 454 "parser.yacc"
    { (yyval.tree) = (yyvsp[(1) - (2)].tree); }
    break;

  case 47:
#line 456 "parser.yacc"
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
				  
				  (yyval.tree) = createTree(FUNCTION_CALL, currSymbol, NULL, NULL);
			  } else {
				  sprintf(_errorMessage, "%s undefined", _currID);
			      typeError(_errorMessage);
				  (yyval.tree) = NULL;
			  }
			
			}
    break;

  case 48:
#line 486 "parser.yacc"
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

  case 49:
#line 507 "parser.yacc"
    {
			  if (_callStack) {
			  	  if (_callStack->currParam) {
				  	  sprintf(_errorMessage, "more arguments expected for function %s",
					  	  _callStack->identifier);
				  	  typeError(_errorMessage);
			  	  }
				
				  (yyval.tree) = createTree(FUNCTION_CALL, recallGlobal(_callStack->identifier), (yyvsp[(4) - (7)].tree), NULL);
				
		      	  popFunctionCall();
		      }
			}
    break;

  case 50:
#line 520 "parser.yacc"
    { (yyval.tree) = (yyvsp[(2) - (3)].tree); }
    break;

  case 51:
#line 521 "parser.yacc"
    { (yyval.tree) = NULL; }
    break;

  case 52:
#line 524 "parser.yacc"
    { yyerrok; }
    break;

  case 53:
#line 528 "parser.yacc"
    {
			  if ((yyvsp[(2) - (2)].tree)) {
			  	  (yyval.tree) = createTree(STATEMENT, NULL, (yyvsp[(2) - (2)].tree), (yyvsp[(1) - (2)].tree));
			  }
			}
    break;

  case 54:
#line 533 "parser.yacc"
    { (yyval.tree) = NULL; }
    break;

  case 55:
#line 536 "parser.yacc"
    { (yyval.integer) = (yyvsp[(1) - (1)].exprReturn).type; }
    break;

  case 56:
#line 537 "parser.yacc"
    { (yyval.integer) = BOOLEAN; }
    break;

  case 57:
#line 541 "parser.yacc"
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
				  if (currSymbol->type != (yyvsp[(3) - (3)].exprReturn).type) {
					  if ((currSymbol->type != INT_TYPE && currSymbol->type != CHAR_TYPE)
						  && ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE)) {
						sprintf(_errorMessage, "incompatible types for assignment of %s",
							_currID);
						typeError(_errorMessage);
					  }
				  }
			  }
			
			  SyntaxTree *leftHandSide = createTree(SYMBOL, currSymbol, NULL, NULL);
			  (yyval.tree) = createTree(ASSIGNMENT, NULL, leftHandSide, (yyvsp[(3) - (3)].exprReturn).tree);
			}
    break;

  case 58:
#line 569 "parser.yacc"
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
				  
				  if ((yyvsp[(3) - (6)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (6)].exprReturn).type != CHAR_TYPE) {
					  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
						  _currID);
					  typeError(_errorMessage);
				  }
				  
				  if ((yyvsp[(6) - (6)].exprReturn).type != INT_TYPE && (yyvsp[(6) - (6)].exprReturn).type != CHAR_TYPE)  {
					    sprintf(_errorMessage, "incompatible types for assignment of %s",
							_currID);
						typeError(_errorMessage);
				  }
			  }
			}
    break;

  case 61:
#line 602 "parser.yacc"
    {
			  if ((yyvsp[(2) - (2)].exprReturn).type != INT_TYPE && (yyvsp[(2) - (2)].exprReturn).type != CHAR_TYPE)
				  typeError("incompatible expression for operator '-'");
			
			  (yyval.exprReturn).type = (yyvsp[(2) - (2)].exprReturn).type;
			}
    break;

  case 62:
#line 609 "parser.yacc"
    {
			  if ((yyvsp[(2) - (2)].exprReturn).type != BOOLEAN)
				  typeError("incompatible expression for operator '!'");
			
			  (yyval.exprReturn).type = (yyvsp[(2) - (2)].exprReturn).type;
			}
    break;

  case 63:
#line 616 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE)
				  || ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '+'");
			
			  (yyval.exprReturn).type = (yyvsp[(1) - (3)].exprReturn).type;
			}
    break;

  case 64:
#line 624 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE)
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '-'");
			
			  (yyval.exprReturn).type = (yyvsp[(1) - (3)].exprReturn).type;
			}
    break;

  case 65:
#line 632 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '*'");
			
			  (yyval.exprReturn).type = (yyvsp[(1) - (3)].exprReturn).type;
			}
    break;

  case 66:
#line 640 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '/'");
			
			  (yyval.exprReturn).type = (yyvsp[(1) - (3)].exprReturn).type;
			}
    break;

  case 67:
#line 648 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '=='");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 68:
#line 656 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '!='");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 69:
#line 664 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '<='");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 70:
#line 672 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '<'");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 71:
#line 680 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '>='");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 72:
#line 688 "parser.yacc"
    {
			  if (((yyvsp[(1) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (3)].exprReturn).type != CHAR_TYPE) 
					|| ((yyvsp[(3) - (3)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (3)].exprReturn).type != CHAR_TYPE))
				  typeError("incompatible expression for operator '>'");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 73:
#line 696 "parser.yacc"
    {
			  if ((yyvsp[(1) - (3)].exprReturn).type != BOOLEAN || (yyvsp[(3) - (3)].exprReturn).type != BOOLEAN)
				  typeError("incompatible expression for operator '&&'");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 74:
#line 703 "parser.yacc"
    {
			  if ((yyvsp[(1) - (3)].exprReturn).type != BOOLEAN || (yyvsp[(3) - (3)].exprReturn).type != BOOLEAN)
				  typeError("incompatible expression for operator '||'");
			
			  (yyval.exprReturn).type = BOOLEAN;
			}
    break;

  case 75:
#line 710 "parser.yacc"
    {
			  _currID = (yyvsp[(1) - (1)].string);
			  Symbol *currSymbol = recall(_currID);
			  
			  if (!currSymbol) {
				  sprintf(_errorMessage, "%s undefined", _currID);
				  typeError(_errorMessage);
			  }
				
			}
    break;

  case 76:
#line 721 "parser.yacc"
    {
				(yyval.exprReturn).type = (yyvsp[(3) - (3)].exprReturn).type;
				(yyval.exprReturn).tree = (yyvsp[(3) - (3)].exprReturn).tree;
			}
    break;

  case 77:
#line 725 "parser.yacc"
    { (yyval.exprReturn).type = (yyvsp[(2) - (3)].exprReturn).type; }
    break;

  case 78:
#line 727 "parser.yacc"
    {
			  (yyval.exprReturn).type = INT_TYPE;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, INT_TYPE);
			  newSymbol->value.intVal = (yyvsp[(1) - (1)].integer);
			  newSymbol->functionType = NON_FUNCTION;
			  (yyval.exprReturn).tree = createTree(SYMBOL, newSymbol, NULL, NULL);
			}
    break;

  case 79:
#line 736 "parser.yacc"
    {
			  (yyval.exprReturn).type = CHAR_TYPE;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, CHAR_TYPE);
			  newSymbol->value.charVal = (yyvsp[(1) - (1)].character);
			  newSymbol->functionType = NON_FUNCTION;
			  (yyval.exprReturn).tree = createTree(SYMBOL, newSymbol, NULL, NULL);
			}
    break;

  case 80:
#line 745 "parser.yacc"
    {
			  (yyval.exprReturn).type = CHAR_ARRAY;
			  generateNewTempID();
			  Symbol *newSymbol = insert(_tempID, CHAR_ARRAY);
			  newSymbol->value.string = (yyvsp[(1) - (1)].string);
			  newSymbol->functionType = NON_FUNCTION;
			  (yyval.exprReturn).tree = createTree(SYMBOL, newSymbol, NULL, NULL);
			}
    break;

  case 81:
#line 756 "parser.yacc"
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
				  (yyval.exprReturn).type = currSymbol->type;
			  } else {
				  (yyval.exprReturn).type = UNKNOWN;
			  }
			}
    break;

  case 82:
#line 777 "parser.yacc"
    {
			  Symbol *currSymbol = recallGlobal(_currID);

			  if (currSymbol) {
			      if (currSymbol->functionType == NON_FUNCTION) {
				      sprintf(_errorMessage, "%s is not a function", _currID);
			          typeError(_errorMessage);
				  } else if (currSymbol->type == VOID_TYPE) {
				  	  sprintf(_errorMessage, "void function %s in expression", _currID);
					  typeError(_errorMessage);
				  }
				  pushFunctionCall(currSymbol);
			  }
			}
    break;

  case 83:
#line 792 "parser.yacc"
    { 
			  if (_callStack) {
			  	  if (_callStack->currParam) {
				  	  sprintf(_errorMessage, "more arguments expected for function %s",
					  	  _callStack->identifier);
				  	  typeError(_errorMessage);
			  	  }
			  	  (yyval.exprReturn).type = (recallGlobal(_callStack->identifier))->type;
			      popFunctionCall();
			  } else {
			      (yyval.exprReturn).type = UNKNOWN;
			  }
			  
			}
    break;

  case 84:
#line 807 "parser.yacc"
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

  case 85:
#line 821 "parser.yacc"
    {
			  if ((yyvsp[(3) - (4)].exprReturn).type != INT_TYPE && (yyvsp[(3) - (4)].exprReturn).type != CHAR_TYPE) {
				  sprintf(_errorMessage, "ARRAY index for %s must be INT or CHAR",
					  _currID);
			  	  typeError(_errorMessage);
			  }
			
			  if (!_callStack) {
				  (yyval.exprReturn).type = UNKNOWN;
			  } else {
				  (yyval.exprReturn).type = (recall(_callStack->identifier))->type;
					
				  if ((yyval.exprReturn).type == CHAR_ARRAY)
					  (yyval.exprReturn).type = CHAR_TYPE;
				  else
					  (yyval.exprReturn).type = INT_TYPE;
				
				  popFunctionCall();
			  }
			}
    break;

  case 86:
#line 842 "parser.yacc"
    {
			  Symbol *currSymbol = recall(_currID);
				
			  if (currSymbol) {
				  if (currSymbol->functionType != NON_FUNCTION) {
					  sprintf(_errorMessage, "expected arguments for function %s",
						  _currID);
					  typeError(_errorMessage);
				  }
				  (yyval.exprReturn).type = currSymbol->type;
				  (yyval.exprReturn).tree = createTree(SYMBOL, currSymbol, NULL, NULL);
			  } else {
				  (yyval.exprReturn).type = UNKNOWN;
			  }
			}
    break;

  case 87:
#line 860 "parser.yacc"
    {
			  if (_callStack) {
		  	  	  if (!_callStack->currParam) {
					  sprintf(_errorMessage, "extra arguments passed to function %s",
						  _callStack->identifier);
				      typeError(_errorMessage);
					  (yyval.tree) = NULL;
				  } else if (_callStack->currParam->type != (yyvsp[(1) - (1)].exprReturn).type) {
					  if ((_callStack->currParam->type != INT_TYPE
					          && _callStack->currParam->type != CHAR_TYPE)
						      || ((yyvsp[(1) - (1)].exprReturn).type != INT_TYPE && (yyvsp[(1) - (1)].exprReturn).type != CHAR_TYPE)) {
			  	          typeError("type mismatch in arguments to function");
						  (yyval.tree) = NULL;
					  } else {
						  (yyval.tree) = (yyvsp[(1) - (1)].exprReturn).tree;
					  }
				  } else {
					  (yyval.tree) = (yyvsp[(1) - (1)].exprReturn).tree;
				  }
			  } else {
				  (yyval.tree) = NULL;
			  }
		  	  
		      if (_callStack->currParam)
			      _callStack->currParam = _callStack->currParam->next;
			}
    break;


/* Line 1267 of yacc.c.  */
#line 2551 "y.tab.c"
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


#line 892 "parser.yacc"


/* Function: main
 * Parameters: none
 * Description: Program execution begins here.
 * Returns: 0 for success, 1 if errors were found (syntactic or semantic).
 * Preconditions: none
 */
main() {
	pushSymbolTable();				// initialize global symbol table
	yyparse();
	popSymbolTable();				// free global symbol table
	
	if (_generateCode)
		return 0;					// success
	return 1;						// failure
}

/* Function: yyError
 * Parameters: char *errorMessage
 * Description: Called when syntax errors are found. Prints error message and
 *					turns code generation off.
 * Returns: void
 * Preconditions: none
 */
yyerror(char* errorMessage) {
	fprintf(stderr, "SYNTAX ERROR: line %d: Near token (%s)\n", yylineno, yytext);
	_generateCode = FALSE;
}

yywrap() {
	return 1;
}

void declareGlobalVariables(SyntaxTree *tree) {
	
}

/* Function: typeError
 * Parameters: char *errorMessage
 * Description: Called when semantic errors are found. Prints error message and
 *					turns code generation off.
 * Returns: void
 * Preconditions: none
 */
void typeError(char *errorMessage) {
	fprintf(stderr, "TYPE ERROR: line %d: %s\n", yylineno, errorMessage);
	_generateCode = FALSE;
}

/* Function: generateNewTempID
 * Parameters: none
 * Description: Updates to a new unique temporary variable ID.
 * Returns: none
 * Preconditions: none
 */
void generateNewTempID() {
	sprintf(_tempID, "_temp%d", _tempNum++);
}

/* Function: generateNewLabelID
 * Parameters: none
 * Description: Updates to a new unique label ID.
 * Returns: none
 * Preconditions: none
 */
void generateNewLabelID() {
	sprintf(_labelID, "_label%d", _labelNum++);
}

