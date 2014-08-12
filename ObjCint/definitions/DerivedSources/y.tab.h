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
     TCOLON = 258,
     TSEMI_COLON = 259,
     TIDENTIFIER = 260,
     TQUOTE = 261,
     TOP_ASSIGN = 262,
     TOP_EQUAL = 263,
     TOP_LT = 264,
     TOP_GT = 265,
     TOP_NOT = 266,
     TOP_IF = 267,
     TOCB = 268,
     TCCB = 269,
     TOSB = 270,
     TCSB = 271,
     TTP_BOOLEAN = 272,
     TTP_NUMBER = 273,
     TTP_STRING = 274,
     TTP_OBJECT = 275,
     TSTRING = 276,
     TNUM = 277
   };
#endif
/* Tokens.  */
#define TCOLON 258
#define TSEMI_COLON 259
#define TIDENTIFIER 260
#define TQUOTE 261
#define TOP_ASSIGN 262
#define TOP_EQUAL 263
#define TOP_LT 264
#define TOP_GT 265
#define TOP_NOT 266
#define TOP_IF 267
#define TOCB 268
#define TCCB 269
#define TOSB 270
#define TCSB 271
#define TTP_BOOLEAN 272
#define TTP_NUMBER 273
#define TTP_STRING 274
#define TTP_OBJECT 275
#define TSTRING 276
#define TNUM 277




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 24 "/Volumes/Development/code/incubator/TR064/TR064int/TR064int/definitions/parser.ym"
{

	TBBlock				*block;
    TBNode              *node;
	TBMethodSignature	*method_signatur;
    TBAssignment        *assignment;
    TBDeclaration       *declaration;
    TBSendMessage       *send_message;

	NSMutableArray		*parameters;
	NSString			*string;
	NSNumber			*number;
    TBValue             *value;

    NSString            *type;

	
	int					token;
}
/* Line 1529 of yacc.c.  */
#line 113 "/Volumes/Development/code/incubator/TR064/TR064int/build/debug/TR064int.build/Debug/TR064int.build/DerivedSources/y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

