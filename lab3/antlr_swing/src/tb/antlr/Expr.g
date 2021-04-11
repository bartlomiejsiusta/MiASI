grammar Expr;

options {
  output=AST;
  ASTLabelType=CommonTree;
}

@header {
package tb.antlr;
}

@lexer::header {
package tb.antlr;
}

prog
    : (stat | blok )+ EOF!;

blok
    : ES^ (stat | blok)* LS!;


stat
    : expr NL -> expr

    | VAR ID PODST expr NL -> ^(VAR ID) ^(PODST ID expr)
    | VAR ID NL -> ^(VAR ID)
    | ID PODST expr NL -> ^(PODST ID expr)
    | if_stat NL -> if_stat
    | NL ->
    ;

if_stat
  : IF^ expr THEN! expr (ELSE! expr)? ;

expr
    : multExpr
      ( PLUS^ multExpr
      | MINUS^ multExpr
      )*
    ;

multExpr
    : atom
      ( MUL^ atom
      | DIV^ atom
      )*
    ;

atom
    : INT
    | ID
    | LP! expr RP!
    ;

VAR :'var';

IF: 'if';

THEN: 'then';

ELSE: 'else';

ID : ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;

INT : '0'..'9'+;

NL : '\r'? '\n' ;

WS : (' ' | '\t')+ {$channel = HIDDEN;} ;


ES: '{';

LS: '}';

LP
	:	'('
	;

RP
	:	')'
	;

PODST
	:	'='
	;

PLUS
	:	'+'
	;

MINUS
	:	'-'
	;

MUL
	:	'*'
	;

DIV
	:	'/'
	;
