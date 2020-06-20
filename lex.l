%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "yacc.tab.h"

extern int yyerror(const char *s);
%}

/* Stop the error "undefined reference to 'yywrap'" from Flex */
%option noyywrap

/* Grammar rules
   [ \t] -- Match space or tab
   [0-9]+(\.[0-9]+)?  -- Match any combination of numbers. Includes decimals.
   [a-zA-Z0-9]+ -- Match any combination of letters (lower and upper case) and numbers.
   . -- Match any remaining character.
*/

DIGIT [0-9]

%%
[ \t]
{DIGIT}+(\.{DIGIT}+)?             {
    yylval.num = atof(yytext);
    return NUMBER;
}
"+"                               { return ADD; }
"-"                               { return SUB; }
"*"                               { return MUL; }
"/"                               { return DIV; }
"%"                               { return MOD; }
"^"                               { return POW; }
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
[\n|\n\r]                         { return EOL; }
.                                 {
    yyerror("Undefined symbol");
    exit(1);
}
%%