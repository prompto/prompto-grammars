lexer grammar ArgsLexer;

STRING :   
    '"' (   EscapeSequence |   ~( '\\' | '"' | '\r' | '\n' ) )* '"' 
    ;

fragment
EscapeSequence :   
    '\\' (
         'b' 
     |   't' 
     |   'n' 
     |   'f' 
     |   'r' 
     |   '\"' 
     |   '\'' 
     |   '\\' 
     |   ('0'..'3') ('0'..'7') ('0'..'7')
     |   ('0'..'7') ('0'..'7') 
     |   ('0'..'7')
     )
     ;         

EQUALS :
    '='
    ;
    
DASH :
    '-'
    ;
    
WS : 
    ' ' -> skip
    ;

ELEMENT :
     ( ~( ' ' | '\t' | '\r' |'\n' | '"' | '=' | '-') )+
     ;
