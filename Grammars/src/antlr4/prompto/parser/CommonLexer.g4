lexer grammar CommonLexer;

JAVA: 'Java:';
CSHARP: 'C#:';
PYTHON2: 'Python2:';
PYTHON3: 'Python3:';
JAVASCRIPT: 'JavaScript:';
SWIFT: 'Swift:';

COLON: ':';
SEMI: ';';
COMMA: ','('\n')?;
RANGE: '..';
DOT: '.'('\n')?;
LPAR: '('('\n')?;
RPAR: ('\n'(' '|'\t')*)? ')';
LBRAK: '['('\n')?;
RBRAK: ('\n'(' '|'\t')*)?']';
LCURL: '{'('\n')?;
RCURL: ('\n'(' '|'\t')*)?'}';
QMARK: '?'('\n')?;
XMARK: '!';
AMP: '&';
AMP2: '&&';
PIPE: '|';
PIPE2: '||';
PLUS: '+'('\n')?;
MINUS: '-';
STAR: '*';
SLASH: '/';
BSLASH: '\\';
PERCENT: '%';
SHARP: '#'; // needed for css text
GT: '>';
GTE: '>=';
LT: '<';
LTE: '<=';
LTGT: '<>';
LTCOLONGT: '<:>';
EQ: '=';
XEQ: '!=';
EQ2: '==';
TEQ: '~=';
TILDE: '~';
LARROW: '<-';
RARROW: '->';
EGT: '=>';

// when adding keywords, remember to update the 'keyword' rule in CommonParser
BOOLEAN: 'Boolean';
CSS: 'Css';
CHARACTER: 'Character';
TEXT: 'Text';
INTEGER: 'Integer';
DECIMAL: 'Decimal';
DATE: 'Date';
TIME: 'Time';
DATETIME: 'DateTime';
PERIOD: 'Period';
VERSION: 'Version';
METHOD_COLON: 'Method:';
CODE: 'Code';
DOCUMENT: 'Document';
BLOB: 'Blob';
IMAGE: 'Image';
UUID: 'Uuid';
DBID: 'DbId';
ITERATOR: 'Iterator';
CURSOR: 'Cursor';
HTML: 'Html';
TYPE: 'Type';

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
BREAK: 'break';
BY: 'by';
CASE: 'case';
CATCH: 'catch';
CATEGORY: 'category';
CLASS: 'class';
CONTAINS: 'contains';
DEF: 'def';
DEFAULT: 'default';
DEFINE: 'define';
DELETE: 'delete';
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
FILTERED: 'filtered';
FINALLY: 'finally';
FLUSH: 'flush';
FOR: 'for';
FROM: 'from';
GETTER: 'getter';
HAS: 'has';
IF: 'if';
IN: 'in';
INDEX: 'index';
INVOKE_COLON: 'invoke:';
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
SUPER: 'super';
SWITCH: 'switch';
TEST: 'test';
THEN: 'then';
THIS: 'this';
THROW: 'throw';
TO: 'to';
TRY: 'try';
VERIFYING: 'verifying';
WIDGET: 'widget';
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
    [A-Z] [A-Z0-9_]*
    ;

TYPE_IDENTIFIER :
    [A-Z] LetterOrDigit*
    ;

VARIABLE_IDENTIFIER :
    [a-z] LetterOrDigit*
  ;

// allow '_' as first char in native expressions  
NATIVE_IDENTIFIER :
    '_' LetterOrDigit*
  ;
  
DOLLAR_IDENTIFIER :
  '$' LetterOrDigit+
  ;

ARONDBASE_IDENTIFIER:
  '@' [A-Za-z0-9_]+
  ;

fragment
LetterOrDigit :
    Letter | Digit 
    ;

fragment
Letter :
    [a-zA-Z_]
    ;
  
fragment
Digit :
    [0-9]
    ;
    
TEXT_LITERAL :   
    '"' (   EscapeSequence |   ~( '\\' | '"' | '\r' | '\n' ) )* '"' 
    ;

UUID_LITERAL :
	'\'' HexByte HexByte HexByte HexByte '-' HexByte HexByte '-' HexByte HexByte '-' HexByte HexByte '-'
	 HexByte HexByte HexByte HexByte HexByte HexByte '\''
	;

VERSION_LITERAL
    : '\'v' Integer DOT Integer (DOT Integer)? ( MINUS VersionQualifier )? '\''
    | '\'latest\'' 
    | '\'development\'' 
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
    '0' | [1-9] [0-9]*
    ;
    
fragment
Decimal :
    Integer DOT [0-9]+ Exponent?
    ;

    
fragment
Exponent :
    ( 'e' | 'E' ) ( '+' | '-' )? ( '0' .. '9' )+ 
    ;
    
fragment
Hexadecimal :
    ( '0x' | '0X' ) HexNibble+
    ;
    
fragment
HexNibble :    
	[0-9a-fA-F]
	;
	  
fragment
EscapeSequence 
    :   '\\' (
                 'b' 
             |   't' 
             |   'n' 
             |   'f' 
             |   'r' 
             |   '\'' 
             |   '"' 
             |   '\\' 
             | 	 'u' ('0'..'9'|'a'..'f'|'A'..'F')+
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
    (':' '0'..'5' '0'..'9' ( DOT '0'..'9' ('0'..'9' ('0'..'9')? )? )? )? 
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
    : '\'' 'P' Years? Months? Weeks? Days? 
      ( ( 'T' Hours Minutes? Seconds?  )
        | ( 'T' Minutes Seconds?  )
         | ( 'T' Seconds ) )? '\''
    ;
   
fragment
Years :
    '-'? Integer 'Y'
    ;
    
fragment
Months :
    '-'? Integer 'M'
    ;
    
fragment
Weeks :
    '-'? Integer 'W'
    ;

fragment
Days :
    '-'? Integer 'D'
    ;
    
fragment
Hours :
    '-'? Integer 'H'
    ;

fragment
Minutes :
    '-'? Integer 'M'
    ;

fragment
Seconds :
    '-'? Integer (DOT ('0')* Integer)? 'S'
    ;

fragment
HexByte :
	HexNibble HexNibble
	;
	
fragment
VersionQualifier :
	'alpha' | 'beta' | 'candidate'
	;
		
JSX_TEXT:
    (~('{'|'}'|'<'|'>'))+?
    ;


   