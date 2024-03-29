parser grammar OParser;

options {
  tokenVocab = OLexer;
  superClass = AbstractParser; 
}

import CommonParser;

enum_category_declaration:
  ENUMERATED CATEGORY name=type_identifier 
  	(LPAR attrs=attribute_identifier_list RPAR )? 
  	(EXTENDS derived=type_identifier)? 
	LCURL symbols=category_symbol_list RCURL
  ;
  
enum_native_declaration:
  ENUMERATED name=type_identifier 
  	LPAR typ=native_type RPAR 
  	LCURL symbols=native_symbol_list RCURL
  ;

category_symbol: 
  name=symbol_identifier LPAR args=argument_assignment_list RPAR SEMI
  ;
  
native_symbol:
  name=symbol_identifier EQ exp=expression SEMI
  ;
  
attribute_declaration:
   STORABLE? ATTRIBUTE name=attribute_identifier COLON typ=typedef
   	( match=attribute_constraint )? ( WITH INDEX ( LPAR indices=variable_identifier_list RPAR )? )? SEMI
  ;


concrete_widget_declaration:
  WIDGET name=type_identifier
  ( EXTENDS derived=type_identifier )?
  methods=category_method_list
  ;


native_widget_declaration:
  NATIVE WIDGET name=type_identifier
    LCURL
    bindings=native_category_bindings
    methods=native_member_method_declaration_list
    RCURL
  ;

concrete_category_declaration:
  STORABLE? CATEGORY name=type_identifier
  	( LPAR attrs=attribute_identifier_list RPAR  )? 
  	( EXTENDS derived=derived_list )? 
  	methods=category_method_list
  ;
  
singleton_category_declaration:
  SINGLETON name=type_identifier
  	( LPAR attrs=attribute_identifier_list RPAR  )? 
  	methods=category_method_list
  ;

derived_list  :
  item=type_identifier				# DerivedList
  | items=derived_list 
  	COMMA item=type_identifier		# DerivedListItem
  ;

category_method_list:
  SEMI														# EmptyCategoryMethodList
  | LCURL ( items=member_method_declaration_list )? RCURL	# CurlyCategoryMethodList
  ;

operator_method_declaration: 
  (typ=typedef)? OPERATOR op=operator 
    LPAR arg=operator_argument RPAR
    LCURL (stmts=statement_list)? RCURL
  ;

setter_method_declaration:
  SETTER name=variable_identifier LCURL (stmts=statement_list)? RCURL
  ;
  
native_setter_declaration:
  NATIVE? SETTER name=variable_identifier LCURL (stmts=native_statement_list)? RCURL
  ;  
   
getter_method_declaration:
  GETTER name=variable_identifier LCURL (stmts=statement_list)? RCURL
  ;

native_getter_declaration:
  NATIVE? GETTER name=variable_identifier LCURL (stmts=native_statement_list)? RCURL
  ;  

native_resource_declaration:
  STORABLE? NATIVE RESOURCE name=type_identifier ( LPAR attrs=attribute_identifier_list RPAR )? 
    LCURL bindings=native_category_bindings 
    (methods=native_member_method_declaration_list)? RCURL
  ;

native_category_declaration:
  STORABLE? NATIVE CATEGORY name=type_identifier ( LPAR attrs=attribute_identifier_list RPAR )?
    LCURL bindings=native_category_bindings 
    (methods=native_member_method_declaration_list)? RCURL
  ;

native_category_bindings:
  CATEGORY BINDINGS LCURL items=native_category_binding_list RCURL
  ; 

native_category_binding_list:
  item=native_category_binding SEMI		# NativeCategoryBindingList
  | items=native_category_binding_list 
  	item=native_category_binding SEMI	# NativeCategoryBindingListItem
  ;

abstract_global_method_declaration:
  ABSTRACT (MUTABLE? typ=typedef)? METHOD name=type_identifier 
    LPAR (args=argument_list)? RPAR SEMI
  ;  

abstract_member_method_declaration:
  ABSTRACT (MUTABLE? typ=typedef)? METHOD name=method_identifier 
    LPAR (args=argument_list)? RPAR SEMI
  ;  

