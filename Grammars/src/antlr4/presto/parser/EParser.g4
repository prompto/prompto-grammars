parser grammar EParser;

options {
  tokenVocab = ELexer;
  superClass = AbstractParser; 
}

import CommonParser;

enum_category_declaration:
  DEFINE name=type_identifier AS COLON ENUMERATED 
  	(CATEGORY | derived=type_identifier)
  	((attrs=attribute_list COMMA AND) | WITH)
    symbols_token COLON
    indent symbols=category_symbol_list dedent
  ;

enum_native_declaration:
  DEFINE name=type_identifier AS COLON ENUMERATED 
  	typ=native_type 
  	WITH symbols_token COLON 
  	indent symbols=native_symbol_list dedent
  ;

native_symbol: 
  name=symbol_identifier WITH exp=expression AS value_token
  ;
  
category_symbol: 
  name=symbol_identifier 
  args=with_argument_assignment_list 
  (AND arg=argument_assignment)?
  ;
  
attribute_declaration:
   DEFINE name=variable_identifier AS COLON 
   	typ=typedef ATTRIBUTE (match=attribute_constraint)?
  ;

concrete_category_declaration:
  DEFINE name=type_identifier AS COLON 
  	( CATEGORY | derived=derived_list )
  	( ( attrs=attribute_list  
	  	( COMMA AND METHODS COLON 
	  		indent methods=member_method_declaration_list dedent )? )
	  | ( WITH METHODS COLON 
	  		indent methods=member_method_declaration_list dedent )
	 ) ?
  ;

singleton_category_declaration:
  DEFINE name=type_identifier AS COLON 
  	SINGLETON
  	( ( attrs=attribute_list  
	  	( COMMA AND METHODS COLON 
	  		indent methods=member_method_declaration_list dedent )? )
	  | ( WITH METHODS COLON 
	  		indent methods=member_method_declaration_list dedent )
	 ) ?
  ;
  
derived_list:
  items=type_identifier_list		# DerivedList
  | items=type_identifier_list
  	AND item=type_identifier		# DerivedListItem
  ;

operator_method_declaration: 
  DEFINE op=operator AS COLON OPERATOR   
    RECEIVING COLON arg=operator_argument
    (RETURNING COLON typ=typedef)?
    DOING COLON
    indent stmts=statement_list dedent
  ;
  
setter_method_declaration:
  DEFINE name=variable_identifier SETTER DOING COLON 
  	indent stmts=statement_list dedent
  ;
   
getter_method_declaration:
  DEFINE name=variable_identifier GETTER DOING COLON
  	indent stmts=statement_list dedent
  ;
  
native_category_declaration:
  DEFINE name=type_identifier AS COLON NATIVE CATEGORY 
   ((attrs=attribute_list COMMA AND BINDINGS) | WITH BINDINGS) COLON 
    indent bindings=native_category_bindings dedent
    (lfp AND METHODS COLON 
    	indent methods=native_member_method_declaration_list dedent
    )?
  ;

native_resource_declaration:
  DEFINE name=type_identifier AS COLON NATIVE RESOURCE 
    ((attrs=attribute_list COMMA AND BINDINGS) | WITH BINDINGS) COLON 
    indent bindings=native_category_bindings dedent
    (lfp AND METHODS COLON 
    	indent methods=native_member_method_declaration_list dedent
    )?
  ;

native_category_bindings:
  DEFINE CATEGORY BINDINGS AS COLON
  indent items=native_category_binding_list dedent
  ; 

native_category_binding_list:
  item=native_category_binding			# NativeCategoryBindingList
  | items=native_category_binding_list 
  	lfp item=native_category_binding	# NativeCategoryBindingListItem
  ;

attribute_list:
  WITH ATTRIBUTE COLON item=variable_identifier 	# AttributeList
  | WITH ATTRIBUTES COLON items=variable_identifier_list
   	(AND item=variable_identifier)? 				# AttributeListItem
  ;

abstract_method_declaration:
  DEFINE name=method_identifier AS COLON ABSTRACT METHOD 
    (RECEIVING COLON args=full_argument_list)? 
    (RETURNING COLON typ=typedef)?
  ;  

concrete_method_declaration:
  DEFINE name=method_identifier AS COLON METHOD
    (RECEIVING COLON args=full_argument_list)? 
    (RETURNING COLON typ=typedef)?
    DOING COLON 
    indent stmts=statement_list dedent
  ;  

native_method_declaration:
  DEFINE name=method_identifier AS COLON NATIVE METHOD 
    (RECEIVING COLON args=full_argument_list)? 
    (RETURNING COLON typ=category_or_any_type)?
    DOING COLON 
    indent stmts=native_statement_list dedent
  ;  

test_method_declaration:
  DEFINE name=TEXT_LITERAL AS COLON TEST METHOD DOING COLON 
    indent stmts=statement_list dedent
  lfp AND EXPECTING COLON
    ((indent exps=assertion_list dedent) | error=symbol_identifier)
  ;  
  
