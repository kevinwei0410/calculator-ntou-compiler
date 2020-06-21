%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "yacc.tab.h"
#include "mem.h"

extern int yyerror(const char *s);
%}

%option noyywrap

digit [0-9]
digits {digit}+
number {digits}(\.{digits})?([Ee][+-]?{digits})?

%%
[ \t]
{number}                          {
    yylval.num = atof(yytext);
    return NUMBER;
}
"+"                               { return ADD; }
"-"                               { return SUB; }
"*"                               { return MUL; }
"/"                               { return DIV; }
"%"                               { return MOD; }
"^"                               { return POW; }
"="                               { return EQUALS; }
"("                               { return L_BRACKET; }
")"                               { return R_BRACKET; }
"!"                               { return FACTORIAL; }
"pi"                              { return PI; }
"e"                               { return E; }
"mod"                             { return MOD; }
"pow"                             { return POW; }
"floor"                           { return FLOOR; }
"ceil"                            { return CEIL; }
"abs"                             { return ABS; }
"sqrt"                            { return SQRT; }
"log2"                            { return LOG2; }
"log10"                           { return LOG10; }
("cos")|("COS")                   { return COS; }
("sin")|("SIN")                   { return SIN; }
("tan")|("TAN")                   { return TAN; }
("cot")|("COT")                   { return COT; }
("sec")|("SEC")                   { return SEC; }
("csc")|("CSC")                   { return CSC; }
("c_to_f")|("ctof")               { return CEL_TO_FAH;}
("f_to_c")|("ftoc")               { return FAH_TO_CEL;}
"exp"                             { return EXP; }
("var")|("VAR")                   { return VAR_KEYWORD; }
[a-zA-Z0-9]+                      { yylval.index = add_variable(yytext); return VARIABLE; }
[\n|\n\r]                         { return EOL; }
.                                 {
    yyerror("Undefined symbol");
    exit(1);
}
%%
