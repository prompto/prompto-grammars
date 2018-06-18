parser grammar WParser;

options {
  tokenVocab = WLexer;
  superClass = AbstractParser;
}

import OParser;

literal_expression:
  atomic_literal
  | collection_literal
  | jsx_literal
  ;


jsx_literal:
    jsx_element
    | jsx_fragment
    ;

jsx_element:
    jsx__self_closing
    | jsx_opening jsx_children? jsx_closing
    ;

jsx_fragment:
    jsx_fragment_start jsx_children? jsx_fragment_end
    ;

jsx_fragment_start:
    LT GT
    | LTGT
    ;

jsx_fragment_end:
    LT SLASH GT
    ;

jsx__self_closing:
    LT name=jsx_element_name (attributes=jsx_attribute)* SLASH GT
    ;

jsx_opening:
    LT name=jsx_element_name (attributes=jsx_attribute)* GT
    ;

jsx_closing:
    LT SLASH name=jsx_element_name GT
    ;

jsx_element_name:
    jsx_identifier (DOT jsx_identifier)*
    ;

jsx_identifier:
    identifier (jsx_hyphen_identifier)*
    ;

jsx_hyphen_identifier:
    {$parser.wasNot(OParser.WS)}? MINUS hyphen_identifier
    ;

hyphen_identifier:
    {$parser.wasNot(OParser.WS)}? identifier
    ;

jsx_attribute:
    jsx_identifier (EQ jsx_attribute_value)?
    ;

jsx_attribute_value:
    TEXT_LITERAL
    | LCURL expression RCURL
    ;

jsx_children:
    jsx_child+
    ;

jsx_child:
    jsx_text
    | jsx_element
    | LCURL expression? RCURL
    ;

jsx_text:
    ~(LCURL | RCURL | LT | GT)+
    ;