assertion:
	exp=expression
	;
	  
full_argument_list:
  items=argument_list
   (AND item=argument)?
   ;
     
typed_argument:
  typ = category_or_any_type 
  	name=variable_identifier					
  	(attrs=attribute_list)? 
  	( EQ value=literal_expression)?
  ;
    
statement: 
  stmt=assign_instance_statement			# AssignInstanceStatement
  | stmt=method_call_statement				# MethodCallStatement
  | stmt=assign_tuple_statement				# AssignTupleStatement
  | stmt=return_statement					# ReturnStatement
  | stmt=if_statement						# IfStatement
  | stmt=switch_statement					# SwitchStatement
  | stmt=for_each_statement					# ForEachStatement
  | stmt=while_statement					# WhileStatement
  | stmt=do_while_statement					# DoWhileStatement 
  | stmt=raise_statement					# RaiseStatement
  | stmt=try_statement						# TryStatement
  | stmt=write_statement					# WriteStatement
  | stmt=with_resource_statement			# WithResourceStatement
  | stmt=with_singleton_statement			# WithSingletonStatement
  | decl=concrete_method_declaration		# ClosureStatement
  ;
  
method_call_statement:  
  exp=unresolved_expression 
  	(args=argument_assignment_list)?  		# UnresolvedWithArgsStatement
  | exp=invocation_expression 				# InvokeStatement	
  ;
  
with_resource_statement:
  WITH stmt=assign_variable_statement COMMA DO COLON 
  	indent stmts=statement_list dedent
  ;
    
with_singleton_statement:
  WITH typ=type_identifier COMMA DO COLON 
  	indent stmts=statement_list dedent
  ;

switch_statement: 
  SWITCH ON exp=expression COLON indent
  	cases=switch_case_statement_list
  	( lfp OTHERWISE COLON indent stmts=statement_list dedent )? 
  	dedent
  ;

switch_case_statement:
  WHEN exp=atomic_literal COLON
  	indent stmts=statement_list dedent	# AtomicSwitchCase
  | WHEN IN exp=literal_collection COLON
  	indent stmts=statement_list dedent	# CollectionSwitchCase
  ;
      
for_each_statement:
  FOR EACH name1=variable_identifier 
  	(COMMA name2=variable_identifier)? 
    IN source=expression COLON
    indent stmts=statement_list dedent
  ;

do_while_statement:
  DO COLON 
  	indent stmts=statement_list dedent
  	lfp WHILE exp=expression
  ;

while_statement:
  WHILE exp=expression COLON
  	indent stmts=statement_list dedent
  ;


if_statement:
  IF exp=expression COLON 
  	indent stmts=statement_list dedent
  	( lfp elseIfs=else_if_statement_list )?
  	( lfp ELSE COLON indent elseStmts=statement_list dedent )? 
  ;

else_if_statement_list:
  ELSE IF exp=expression COLON 
  	indent stmts=statement_list dedent 	# ElseIfStatementList
  | items=else_if_statement_list
  	lfp ELSE IF exp=expression COLON
  	indent stmts=statement_list dedent # ElseIfStatementListItem
  ;

raise_statement: 
  RAISE exp=expression
  ; 

try_statement:
  SWITCH ON  name=variable_identifier DOING COLON
  	indent stmts=statement_list dedent lfs
    ( handlers=catch_statement_list )? 
    ( (OTHERWISE | (WHEN ANY)) COLON
    	indent anyStmts=statement_list dedent lfs )? 
    ( ALWAYS COLON
    	indent finalStmts=statement_list dedent lfs )? 
    lfs
  ;

catch_statement:
  WHEN name=symbol_identifier COLON
  	indent stmts=statement_list dedent lfs # CatchAtomicStatement
  | WHEN IN LBRAK exp=symbol_list RBRAK COLON
  	indent stmts=statement_list dedent lfs # CatchCollectionStatement
  ;    

return_statement:
  RETURN exp=expression?
  ;
    
