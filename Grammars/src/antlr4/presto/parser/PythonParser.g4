parser grammar PythonParser;

python_statement: 
  RETURN exp=python_expression	# PythonReturnStatement
  | exp=python_expression		# PythonStatement
  ;

python_expression: 
  exp=python_primary_expression 	# PythonPrimaryExpression
  | parent=python_expression
  	child=python_selector_expression # PythonSelectorExpression
  ;

python_primary_expression: 
  exp=python_parenthesis_expression		# PythonParenthesisExpression
  | exp=python_identifier_expression	# PythonIdentifierExpression
  | exp=python_literal_expression		# PythonLiteralExpression
  | exp=python_method_expression		# PythonGlobalMethodExpression
  ;
  
python_selector_expression:
  DOT exp=python_method_expression		# PythonMethodExpression
  | LBRAK exp=python_expression RBRAK	# PythonItemExpression			
  ;

python_method_expression:
  name=python_identifier 
  	LPAR ( args=python_argument_list )? RPAR
  ;
  
python_argument_list:   
  ordinal=python_ordinal_argument_list		# PythonOrdinalOnlyArgumentList
  | named=python_named_argument_list	# PythonNamedOnlyArgumentList
  | ordinal=python_ordinal_argument_list 
  	COMMA named=python_named_argument_list	# PythonArgumentList
  ;

python_ordinal_argument_list:   
  item=python_expression 				# PythonOrdinalArgumentList
  | items=python_ordinal_argument_list
  		COMMA item=python_expression			# PythonOrdinalArgumentListItem
  ;	 

python_named_argument_list:   
  name=python_identifier EQ exp=python_expression	# PythonNamedArgumentList
  | items=python_named_argument_list COMMA 
  	name=python_identifier EQ exp=python_expression	# PythonNamedArgumentListItem
  ;	 
      
python_parenthesis_expression:
  LPAR exp=python_expression RPAR
  ;  
  
python_identifier_expression:
  name=python_identifier 		# PythonIdentifier
  | parent=python_identifier_expression
  	DOT name=python_identifier	# PythonChildIdentifier
  ;  

   
python_literal_expression:
  t=INTEGER_LITERAL		# PythonIntegerLiteral
  | t=DECIMAL_LITERAL	# PythonDecimalLiteral
  | t=TEXT_LITERAL		# PythonTextLiteral
  | t=BOOLEAN_LITERAL	# PythonBooleanLiteral
  | t=CHAR_LITERAL		# PythonCharacterLiteral
  ;    


python_identifier:
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
  ;
 