concrete_method_declaration:
  (MUTABLE? typ=typedef)? METHOD name=method_identifier 
    LPAR (args=argument_list)? RPAR
    LCURL (stmts=statement_list)? RCURL
  ;  

native_method_declaration:
  (typ=category_or_any_type)? NATIVE? METHOD name=method_identifier 
    LPAR (args=argument_list)? RPAR
    LCURL stmts=native_statement_list RCURL
  ;

test_method_declaration:
  TEST METHOD name=TEXT_LITERAL LPAR RPAR
    LCURL stmts=statement_list RCURL
  	VERIFYING
    ((LCURL exps=assertion_list RCURL) | (error=symbol_identifier SEMI))
  ;  
  
assertion:
	exp=expression SEMI
	;

typed_argument:
  typ = category_or_any_type 
  	(LPAR attrs=attribute_identifier_list RPAR )? 
  	name=variable_identifier					
  	( EQ value=literal_expression)?
  ;
    
statement_or_list:
  stmt=statement							# SingleStatement
  | LCURL ( items=statement_list RCURL )?	# CurlyStatementList
  ;

statement: 
  stmt=method_call_statement				# MethodCallStatement
  | stmt=assign_instance_statement			# AssignInstanceStatement
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
  | stmt=try_statement						# TryStatement
  | stmt=raise_statement					# RaiseStatement
  | stmt=write_statement					# WriteStatement
  | stmt=with_resource_statement			# WithResourceStatement
  | stmt=with_singleton_statement			# WithSingletonStatement
  | decl=concrete_method_declaration		# ClosureStatement
  | decl=comment_statement					# CommentStatement
  ;


flush_statement:
  FLUSH LPAR RPAR SEMI
  ;
  
store_statement:
  (DELETE LPAR to_del=expression_list RPAR ( AND STORE LPAR to_add=expression_list RPAR) ? 
  | STORE LPAR to_add=expression_list RPAR)
  ( WITH metadata LPAR with_meta=expression RPAR )?
  (( THEN LCURL stmts=statement_list RCURL ) | SEMI)
  ;

with_resource_statement:
  WITH LPAR stmt=assign_variable_statement RPAR stmts=statement_or_list
  ;

with_singleton_statement:
  WITH LPAR typ=type_identifier RPAR stmts=statement_or_list
  ;
  
switch_statement: 
  SWITCH LPAR exp=expression RPAR 
  	LCURL cases=switch_case_statement_list
  	( DEFAULT COLON ( stmts=statement_list )? )? RCURL
  ;

switch_case_statement:
  CASE exp=atomic_literal COLON stmts=statement_list			# AtomicSwitchCase
  | CASE IN exp=literal_collection COLON stmts=statement_list 	# CollectionSwitchCase
  ;
  
for_each_statement:
  FOR EACH LPAR name1=variable_identifier 
  	(COMMA name2=variable_identifier)? 
    IN source=expression RPAR stmts=statement_or_list
  ;
  
do_while_statement:
  DO LCURL (stmts=statement_list)? RCURL 
  	WHILE LPAR exp=expression RPAR SEMI
  ;

while_statement:
  WHILE LPAR exp=expression RPAR stmts=statement_or_list
  ;
 
 
if_statement:
  IF LPAR exp=expression RPAR stmts=statement_or_list
  	( elseIfs=else_if_statement_list )?
  	( ELSE elseStmts=statement_or_list )? 
  ;

else_if_statement_list:
  ELSE IF LPAR exp=expression RPAR stmts=statement_or_list	# ElseIfStatementList
  | items=else_if_statement_list
  	ELSE IF LPAR exp=expression RPAR stmts=statement_or_list	# ElseIfStatementListItem
  ;
  
raise_statement: 
  THROW exp=expression SEMI
  ; 

try_statement:
  TRY LPAR name=variable_identifier RPAR 
    LCURL ( stmts=statement_list )? RCURL
    ( handlers=catch_statement_list )? 
    ( CATCH LPAR ANY RPAR LCURL ( anyStmts=statement_list )? RCURL )? 
    ( FINALLY LCURL ( finalStmts=statement_list )? RCURL )?
  ;

