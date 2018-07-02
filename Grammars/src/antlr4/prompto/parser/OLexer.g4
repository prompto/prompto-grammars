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

COMMENT :   
    '/*' .*? '*/'
    | '//' ~('\n'|'\r')*
    ;   
    

fragment
JSX_TEXT:
    ~('{'|'}'|'<'|'>')*?
    ;

