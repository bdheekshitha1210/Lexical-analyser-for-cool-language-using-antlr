lexer grammar CoolLexer;

tokens{
	ERROR,
	TYPEID,
	OBJECTID,
	BOOL_CONST,
	INT_CONST,
	STR_CONST,
	LPAREN,
	RPAREN,
	COLON,
	ATSYM,
	SEMICOLON,
	COMMA,
	PLUS,
	MINUS,
	STAR,
	SLASH,
	TILDE,
	LT,
	EQUALS,
	LBRACE,
	RBRACE,
	DOT,
	DARROW,
	LE,
	ASSIGN,
	CLASS,
	ELSE,
	FI,
	IF,
	IN,
	INHERITS,
	LET,
	LOOP,
	POOL,
	THEN,
	WHILE,
	CASE,
	ESAC,
	OF,
	NEW,
	ISVOID,
	NOT
}

/*
  DO NOT EDIT CODE ABOVE THIS LINE
*/

@members{

	/*
		YOU CAN ADD YOUR MEMBER VARIABLES AND METHODS HERE
	*/

	/**
	* Function to report errors.
	* Use this function whenever your lexer encounters any erroneous input
	* DO NOT EDIT THIS FUNCTION
	*/
	public void reportError(String errorString){
		setText(errorString);
		setType(ERROR);
	}
	//function for invalid tokens
	public void invalid(){
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		reportError(text);
	}

	public void processString() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();

		//write your code to test strings here
		String result = "";
		text=text.substring(1,text.length()-1);

			int i=0;
			while(i<text.length())
			{
				if(text.charAt(i)=='\u0000')
				{
					reportError("String contains null character.");//if string contains a null character
					return;
				}
				
				else if(text.charAt(i)=='\\')
				{
					if(text.charAt(i+1)=='n')
						result=result.concat("\n");

					else if(text.charAt(i+1)=='\n')
						result=result.concat("\n");

					else if(text.charAt(i+1)=='0')
						result=result.concat("0");

					else if(text.charAt(i+1)=='b')
						result=result.concat("\b");

					else if(text.charAt(i+1)=='f')
						result=result.concat("\f");

					else if(text.charAt(i+1)=='t')
						result=result.concat("\t");

					else if(text.charAt(i+1)=='\u0000')
					{
						reportError("String contains escaped null character.");//if string has escaped null character
						return;
					}

					else result=result.concat(String.valueOf(text.charAt(i+1)));

					i=i+2;
					continue;
				}
				else
				{
					result=result.concat(String.valueOf(text.charAt(i)));
					i=i+1;
				}
			}
			if(result.length()>1024)
			{
				reportError("String constant too long");
				return;
			}
			setText(result);
		
		return;

	}
}

/*
	WRITE ALL LEXER RULES BELOW
*/

//special symbols
SEMICOLON   : ';';
DARROW      : '=>';
COMMA		: ',';
PLUS		: '+';
MINUS		: '-';
STAR        : '*';
SLASH		: '/';
DOT         : '.';
COLON       : ':';
EQUALS		: '=';
ASSIGN		: '<-';
LPAREN		: '(';
RPAREN		: ')';
LBRACE      : '{';
RBRACE		: '}';
TILDE		: '~';
ATSYM		: '@';
LT 			: '<';
LE 			: '<=';

//keywords(these are case insensitive)
IF			: ('I'|'i')('F'|'f');
ELSE		: ('E'|'e')('L'|'l')('S'|'s')('E'|'e');
FI          : ('F'|'f')('I'|'i');
CLASS		: ('C'|'c')('L'|'l')('A'|'a')('S'|'s')('S'|'s');
IN  		: ('I'|'i')('N'|'n');
INHERITS    : ('I'|'i')('N'|'n')('H'|'h')('E'|'e')('R'|'r')('I'|'i')('T'|'t')('S'|'s');
LET			: ('L'|'l')('E'|'e')('T'|'t');
LOOP		: ('L'|'l')('O'|'o')('O'|'o')('P'|'p');
POOL 		: ('P'|'p')('O'|'o')('O'|'o')('L'|'l');
THEN		: ('T'|'t')('H'|'h')('E'|'e')('N'|'n');
WHILE		: ('W'|'w')('H'|'h')('I'|'i')('L'|'l')('E'|'e');
CASE		: ('C'|'c')('A'|'a')('S'|'s')('E'|'e');
ESAC		: ('E'|'e')('S'|'s')('A'|'a')('C'|'c');
OF			: ('O'|'o')('F'|'f');
NEW			: ('N'|'n')('E'|'e')('W'|'w');
ISVOID		: ('I'|'i')('S'|'s')('V'|'v')('O'|'o')('I'|'i')('D'|'d');
NOT			: ('N'|'n')('O'|'o')('T'|'t');

//integers
INT_CONST   : [0-9]+;

//first letter must be lower case
BOOL_CONST	: 't' ('r'|'R') ('u'|'U') ('e'|'E') | 'f' ('a'|'A') ('l'|'L') ('s'|'S') ('e'|'E') ;

TYPEID		: [A-Z] [a-zA-Z0-9_]*;//type identifiers
OBJECTID	: [a-z] [a-zA-Z0-9_]*;//object identifiers

//strings
WHITE       : (' ' | '\t' | '\n' | '\r' | '\f'|'\u000b') -> skip;
//If a null character occurs without the close quote
NULL        :  '"'(~'"')*?('\u0000')(~'"')*?('\n'){reportError("String contains null character");};

//If unescaped newline occurs lexer reports a error
ERRORSTRING	: ('"'((~('"'|'\\'|'\n'))|'\\'(.))*?('\n')){reportError("Unterminated string constant");};

//EOF occurs before the close quote
EOF_STRING	: '"'((~('"'|'\n'|'\\'))|('\\')(.))*?(EOF) { reportError("EOF in string constant"); };

//if there is \ at the end of the file
BACKSLASH	: '"'((~('"'|'\n'|'\\'))|('\\')(.))*?('\\')(EOF) { reportError("backslash at end of file"); };

//strings
STR_CONST 	: '"' (('\\')('\\')|'\\''"'|((('\\')('\\'))+|~'\\')('\\')('\n')|~'\n')*? '"'{processString();};

//comments
SINGLE      : '--'(.)*? ('\n'|(EOF)) -> skip;
//for a unmatched *)
ERRORCOMMENT: ('*)'(EOF)|'*)') {reportError("Unmatched *)");};

//multiline comments
MULTICOMMENT: '(*'-> pushMode(FIRST), skip;//multiline comments can be nested
//when an invalid character occurs error is reported
INVALID		: .{invalid();};

//used for multiline comments
mode FIRST;
ERR     	: .(EOF) { reportError("EOF in comment"); } ;
OPEN	    : '(*' -> skip,pushMode(SECOND);
CLOSE	    : '*)' ->  skip,popMode ;
INC         : . -> skip ;

mode SECOND;
ERR3		: .(EOF) { reportError("EOF in comment"); } ;
OCOM		: '(*' -> skip, pushMode(SECOND) ;//for nesting
ERR4		: '*)' EOF { reportError("EOF in comment"); } ; 
CCOM		: '*)' -> skip,popMode;
INCOM	    : . -> skip ;



