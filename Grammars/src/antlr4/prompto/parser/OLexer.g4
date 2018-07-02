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


// fragment
// CSS_TEXT:
//    ('0'..'9'|'a'..'z'|'A'..'Z'|'_'|'-')*?
//    ;

