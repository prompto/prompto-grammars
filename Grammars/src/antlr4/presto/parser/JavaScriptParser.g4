parser grammar JavaScriptParser;

javascript_statement: 
  RETURN exp=javascript_expression SEMI	# JavascriptReturnStatement
  | exp=javascript_expression SEMI		# JavascriptStatement
  ;

javascript_expression: 
  exp=javascript_primary_expression			# JavascriptPrimaryExpression
  | parent=javascript_expression			
  	child=javascript_selector_expression	# JavascriptSelectorExpression
  ;

javascript_primary_expression: 
  exp=javascript_parenthesis_expression		# JavascriptParenthesisExpression
  | exp=javascript_identifier_expression	# JavascriptIdentifierExpression
  | exp=javascript_literal_expression		# JavascriptLiteralExpression
  ;
  
javascript_selector_expression:		
  DOT exp=javascript_method_expression		# JavascriptMethodExpression
  | exp=javascript_item_expression			# JavascriptItemExpression
  ;
  
javascript_method_expression:
  name=javascript_identifier LPAR (args=javascript_arguments)? RPAR
  ;
  
javascript_arguments:
  item=javascript_expression 			# JavascriptArgumentList
  | items=javascript_arguments 
  	COMMA item=javascript_expression	# JavascriptArgumentListItem
  ;
  
javascript_item_expression :   
  LBRAK exp=javascript_expression RBRAK
  ;
  
javascript_parenthesis_expression:
  LPAR exp=javascript_expression RPAR
  ;  
  
javascript_identifier_expression:
  name=javascript_identifier 				# JavascriptIdentifier
  | parent=javascript_identifier_expression 
  	DOT name=javascript_identifier			# JavascriptChildIdentifier
  ;  
      
javascript_literal_expression:
  t=INTEGER_LITERAL		# JavascriptIntegerLiteral
  | t=DECIMAL_LITERAL	# JavascriptDecimalLiteral
  | t=TEXT_LITERAL		# JavascriptTextLiteral
  | t=BOOLEAN_LITERAL	# JavascriptBooleanLiteral
  | t=CHAR_LITERAL		# JavascriptCharacterLiteral
  ;    


javascript_identifier:
  VARIABLE_IDENTIFIER
  | SYMBOL_IDENTIFIER
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
  | READ
  | WRITE
  | TEST
  ;
 
  