catch_statement:
  CATCH LPAR name=symbol_identifier RPAR 	
    LCURL ( stmts=statement_list )? RCURL # CatchAtomicStatement
  | CATCH IN LPAR exp=symbol_list RPAR	
    LCURL ( stmts=statement_list )? RCURL # CatchCollectionStatement
  ;

break_statement:
  BREAK SEMI
  ;

return_statement:
  RETURN exp=expression? SEMI
  ;
  
method_call_expression:
  name=method_identifier LPAR (args=argument_assignment_list)? RPAR
  ;
  
// need a dedicated rule not applicable for expression   
method_call_statement:
  (parent=instance_expression DOT)? method=method_call_expression ((THEN (WITH name=variable_identifier)? LCURL stmts=statement_list RCURL) | SEMI)
  ;
 

x_expression:
  css_expression
  ;

expression:
  exp=css_expression									    # CssExpression
  | exp=jsx_expression									    # JsxExpression
  | exp=instance_expression									# InstanceExpression
  | exp=mutable_instance_expression							# MutableInstanceExpression
  | exp=arrow_expression 									# ArrowExpression
  | MINUS exp=expression									# MinusExpression
  | XMARK exp=expression									# NotExpression
  | LPAR MUTABLE? right=category_or_any_type RPAR 
  		left=expression										# CastExpression
  | left=expression multiply right=expression 				# MultiplyExpression
  | left=expression divide right=expression 				# DivideExpression
  | left=expression modulo right=expression 				# ModuloExpression
  | left=expression idivide right=expression 				# IntDivideExpression
  | left=expression op=(PLUS | MINUS) right=expression 		# AddExpression
  | left=expression op=(LT | LTE | GT | GTE) right=expression # CompareExpression
  | left=expression IS NOT? right=an_expression				# IsAnExpression
  | left=expression IS NOT? right=expression				# IsExpression
  | left=expression op=(EQ2 | XEQ | TEQ) right=expression	# EqualsExpression
  | left=expression NOT? CONTAINS right=expression			# ContainsExpression
  | left=expression NOT? IN right=expression				# InExpression
  | left=expression NOT? HAS right=expression				# HasExpression
  | left=expression NOT? HAS ALL right=filter_expression	# HasAllExpression
  | left=expression NOT? HAS ANY right=filter_expression	# HasAnyExpression
  | left=expression PIPE2 right=expression					# OrExpression
  | left=expression AMP2 right=expression					# AndExpression
  | test=expression 
  		QMARK ifTrue=expression COLON ifFalse=expression 	# TernaryExpression
  | CODE LPAR exp=expression RPAR							# CodeExpression
  | EXECUTE LPAR name=variable_identifier RPAR				# ExecuteExpression
  | exp=type_expression										# TypeExpression
  | exp=expression FOR EACH LPAR name=variable_identifier 
  			IN source=expression RPAR						# IteratorExpression
  ;

filter_expression:
  WHERE LPAR arrow_expression RPAR			# ArrowFilterExpression
  | LPAR variable_identifier RPAR 
  		WHERE LPAR expression RPAR			# ExplicitFilterExpression
  | expression								# OtherFilterExpression
  ;

    
an_expression:
  {$parser.willBeAOrAn()}? VARIABLE_IDENTIFIER typ=category_or_any_type
  ;

type_expression:
  name=type_identifier
  ;

selectable_expression:
  exp=method_expression			# MethodExpression
  | exp=parenthesis_expression	# ParenthesisExpression
  | exp=literal_expression 		# LiteralExpression
  | exp=identifier 				# IdentifierExpression
  | exp=this_expression			# ThisExpression
  | exp=super_expression		# SuperExpression
  ; 

instance_expression:
  parent=selectable_expression	# SelectableExpression
  | parent=instance_expression 
  	selector=instance_selector	# SelectorExpression
  ;
 
mutable_instance_expression:
	MUTABLE exp=identifier				# MutableSelectableExpression
	| parent=mutable_instance_expression
		selector=instance_selector	   # MutableSelectorExpression
  ;
    
