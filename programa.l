%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TOKEN_PROGRAM       256
#define TOKEN_VAR           257
#define TOKEN_INTEGER       258
#define TOKEN_BEGIN         259
#define TOKEN_END           260
#define TOKEN_WHILE         261
#define TOKEN_DO            262
#define TOKEN_IF            263
#define TOKEN_THEN          264
#define TOKEN_ELSE          265
#define TOKEN_ATRIBUICAO    266
#define TOKEN_MENOR_IGUAL   267
#define TOKEN_MAIOR_IGUAL   268
#define TOKEN_MENOR         269
#define TOKEN_MAIOR         270
#define TOKEN_IGUAL         271
#define TOKEN_SOMA          272
#define TOKEN_SUBTRACAO     273
#define TOKEN_MULTIPLICACAO 274
#define TOKEN_DIVISAO       275
#define TOKEN_DOIS_PONTOS   276
#define TOKEN_PONTO_VIRGULA 277
#define TOKEN_VIRGULA       278
#define TOKEN_PONTO         279
#define TOKEN_NUMERO        280
#define TOKEN_IDENTIFICADOR 281
#define TOKEN_INVALIDO      282

char yylval_text[256];
int yylval_num;
%}

LETRA      [a-zA-Z]
DIGITO     [0-9]
ID         {LETRA}({LETRA}|{DIGITO})*
NUMERO     {DIGITO}+

%%

"program"      { return TOKEN_PROGRAM; }
"var"          { return TOKEN_VAR; }
"integer"      { return TOKEN_INTEGER; }
"begin"        { return TOKEN_BEGIN; }
"end"          { return TOKEN_END; }
"while"        { return TOKEN_WHILE; }
"do"           { return TOKEN_DO; }
"if"           { return TOKEN_IF; }
"then"         { return TOKEN_THEN; }
"else"         { return TOKEN_ELSE; }

":="           { return TOKEN_ATRIBUICAO; }
"<="           { return TOKEN_MENOR_IGUAL; }
">="           { return TOKEN_MAIOR_IGUAL; }
"<"            { return TOKEN_MENOR; }
">"            { return TOKEN_MAIOR; }
"="            { return TOKEN_IGUAL; }

"+"            { return TOKEN_SOMA; }
"-"            { return TOKEN_SUBTRACAO; }
"*"            { return TOKEN_MULTIPLICACAO; }
"/"            { return TOKEN_DIVISAO; }

":"            { return TOKEN_DOIS_PONTOS; }
";"            { return TOKEN_PONTO_VIRGULA; }
","            { return TOKEN_VIRGULA; }
"."            { return TOKEN_PONTO; }

{NUMERO}       {
                   yylval_num = atoi(yytext);
                   return TOKEN_NUMERO;
               }

{ID}           {
                   strncpy(yylval_text, yytext, sizeof(yylval_text) - 1);
                   yylval_text[sizeof(yylval_text) - 1] = '\0';
                   return TOKEN_IDENTIFICADOR;
               }

[ \t\n\r]+     ;

.              { return TOKEN_INVALIDO; }

%%

int main(int argc, char *argv[]) {
    int token;

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    }

    while ((token = yylex()) != 0) {
        /* tokens retornados por yylex() para uso do parser */
    }

    if (yyin && yyin != stdin) {
        fclose(yyin);
    }

    return 0;
}
