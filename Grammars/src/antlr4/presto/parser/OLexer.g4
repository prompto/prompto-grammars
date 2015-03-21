lexer grammar OLexer;

import CommonLexer;

SPACE :
	' ' -> skip   
	;
	   
WS :
    ('\t' | '\u000C') -> skip       
    ;
    
LF :
    ('\r'?'\n') -> skip       
    ;
