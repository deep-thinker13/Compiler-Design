%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
void yyerror(char *s);
int extract(char *s);
#include "y.tab.h"

%}



digit	[0-9]
letter	[a-zA-Z]
id	{letter}({letter}|{digit})*
digits	{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
real	{digits}{opFraction}{opExponent}
%%
"//"[^\n]*	;
import	{yylval.string=strdup(yytext);return T_IMPORT;}
package	{yylval.string=strdup(yytext);return T_PACKAGE;}
class	{yylval.string=strdup(yytext);return T_CLASS;}
public	{yylval.string=strdup(yytext);return T_PUBLIC;}
private	{yylval.string=strdup(yytext);return T_PRIVATE;}
protected	{yylval.string=strdup(yytext);return T_PROTECTED;}
static	{yylval.string=strdup(yytext);return T_STATIC;}
void	{yylval.string=strdup(yytext);return T_VOID;}
main	{yylval.string=strdup(yytext);return T_MAIN;}
const	{yylval.string=strdup(yytext);return T_CONST;}
int	{yylval.string=strdup(yytext);return T_INT;}
float	{yylval.string=strdup(yytext);return T_FLOAT;}
double	{yylval.string=strdup(yytext);return T_DOUBLE;}
boolean	{yylval.string=strdup(yytext);return T_BOOLEAN;}
String	{yylval.string=strdup(yytext);return T_STRING;}
char	{yylval.string=strdup(yytext);return T_CHAR;}
true	{yylval.string=strdup(yytext);return T_TRUE;}
false	{yylval.string=strdup(yytext);return T_FALSE;}
null	{yylval.string=strdup(yytext);return T_NULL;}
break	{yylval.string=strdup(yytext);return T_BREAK;}
continue	{yylval.string=strdup(yytext);return T_CONTINUE;}
return	{yylval.string=strdup(yytext);return T_RETURN;}
System.out.println	{yylval.string=strdup(yytext);return T_PRINTLN;}
System.out.print	{yylval.string=strdup(yytext);return T_PRINT;}
if/"(".*")"	{yylval.string=strdup(yytext);return T_IF;}
else	{yylval.string=strdup(yytext);return T_ELSE;}
do	{yylval.string=strdup(yytext);return T_DO;}
while	{yylval.string=strdup(yytext);return T_WHILE;}
exit	{return T_EXIT;}
{id}	{yylval.string=strdup(yytext);return T_ID;}
\[{digits}?\]	{yylval.integer=extract(yytext);return T_DIMS;}
{digits}	{yylval.number=atoi(yytext);return T_NUM;}
{real}	{yylval.real=atof(yytext);return T_REAL;}
[\n|\t|' ']	;
.	return *yytext;
%%

int extract(char *s)
{
int len = strlen(s),i;
char *new;
if(len == 2)
	return -1;
else
{
	new = s+1;
	new[len-2] = '\0';
	i = atoi(new);
	return i;
}
}
