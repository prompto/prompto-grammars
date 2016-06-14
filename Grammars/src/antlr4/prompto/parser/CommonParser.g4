parser grammar CommonParser;

import JavaScriptParser, PythonParser, JavaParser, CSharpParser;

declaration_list:
  (declarations)? lfs EOF		# FullDeclarationList
  ;

declarations:
  declaration (lfp declaration)*
  ;

declaration: 
  (comment_statement lfp)*
  (attribute_declaration
  | category_declaration
  | resource_declaration
  | enum_declaration
  | method_declaration )
  ;

resource_declaration:
  native_resource_declaration
  ;

enum_declaration :
  enum_category_declaration	
  | enum_native_declaration	
  ;
   
native_symbol_list:
  native_symbol (lfp native_symbol)*
  ;

category_symbol_list:
  category_symbol (lfp category_symbol)*
  ;  

symbol_list:
  symbol_identifier (COMMA symbol_identifier)*
  ;
  

attribute_constraint:
  IN source=list_literal			# MatchingList
  | IN source=set_literal 			# MatchingSet
  | IN source=range_literal 		# MatchingRange
  | MATCHING text=TEXT_LITERAL 		# MatchingPattern
  | MATCHING exp=expression 		# MatchingExpression
  ;

list_literal:
  MUTABLE? LBRAK ( expression_list )? RBRAK
  ;

set_literal:
  MUTABLE? LT ( expression_list )? GT
  ;

expression_list:
  expression ( COMMA expression)*
  ;

range_literal:
  LBRAK low=expression RANGE high=expression RBRAK
  ;

typedef: 
  p=primary_type				# PrimaryType
  | s=typedef LTGT 				# SetType
  | l=typedef LBRAK RBRAK 		# ListType
  | d=typedef LCURL RCURL 		# DictType
  | CURSOR LT c=typedef GT 		# CursorType
  | ITERATOR LT i=typedef GT 	# IteratorType
  ;
   
primary_type:
  n=native_type			# NativeType
  | c=category_type		# CategoryType
  ;
  
native_type:
  BOOLEAN			# BooleanType
  | CHARACTER		# CharacterType
  | TEXT			# TextType
  | IMAGE			# ImageType
  | INTEGER			# IntegerType
  | DECIMAL			# DecimalType
  | DOCUMENT		# DocumentType
  | DATE			# DateType
  | DATETIME		# DateTimeType
  | TIME			# TimeType
  | PERIOD			# PeriodType
  | CODE			# CodeType
  | BLOB			# BlobType
  | UUID			# UUIDType
  ;
  
category_type:
  t1=TYPE_IDENTIFIER
  ;

mutable_category_type:
  MUTABLE? category_type
  ;
  	
code_type:
  t1=CODE
  ; 
  
category_declaration:
  decl=concrete_category_declaration	# ConcreteCategoryDeclaration
  | decl=native_category_declaration	# NativeCategoryDeclaration
  | decl=singleton_category_declaration	# SingletonCategoryDeclaration
  ;

type_identifier_list  :
  type_identifier (COMMA type_identifier)*
  ;

method_identifier:
  variable_identifier
  | type_identifier
  ;
  
identifier:
  variable_identifier	# VariableIdentifier
  | type_identifier		# TypeIdentifier
  | symbol_identifier	# SymbolIdentifier
  ;  
  
variable_identifier:
  VARIABLE_IDENTIFIER
  ;
  
attribute_identifier:
  VARIABLE_IDENTIFIER | STORABLE
  ;
  
type_identifier:
  TYPE_IDENTIFIER
  ; 

symbol_identifier:
  SYMBOL_IDENTIFIER
  ; 

argument_list:
  argument (COMMA argument)*
 ;

argument:
  arg=code_argument					# CodeArgument	
  | MUTABLE? arg=operator_argument	# OperatorArgument
  ;
  
operator_argument:
  named_argument
  | typed_argument
  ;
   

named_argument:
  variable_identifier
  	( EQ literal_expression)?
  ;

code_argument:
  code_type name=variable_identifier
  ;
  
category_or_any_type:
  typedef	
  | any_type			
  ;

any_type:
  ANY						# AnyType
  | any_type LBRAK RBRAK	# AnyListType
  | any_type LCURL RCURL	# AnyDictType
  ;

member_method_declaration_list:
  member_method_declaration (lfp member_method_declaration)*
  ;
  
member_method_declaration:
  setter_method_declaration			
  | getter_method_declaration			
  | concrete_method_declaration		
  | abstract_method_declaration		
  | operator_method_declaration	
  ;

