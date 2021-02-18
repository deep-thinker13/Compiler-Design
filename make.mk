parser: y.tab.c lex.yy.c
	gcc -o parser y.tab.c lex.yy.c -ll
y.tab.c: prog.y
	yacc -d prog.y
lex.yy.c: prog.l
	lex prog.l
