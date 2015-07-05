parser grammar SParser;

options {
  tokenVocab = SLexer;
  superClass = AbstractParser; 
}

import CommonParser;

enum_category_declaration:
  ENUM name=type_identifier LPAR 
  	( derived=type_identifier (COMMA attrs=attribute_list)?
  	  | attrs=attribute_list ) RPAR COLON
    indent symbols=category_symbol_list dedent
  ;

enum_native_declaration:
  ENUM name=type_identifier LPAR typ=native_type RPAR COLON 
  	indent symbols=native_symbol_list dedent
  ;

native_symbol: 
  name=symbol_identifier EQ exp=expression
  ;
  
category_symbol: 
  name=symbol_identifier LPAR (args=argument_assignment_list)? RPAR
  ;
  
attribute_declaration:
   ATTR name=variable_identifier LPAR  typ=typedef RPAR COLON
   	indent (match=attribute_constraint | PASS) dedent
  ;

concrete_category_declaration:
  ( CLASS | CATEGORY ) name=type_identifier LPAR 
  	( derived=derived_list 
  	  | attrs=attribute_list  
  	  | derived=derived_list COMMA attrs=attribute_list ) 
  RPAR COLON
	  	indent ( methods=member_method_declaration_list | PASS ) dedent
  ;

singleton_category_declaration:
  SINGLETON name=type_identifier LPAR attrs=attribute_list RPAR COLON
	  	indent ( methods=member_method_declaration_list | PASS ) dedent
  ;

derived_list:
  items=type_identifier_list
  ;

operator_method_declaration: 
  DEF OPERATOR op=operator LPAR arg=operator_argument RPAR (RARROW typ=typedef)? COLON 
    indent stmts=statement_list dedent
  ;
  
setter_method_declaration:
  DEF name=variable_identifier SETTER LPAR RPAR COLON 
  	indent stmts=statement_list dedent
  ;
   
getter_method_declaration:
  DEF name=variable_identifier GETTER LPAR RPAR COLON
  	indent stmts=statement_list dedent
  ;
  
native_category_declaration:
  NATIVE ( CLASS | CATEGORY ) name=type_identifier LPAR attrs=attribute_list? RPAR COLON  
    indent 
    bindings=native_category_bindings 
    (lfp methods=native_member_method_declaration_list)?
    dedent
  ;

native_resource_declaration:
  NATIVE RESOURCE name=type_identifier LPAR attrs=attribute_list? RPAR COLON  
    indent 
    bindings=native_category_bindings 
    (lfp methods=native_member_method_declaration_list)?
    dedent
  ;

native_category_bindings:
  DEF ( CLASS | CATEGORY ) BINDINGS COLON
  indent items=native_category_binding_list dedent
  ; 

native_category_binding_list:
  item=native_category_binding			# NativeCategoryBindingList
  | items=native_category_binding_list 
  	lfp item=native_category_binding	# NativeCategoryBindingListItem
  ;

attribute_list:
  items=variable_identifier_list
  ;

abstract_method_declaration:
  ABSTRACT DEF name=method_identifier LPAR args=argument_list? RPAR 
    (RARROW typ=typedef)?
  ;  

concrete_method_declaration:
  DEF name=method_identifier LPAR args=argument_list? RPAR (RARROW typ=typedef)? COLON 
    indent stmts=statement_list dedent
  ;  

native_method_declaration:
  DEF NATIVE name=method_identifier LPAR args=argument_list? RPAR (RARROW typ=category_or_any_type)? COLON 
    indent stmts=native_statement_list dedent
  ;  

test_method_declaration:
  DEF TEST name=TEXT_LITERAL LPAR RPAR COLON
    indent stmts=statement_list dedent
  	lfp EXPECTING COLON
    ((indent exps=assertion_list dedent) | (error=symbol_identifier))
  ;  
  
assertion:
	exp=expression
	;

typed_argument:
  name=variable_identifier COLON 
  	typ = category_or_any_type 
  	( LPAR attrs=attribute_list RPAR )? 
  	( EQ value=literal_expression )?
  ;
    
statement: 
  stmt=method_call							# MethodCallStatement
  | stmt=assign_instance_statement			# AssignInstanceStatement
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
  
method_call:  
  method=method_selector LPAR (args=argument_assignment_list)? RPAR
  ;
  
