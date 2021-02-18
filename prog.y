%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>
int yylineno;
extern FILE *yyin;
int yylex();
void yyerror(char *s);
int index_a;
int* current_scope;
char* return_string();

struct node
{
   char type[10];
   char value[10];
   char name[33];
   char scope[10];
   struct node *next;
};

struct hash
{
  struct node *head;
  int count;
};

int size = 32;

 void display(struct hash *);
 void insert(struct hash *ht, int key, char* scope, char* name, char* type);
int search(struct hash *ht,int key, char* scope, char* name);
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
	 Package T_PACKAGE print_pid ';'
	|Package T_PACKAGE print_id ';'
	|
	;
	
Import:
	 Import T_IMPORT T_PID ';'
	|Import T_IMPORT print_id ';'
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

	 Modifier T_CLASS print_id flower_paran_o_c ClassBody flower_paran_c_c Classes 
	|Modifier error print_id flower_paran_o_c ClassBody flower_paran_c_c Classes
	|Modifier T_CLASS error flower_paran_o_c ClassBody flower_paran_c_c Classes
	|{fprintf(stderr, "valid"); YYACCEPT;} 
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
	 Modifier Type print_id func_paran_o ParameterList func_paran_c flower_paran_o Statements flower_paran_c
	|Modifier T_VOID  print_id func_paran_o ParameterList func_paran_c flower_paran_o Statements flower_paran_c
	|Modifier T_VOID  T_MAIN func_paran_o T_STRING print_id T_DIMS func_paran_c flower_paran_o Statements flower_paran_c
	|error
	;

ParameterList:
	 Type print_id
	|Type print_id ',' ParameterList
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
	|error
	;

PrintBlock:
	 String '+' Exp
	|Exp T_PLUS String
	|Exp
	|String
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
	|T_DIMS print_id
	|T_DIMS T_DIMS print_id 
	|print_id T_DIMS '=' T_NEW Type T_DIMS {if($6==-1){yyerror("error");}}
	|T_DIMS print_id '=' T_NEW Type T_DIMS {if($6==-1){yyerror("error");}}
	;
X:
	 print_id
	|Assign
	|print_id T_DIMS
	|print_id T_DIMS T_DIMS
	;
Assign:
	 print_id '=' PrintBlock
	|print_id T_PE ArithExp
	|print_id T_ME ArithExp
	|print_id T_MULE ArithExp
	|print_id T_DE ArithExp
	|print_id '=' T_NEW Type T_DIMS {if($5==-1){yyerror("error");}}
	|print_id T_DIMS '=' Exp {if($2==-1){yyerror("error");}}
	|print_id T_PERCE ArithExp
	//|print_id '=' String
	;

/*Strings:
	Strings '+' String
	|String 
	;*/
String:
	 T_STR
	;
	
Cond:
	 LogExp
	|error
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
	|print_id T_DIMS
	|print_id '.' print_id
	|print_id
	|T_NUM
	;
print_pid:
	T_PID	{fprintf(stderr,"%s\t",$1);();fprintf(stderr,"\n");}; 

print_id:
	T_ID	{fprintf(stderr,"%s\t",$1);printing();fprintf(stderr,"\n");};

flower_paran_o:
	'{'	 {index_a++;current_scope[index_a]+=1;};

flower_paran_c:
	'}'	{index_a--;};
flower_paran_o_c:
	'{'	 {index_a++;current_scope[index_a]+=1;current_scope[2]=0;};

flower_paran_c_c:
	'}'	{index_a--;current_scope[2]=0;};
func_paran_o:
	'('	{ index_a++;current_scope[index_a]+=1;};
func_paran_c:
	')'	{current_scope[index_a]-=1;index_a--;}; 


%%

void insert(struct hash *ht, int key, char* scope, char* name, char* type)
 {
   int index;
   struct node *temp;

   temp=malloc(sizeof(struct node));
   strcpy(temp->name,name);
   strcpy(temp->type,type);
   strcpy(temp->scope,scope);
   temp->next=NULL;

   index=key%size;//hash function
   temp->next=ht[index].head;
   ht[index].head=temp;
   ht[index].count++;
}


void display(struct hash* ht)
 {
    int i;
    struct node *temp;
    FILE *fptr = fopen("symboltable.txt", "w");
   fprintf(fptr,"NAME\tTYPE\tSCOPE\n");

   for(i=0;i<size;i++)
   {
     if(ht[i].head!=NULL)
     {
        temp=ht[i].head;
        while(temp!=NULL)
        {
          fprintf(fptr,"%s\t\t\t",temp->name);
          fprintf(fptr,"%s\t\t",temp->type);
          fprintf(fptr,"%s\t",temp->scope);
          fprintf(fptr,"\n");

          temp=temp->next;
        }
      }
   }
   fclose(fptr);

  }


 int search(struct hash *ht,int key, char* scope, char* name)
 {
  int index;
   struct node *temp, *prev;

   index=key%size;

   temp=ht[index].head;


   while(temp!=NULL)
   {
   		if(strcmp(temp->name,name) == 0 &&strcmp(temp->scope,scope)==0)
        {
        	return 1;
        }
        temp=temp->next;
   }

   if(temp==NULL)
     return 0;
    return 0;
  }


void yyerror(char *s)
{
    fprintf(stderr, "%s in line %d\n",s,yylineno);
}
int yywrap()
{
    return 1;
}

char* return_string()
{
	char* sco;
	sco=(char*)malloc(15*sizeof(char));
	char hi[3];
	for(int j=0;j<index_a;j++)
	{
		sprintf(hi,"%d",current_scope[j]);
		if(j==(index_a-1))
		{
			strcat(sco,hi);
		}
		else
		{
			strcat(sco,hi);
			strcat(sco,".");
		}	
	}
	return sco;
}

int main()
{
	current_scope=(int*)malloc(3*sizeof(int));
	current_scope[0]=1;
	index_a=0;
	char fname[100];
	fprintf(stderr,"\nEnter the name of file\n");
	scanf("%s",fname);
	yyin=fopen(fname,"r+");
	yyparse();
return 0;
}