native_member_method_declaration_list:
  native_member_method_declaration (lfp native_member_method_declaration)*
  ;

native_member_method_declaration:
  native_getter_declaration			
  | native_setter_declaration			
  | native_method_declaration			
  ;

native_category_binding:
  JAVA binding=java_class_identifier_expression		# JavaCategoryBinding
  | CSHARP binding=csharp_identifier_expression		# CSharpCategoryBinding
  | PYTHON2 binding=python_category_binding			# Python2CategoryBinding
  | PYTHON3 binding=python_category_binding			# Python3CategoryBinding
  | JAVASCRIPT binding=javascript_category_binding	# JavaScriptCategoryBinding
  ;  

python_category_binding:
  identifier python_module?
  ;
  
python_module:
  FROM module_token COLON identifier (DOT identifier)*
  ;
  
javascript_category_binding:  
  identifier javascript_module?
  ;
  
javascript_module:  
  FROM module_token COLON SLASH? javascript_identifier (SLASH javascript_identifier)* (DOT javascript_identifier)?
  ;
   
variable_identifier_list:
  variable_identifier (COMMA variable_identifier)*
  ;

attribute_identifier_list:
  attribute_identifier (COMMA attribute_identifier)*
  ;
  
method_declaration:
  abstract_method_declaration
  | concrete_method_declaration
  | native_method_declaration
  | test_method_declaration
  ; 

comment_statement:
  COMMENT
  ;
  
native_statement_list:
  native_statement (lfp native_statement)*
  ;
 
native_statement:
  JAVA java_statement						# JavaNativeStatement
  | CSHARP csharp_statement					# CSharpNativeStatement
  | PYTHON2 python_native_statement			# Python2NativeStatement
  | PYTHON3 python_native_statement			# Python3NativeStatement
  | JAVASCRIPT javascript_native_statement 	# JavaScriptNativeStatement
  ;   
   
python_native_statement:
  python_statement SEMI? python_module?
  ;

javascript_native_statement:
  javascript_statement SEMI? javascript_module?
  ;

statement_list:
  statement	(lfp statement)*
  ;
  
assertion_list:
  assertion	(lfp assertion)*
  ;  

switch_case_statement_list:
  switch_case_statement (lfp switch_case_statement)*
  ;

catch_statement_list:
  catch_statement (lfp catch_statement)*
  ;
  
  	
literal_collection:
  LBRAK low=atomic_literal 
  	RANGE high=atomic_literal RBRAK		# LiteralRangeLiteral
  | LBRAK literal_list_literal RBRAK	# LiteralListLiteral
  | LT literal_list_literal GT			# LiteralSetLiteral
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
  | t=UUID_LITERAL				# UUIDLiteral
  | n=null_literal				# NullLiteral
  ;
   
literal_list_literal:
  atomic_literal (COMMA atomic_literal)*
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
  LPAR expression RPAR
  ;  

literal_expression:
  atomic_literal
  | collection_literal	
  ;
  
collection_literal:
  range_literal				
  | list_literal		
  | set_literal			
  | dict_literal		
  | tuple_literal		
  ;     

tuple_literal:
  MUTABLE? LPAR expression_tuple? RPAR
  ;
    
dict_literal: 
  MUTABLE? LCURL dict_entry_list? RCURL	
  ; 

expression_tuple:
  // comma is mandatory to avoid collision with parenthesis expression
  expression COMMA (expression (COMMA expression)*)?
  ; 

dict_entry_list:
  dict_entry (COMMA dict_entry)*
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
  variable_identifier assign expression
  ;  

assignable_instance:
  variable_identifier 		# RootInstance
  | assignable_instance 
  	child_instance	 	# ChildInstance
  ;

is_expression:
  {$parser.willBeAOrAn()}? VARIABLE_IDENTIFIER category_or_any_type		# IsATypeExpression
  | expression															# IsOtherExpression		
  ;

order_by_list:
	order_by ( COMMA order_by )*
	;
	
order_by:
	variable_identifier (DOT variable_identifier)* ( ASC | DESC)?
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
new_token:
  i1=VARIABLE_IDENTIFIER {$parser.isText($i1,"new")}? 
  ; 

key_token:
  i1=VARIABLE_IDENTIFIER {$parser.isText($i1,"key")}? 
  ; 

module_token:
  i1=VARIABLE_IDENTIFIER {$parser.isText($i1,"module")}? 
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
native_setter_declaration:;
native_getter_declaration:;
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