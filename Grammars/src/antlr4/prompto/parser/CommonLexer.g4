lexer grammar CommonLexer;

JAVA: 'Java:';
CSHARP: 'C#:';
PYTHON2: 'Python2:';
PYTHON3: 'Python3:';
JAVASCRIPT: 'JavaScript:';
SWIFT: 'Swift:';

COLON: ':';
SEMI: ';';
COMMA: ',';
RANGE: '..';
DOT: '.';
LPAR: '(';
RPAR: ')';
LBRAK: '[';
RBRAK: ']';
LCURL: '{';
RCURL: '}';
QMARK: '?';
XMARK: '!';
AMP: '&';
AMP2: '&&';
PIPE: '|';
PIPE2: '||';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
BSLASH: '\\';
PERCENT: '%';
GT: '>';
GTE: '>=';
LT: '<';
LTE: '<=';
LTGT: '<>';
EQ: '=';
XEQ: '!=';
EQ2: '==';
TEQ: '~=';
TILDE: '~';
LARROW: '<-';
RARROW: '->';

BOOLEAN: 'Boolean';
CHARACTER: 'Character';
TEXT: 'Text';
INTEGER: 'Integer';
DECIMAL: 'Decimal';
DATE: 'Date';
TIME: 'Time';
DATETIME: 'DateTime';
PERIOD: 'Period';
METHOD_T: 'Method';
CODE: 'Code';
DOCUMENT: 'Document';
BLOB: 'Blob';
IMAGE: 'Image';
UUID: 'UUID';

ABSTRACT: 'abstract';
ALL: 'all';
ALWAYS: 'always';
AND: 'and';
ANY: 'any';
AS: 'as';
ASC: 'asc' | 'ascending';
ATTR: 'attr';
ATTRIBUTE: 'attribute';
ATTRIBUTES: 'attributes';
BINDINGS: 'bindings';
BY: 'by';
CASE: 'case';
CATCH: 'catch';
CATEGORY: 'category';
CLASS: 'class';
CLOSE: 'close';
CONTAINS: 'contains';
DEF: 'def';
DEFAULT: 'default';
DEFINE: 'define';
DESC: 'desc' | 'descending';
DO: 'do';
DOING: 'doing';
EACH: 'each';
ELSE: 'else';
ENUM: 'enum';
ENUMERATED: 'enumerated';
EXCEPT: 'except';
EXECUTE: 'execute';
EXPECTING: 'expecting';
EXTENDS: 'extends';
FETCH: 'fetch';
FINALLY: 'finally';
FOR: 'for';
FROM: 'from';
GETTER: 'getter';
IF: 'if';
IN: 'in';
INVOKE: 'invoke';
IS: 'is';
MATCHING: 'matching';
METHOD: 'method';
METHODS: 'methods';
MODULO: 'modulo';
MUTABLE: 'mutable';
NATIVE: 'native';
NONE: 'None';
NOT: 'not';
NOTHING: 'nothing' | 'Nothing';
NULL: 'null';
ON: 'on';
ONE: 'one';
OPEN: 'open';
OPERATOR: 'operator';
OR: 'or';
ORDER: 'order';
OTHERWISE: 'otherwise';
PASS: 'pass';
RAISE: 'raise';
READ: 'read';
RECEIVING: 'receiving';
RESOURCE: 'resource';
RETURN: 'return';
RETURNING: 'returning';
ROWS: 'rows';
SELF: 'self';
SETTER: 'setter';
SINGLETON: 'singleton';
SORTED: 'sorted';
STORABLE: 'storable';
STORE: 'store';
SWITCH: 'switch';
TEST: 'test';
THIS: 'this';
THROW: 'throw';
TO: 'to';
TRY: 'try';
VERIFYING: 'verifying';
WITH: 'with';
WHEN: 'when';
WHERE: 'where';
WHILE: 'while';
WRITE: 'write';