expression:
  // an expression ending with slice or item	
  exp=instance_expression									# InstanceExpression
  // any standalone expression ending with an identifier
  | exp=unresolved_expression								# UnresolvedExpression							
  // an ambiguous expression followed by arguments
  | exp=unresolved_expression 
  	args=argument_assignment_list							# MethodCallExpression
  | MINUS exp=expression									# MinusExpression
  | NOT exp=expression										# NotExpression
  | left=expression multiply right=expression 				# MultiplyExpression
  | left=expression divide right=expression 				# DivideExpression
  | left=expression modulo right=expression 				# ModuloExpression
  | left=expression idivide right=expression 				# IntDivideExpression
  | left=expression op=(PLUS | MINUS) right=expression 		# AddExpression
  | left=expression LT right=expression						# LessThanExpression
  | left=expression LTE right=expression					# LessThanOrEqualExpression
  | left=expression GT right=expression						# GreaterThanExpression
  | left=expression GTE right=expression					# GreaterThanOrEqualExpression
  | left=expression IS NOT right=is_expression				# IsNotExpression
  | left=expression IS right=is_expression					# IsExpression
  | left=expression EQ right=expression						# EqualsExpression
  | left=expression LTGT right=expression					# NotEqualsExpression
  | left=expression TILDE right=expression					# RoughlyEqualsExpression
  | left=expression OR right=expression						# OrExpression
  | left=expression AND right=expression					# AndExpression
  | ifTrue=expression IF test=expression 
  		ELSE ifFalse=expression 							# TernaryExpression
  | left=expression AS right=category_or_any_type			# CastExpression
  | left=expression IN right=expression						# InExpression
  | left=expression CONTAINS right=expression				# ContainsExpression
  | left=expression CONTAINS ALL right=expression			# ContainsAllExpression
  | left=expression CONTAINS ANY right=expression			# ContainsAnyExpression
  | left=expression NOT IN right=expression					# NotInExpression
  | left=expression NOT CONTAINS right=expression			# NotContainsExpression
  | left=expression NOT CONTAINS ALL right=expression		# NotContainsAllExpression
  | left=expression NOT CONTAINS ANY right=expression		# NotContainsAnyExpression
  | CODE COLON exp=expression								# CodeExpression
  | EXECUTE COLON name=variable_identifier					# ExecuteExpression
  | METHOD_T COLON name=method_identifier					# ClosureExpression
  | exp=document_expression									# DocumentExpression
  | exp=constructor_expression								# ConstructorExpression
  | exp=fetch_expression									# FetchExpression
  | exp=read_expression										# ReadExpression
  | exp=sorted_expression									# SortedExpression
  | exp=ambiguous_expression								# AmbiguousExpression
  | exp=invocation_expression								# InvocationExpression
  ;

unresolved_expression: 
  name=identifier				    		# UnresolvedIdentifier
  | parent=unresolved_expression 
  	selector=unresolved_selector			# UnresolvedSelector
  ;
 
unresolved_selector:
  {$parser.wasNot(EParser.WS)}? DOT name=identifier 
  ;

invocation_expression:
  INVOKE COLON name=variable_identifier invocation_trailer
  ;

invocation_trailer:
  {$parser.willBe(EParser.LF)}?
  ;	

// specific case for unresolved which cannot be a method   
instance_expression:    
	parent=selectable_expression 		# SelectableExpression
	| parent=instance_expression 
		selector=instance_selector	   # SelectorExpression
	;
	
instance_selector:
  {$parser.wasNot(EParser.WS)}? DOT name=variable_identifier 				# MemberSelector
  | {$parser.wasNot(EParser.WS)}? LBRAK xslice=slice_arguments RBRAK		# SliceSelector
  |	{$parser.wasNot(EParser.WS)}? LBRAK exp=expression RBRAK				# ItemSelector
  ; 
 
document_expression:
  document_type
  ;

constructor_expression:
  MUTABLE? typ=category_type FROM firstArg=expression	
 	( (COMMA)? args=with_argument_assignment_list 
  		(AND arg=argument_assignment)? )?				# ConstructorFrom
  | MUTABLE? typ=category_type 
  	( args=with_argument_assignment_list
  		(AND arg=argument_assignment)? )?				# ConstructorNoFrom
  ;

read_expression:
  READ FROM source=expression
  ;
  
write_statement: 
  WRITE what=expression TO target=expression
  ;
  
ambiguous_expression:
  method=unresolved_expression MINUS exp=expression
  ;
  
fetch_expression:
  FETCH ANY name=variable_identifier FROM source=expression WHERE xfilter=expression
  ;  

sorted_expression:
  SORTED source=instance_expression
  	( WITH key=instance_expression AS key_token )?
  ;

  
argument_assignment_list:
  {$parser.was(EParser.WS)}? exp=expression
  	(items=with_argument_assignment_list
  	  (AND item=argument_assignment)?)?		# ArgumentAssignmentListExpression
  | items=with_argument_assignment_list
  	  (AND item=argument_assignment)?		# ArgumentAssignmentListNoExpression
  ;
  
with_argument_assignment_list:
  WITH item=argument_assignment				# ArgumentAssignmentList
  | items=with_argument_assignment_list
  	COMMA item=argument_assignment			# ArgumentAssignmentListItem
 ;
   
argument_assignment:
  exp=expression AS name=variable_identifier
  ;

assign_instance_statement: 
  inst=assignable_instance assign exp=expression
  ;  

child_instance:
  {$parser.wasNot(EParser.WS)}? DOT name=variable_identifier		# MemberInstance
  | {$parser.wasNot(EParser.WS)}? LBRAK exp=expression RBRAK 		# ItemInstance
  ;
    
assign_tuple_statement: 
  items=variable_identifier_list assign exp=expression
  ;

lfs:
  (LF)*
  ;  
  
lfp:
  (LF)+ 
  ;  
  
indent:
  (LF)+ INDENT
  ;
  
dedent:
  (LF)* DEDENT
  ;   
  
null_literal : NOTHING;
