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
  javascript_this_expression
  | javascript_new_expression
  | javascript_parenthesis_expression		
  | javascript_identifier_expression	
  | javascript_literal_expression		
  | javascript_method_expression		
  | javascript_item_expression		
  ;

javascript_this_expression:
  this_expression
  ;
    
javascript_new_expression:
  new_token javascript_method_expression
  ;

javascript_selector_expression:		
  DOT method=javascript_method_expression	# JavaScriptMethodExpression		
  | DOT name=javascript_identifier			# JavaScriptMemberExpression
  | exp=javascript_item_expression			# JavaScriptItemExpression
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
  name=javascript_identifier 
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
  
