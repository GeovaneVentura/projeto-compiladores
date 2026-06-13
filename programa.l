%option noyywrap

%{
#include <stdio.h>
%}

LETRA      [a-zA-Z]
DIGITO     [0-9]
ID         {LETRA}({LETRA}|{DIGITO})*
NUMERO     {DIGITO}+

%%

"program"      { printf("PROGRAM: %s\n", yytext); }
"var"          { printf("VAR: %s\n", yytext); }
"integer"      { printf("INTEGER: %s\n", yytext); }
"begin"        { printf("BEGIN: %s\n", yytext); }
"end"          { printf("END: %s\n", yytext); }
"while"        { printf("WHILE: %s\n", yytext); }
"do"           { printf("DO: %s\n", yytext); }
"if"           { printf("IF: %s\n", yytext); }
"then"         { printf("THEN: %s\n", yytext); }
"else"         { printf("ELSE: %s\n", yytext); }

":="           { printf("ATRIBUICAO: %s\n", yytext); }
"<="           { printf("MENOR_IGUAL: %s\n", yytext); }
">="           { printf("MAIOR_IGUAL: %s\n", yytext); }
"<"            { printf("MENOR: %s\n", yytext); }
">"            { printf("MAIOR: %s\n", yytext); }
"="            { printf("IGUAL: %s\n", yytext); }

"+"            { printf("SOMA: %s\n", yytext); }
"-"            { printf("SUBTRACAO: %s\n", yytext); }
"*"            { printf("MULTIPLICACAO: %s\n", yytext); }
"/"            { printf("DIVISAO: %s\n", yytext); }

":"            { printf("DOIS_PONTOS: %s\n", yytext); }
";"            { printf("PONTO_VIRGULA: %s\n", yytext); }
","            { printf("VIRGULA: %s\n", yytext); }
"."            { printf("PONTO: %s\n", yytext); }

{NUMERO}       { printf("NUMERO: %s\n", yytext); }
{ID}           { printf("IDENTIFICADOR: %s\n", yytext); }

[ \t\n\r]+     ;   /* Ignora espaços */

.              { printf("CARACTERE_INVALIDO: %s\n", yytext); }

%%

int main() {
    yylex();
    return 1;
}