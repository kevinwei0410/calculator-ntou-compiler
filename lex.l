%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "yacc.tab.h"
%}

/* Stop the error "undefined reference to 'yywrap'" from Flex */
%option noyywrap

/* Grammar rules
   [ \t] -- Match space or tab
   [0-9]+(\.[0-9]+)?  -- Match any combination of numbers. Includes decimals.
   [a-zA-Z0-9]+ -- Match any combination of letters (lower and upper case) and numbers.
   . -- Match any remaining character.
*/

%%
[ \t]
[0-9]+(\.[0-9]+)?                         { yylval.num = atof(yytext); return NUMBER; }
"+"                                       { return ADD; }
"-"                                       { return SUB; }
"*"                                       { return MUL; }
"/"                                       { return DIV; }
"%"                                       { return MOD; }
"^"                                       { return POW; }
"("                                       { return L_BRACKET; }
")"                                       { return R_BRACKET; }
"!"                                       { return FACTORIAL; }
("pi")|("PI")                             { return PI; }
("mod")|("MOD")                           { return MOD; }
("pow")|("POW")                           { return POW; }
("floor")|("FLOOR")                       { return FLOOR; }
("ceil")|("CEIL")                         { return CEIL; }
("abs")|("ABS")                           { return ABS; }
("sqrt")|("SQRT")                         { return SQRT; }
("log2")|("LOG2")                         { return LOG2; }
("log10")|("LOG10")                       { return LOG10; }
[\n]                                      { return EOL; }
.                                         { yyerror("Undefined symbol"); exit(1); }
%%
