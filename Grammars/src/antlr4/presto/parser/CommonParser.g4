parser grammar CommonParser;

import JavaScriptParser, PythonParser, JavaParser, CSharpParser;

declaration_list:
  (items=declarations)? lfs EOF		# FullDeclarationList
  ;

declarations:
  item=declaration 				# DeclarationList
  | items=declarations 
  	lfp item=declaration		# DeclarationListItem
  ;

declaration : 
  decl=attribute_declaration	# AttributeDeclaration
  | decl=category_declaration	# CategoryDeclaration
  | decl=resource_declaration	# ResourceDeclaration
  | decl=enum_declaration		# EnumDeclaration
  | decl=method_declaration		# MethodDeclaration
  ;

resource_declaration:
  decl=native_resource_declaration
  ;

enum_declaration :
  decl=enum_category_declaration	# EnumCategoryDeclaration
  | decl=enum_native_declaration	# EnumNativeDeclaration
  ;
   
native_symbol_list:
  item=native_symbol			# NativeSymbolList
  | items=native_symbol_list 
  	 lfp item=native_symbol		# NativeSymbolListItem
  ;

category_symbol_list:
  item=category_symbol				# CategorySymbolList
  | items=category_symbol_list
	  lfp item=category_symbol		# CategorySymbolListItem
  ;  

symbol_list:
  item=symbol_identifier 		# SymbolList
  | items=symbol_list 
  	COMMA item=symbol_identifier # SymbolListItem
  ;
  

attribute_constraint:
  IN source=list_literal			# MatchingList
  | IN source=set_literal 			# MatchingSet
  | IN source=range_literal 		# MatchingRange
  | MATCHING text=TEXT_LITERAL 		# MatchingPattern
  | MATCHING exp=expression 		# MatchingExpression
  ;

list_literal:
  LBRAK ( items=expression_list )? RBRAK
  ;

set_literal:
  LT ( items=expression_list )? GT
  ;

expression_list:
  item=expression 									# ValueList
  | items=expression_list COMMA item=expression		# ValueListItem 
  ;

range_literal:
  LBRAK low=expression RANGE high=expression RBRAK
  ;

typedef: 
  p=primary_type			# PrimaryType
  | s=typedef LTGT 			# SetType
  | l=typedef LBRAK RBRAK 	# ListType
  | d=typedef LCURL RCURL 	# DictType
  ;
   
primary_type:
  n=native_type			# NativeType
  | c=category_type		# CategoryType
  ;
  
native_type:
  t1=BOOLEAN			# BooleanType
  | t1=CHARACTER		# CharacterType
  | t1=TEXT				# TextType
  | t1=INTEGER			# IntegerType
  | t1=DECIMAL			# DecimalType
  | t1=DATE				# DateType
  | t1=DATETIME			# DateTimeType
  | t1=TIME				# TimeType
  | t1=PERIOD			# PeriodType
  | t1=CODE				# CodeType
  ;
  
category_type:
  t1=TYPE_IDENTIFIER
  ;

code_type:
  t1=CODE
  ; 
  
document_type:
  t1=DOCUMENT
  ;  

category_declaration:
  decl=concrete_category_declaration	# ConcreteCategoryDeclaration
  | decl=native_category_declaration	# NativeCategoryDeclaration
  | decl=singleton_category_declaration	# SingletonCategoryDeclaration
  ;

type_identifier_list  :
  item=type_identifier				# TypeIdentifierList
  | items=type_identifier_list 
  	COMMA item=type_identifier		# TypeIdentifierListItem
  ;

method_identifier:
  name=variable_identifier	# MethodVariableIdentifier
  | name=type_identifier	# MethodTypeIdentifier
  ;
  
identifier:
  name=variable_identifier 	# VariableIdentifier
  | name=type_identifier	# TypeIdentifier
  | name=symbol_identifier	# SymbolIdentifier
  ;  
  
variable_identifier:
  VARIABLE_IDENTIFIER
  ;
  
type_identifier:
  TYPE_IDENTIFIER
  ; 

symbol_identifier:
  SYMBOL_IDENTIFIER
  ; 

argument_list:
  item=argument				# ArgumentList
  | items=argument_list 
  	COMMA item=argument		# ArgumentListItem
 ;

argument:
  arg=code_argument			# CodeArgument	
  | arg=operator_argument	# OperatorArgument
  ;
  
