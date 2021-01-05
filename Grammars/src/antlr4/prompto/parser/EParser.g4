parser grammar EParser;

options {
  tokenVocab = ELexer;
  superClass = AbstractParser; 
}

import CommonParser;

enum_category_declaration:
  DEFINE name=type_identifier AS ENUMERATED 
  	(CATEGORY | derived=type_identifier)
  	((attrs=attribute_list COMMA AND) | WITH)
    symbols_token COLON
    indent symbols=category_symbol_list dedent
  ;

enum_native_declaration:
  DEFINE name=type_identifier AS ENUMERATED 
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
   DEFINE name=attribute_identifier AS 
   	STORABLE? typ=typedef ATTRIBUTE (match=attribute_constraint)?
   	( WITH (indices=variable_identifier_list (AND index=variable_identifier)?)? INDEX )?
  ;


concrete_widget_declaration:
  DEFINE name=type_identifier AS
  	( WIDGET | derived=type_identifier )
  	( WITH METHODS COLON
        indent methods=member_method_declaration_list dedent ) ?
  ;

native_widget_declaration:
  DEFINE name=type_identifier AS NATIVE WIDGET WITH BINDINGS COLON
    indent bindings=native_category_bindings dedent
  lfp AND METHODS COLON
    indent methods=native_member_method_declaration_list dedent
  ;

concrete_category_declaration:
  DEFINE name=type_identifier AS STORABLE? 
  	( CATEGORY | derived=derived_list )
  	( ( attrs=attribute_list  
	  	( COMMA AND METHODS COLON 
	  		indent methods=member_method_declaration_list dedent )? )
	  | ( WITH METHODS COLON 
	  		indent methods=member_method_declaration_list dedent )
	 ) ?
  ;

singleton_category_declaration:
  DEFINE name=type_identifier AS 
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
  DEFINE op=operator AS OPERATOR   
    RECEIVING arg=operator_argument
    (RETURNING typ=typedef)?
    DOING COLON
    indent stmts=statement_list dedent
  ;
  
setter_method_declaration:
  DEFINE name=variable_identifier AS SETTER DOING COLON 
  	indent stmts=statement_list dedent
  ;
   
native_setter_declaration:
  DEFINE name=variable_identifier AS NATIVE? SETTER DOING COLON 
  	indent stmts=native_statement_list dedent
  ;

getter_method_declaration:
  DEFINE name=variable_identifier AS GETTER DOING COLON
  	indent stmts=statement_list dedent
  ;
  
native_getter_declaration:
  DEFINE name=variable_identifier AS NATIVE? GETTER DOING COLON
  	indent stmts=native_statement_list dedent
  ;
    
native_category_declaration:
  DEFINE name=type_identifier AS STORABLE? NATIVE CATEGORY 
   ((attrs=attribute_list COMMA AND BINDINGS) | WITH BINDINGS) COLON 
    indent bindings=native_category_bindings dedent
    (lfp AND METHODS COLON 
    	indent methods=native_member_method_declaration_list dedent
    )?
  ;

native_resource_declaration:
  DEFINE name=type_identifier AS STORABLE? NATIVE RESOURCE 
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
  WITH ATTRIBUTE item=attribute_identifier 	# AttributeList
  | WITH ATTRIBUTES items=attribute_identifier_list
   	(AND item=attribute_identifier)? 				# AttributeListItem
  ;

abstract_method_declaration:
  DEFINE name=method_identifier AS ABSTRACT METHOD 
    (RECEIVING args=full_argument_list)? 
    (RETURNING MUTABLE? typ=typedef)?
  ;  

concrete_method_declaration:
  DEFINE name=method_identifier AS METHOD
    (RECEIVING args=full_argument_list)? 
    (RETURNING MUTABLE? typ=typedef)?
    DOING COLON 
    indent (stmts=statement_list | PASS) dedent
  ;  

native_method_declaration:
  DEFINE name=method_identifier AS NATIVE? METHOD 
    (RECEIVING args=full_argument_list)? 
    (RETURNING typ=category_or_any_type)?
    DOING COLON 
    indent stmts=native_statement_list dedent
  ;  