BOOLEAN_LITERAL :
    'true' | 'True' | 'false' | 'False'
    ;

CHAR_LITERAL :   
    '\'' ( EscapeSequence | ~( '\\' | '\'' | '\r' | '\n' ) ) '\'' 
    ;

MIN_INTEGER:
	'MIN_INTEGER'
	;
	    
MAX_INTEGER:
	'MAX_INTEGER'
	;
	    
SYMBOL_IDENTIFIER :
    'A'..'Z' ('A'..'Z' | '_' | Digit)+
    ;

TYPE_IDENTIFIER :
    'A'..'Z' IdentifierSuffix
    ;

VARIABLE_IDENTIFIER :
    'a'..'z' IdentifierSuffix
  ;
  
NATIVE_IDENTIFIER :
    Letter IdentifierSuffix
  ;
  
DOLLAR_IDENTIFIER :  
  '$' IdentifierSuffix
  ;
  
fragment
IdentifierSuffix :
    ( Letter | Digit )* 
    ;

fragment
Letter :
    'a'..'z'|'A'..'Z'|'_'
    ;
  
fragment
Digit :
    '0'..'9'
    ;
    
TEXT_LITERAL :   
    '"' (   EscapeSequence |   ~( '\\' | '"' | '\r' | '\n' ) )* '"' 
    ;

INTEGER_LITERAL
    : Integer
    ;    
    
HEXA_LITERAL
    : Hexadecimal
    ;    

DECIMAL_LITERAL
    : Decimal 
    ;    

fragment
Integer :
    '0' | '1'..'9' ('0'..'9')*
    ;
    
fragment
Decimal :
    Integer DOT ('0'..'9')+ Exponent?
    ;

    
fragment
Exponent :
    ( 'e' | 'E' ) ( '+' | '-' )? ( '0' .. '9' )+ 
    ;
    
fragment
Hexadecimal :
    ( '0x' | '0X' ) ('0'..'9'|'a'..'f'|'A'..'F')+
    ;
    
fragment
EscapeSequence 
    :   '\\' (
                 'b' 
             |   't' 
             |   'n' 
             |   'f' 
             |   'r' 
             |   '\"' 
             |   '\'' 
             |   '\\' 
             |       
                 ('0'..'3') ('0'..'7') ('0'..'7')
             |       
                 ('0'..'7') ('0'..'7') 
             |       
                 ('0'..'7')
             )          
;  

DATETIME_LITERAL    
   : '\'' Date 'T' Time TimeZone? '\''
   ;
 

TIME_LITERAL
    : '\'' Time '\''
    ;

fragment
Time :
    '0'..'2' '0'..'9' 
    ':' '0'..'5' '0'..'9'
    (':' '0'..'5' '0'..'9' ( '.' '0'..'9' ('0'..'9' ('0'..'9')? )? )? )? 
    ;
        
DATE_LITERAL
    : '\'' Date '\''
    ;
    
fragment
Date :
    '0'..'9' '0'..'9' '0'..'9' '0'..'9'
    '-' '0'..'1' '0'..'9'
    '-' '0'..'3' '0'..'9'
    ;
    
fragment
TimeZone :
    'Z' | ( ('+' | '-') '0'..'1' '0'..'9' ':' '0'..'9' '0'..'9' )
    ;
    
PERIOD_LITERAL
    : '\'' 'P' Years? Months? Days? 
      ( ( 'T' Hours Minutes? Seconds?  )
        | ( 'T' Minutes Seconds?  )
         | ( 'T' Seconds ) )? '\''
    ;
   
fragment
Years :
    Integer 'Y'
    ;
    
fragment
Months :
    Integer 'M'
    ;
    
fragment
Days :
    Integer 'D'
    ;
    
fragment
Hours :
    Integer 'H'
    ;

fragment
Minutes :
    Integer 'M'
    ;

fragment
Seconds :
    Integer ('.' ('0')* Integer)? 'S'
    ;

