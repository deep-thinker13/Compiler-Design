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
pack_id	[a-z]+(\.[a-z]+)+
digits	{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
real	{digits}{opFraction}{opExponent}
%%
"/*"[^"*/"]*"*/"    ;
"//"[^\n]*	;
"+="    {yylval.string=strdup(yytext);return T_PE;}
"-="    {yylval.string=strdup(yytext);return T_ME;}
"/="    {yylval.string=strdup(yytext);return T_DE;}
"*="    {yylval.string=strdup(yytext);return T_MULE;}
"%="    {yylval.string=strdup(yytext);return T_PERCE;}
"&="    {yylval.string=strdup(yytext);return T_ANDE;}
"^="    {yylval.string=strdup(yytext);return T_XORE;}
"|="    {yylval.string=strdup(yytext);return T_ORE;}
"++"    {yylval.string=strdup(yytext);return T_INC;}
"--"    {yylval.string=strdup(yytext);return T_DEC;}
"&&"    {yylval.string=strdup(yytext);return T_AND;}
"||"    {yylval.string=strdup(yytext);return T_OR;}
"!="    {yylval.string=strdup(yytext);return T_NE;}
"<="    {yylval.string=strdup(yytext);return T_LTE;}
">="    {yylval.string=strdup(yytext);return T_GTE;}
"=="    {yylval.string=strdup(yytext);return T_EE;}
"new"	{yylval.string=strdup(yytext);return T_NEW;}
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
{pack_id}	{yylval.string=strdup(yytext);return T_PID;}
{id}	{yylval.string=strdup(yytext);return T_ID;}
\[{digits}?\]	{yylval.number=extract(yytext);return T_DIMS;}
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
	s[len-1] = '\0';
	new = s+1;
	
	i = atoi(new);
	return i;
}
}