operator_argument:
  arg=named_argument 			# NamedArgument
  | arg=typed_argument			# TypedArgument
  ;
   

named_argument:
  name=variable_identifier
  	( EQ value=literal_expression)?
  ;

code_argument:
  code_type name=variable_identifier
  ;
  
category_or_any_type:
  typ=typedef				# CategoryArgumentType
  | typ=any_type			# AnyArgumentType
  ;

any_type:
  ANY							# AnyType
  | typ=any_type LBRAK RBRAK	# AnyListType
  | typ=any_type LCURL RCURL	# AnyDictType
  ;

member_method_declaration_list:
  item=member_method_declaration			# CategoryMethodList		
  | items=member_method_declaration_list 
  	lfp item=member_method_declaration		# CategoryMethodListItem
  ;
  
member_method_declaration:
  decl=setter_method_declaration			# SetterMemberMethod
  | decl=getter_method_declaration			# GetterMemberMethod
  | decl=concrete_method_declaration		# ConcreteMemberMethod
  | decl=abstract_method_declaration		# AbstractMemberMethod
  | decl=operator_method_declaration		# OperatorMemberMethod
  ;

native_category_mapping:
  JAVA mapping=java_class_identifier_expression		# JavaCategoryMapping
  | CSHARP mapping=csharp_identifier_expression		# CSharpCategoryMapping
  | PYTHON2 mapping=python_category_mapping			# Python2CategoryMapping
  | PYTHON3 mapping=python_category_mapping			# Python3CategoryMapping
  | JAVASCRIPT mapping=javascript_category_mapping	# JavaScriptCategoryMapping
  ;  

python_category_mapping:
  id_=identifier module=python_module?
  ;
  
python_module:
  FROM module_token COLON identifier (DOT identifier)*
  ;
  
module_token:
i1=VARIABLE_IDENTIFIER {$parser.isText($i1,"module")}? 
; 

javascript_category_mapping:  
  id_=identifier module=javascript_module?
  ;
  
javascript_module:  
  FROM module_token COLON SLASH? javascript_identifier (SLASH javascript_identifier)* (DOT javascript_identifier)?
  ;
   
variable_identifier_list:
  item=variable_identifier 				# VariableList
  | items=variable_identifier_list
  	COMMA item=variable_identifier 		# VariableListItem
  ;

method_declaration:
  decl=abstract_method_declaration		# AbstractMethod
  | decl=concrete_method_declaration	# ConcreteMethod
  | decl=native_method_declaration		# NativeMethod
  | decl=test_method_declaration		# TestMethod
  ; 
  
native_statement_list:
  item=native_statement				# NativeStatementList
  | items= native_statement_list 
  	lfp item=native_statement		# NativeStatementListItem
  ;
 
native_statement:
  JAVA stmt=java_statement							# JavaNativeStatement
  | CSHARP stmt=csharp_statement					# CSharpNativeStatement
  | PYTHON2 stmt=python_native_statement			# Python2NativeStatement
  | PYTHON3 stmt=python_native_statement			# Python3NativeStatement
  | JAVASCRIPT stmt=javascript_native_statement 	# JavaScriptNativeStatement
  ;   
   
python_native_statement:
  stmt=python_statement SEMI? module=python_module?
  ;

javascript_native_statement:
  stmt=javascript_statement SEMI? module=javascript_module?
  ;

statement_list:
  item=statement			# StatementList
  | items=statement_list 
  	lfp item=statement		# StatementListItem
  ;
  
assertion_list:
  item=assertion			# AssertionList
  | items=assertion_list 
  	lfp item=assertion		# AssertionListItem
  ;  

switch_case_statement_list:
  item=switch_case_statement		# SwitchCaseStatementList
  | items=switch_case_statement_list
  	lfp item=switch_case_statement		# SwitchCaseStatementListItem
  ;

catch_statement_list:
  item=catch_statement		# CatchStatementList
  | items=catch_statement_list
	lfp item=catch_statement	# CatchStatementListItem
  ;
  
  	
literal_collection:
  LBRAK low=atomic_literal 
  	RANGE high=atomic_literal RBRAK			# LiteralRangeLiteral
  | LBRAK exp=literal_list_literal RBRAK	# LiteralListLiteral
  | LT exp=literal_list_literal GT			# LiteralSetLiteral
  ;

    
