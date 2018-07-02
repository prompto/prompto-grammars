parser grammar CssParser;

css_expression:
    LCURL field=css_field+ RCURL
    ;

css_field:
    name=css_identifier COLON value=css_value SEMI
    ;

css_identifier:
    identifier_or_keyword
    | MINUS nospace_identifier_or_keyword
    |  css_identifier nospace_hyphen_identifier_or_keyword+
    ;

css_value:
    LCURL exp=expression RCURL      # CssValue
    | text=css_text                 # CssText
    ;

css_text:
    ~(LCURL | RCURL | COLON | SEMI | WS)+
    ;

nospace_hyphen_identifier_or_keyword: DOT;
nospace_identifier_or_keyword: DOT;
identifier_or_keyword: DOT;
expression: DOT;