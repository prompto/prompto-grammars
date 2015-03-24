parser grammar CSharpParser;

csharp_statement: 
  RETURN exp=csharp_expression SEMI 		# CSharpReturnStatement
  | exp=csharp_expression SEMI 				# CSharpStatement
  ;

csharp_expression: 
  exp=csharp_primary_expression 		# CSharpPrimaryExpression
  | parent=csharp_expression
  	child=csharp_selector_expression 	# CSharpSelectorExpression
  ;

csharp_primary_expression: 
  exp=csharp_parenthesis_expression		# CSharpParenthesisExpression
  | exp=csharp_identifier_expression	# CSharpIdentifierExpression
  | exp=csharp_literal_expression		# CSharpLiteralExpression
  ;
  
csharp_selector_expression:
  DOT exp=csharp_method_expression		# CSharpMethodExpression
  | exp=csharp_item_expression			# CSharpItemExpression
  ;
  
csharp_method_expression:
   name=csharp_identifier LPAR ( args=csharp_arguments )? RPAR
  ;

csharp_arguments:
  item=csharp_expression 				# CSharpArgumentList
  | items=csharp_arguments 
  	COMMA item=csharp_expression		# CSharpArgumentListItem
  ;
  
csharp_item_expression:   
  LBRAK exp=csharp_expression RBRAK
  ;
  
csharp_parenthesis_expression:
  LPAR exp=csharp_expression RPAR
  ;  
  
csharp_identifier_expression:
  name=csharp_identifier 			# CSharpIdentifier
  | parent=csharp_identifier_expression
  	DOT name=csharp_identifier		# CSharpChildIdentifier
  ;  
  
csharp_literal_expression:
  INTEGER_LITERAL			# CSharpIntegerLiteral
  | DECIMAL_LITERAL			# CSharpDecimalLiteral
  | TEXT_LITERAL			# CSharpTextLiteral
  | BOOLEAN_LITERAL			# CSharpBooleanLiteral
  | CHAR_LITERAL			# CSharpCharacterLiteral
  ;    

csharp_identifier:
  VARIABLE_IDENTIFIER
  | SYMBOL_IDENTIFIER
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
  | READ
  | WRITE
  | TEST
  ;

