parser grammar ArgsParser;

options {
  tokenVocab = ArgsLexer;
}

parse:
  ( e=entry )*
  ;
  
entry:
  ( DASH )? k=key EQUALS v=value
  ;
  
key:
  ELEMENT 
  ;
  
value:
  ELEMENT #ELEMENT
  | STRING #STRING
  ;
  
  
