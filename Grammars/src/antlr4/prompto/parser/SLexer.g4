lexer grammar SLexer;

import CommonLexer;

tokens {
  INDENT,
  DEDENT
} 

LF_TAB: LF ('\t' | ' ')*
	;

LF_MORE: '\\' LF_TAB
	;

LF:
    '\r'?'\n'
    ;

TAB:
    '\t' -> channel(HIDDEN)  
    ;

	
WS:
	' ' -> channel(HIDDEN)   
	;    

COMMENT :   
    '#' ~('\n'|'\r')*
    ;   
    

