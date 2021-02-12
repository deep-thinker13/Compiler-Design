%{
#include<stdio.h>
#include<stdlib.h>
int yylex();
void yyerror(char *s);


%}


%union
{
	int number;
	double real;
	char *string;
}

%token <number> T_NUM 
%token <real> T_REAL
%token <string> T_ID T_FLOAT T_INT T_IMPORT T_DOUBLE T_BOOLEAN T_STRING T_CHAR T_IF T_ELSE T_DO T_WHILE T_RETURN T_PACKAGE T_CLASS T_PUBLIC T_PRIVATE T_PROTECTED T_STATIC T_VOID T_MAIN T_CONST T_TRUE T_FALSE T_NULL T_BREAK T_CONTINUE T_PRINTLN T_PRINT T_EXIT T_PE T_ME T_DE T_MULE T_PERCE T_INC T_DEC T_AND T_OR T_NE T_GTE T_LTE T_EE T_DIMS


%%
Prog:
	 Statements
	;

Statements:
	 Statements Statement
	|Statement
	;
Statement:
	 Declr ';'
	|Assign ';'
	|T_IF '(' Cond ')' '{' Statements '}' T_ELSE '{' Statements '}'
	|T_DO '{' Statements '}' T_WHILE '(' Cond ')' ';'
	|T_RETURN Exp ';'
	|T_EXIT {printf("valid"); YYACCEPT; exit(0);}
	;

Declr:
	 Type ListVar
	;
Type:
	 T_INT
	|T_FLOAT
	|T_DOUBLE
	|T_BOOLEAN
	|T_CHAR
	|T_STRING 	
	;
ListVar:
	 X
	|ListVar ',' X 
	;
X:
	 T_ID
	|Assign
	;
Assign:
	 T_ID '=' Exp
	|T_ID '+' '=' Exp
	|T_ID '-' '=' Exp
	|T_ID '*' '=' Exp
	|T_ID '/' '=' Exp
	|T_ID '^' '=' Exp
	;
Cond:
	 T_ID Relop T_ID
	;
Relop:
	 '<'
	|'>'
	|'<' '='
	|'>' '='
	|'=' '='
	|'!' '='
	;
Unary:
 	 T_ID '+' '+'
	|'+' '+' T_ID
	|T_ID '-' '-'
	|'-' '-' T_ID
	;
Exp:
	 Exp '+' T
	|Exp '-' T
	|T
	;
T:
	 T '*' F
	|T '/' F
	|F
	;
F:
	 G '^' F
	|G
	;
G:
	 '(' Exp ')'
	|T_ID
	|T_NUM
	; 



%%
void yyerror(char *s)
{
printf("%s\n",s);
}
int main()
{
yyparse();
return 0;
}
