%{
/*
    字句解析を行う為のファイル
*/
#include <stdio.h>
#include "Calc.tab.h"

#define YY_SKIP_YYWRAP 1

int
yywrap(void)
{
    return 1;
}
%}
%%
"+"     return ADD;
"-"     return SUB;
"*"     return MUL;
"/"     return DIV;
"**"    return EXPONENT;
"%"     return MOD;
"\n"    return CR;
"("     return LP;
")"     return RP;
(pi|PI)  return PI;
(sqrt|SQRT)  return SQRT;
(sin|SIN)   return Sin;
(cos|COS)   return Cos;
(tan|TAN)   return Tan;
[0-9]+\.[0-9]*|[0-9]+ {
    double temp;
    sscanf(yytext, "%lf", &temp);
    yylval.double_value = temp;
    return DOUBLE_LITERAL;
}
[ \t] ;
%%