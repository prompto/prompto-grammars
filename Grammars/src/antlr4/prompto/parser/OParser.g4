parser grammar OParser;

options {
  tokenVocab = OLexer;
  superClass = AbstractParser; 
}

import CommonParser;

enum_category_declaration:
  ENUMERATED CATEGORY name=type_identifier 
  	(LPAR attrs=attribute_list RPAR )? 
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
   STORABLE? ATTRIBUTE name=variable_identifier COLON typ=typedef
   	( match=attribute_constraint )? SEMI
  ;


concrete_category_declaration:
  STORABLE? CATEGORY name=type_identifier
  	( LPAR attrs=attribute_list RPAR  )? 
  	( EXTENDS derived=derived_list )? 
  	methods=category_method_list
  ;
  
singleton_category_declaration:
  SINGLETON name=type_identifier
  	( LPAR attrs=attribute_list RPAR  )? 
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
   
getter_method_declaration:
  GETTER name=variable_identifier LCURL (stmts=statement_list)? RCURL
  ;

native_resource_declaration:
  NATIVE RESOURCE name=type_identifier ( LPAR attrs=attribute_list RPAR )? 
    LCURL bindings=native_category_bindings 
    (methods=native_member_method_declaration_list)? RCURL
  ;

native_category_declaration:
  STORABLE? NATIVE CATEGORY name=type_identifier ( LPAR attrs=attribute_list RPAR )?
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

attribute_list: 
  item=variable_identifier			# AttributeList
  | items=attribute_list 
  	COMMA item=variable_identifier 	# AttributeListItem
  ;
    
abstract_method_declaration:
  ABSTRACT (typ=typedef)? METHOD name=method_identifier 
    LPAR (args=argument_list)? RPAR SEMI
  ;  


concrete_method_declaration:
  (typ=typedef)? METHOD name=method_identifier 
    LPAR (args=argument_list)? RPAR
    LCURL (stmts=statement_list)? RCURL
  ;  

native_method_declaration:
  (typ=category_or_any_type)? NATIVE METHOD name=method_identifier 
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
  	(LPAR attrs=attribute_list RPAR )? 
  	name=variable_identifier					
  	( EQ value=literal_expression)?
  ;
    
statement_or_list:
  stmt=statement							# SingleStatement
  | LCURL ( items=statement_list RCURL )?	# CurlyStatementList
  ;

statement: 
  stmt=method_call SEMI						# MethodCallStatement
  | stmt=assign_instance_statement			# AssignInstanceStatement
  | stmt=assign_tuple_statement				# AssignTupleStatement
  | stmt=store_statement					# StoreStatement
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

store_statement:
  DELETE LPAR to_del=expression_list RPAR SEMI
  | STORE LPAR to_add=expression_list RPAR SEMI
  | DELETE LPAR to_del=expression_list RPAR AND STORE LPAR to_add=expression_list RPAR SEMI
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
  CASE exp=atomic_literal COLON ( stmts=statement_list )?	# AtomicSwitchCase
  | CASE IN exp=literal_collection COLON ( stmts=statement_list )? # CollectionSwitchCase
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

return_statement:
  RETURN exp=expression? SEMI
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
  
expression:
  exp=instance_expression									# InstanceExpression	
  | exp=method_expression									# MethodExpression
  | MINUS exp=expression									# MinusExpression
  | XMARK exp=expression									# NotExpression
  | left=expression multiply right=expression 				# MultiplyExpression
  | left=expression divide right=expression 				# DivideExpression
  | left=expression modulo right=expression 				# ModuloExpression
  | left=expression idivide right=expression 				# IntDivideExpression
  | left=expression op=(PLUS | MINUS) right=expression 		# AddExpression
  | left=expression LT right=expression						# LessThanExpression
  | left=expression LTE right=expression					# LessThanOrEqualExpression
  | left=expression GT right=expression						# GreaterThanExpression
  | left=expression GTE right=expression					# GreaterThanOrEqualExpression
  | left=expression IS NOT right=an_expression				# IsNotAnExpression
  | left=expression IS right=an_expression					# IsAnExpression
  | left=expression IS NOT right=expression					# IsNotExpression
  | left=expression IS right=expression						# IsExpression
  | left=expression EQ2 right=expression					# EqualsExpression
  | left=expression XEQ right=expression					# NotEqualsExpression
  | left=expression TEQ right=expression					# RoughlyEqualsExpression
  | left=expression PIPE2 right=expression					# OrExpression
  | left=expression AMP2 right=expression					# AndExpression
  | test=expression 
  		QMARK ifTrue=expression COLON ifFalse=expression 	# TernaryExpression
  | LPAR right=category_or_any_type RPAR left=expression	# CastExpression
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
  | exp=expression FOR EACH LPAR name=variable_identifier 
  			IN source=expression RPAR						# IteratorExpression
  ;

an_expression:
  {$parser.willBeAOrAn()}? VARIABLE_IDENTIFIER typ=category_or_any_type
  ;

closure_expression:
  // given the context, this can only occur for a standalone type identifier
  // disable variable identifier to avoid NoViableAltException, or wrong routing
  name=type_identifier
  ;

instance_expression:
  parent=selectable_expression		# SelectableExpression
  | parent=instance_expression 
  	selector=selector_expression	# SelectorExpression
  ;
  
method_expression:
  exp=document_expression			# DocumentExpression
  | exp=fetch_expression			# FetchExpression
  | exp=read_expression				# ReadExpression
  | exp=sorted_expression			# SortedExpression
  | exp=method_call					# MethodCallExpression
  | exp=constructor_expression		# ConstructorExpression
  ;

document_expression:
  DOCUMENT LPAR RPAR
  ;

read_expression:
  READ FROM source=expression
  ;
  
write_statement: 
  WRITE LPAR what=expression RPAR TO target=expression SEMI
  ;

fetch_expression:
  FETCH LPAR name=variable_identifier RPAR 
  		FROM source=expression 
  		WHERE xfilter=expression							# FetchList
  | FETCH ONE LPAR typ=mutable_category_type? RPAR 
  		WHERE LPAR xfilter=expression RPAR					# FetchOne
  | FETCH  (( ALL LPAR typ=mutable_category_type? RPAR )
  			| ( LPAR typ=mutable_category_type? RPAR 
  			ROWS LPAR xstart=expression TO xstop=expression RPAR ) )
  			( WHERE LPAR xfilter=expression RPAR )?			
  			( ORDER BY LPAR xorder=order_by_list RPAR )?				# FetchAll
  ;
  
sorted_expression:
  SORTED LPAR source=instance_expression 
  	( COMMA key_token EQ key=instance_expression )? RPAR
  ;

selector_expression:
  DOT name=variable_identifier 			# MemberSelector
  | LBRAK exp=expression RBRAK			# ItemSelector
  | LBRAK xslice=slice_arguments RBRAK	# SliceSelector
  ; 
  
constructor_expression:
  typ=mutable_category_type LPAR ( args=argument_assignment_list )? RPAR
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
  
null_literal : NULL;
  
  