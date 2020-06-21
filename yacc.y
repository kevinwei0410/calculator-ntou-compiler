%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "functions.h"
#include "yacc.tab.h"

extern double variable_values[100];
extern int variable_set[100];

/* Flex functions */
extern int yylex(void);
extern void yyterminate();
extern FILE* yyin;
extern int set_variable(int index, double val);

int yyerror(const char *s);
%}

%union {
	int index;
	double num;
}

%token<num> NUMBER
%token<num> L_PAREN R_PAREN
%token<num> DIV MUL ADD SUB
%token<num> EQUALS
%token<num> PI E
%token<num> POW SQRT FACTORIAL MOD
%token<num> EXP
%token<num> LOG LOG2 LOG10
%token<num> FLOOR CEIL ABS
%token<num> COS SIN TAN COT SEC CSC
%token<num> EOL
%token<num> VAR_KEYWORD 
%token<num> CEL_TO_FAH FAH_TO_CEL
%token<index> VARIABLE
%type<num> input
%type<num> line
%type<num> calculation
%type<num> constant
%type<num> expr
%type<num> function
%type<num> temperature_conversion
%type<num> logarithm
%type<num> trig_function
%type<num> assignment

/* Set operator precedence, follows BODMAS rules. */
%left SUB
%left ADD
%left MUL 
%left DIV 
%left POW SQRT
%left L_PAREN R_PAREN

%%

input:
	| input line
	;

line: 
	  EOL              { fprintf(stdout, "Please enter a math expression:\n"); }
	| calculation EOL  { fprintf(stdout, "= %.2f\n",$1); }
	;

calculation:
	  expr
	| function
	| assignment
	;

constant:
	  PI { $$ = 3.141592653589793; }
	| E  { $$ = 2.718281828459045; }
	;

expr:
	SUB expr                  { $$ = -$2; }
	| NUMBER                  { $$ = $1; }
	| VARIABLE                { $$ = variable_values[$1]; }
	| expr DIV expr           {
		if ($3 == 0) {
			yyerror("Cannot divide by zero");
			exit(1);
		} else {
			$$ = $1 / $3;
		}
	}
	| expr MUL expr            { $$ = $1 * $3; }
	| L_PAREN expr R_PAREN { $$ = $2; }
	| expr ADD expr            { $$ = $1 + $3; }
	| expr SUB expr            { $$ = $1 - $3; }
	| expr POW expr            { $$ = pow($1, $3); }
	| expr MOD expr            { $$ = modulo($1, $3); }
	| constant
	| function
	;

function: 
	  logarithm
	| temperature_conversion
	| SQRT L_PAREN expr R_PAREN      { $$ = sqrt($3); }
	| EXP L_PAREN expr R_PAREN      { $$ = exp($3); }
	| ABS L_PAREN expr R_PAREN       { $$ = fabs($3); }
	| FLOOR L_PAREN expr R_PAREN     { $$ = floor($3); }
	| CEIL L_PAREN expr R_PAREN      { $$ = ceil($3); }
	| trig_function
	| expr FACTORIAL { $$ = factorial($1); }
	;

logarithm:
	  LOG L_PAREN expr R_PAREN       { $$ = log($3); }
	| LOG2 L_PAREN expr R_PAREN       { $$ = log2($3); }
	| LOG10 L_PAREN expr R_PAREN    { $$ = log10($3); }
	;

temperature_conversion:
	  CEL_TO_FAH L_PAREN expr R_PAREN     { $$ = c_to_f($3);  }
	| FAH_TO_CEL L_PAREN expr R_PAREN     { $$ = f_to_c($3); }
	;
trig_function:
	  COS L_PAREN expr R_PAREN             { $$ = cos($3); }
	| SIN L_PAREN expr R_PAREN            { $$ = sin($3); }
	| TAN L_PAREN expr R_PAREN            { $$ = tan($3); }
	| COT L_PAREN expr R_PAREN            { $$ = 1/tan($3); }
	| SEC L_PAREN expr R_PAREN            { $$ = 1/cos($3); }
	| CSC L_PAREN expr R_PAREN            { $$ = 1/sin($3); }
	;
assignment: 
	VAR_KEYWORD VARIABLE EQUALS calculation { $$ = set_variable($2, $4); }
	;
%%

/* Entry point */
int main(int argc, char **argv)
{
	if (argc < 2) {
		yyin = stdin;
		yyparse();
	}
	else {
		char* filename = argv[1];
		FILE* fp = fopen(filename, "r");
		if (fp == NULL) {
			fprintf(stderr, "Unable to open file \"%s\"\n", filename);
			exit(EXIT_FAILURE);
		}
		yyin = fp;
		yyparse();
		fclose(fp);
	}
}

/* Display error messages */
int yyerror(const char *s)
{
	fprintf(stderr, "[ERR] %s\n", s);
}
