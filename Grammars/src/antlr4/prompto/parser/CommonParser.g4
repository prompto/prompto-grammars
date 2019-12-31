parser grammar CommonParser;

import JavaScriptParser, PythonParser, JavaParser, CSharpParser, JsxParser, CssParser;

repl:
  declaration 					
  | statement					
  | expression					
  ;
  	
declaration_list:
  (declarations)? lfs EOF		# FullDeclarationList
  ;

declarations:
  declaration (lfp declaration)*
  ;

declaration: 
  (comment_statement lfp)*
  (annotation_constructor lfp)*
  (attribute_declaration
  | category_declaration
  | resource_declaration
  | enum_declaration
  | widget_declaration
  | method_declaration )
  ;

annotation_constructor:
  name=annotation_identifier ( LPAR (exp=annotation_argument_value | (annotation_argument (COMMA annotation_argument)*)) RPAR )?
  ;

annotation_identifier:
  ARONDBASE_IDENTIFIER 
  ;

annotation_argument:
  name=annotation_argument_name EQ exp=annotation_argument_value
  ;

annotation_argument_name:
  VARIABLE_IDENTIFIER
  | GETTER
  | SETTER
  // any keyword is acceptable here
  ;
  		
annotation_argument_value:
  exp=literal_expression # AnnotationLiteralValue
  | typ=primary_type	 # AnnotationTypeValue
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
  | d=typedef LTCOLONGT 		# DictType
  | CURSOR LT c=typedef GT 		# CursorType
  | ITERATOR LT i=typedef GT 	# IteratorType
  ;
   
primary_type:
  n=native_type			# NativeType
  | c=category_type		# CategoryType
  ;
  
native_type:
  BOOLEAN			# BooleanType
  | CSS				# CssType
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
  | VERSION			# VersionType
  | CODE			# CodeType
  | BLOB			# BlobType
  | UUID			# UUIDType
  | HTML			# HtmlType
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

widget_declaration:
  decl=concrete_widget_declaration	    # ConcreteWidgetDeclaration
  | decl=native_widget_declaration		# NativeWidgetDeclaration
  ;

type_identifier_list  :
  type_identifier (COMMA type_identifier)*
  ;

method_identifier:
  variable_identifier
  | type_identifier
  ;

identifier_or_keyword:
    identifier
    | keyword
    ;

nospace_hyphen_identifier_or_keyword:
    {$parser.wasNotWhiteSpace()}? MINUS nospace_identifier_or_keyword
    ;


nospace_identifier_or_keyword:
    {$parser.wasNotWhiteSpace()}? identifier_or_keyword
    ;


identifier:
  variable_identifier	# VariableIdentifier
  | type_identifier		# TypeIdentifier
  | symbol_identifier	# SymbolIdentifier
  ;  
 
 
member_identifier:
  VARIABLE_IDENTIFIER | CATEGORY
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
  (comment_statement lfp)*
  (annotation_constructor lfp)*
  (setter_method_declaration			
  | getter_method_declaration			
  | concrete_method_declaration		
  | abstract_method_declaration		
  | operator_method_declaration)
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
  FROM module_token COLON python_identifier (DOT python_identifier)*
  ;
  
javascript_category_binding:  
  javascript_identifier (DOT javascript_identifier)* javascript_module?
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
  MIN_INTEGER				# MinIntegerLiteral
  | MAX_INTEGER				# MaxIntegerLiteral
  | INTEGER_LITERAL 		# IntegerLiteral
  | HEXA_LITERAL			# HexadecimalLiteral
  | CHAR_LITERAL			# CharacterLiteral
  | DATE_LITERAL			# DateLiteral
  | TIME_LITERAL			# TimeLiteral
  | TEXT_LITERAL			# TextLiteral
  | DECIMAL_LITERAL 		# DecimalLiteral
  | DATETIME_LITERAL		# DateTimeLiteral
  | BOOLEAN_LITERAL			# BooleanLiteral
  | PERIOD_LITERAL			# PeriodLiteral
  | VERSION_LITERAL			# VersionLiteral
  | UUID_LITERAL			# UUIDLiteral
  | type_literal			# TypeLiteral
  | null_literal			# NullLiteral
  // TODO symbol_literal?
  ;
   
