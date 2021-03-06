grammar lab1;

plik : (expr {System.out.println("Wynik: " + $expr.output);})* EOF;

expr 	 returns [int output]
	:	t1 = term {$output = $t1.output;}
		(PLUS t2 = term {$output += $t2.output;}
		| MINUS  t2 = term {$output -= $t2.output;}
		)* NL ;

term returns [int output]	
	: a1 = atom {$output = $a1.output;}
	((MUL a2 = atom {$output *= $a2.output;}
	| DIV a2 = atom {if ($a2.output == 0) {
					throw new ArithmeticException("Cannot divide by 0");
				} else {$output /= $a2.output;}
			}
	| MOD a2 = atom {$output \%= $a2.output;}
	))*;




atom returns [int output]
	: INT {$output = Integer.parseInt($INT.text);}	
        | (LP expr RP) {$output = $expr.output;} 
        ;



ID  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

INT :	'0'..'9'+
    ;

COMMENT
    :   '//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;}
    |   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
    ;

WS  :   ( ' '
        | '\t'
        | '\r'
        ) {$channel=HIDDEN;}
    ;

PLUS :	'+'
     ;
     
MINUS : '-'
      ;
      
MUL : '*'
    ;

DIV : '/'
    ;

MOD 	:	'%'
	;

NL : '\n'
   ;

LP : '('
   ;
	
RP : ')'
   ;