test_method_declaration:
  DEFINE name=TEXT_LITERAL AS TEST METHOD DOING COLON 
    indent stmts=statement_list dedent
  lfp AND VERIFYING 
    ((COLON indent exps=assertion_list dedent) | error=symbol_identifier)
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
  | stmt=store_statement					# StoreStatement
  | stmt=fetch_statement					# FetchStatement
  | stmt=read_statement						# ReadStatement
  | stmt=flush_statement					# FlushStatement
  | stmt=break_statement					# BreakStatement
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
  | decl=comment_statement					# CommentStatement
  ;


flush_statement:
  FLUSH
  ;
  
store_statement:
  ( DELETE to_del=expression_list	(AND STORE to_add=expression_list)? 						
  | STORE to_add=expression_list )
  ( THEN COLON indent stmts=statement_list dedent )?
  ;
  
method_call_statement:  
  (exp1=instance_expression | exp2=unresolved_expression)
  	(args=argument_assignment_list)?  		
  	(THEN (WITH name=variable_identifier)? COLON 
  		indent stmts=statement_list dedent )? 		# UnresolvedWithArgsStatement
  | exp=invocation_expression 						# InvokeStatement	
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

break_statement:
  BREAK
  ;

return_statement:
  RETURN exp=expression?
  ;
    
expression:
  exp=css_expression									    # CssExpression
  | exp=jsx_expression									    # JsxExpression
  | exp=instance_expression									# InstanceExpression
  | exp=arrow_expression 									# ArrowExpression
  | exp=unresolved_expression								# UnresolvedExpression
  | (exp1=instance_expression | exp2=unresolved_expression)
  	args=argument_assignment_list							# MethodCallExpression
  | exp=constructor_expression								# ConstructorExpression
  | MINUS exp=expression									# MinusExpression
  | NOT exp=expression										# NotExpression
  | left=expression AS MUTABLE? right=category_or_any_type	# CastExpression
  | left=expression multiply right=expression 				# MultiplyExpression
  | left=expression divide right=expression 				# DivideExpression
  | left=expression modulo right=expression 				# ModuloExpression
  | left=expression idivide right=expression 				# IntDivideExpression
  | left=expression op=(PLUS | MINUS) right=expression 		# AddExpression
  | left=expression op=(LT | LTE | GT | GTE) right=expression # CompareExpression
  | left=expression IS NOT? right=is_expression				# IsExpression
  | left=expression op=(EQ | LTGT | TILDE) right=expression	# EqualsExpression
  | left=expression NOT? CONTAINS right=expression			# ContainsExpression
  | left=expression NOT? IN right=expression				# InExpression
  | left=expression NOT? HAS right=expression				# HasExpression
  | left=expression NOT? HAS ALL right=filter_expression	# HasAllExpression
  | left=expression NOT? HAS ANY right=filter_expression	# HasAnyExpression
  | left=expression OR right=expression						# OrExpression
  | left=expression AND right=expression					# AndExpression
  | ifTrue=expression IF test=expression 
  		ELSE ifFalse=expression 							# TernaryExpression
  | CODE COLON exp=expression								# CodeExpression
  | EXECUTE COLON name=variable_identifier					# ExecuteExpression
  | METHOD_COLON name=method_identifier						# ClosureExpression
  | exp=blob_expression										# BlobExpression
  | exp=document_expression									# DocumentExpression
  | exp=mutable_instance_expression							# MutableInstanceExpression
  | src=expression filtered_list_suffix						# FilteredListExpression
  | exp=fetch_expression									# FetchExpression
  | exp=read_blob_expression								# ReadBlobExpression
  | exp=read_all_expression									# ReadAllExpression
  | exp=read_one_expression									# ReadOneExpression
  | exp=sorted_expression									# SortedExpression
  | exp=ambiguous_expression								# AmbiguousExpression
  | exp=invocation_expression								# InvocationExpression
  | exp=expression FOR EACH name=variable_identifier 
  		IN source=expression								# IteratorExpression
  ;

