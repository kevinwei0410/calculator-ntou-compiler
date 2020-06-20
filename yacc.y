%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "functions.h"
#include "yacc.tab.h"


/* Flex functions */
extern int yylex(void);
extern void yyterminate();
extern FILE* yyin;
int yyerror(const char *s);
%}

%union {
	int index;
	double num;
}

%token<num> NUMBER
%token<num> L_BRACKET R_BRACKET
%token<num> DIV MUL ADD SUB
%token<num> PI
%token<num> POW SQRT FACTORIAL MOD
%token<num> LOG2 LOG10
%token<num> FLOOR CEIL ABS
%token<num> EOL
%type<num> input
%type<num> line
%type<num> calculation
%type<num> constant
%type<num> expr
%type<num> function
%type<num> logarithm

/* Set operator precedence, follows BODMAS rules. */
%left SUB
%left ADD
%left MUL 
%left DIV 
%left POW SQRT
%left L_BRACKET R_BRACKET

%%

input:
	  %empty
	| input line
	;
	
line: 
	  EOL              { fprintf(stdout, "Please enter a math expression:\n"); }
	| calculation EOL  { fprintf(stdout, "= %.2f\n",$1); }
	;

calculation:
	  expr
	| function
	;
		
constant:
	PI { $$ = 3.141592653589793; }
	;
		
expr:
	SUB expr                  { $$ = -$2; }
	| NUMBER                  { $$ = $1; }
	| constant
	| expr DIV expr           {
		if ($3 == 0) {
			yyerror("Cannot divide by zero");
			exit(1);
		} else {
			$$ = $1 / $3;
		}
	}
	| expr MUL expr            { $$ = $1 * $3; }
	| L_BRACKET expr R_BRACKET { $$ = $2; }
	| expr ADD expr            { $$ = $1 + $3; }
	| expr SUB expr            { $$ = $1 - $3; }
	| expr POW expr            { $$ = pow($1, $3); }
	| expr MOD expr            { $$ = modulo($1, $3); }
	| function
	;
		
function: 
	  logarithm
	| SQRT expr      { $$ = sqrt($2); }
	| expr FACTORIAL { $$ = factorial($1); }
	| ABS expr       { $$ = fabs($2); }
	| FLOOR expr     { $$ = floor($2); }
	| CEIL expr      { $$ = ceil($2); }
	;
	
logarithm:
	LOG2 expr        { $$ = log2($2); }
	| LOG10 expr     { $$ = log10($2); }
	;
%%

/* Entry point */
int main(int argc, char **argv)
{		
	yyin = stdin;
	yyparse();
}

/* Display error messages */
int yyerror(const char *s)
{
	fprintf(stderr, "[ERR] %s\n", s);
}
