lexer grammar OLexer;

import CommonLexer;

SPACE :
	' ' -> channel(HIDDEN)   
	;
	   
WS :
    ('\t' | '\u000C') -> channel(HIDDEN)       
    ;
    
LF :
    ('\r'?'\n') -> channel(HIDDEN)       
    ;

COMMENT :   
    '/*' .*? '*/'
    | '//' ~('\n'|'\r')*
    ;   
    