atomic_literal:
  t=MIN_INTEGER					# MinIntegerLiteral
  | t=MAX_INTEGER				# MaxIntegerLiteral
  | t=INTEGER_LITERAL 			# IntegerLiteral
  | t=HEXA_LITERAL				# HexadecimalLiteral
  | t=CHAR_LITERAL				# CharacterLiteral
  | t=DATE_LITERAL				# DateLiteral
  | t=TIME_LITERAL				# TimeLiteral
  | t=TEXT_LITERAL				# TextLiteral
  | t=DECIMAL_LITERAL 			# DecimalLiteral
  | t=DATETIME_LITERAL			# DateTimeLiteral
  | t=BOOLEAN_LITERAL			# BooleanLiteral
  | t=PERIOD_LITERAL			# PeriodLiteral
  | n=null_literal				# NullLiteral
  ;
   
literal_list_literal:
  item=atomic_literal 			# LiteralList
  | items=literal_list_literal
  	COMMA item=atomic_literal 	# LiteralListItem
  ;
   
selectable_expression:
  exp=parenthesis_expression	# ParenthesisExpression
  | exp=literal_expression 		# LiteralExpression
  | exp=identifier 				# IdentifierExpression
  | exp=this_expression			# ThisExpression
  ; 

this_expression:
  SELF | THIS
  ;
  
parenthesis_expression:
  LPAR exp=expression RPAR
  ;  

literal_expression:
  exp=atomic_literal			# AtomicLiteral
  | exp=collection_literal		# CollectionLiteral
  ;
  
collection_literal:
  exp=range_literal				# RangeLiteral
  | exp=list_literal			# ListLiteral
  | exp=set_literal				# SetLiteral
  | exp=dict_literal			# DictLiteral
  | exp=tuple_literal			# TupleLiteral
  ;     

tuple_literal:
  LPAR ( items=expression_tuple )? RPAR
  ;
    
dict_literal: 
  LCURL ( items=dict_entry_list )? RCURL	
  ; 

expression_tuple:
  item=expression 									# ValueTuple
  | items=expression_tuple COMMA item=expression	# ValueTupleItem 
  ; 

dict_entry_list:
  item=dict_entry 									# DictEntryList
  | items=dict_entry_list COMMA item=dict_entry		# DictEntryListItem
  ;

dict_entry:
  key=expression COLON value=expression
  ; 

slice_arguments:
  first=expression COLON last=expression	# SliceFirstAndLast
  | first=expression COLON					# SliceFirstOnly
  | COLON last=expression					# SliceLastOnly
  ;

assign_variable_statement:
  name=variable_identifier assign exp=expression
  ;  

assignable_instance:
  name=variable_identifier 		# RootInstance
  | parent=assignable_instance 
  	child=child_instance	 	# ChildInstance
  ;

is_expression:
  {$parser.willBeAOrAn()}? VARIABLE_IDENTIFIER typ=category_or_any_type		# IsATypeExpression
  | exp=expression															# IsOtherExpression		
  ;
  
operator:
  PLUS			# OperatorPlus
  | MINUS		# OperatorMinus
  | multiply	# OperatorMultiply
  | divide		# OperatorDivide
  | idivide		# OperatorIDivide
  | modulo		# OperatorModulo
  ;
 
// special names  
key_token:
  i1=VARIABLE_IDENTIFIER {$parser.isText($i1,"key")}? 
  ; 

value_token:
  i1=VARIABLE_IDENTIFIER {$parser.isText($i1,"value")}? 
  ; 

symbols_token:
i1=VARIABLE_IDENTIFIER {$parser.isText($i1,"symbols")}? 
; 

// token aliases
// operators common to all dialects
assign: EQ;
multiply: STAR;
divide: SLASH;
idivide: BSLASH;
modulo: PERCENT | MODULO;
   
// overridden rules
lfs:; // see PParser and EParser
lfp:; // see PParser and EParser
attribute_declaration:;
abstract_method_declaration:;
concrete_method_declaration:;
native_method_declaration:;
test_method_declaration:;
concrete_category_declaration:;
singleton_category_declaration:;
native_category_declaration:;
native_resource_declaration:;
enum_category_declaration:;
enum_native_declaration:;
setter_method_declaration:;
getter_method_declaration:;
operator_method_declaration:;
typed_argument:;
native_symbol:;
category_symbol:;
expression:;
assertion:;
statement:;
switch_case_statement:;
catch_statement:;
child_instance:;
null_literal:;