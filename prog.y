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

%token <number> T_NUM T_DIMS
%token <real> T_REAL
%token <string> T_ID T_FLOAT T_INT T_IMPORT T_DOUBLE T_BOOLEAN T_STRING T_CHAR T_IF T_ELSE T_DO T_WHILE T_RETURN T_PACKAGE T_CLASS T_PUBLIC T_PRIVATE T_PROTECTED T_STATIC T_VOID T_MAIN T_CONST T_TRUE T_FALSE T_NULL T_BREAK T_CONTINUE T_PRINTLN T_PRINT T_EXIT T_PE T_ME T_DE T_MULE T_PERCE T_INC T_DEC T_AND T_OR T_NE T_GTE T_LTE T_EE T_NEW T_PID T_ANDE T_XORE T_ORE
%type <string> Type 
%type <number> Exp


%%
/*Prog:
	 Statements
	;*/
Prog:
	 Package Import Classes 
	;

Package:
	 Package T_PACKAGE T_PID ';'
	|Package T_PACKAGE T_ID ';'
	|
	;
Import:
	 Import T_IMPORT T_PID ';'
	|Import T_IMPORT T_ID ';'
	|
	; 
Classes:

	 T_CLASS T_ID '{' Statements '}' Classes 
	|T_EXIT {printf("valid"); YYACCEPT;} 
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
	|T_DIMS T_ID
	|T_DIMS T_DIMS T_ID 
	|T_ID T_DIMS '=' T_NEW Type T_DIMS {if($6==-1){yyerror("error");}}
	|T_DIMS T_ID '=' T_NEW Type T_DIMS {if($6==-1){yyerror("error");}}
	;
X:
	 T_ID
	|Assign
	|T_ID T_DIMS
	|T_ID T_DIMS T_DIMS
	;
Assign:
	 T_ID '=' Exp
	|T_ID T_PE Exp
	|T_ID T_ME Exp
	|T_ID T_MULE Exp
	|T_ID T_DE Exp
	|T_ID T_XORE Exp
	|T_ID '=' T_NEW Type T_DIMS {if($5==-1){yyerror("error");}}
	|T_ID T_DIMS '=' Exp {if($2==-1){yyerror("error");}}
	;
Cond:
	 T_ID Relop T_ID
	;
Relop:
	 '<'
	|'>'
	|T_LTE
	|T_GTE
	|T_EE
	|T_NE
	;
Unary:
 	 T_ID T_INC
	|T_INC T_ID
	|T_ID T_DEC
	|T_DEC T_ID
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