literal_list_literal:
  atomic_literal (COMMA atomic_literal)*
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
  | document_literal
  | tuple_literal		
  ;     

tuple_literal:
  MUTABLE? LPAR expression_tuple? RPAR
  ;
    
dict_literal:
  MUTABLE? ((LT dict_entry_list GT) | LTCOLONGT | (LT COLON GT))
  ; 

document_literal:
  LCURL dict_entry_list? RCURL	
  ; 

expression_tuple:
  // comma is mandatory to avoid collision with parenthesis expression
  expression COMMA (expression (COMMA expression)*)?
  ; 


dict_entry_list:
  dict_entry (COMMA dict_entry)*
  ;

dict_entry:
  key=dict_key COLON value=expression
  ; 

dict_key:
  name=identifier_or_keyword	# DictKeyIdentifier
  | name=TEXT_LITERAL			# DictKeyText 	
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
  variable_identifier 	# RootInstance
  | assignable_instance 
  	child_instance	 	# ChildInstance
  ;

is_expression:
  {$parser.willBeAOrAn()}? VARIABLE_IDENTIFIER category_or_any_type		# IsATypeExpression
  | expression															# IsOtherExpression		
  ;

arrow_expression:
  arrow_prefix expression 						# ArrowExpressionBody
  | arrow_prefix LCURL statement_list RCURL	 	# ArrowStatementsBody
  ;
  
arrow_prefix:
  arrow_args s1=ws_plus EGT s2=ws_plus 	
  ;
  
arrow_args:
  variable_identifier						# ArrowSingleArg
  | LPAR variable_identifier_list? RPAR		# ArrowListArg
  ;
  
sorted_key:
  instance_expression 
  | arrow_expression
  ;		
  	   	
read_all_expression:
  READ ALL FROM source=expression
  ;
  
read_one_expression:
  READ ONE FROM source=expression
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

keyword:
    JAVA
    | CSHARP
    | PYTHON2
    | PYTHON3
    | JAVASCRIPT
    | SWIFT
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
    | CODE
    | DOCUMENT
    | BLOB
    | IMAGE
    | UUID
    | ITERATOR
    | CURSOR
    | HTML
    | ABSTRACT
    | ALL
    | ALWAYS
    | AND
    | ANY
    | AS
    | ASC
    | ATTR
    | ATTRIBUTE
    | ATTRIBUTES
    | BINDINGS
    | BREAK
    | BY
    | CASE
    | CATCH
    | CATEGORY
    | CLASS
    | CLOSE
    | CONTAINS
    | DEF
    | DEFAULT
    | DEFINE
    | DELETE
    | DESC
    | DO
    | DOING
    | EACH
    | ELSE
    | ENUM
    | ENUMERATED
    | EXCEPT
    | EXECUTE
    | EXPECTING
    | EXTENDS
    | FETCH
    | FILTERED
    | FINALLY
    | FLUSH
    | FOR
    | FROM
    | GETTER
    | HAS
    | IF
    | IN
    | INDEX
    | IS
    | MATCHING
    | METHOD
    | METHODS
    | MODULO
    | MUTABLE
    | NATIVE
    | NONE
    | NOT
    | NOTHING
    | NULL
    | ON
    | ONE
    | OPEN
    | OPERATOR
    | OR
    | ORDER
    | OTHERWISE
    | PASS
    | RAISE
    | READ
    | RECEIVING
    | RESOURCE
    | RETURN
    | RETURNING
    | ROWS
    | SELF
    | SETTER
    | SINGLETON
    | SORTED
    | STORABLE
    | STORE
    | SWITCH
    | TEST
    | THIS
    | THROW
    | TO
    | TRY
    | VERIFYING
    | WIDGET
    | WITH
    | WHEN
    | WHERE
    | WHILE
    | WRITE
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
lfs:; // see MParser and EParser
lfp:; // see MParser and EParser
ws_plus:; // see MParser and EParser
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
concrete_widget_declaration:;
native_widget_declaration:;
setter_method_declaration:;
getter_method_declaration:;
native_setter_declaration:;
native_getter_declaration:;
operator_method_declaration:;
instance_expression:;
typed_argument:;
native_symbol:;
category_symbol:;
expression:;
assertion:;
statement:;
switch_case_statement:;
catch_statement:;
child_instance:;
type_literal:;
null_literal:;