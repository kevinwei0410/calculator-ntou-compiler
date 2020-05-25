Support functions:
*add, sub, mul, div, power, sqrt, (), log2, log10, abs, floor, ceil, factorial, pi, mod*
using command compile
```
$bison -d yacc.y
$flex lex.l
$gcc yacc.tab.c lex.yy.c -lm -o scientific-calc
```
don't care waening