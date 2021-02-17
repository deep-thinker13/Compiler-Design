%{
#include<stdio.h>
#include<stdlib.h>
int yylineno;
extern FILE *yyin;
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
%token <string> T_ID T_FLOAT T_INT T_IMPORT T_DOUBLE T_BOOLEAN T_STRING T_CHAR T_IF T_ELSE T_DO T_WHILE T_RETURN T_PACKAGE T_CLASS T_PUBLIC T_PRIVATE T_PROTECTED T_STATIC T_VOID T_MAIN T_CONST T_TRUE T_FALSE T_NULL T_BREAK T_CONTINUE T_PRINTLN T_PRINT T_EXIT T_PE T_ME T_DE T_MULE T_PERCE T_AND T_OR T_NE T_GTE T_LTE T_EE T_NEW T_PID T_FINAL T_STR T_PLUS
%type <string> Type 
//%type <number> Exp


%%

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

Modifier:
	 T_PUBLIC Modifier1
	|T_PRIVATE Modifier1
	|T_PROTECTED Modifier1
	|Modifier1
	;

Modifier1:
	 T_STATIC Modifier2
	|Modifier2
	;

Modifier2:
	 T_FINAL
	|
	;

Classes:

	 Modifier T_CLASS T_ID '{' ClassBody '}' Classes 
	|{printf("valid"); YYACCEPT;} 
	;

ClassBody:
	 GlobalVar ClassBody
	|MethodDec ClassBody
	|
	;

GlobalVar:
	 Modifier Declr ';'
	;

MethodDec:
	 Modifier Type T_ID '(' ParameterList ')' '{' Statements '}'
	|Modifier T_VOID  T_ID '(' ParameterList ')' '{' Statements '}'
	|Modifier T_VOID  T_MAIN '(' T_STRING T_ID T_DIMS ')' '{' Statements '}'
	;

ParameterList:
	 Type T_ID
	|Type T_ID ',' ParameterList
	|
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
	|T_PRINTLN '(' PrintBlock ')' ';'
	|T_PRINT '(' PrintBlock ')' ';'
	;

PrintBlock:
	 Strings '+' Exp
	|Exp T_PLUS Strings
	|Exp
	|Strings
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
	|T_ID T_PE ArithExp
	|T_ID T_ME ArithExp
	|T_ID T_MULE ArithExp
	|T_ID T_DE ArithExp
	|T_ID '=' T_NEW Type T_DIMS {if($5==-1){yyerror("error");}}
	|T_ID T_DIMS '=' Exp {if($2==-1){yyerror("error");}}
	|T_ID T_PERCE ArithExp
	|T_ID '=' Strings
	;

Strings:
	Strings '+' String
	|String 
	;
String:
	 T_STR
	;
	
Cond:
	 LogExp
	;
Exp: 
	LogExp
	|ArithExp
	;
LogExp:
	LogExp Logop EqExp0
	|EqExp0
	;
Logop:
	T_AND
	|T_OR
	;
EqExp0: 
	EqExp0 Eqop RelG
	|RelG
	;
RelG:
	RelExp
	|'(' LogExp ')'
	|T_TRUE
	|T_FALSE
	;
Eqop:
	T_EE
	|T_NE
	;
RelExp:
	ArithExp Relop ArithExp
	;
Relop:
	'<'
	|T_LTE
	|'>'
	|T_GTE
	|T_EE
	|T_NE
	;
ArithExp:
	 ArithExp '+' T
	|ArithExp '-' T
	|T
	;
T:
	 T '*' G
	|T '/' G
	|T '%' G
	|G
	;
G:
	 '(' ArithExp ')'
	|T_ID T_DIMS
	|T_ID '.' T_ID
	|T_ID
	|T_NUM
	; 


%%



void yyerror(char *s)
{
printf("%s in line %d\n",s,yylineno);

}
int yywrap()
{
    return 1;
}
int main()
{
	char fname[100];
	printf("\nEnter the name of file\n");
	scanf("%s",fname);
	yyin=fopen(fname,"r+");
	yyparse();
return 0;
}
