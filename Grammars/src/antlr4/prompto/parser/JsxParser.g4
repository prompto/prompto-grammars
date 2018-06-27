parser grammar JsxParser;

jsx_expression:
    jsx_element
    | jsx_fragment
    ;

jsx_element:
    jsx=jsx_self_closing                                     #JsxSelfClosing
    | jsx=jsx_opening children_=jsx_children? jsx_closing    #JsxElement
    ;

jsx_fragment:
    jsx_fragment_start children_=jsx_children? jsx_fragment_end
    ;


jsx_fragment_start:
    LT GT
    | LTGT
    ;


jsx_fragment_end:
    LT SLASH GT
    ;

jsx_self_closing:
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
    identifier_or_keyword (jsx_hyphen_identifier)*
    ;


jsx_hyphen_identifier:
    {$parser.wasNotWhiteSpace()}? MINUS hyphen_identifier
    ;


hyphen_identifier:
    {$parser.wasNotWhiteSpace()}? identifier_or_keyword
    ;


identifier_or_keyword:
    identifier
    | keyword
    ;


jsx_attribute:
    name=jsx_identifier (EQ value=jsx_attribute_value)?
    ;

jsx_attribute_value:
    TEXT_LITERAL                        #JsxLiteral
    | LCURL exp=expression RCURL        #JsxValue
    ;

jsx_children:
    jsx_child+
    ;

jsx_child:
    text=jsx_text                        #JsxText
    | jsx=jsx_element                    #JsxChild
    | LCURL exp=expression? RCURL        #JsxCode
    ;

jsx_text:
    ~(LCURL | RCURL | LT | GT)+
    ;