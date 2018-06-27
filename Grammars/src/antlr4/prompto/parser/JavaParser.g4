parser grammar JavaParser;

java_statement: 
  RETURN exp=java_expression SEMI	# JavaReturnStatement
  | exp=java_expression SEMI		# JavaStatement
  ;

java_expression: 
  exp=java_primary_expression		# JavaPrimaryExpression
  | parent=java_expression			
  	child=java_selector_expression	# JavaSelectorExpression
  ;

java_primary_expression: 
  java_this_expression
  | java_new_expression
  | java_parenthesis_expression	
  | java_identifier_expression	
  | java_literal_expression		
  ;

java_this_expression:
  this_expression
  ;
    
java_new_expression:
  new_token java_method_expression
  ;

java_selector_expression:		
  DOT exp=java_method_expression	# JavaMethodExpression
  | exp=java_item_expression		# JavaItemExpression
  ;
  
java_method_expression:
  name=java_identifier LPAR (args=java_arguments)? RPAR
  ;
  
java_arguments:
  item=java_expression 			# JavaArgumentList
  | items=java_arguments 
  	COMMA item=java_expression	# JavaArgumentListItem
  ;
  
java_item_expression :   
  LBRAK exp=java_expression RBRAK
  ;
  
java_parenthesis_expression:
  LPAR exp=java_expression RPAR
  ;  
  
java_identifier_expression:
  name=java_identifier 				# JavaIdentifier
  | parent=java_identifier_expression 
  	DOT name=java_identifier		# JavaChildIdentifier
  ;  
  
java_class_identifier_expression:
  klass=java_identifier_expression  # JavaClassIdentifier
  | parent=java_class_identifier_expression
  	name=DOLLAR_IDENTIFIER 			# JavaChildClassIdentifier
  ;  
    
java_literal_expression:
  t=INTEGER_LITERAL		# JavaIntegerLiteral
  | t=DECIMAL_LITERAL	# JavaDecimalLiteral
  | t=TEXT_LITERAL		# JavaTextLiteral
  | t=BOOLEAN_LITERAL	# JavaBooleanLiteral
  | t=CHAR_LITERAL		# JavaCharacterLiteral
  ;    


java_identifier:
  VARIABLE_IDENTIFIER
  | SYMBOL_IDENTIFIER
  | NATIVE_IDENTIFIER
  | DOLLAR_IDENTIFIER
  | TYPE_IDENTIFIER
  | BOOLEAN
  | CHARACTER
  | TEXT
  | INTEGER
  | DECIMAL
  | DATE
  | TIME
  | DATETIME
  | PERIOD
  | VERSION
  | UUID
  | HTML
  | READ
  | WRITE
  | TEST
  | SELF
  | NONE
  | NULL
  ;
 
this_expression:; 
new_token:;