method_selector:
  name=method_identifier					# MethodName
  | parent=callable_parent 
  	DOT name=method_identifier				# MethodParent
  ;

callable_parent:
  name=identifier							# CallableRoot
  | parent=callable_parent 
  	select=callable_selector				# CallableSelector
  ;

callable_selector:
  DOT name=variable_identifier 				# CallableMemberSelector
  | LBRAK exp=expression RBRAK				# CallableItemSelector
  ;
    
with_resource_statement:
  WITH stmt=assign_variable_statement COLON 
  	indent stmts=statement_list dedent
  ;
    
with_singleton_statement:
  WITH typ=type_identifier COLON 
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
  FOR name1=variable_identifier 
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
  TRY  name=variable_identifier COLON
  	indent stmts=statement_list dedent lfs
    ( handlers=catch_statement_list )? 
    ( EXCEPT COLON
    	indent anyStmts=statement_list dedent lfs )? 
    ( FINALLY COLON
    	indent finalStmts=statement_list dedent lfs )? 
    lfs
  ;

catch_statement:
  EXCEPT name=symbol_identifier COLON
  	indent stmts=statement_list dedent lfs # CatchAtomicStatement
  | EXCEPT IN LBRAK exp=symbol_list RBRAK COLON
  	indent stmts=statement_list dedent lfs # CatchCollectionStatement
  ;    

return_statement:
  RETURN exp=expression?
  ;
    
expression:
  exp=instance_expression									# InstanceExpression	
  | exp=method_expression									# MethodExpression
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
  | left=expression EQ2 right=expression					# EqualsExpression
  | left=expression XEQ right=expression					# NotEqualsExpression
  | left=expression TEQ right=expression					# RoughlyEqualsExpression
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
  | CODE LPAR exp=expression RPAR							# CodeExpression
  | EXECUTE LPAR name=variable_identifier RPAR				# ExecuteExpression
  | exp=closure_expression									# ClosureExpression
  ;

closure_expression:
  // given the context, this can only occur for a standalone type identifier
  // disable variable identifier to avoid NoViableAltException, or wrong routing
  name=type_identifier
  ;


// specific case for unresolved which cannot be a method   
instance_expression:    
	parent=selectable_expression 		# SelectableExpression
	| parent=instance_expression 
		selector=instance_selector	   # SelectorExpression
	;

method_expression:
  exp=document_expression			# DocumentExpression
  | exp=fetch_expression			# FetchExpression
  | exp=read_expression				# ReadExpression
  | exp=sorted_expression			# SortedExpression
  | exp=method_call					# MethodCallExpression
  | exp=constructor_expression		# ConstructorExpression
  ;
	
instance_selector:
  {$parser.wasNot(SParser.WS)}? DOT name=variable_identifier 				# MemberSelector
  | {$parser.wasNot(SParser.WS)}? LBRAK xslice=slice_arguments RBRAK		# SliceSelector
  |	{$parser.wasNot(SParser.WS)}? LBRAK exp=expression RBRAK				# ItemSelector
  ; 
 
document_expression:
  document_type
  ;

constructor_expression:
  MUTABLE? typ=category_type LPAR ( args=argument_assignment_list )? RPAR
  ;

argument_assignment_list:
  exp=expression {$parser.willNotBe($parser.equalToken())}?	# ExpressionAssignmentList
  | item=argument_assignment				# ArgumentAssignmentList
  | items=argument_assignment_list 
  		COMMA item=argument_assignment		# ArgumentAssignmentListItem
  ; 

argument_assignment:
  name=variable_identifier assign exp=expression
  ;

read_expression:
  READ FROM source=expression
  ;
  
write_statement: 
  WRITE what=expression TO target=expression
  ;
  
fetch_expression:
  FETCH name=variable_identifier FROM source=expression WHERE xfilter=expression
  ;  

sorted_expression:
  SORTED LPAR source=instance_expression ( COMMA key_token EQ key=instance_expression)? RPAR
  ;

assign_instance_statement: 
  inst=assignable_instance assign exp=expression
  ;  

child_instance:
  {$parser.wasNot(SParser.WS)}? DOT name=variable_identifier		# MemberInstance
  | {$parser.wasNot(SParser.WS)}? LBRAK exp=expression RBRAK 		# ItemInstance
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
  
null_literal : NONE;