filter_expression:
  WHERE arrow_expression					# ArrowFilterExpression
  | variable_identifier WHERE expression	# ExplicitFilterExpression
  | expression								# OtherFilterExpression
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
  INVOKE_COLON name=variable_identifier invocation_trailer
  ;

invocation_trailer:
  {$parser.willBe(EParser.LF)}?
  ;	

selectable_expression:
  exp=parenthesis_expression	# ParenthesisExpression
  | exp=literal_expression 		# LiteralExpression
  | exp=identifier 				# IdentifierExpression
  | exp=this_expression			# ThisExpression
  | exp=super_expression		# SuperExpression
  ; 

// specific case for unresolved which cannot be a method   
instance_expression:    
	parent=selectable_expression 		# SelectableExpression
	| parent=instance_expression 
		selector=instance_selector	   # SelectorExpression
	;
	
instance_selector:
  {$parser.wasNot(EParser.WS)}? DOT name=member_identifier		 			# MemberSelector
  | {$parser.wasNot(EParser.WS)}? LBRAK xslice=slice_arguments RBRAK		# SliceSelector
  |	{$parser.wasNot(EParser.WS)}? LBRAK exp=expression RBRAK				# ItemSelector
  ; 
 
mutable_instance_expression:
	MUTABLE exp=identifier				# MutableSelectableExpression
	| parent=mutable_instance_expression
		selector=instance_selector	   # MutableSelectorExpression
  ;
 
document_expression:
  DOCUMENT (FROM exp=expression)?
  ;

blob_expression:
  BLOB FROM expression
  ;

constructor_expression:
  typ=mutable_category_type FROM copyExp=expression	
 	( (COMMA)? args=with_argument_assignment_list 
  		(AND arg=argument_assignment)? )?				# ConstructorFrom
  | typ=mutable_category_type 
  	( args=with_argument_assignment_list
  		(AND arg=argument_assignment)? )?				# ConstructorNoFrom
  ;

write_statement: 
  WRITE what=expression TO target=expression
  ;
  
ambiguous_expression:
  method=unresolved_expression MINUS exp=expression
  ;
  
filtered_list_suffix:
  FILTERED (WITH name=variable_identifier)? 
  			WHERE predicate=expression		
  ;
  
fetch_expression:
  FETCH ONE (typ=mutable_category_type?) 
  			WHERE predicate=expression							# FetchOne
  | FETCH ( ( ALL typ=mutable_category_type? ) 
  			| ( typ=mutable_category_type ROWS? xstart=expression TO xstop=expression )
  			| ( ROWS xstart=expression TO xstop=expression ) )
  			( WHERE predicate=expression )?
  			( ORDER BY orderby=order_by_list )?					# FetchMany
  ;  
  
fetch_statement:
  FETCH ONE (typ=mutable_category_type?) 
  			WHERE predicate=expression
  			THEN WITH name=variable_identifier COLON indent
  			stmts=statement_list
  			dedent											# FetchOneAsync
  | FETCH ( ( ALL typ=mutable_category_type? ) 
  			| ( typ=mutable_category_type ROWS? xstart=expression TO xstop=expression )
  			| ( ROWS xstart=expression TO xstop=expression ) )
  			( WHERE predicate=expression )?
  			( ORDER BY orderby=order_by_list )?
  			THEN WITH name=variable_identifier COLON indent
  			stmts=statement_list
  			dedent											# FetchManyAsync
  ;  


read_statement:
  READ ALL FROM source=expression THEN WITH name=variable_identifier COLON indent
  			stmts=statement_list
  			dedent
  ;
  
  
sorted_expression:
  SORTED DESC? source=instance_expression
  	( WITH key=sorted_key AS key_token )?
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
  (exp=expression AS)? name=variable_identifier
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
  
ws_plus:
  (LF | TAB | WS | INDENT)*
  ;
    
indent:
  (LF)+ INDENT
  ;
  
dedent:
  (LF)* DEDENT
  ;   
  
type_literal:
    TYPE COLON category_or_any_type
    ;
  
null_literal : NOTHING;
