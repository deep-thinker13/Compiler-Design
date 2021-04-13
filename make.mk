a.out: y.tab.c lex.yy.c
	gcc -o a.out y.tab.c lex.yy.c -ly -ll
y.tab.c: prog.y
	yacc -d prog.y
lex.yy.c: prog.l
	lex prog.l
