# NTOU compiler final project
# Team 8

CC = gcc
LEX = flex
YACC = bison

SRCS = lex.yy.c yacc.tab.c yacc.tab.h functions.c
LDFLAGS = -lm

all: bison flex
	$(CC) -I./ $(LDFLAGS) $(SRCS) -o calculator

flex: lex.l
	$(LEX) lex.l

bison: yacc.y
	$(YACC) -d yacc.y

clean:
	rm -f *.tab.c *.tab.h *.yy.c calculator