method_expression:
  blob_expression				
  | document_expression			
  | filtered_list_expression		
  | fetch_expression		
  | read_blob_expression				
  | read_all_expression				
  | read_one_expression				
  | sorted_expression			
  | method_call_expression					
  | constructor_expression		
  ;

blob_expression:
  BLOB LPAR expression RPAR
  ;

document_expression:
  DOCUMENT LPAR (FROM EQ exp=expression)? RPAR
  ;

write_statement: 
  WRITE LPAR what=expression RPAR TO target=expression (then | SEMI)
  ;

filtered_list_expression:
  FILTERED LPAR source=expression RPAR 
  		(WITH LPAR name=variable_identifier RPAR)?
  		WHERE LPAR predicate=expression RPAR
  ;
  
fetch_expression:
  FETCH ONE (LPAR typ=mutable_category_type RPAR)? 
  		WHERE LPAR predicate=expression RPAR	
  		( INCLUDE LPAR include=include_list RPAR)?				# FetchOne
  | FETCH (
  		( ALL (LPAR typ=mutable_category_type RPAR)? )
	  | ( (LPAR typ=mutable_category_type RPAR)?  ROWS LPAR xstart=expression TO xstop=expression RPAR ) 
	  	  )
  			( WHERE LPAR predicate=expression RPAR )?	
  			( INCLUDE LPAR include=include_list RPAR)?			
  			( ORDER BY LPAR orderby=order_by_list RPAR )?				# FetchMany
  ;
  
fetch_statement:
  FETCH ONE (LPAR typ=mutable_category_type RPAR)? 
  		WHERE LPAR predicate=expression RPAR
  		( INCLUDE LPAR include=include_list RPAR )?
  		then															# FetchOneAsync
  | FETCH  (( ALL (LPAR typ=mutable_category_type RPAR)? )
  			| ( (LPAR typ=mutable_category_type RPAR)? 
  			ROWS LPAR xstart=expression TO xstop=expression RPAR ) )
  			( WHERE LPAR predicate=expression RPAR )?
  			( INCLUDE LPAR include=include_list RPAR )?			
  			( ORDER BY LPAR orderby=order_by_list RPAR )? 
  			then														# FetchManyAsync
  ;

then:
	THEN WITH name=variable_identifier LCURL
  			stmts=statement_list
  			RCURL	
  ;
  													
read_statement:
  READ ALL FROM source=expression then
  ;

  
sorted_expression:
  SORTED DESC? LPAR source=instance_expression 
  	( COMMA key_token EQ key=sorted_key )? RPAR
  ;

instance_selector:
  DOT name=member_identifier 			# MemberSelector
  | DOT name=method_identifier			# MethodRefSelector
  | DOT method=method_call_expression	# MethodCallSelector
  | LBRAK exp=expression RBRAK			# ItemSelector
  | LBRAK xslice=slice_arguments RBRAK	# SliceSelector
  ; 
  
constructor_expression:
  typ=mutable_category_type LPAR copyExp=copy_from ( COMMA args=argument_assignment_list )? RPAR  	# ConstructorFrom
  | typ=mutable_category_type LPAR ( args=argument_assignment_list )? RPAR 							# ConstructorNoFrom
  ;

copy_from:
  FROM assign exp=expression {$parser.willNotBe($parser.equalToken())}?	
  ;

argument_assignment_list:
  exp=expression {$parser.willNotBe($parser.equalToken())}?	# ExpressionAssignmentList
  | item=argument_assignment				# ArgumentAssignmentList
  | items=argument_assignment_list 
  		COMMA item=argument_assignment		# ArgumentAssignmentListItem
  ; 

argument_assignment:
  name=variable_identifier (assign exp=expression)?
  ;
  
assign_instance_statement: 
  inst=assignable_instance assign exp=expression SEMI
  ;  

child_instance:
  DOT name=variable_identifier		# MemberInstance
  | LBRAK exp=expression RBRAK 		# ItemInstance
  ;
  
assign_tuple_statement: 
  items=variable_identifier_list assign exp=expression SEMI
  ;
  
type_literal : category_or_any_type;

null_literal : NULL;

ws_plus:
  (LF | WS)*
  ;

