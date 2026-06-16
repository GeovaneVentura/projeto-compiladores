%code requires {
    typedef struct No {
        int id;
        char nome[50];
        struct No *filho1;
        struct No *filho2;
        struct No *filho3;
    } No;
}

%code top {
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
}

%code {
    No *raiz;
    int contador = 0;

    No *criarNo(char *nome, No *f1, No *f2, No *f3);

    void gerarDOT(No *no, FILE *arquivo);
    void salvarArvore(void);

    void yyerror(const char *s);
    int yylex(void);
}

%union {
    int num;
    char *str;
    No *no;
}

/* Tokens do programa */
%token PROGRAM VAR INTEGER
%token BEGIN_T END_T
%token WHILE DO
%token IF THEN ELSE

%token ATRIBUICAO

%token MENOR
%token MAIOR
%token MENOR_IGUAL
%token MAIOR_IGUAL
%token IGUAL
%token DIFERENTE

%token MAIS
%token MENOS
%token MULT
%token DIV

%token PONTO_VIRGULA
%token DOIS_PONTOS
%token VIRGULA
%token PONTO

%token ABRE_PAR
%token FECHA_PAR

%token <str> IDENTIFICADOR
%token <num> NUMERO

%type <no> programa
%type <no> declaracoes
%type <no> lista_declaracoes
%type <no> declaracao
%type <no> lista_id
%type <no> bloco
%type <no> comandos
%type <no> comando
%type <no> expressao

/* Precedência dos operadores */
%left MENOR MAIOR MENOR_IGUAL MAIOR_IGUAL IGUAL DIFERENTE
%left MAIS MENOS
%left MULT DIV

/* Resolver o problema do if-else */
%nonassoc THEN
%nonassoc ELSE

%%

programa:
    PROGRAM IDENTIFICADOR PONTO_VIRGULA
    declaracoes bloco PONTO
    {
        raiz = criarNo(
            "PROGRAMA",
            criarNo($2, NULL, NULL, NULL),
            $4,
            $5
        );

        $$ = raiz;
    }
;

declaracoes:
    VAR lista_declaracoes
    {
        $$ = criarNo("VAR", $2, NULL, NULL);
    }
;

lista_declaracoes:
    declaracao
    {
        $$ = $1;
    }

    | lista_declaracoes declaracao
    {
        $$ = criarNo(
            "DECLARACOES",
            $1,
            $2,
            NULL
        );
    }
;

declaracao:
    lista_id DOIS_PONTOS INTEGER PONTO_VIRGULA
    {
        $$ = criarNo(
            "DECLARACAO",
            $1,
            criarNo("INTEGER", NULL, NULL, NULL),
            NULL
        );
    }
;

lista_id:
    IDENTIFICADOR
    {
        $$ = criarNo($1, NULL, NULL, NULL);
    }

    | lista_id VIRGULA IDENTIFICADOR
    {
        $$ = criarNo(
            "LISTA_ID",
            $1,
            criarNo($3, NULL, NULL, NULL),
            NULL
        );
    }
;

bloco:
    BEGIN_T comandos END_T
    {
        $$ = criarNo("BLOCO", $2, NULL, NULL);
    }
;

comandos:
    comando
    {
        $$ = $1;
    }

    | comandos PONTO_VIRGULA comando
    {
        $$ = criarNo(
            "SEQUENCIA",
            $1,
            $3,
            NULL
        );
    }

    | comandos PONTO_VIRGULA
    {
        $$ = $1;
    }
;

comando:
    IDENTIFICADOR ATRIBUICAO expressao
    {
        $$ = criarNo(
            ":=",
            criarNo($1, NULL, NULL, NULL),
            $3,
            NULL
        );
    }

    | WHILE expressao DO comando
    {
        $$ = criarNo(
            "WHILE",
            $2,
            $4,
            NULL
        );
    }

    | IF expressao THEN comando %prec THEN
    {
        $$ = criarNo(
            "IF",
            $2,
            $4,
            NULL
        );
    }

    | IF expressao THEN comando ELSE comando
    {
        $$ = criarNo(
            "IF_ELSE",
            $2,
            $4,
            $6
        );
    }

    | bloco
    {
        $$ = $1;
    }
;

expressao:
    IDENTIFICADOR
    {
        $$ = criarNo($1, NULL, NULL, NULL);
    }

    | NUMERO
    {
        char valor[20];

        sprintf(valor, "%d", $1);

        $$ = criarNo(valor, NULL, NULL, NULL);
    }

    | ABRE_PAR expressao FECHA_PAR
    {
        $$ = $2;
    }

    | expressao MAIS expressao
    {
        $$ = criarNo("+", $1, $3, NULL);
    }

    | expressao MENOS expressao
    {
        $$ = criarNo("-", $1, $3, NULL);
    }

    | expressao MULT expressao
    {
        $$ = criarNo("*", $1, $3, NULL);
    }

    | expressao DIV expressao
    {
        $$ = criarNo("/", $1, $3, NULL);
    }

    | expressao MENOR expressao
    {
        $$ = criarNo("<", $1, $3, NULL);
    }

    | expressao MAIOR expressao
    {
        $$ = criarNo(">", $1, $3, NULL);
    }

    | expressao MENOR_IGUAL expressao
    {
        $$ = criarNo("<=", $1, $3, NULL);
    }

    | expressao MAIOR_IGUAL expressao
    {
        $$ = criarNo(">=", $1, $3, NULL);
    }

    | expressao IGUAL expressao
    {
        $$ = criarNo("=", $1, $3, NULL);
    }

    | expressao DIFERENTE expressao
    {
        $$ = criarNo("<>", $1, $3, NULL);
    }
;

%%

No *criarNo(char *nome, No *f1, No *f2, No *f3)
{
    No *novo = (No *) malloc(sizeof(No));

    if (novo == NULL)
    {
        printf("Erro de alocacao de memoria\n");
        exit(1);
    }

    novo->id = contador++;

    strcpy(novo->nome, nome);

    novo->filho1 = f1;
    novo->filho2 = f2;
    novo->filho3 = f3;

    return novo;
}


void gerarDOT(No *no, FILE *arquivo)
{
    if (no == NULL)
        return;

    fprintf(
        arquivo,
        "n%d [label=\"%s\"];\n",
        no->id,
        no->nome
    );

    No *filhos[3] = {
        no->filho1,
        no->filho2,
        no->filho3
    };

    for (int i = 0; i < 3; i++)
    {
        if (filhos[i] != NULL)
        {
            fprintf(
                arquivo,
                "n%d -> n%d;\n",
                no->id,
                filhos[i]->id
            );

            gerarDOT(filhos[i], arquivo);
        }
    }
}


void salvarArvore(void)
{
    FILE *arquivo = fopen("arvore.dot", "w");

    if (arquivo == NULL)
    {
        printf("Erro ao criar arvore.dot\n");
        return;
    }

    fprintf(arquivo, "digraph AST {\n");

    gerarDOT(raiz, arquivo);

    fprintf(arquivo, "}\n");

    fclose(arquivo);
}


void yyerror(const char *s)
{
    extern char *yytext;

    printf("Erro sintatico: %s\n", s);
    printf("Token encontrado: '%s'\n", yytext);
}


int main(void)
{
    if (yyparse() == 0)
    {
        printf("Analise sintatica concluida com sucesso.\n");

        salvarArvore();

        printf("Arquivo arvore.dot gerado.\n");
    }

    return 0;
}