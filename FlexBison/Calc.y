%{
/*
    構文解析を行う為のファイル
*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define YYDEBUG 1
#define PICONST 3.141592653589793

extern int yylex(void);

double mcon = PICONST / 180.0;

int
yyerror(char const *str)
{
    extern char *yytext;
    fprintf(stderr, "parser error near %s\n", yytext);
    return 0;
}

%}
%union {
    int     int_value;
    double  double_value;
}
%token <double_value>    DOUBLE_LITERAL
%token ADD SUB MUL DIV EXPONENT MOD PI SQRT Sin Cos Tan CR
%token LP RP
%type <double_value> expression term primary_expression
%%
line_list
    : line
    | line_list line
    ;
line
    : expression CR
    {
        printf(">>%lf\n", $1);
    }
expression
    : term
    | expression ADD term
    {
        $$ = $1 + $3;
    }
    | expression SUB term
    {
        $$ = $1 - $3;
    }
    | PI LP expression RP
    {
        $$ = $3 * 3.141592653589793;
    }
    | SQRT LP expression RP
    {
        $$ = sqrt($3);
    }
    ;
term
    : primary_expression
    | term MUL primary_expression
    {
        $$ = $1 * $3;
    }
    | term DIV primary_expression
    {
        $$ = $1 / $3;
    }
    | term EXPONENT primary_expression
    {
        $$ = pow($1,$3);
    }
    | term MOD primary_expression
    {
        $$ = ((int)$1) % ((int)$3);
    }
    ;
primary_expression
    : DOUBLE_LITERAL
    | LP expression RP
    {
        $$ = $2;
    }
    | Sin LP expression RP
    {
        $$ = sin($3 * mcon);
    }
    | Cos LP expression RP
    {
        $$ = cos($3 * mcon);
    }
    | Tan LP expression RP
    {
        $$ = tan($3 * mcon);
    }
    ;
%%


int main(void)
{
    extern int yyparse(void);
    extern FILE *yyin;

    yyin = stdin;
    if (yyparse()) {
        fprintf(stderr, "不正な入力\n");
        exit(1);
    }
}