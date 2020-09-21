# Lexical-analyser-for-cool-language-using-antlr
# COOL Compiler #
I have written a lexical analyser for the cool language using antlr in java.

The grammar of the lexical analyser is to get the lexical units of cool :
1.Integers
2.Identifiers(Type and Object)
3.Special notations
4.Strings
5.Key words
6.White space

First special symbols,keywords,integers and bool constants are defined.

Keywords and Bool constants(true and false) should be kept before the identifiers to make sure that keywords like true,false.. are not tokenised as identifiers.

Identifiers contain alphabet,integers and underscore.

White space consists of sequence of characters:' ',\n,\f,\r,\t.These are skipped if there are not in a string.

A string constant is defined as one which begins with a double quote and ends with double quote. The function processstring() is called in the STR_CONST which formats the string and checks if there are any errors like unescaped null character,if string length is too long and reports these errors to parser.

Comments in cool are of two types:
Single line comments are between -- and newline(or EOF)
Multiline comments which can be nested,these are of the form (*....*)

Invalid function is written if it finds a token that is not identified in above.

There are number of errors which can occur namely
1.Unterminated string constant.
2.EOF in string
3.String contains null/escaped null character.
4.String constant too long.
5.Backslash at the end of the file.
6.EOF in a comment.
7.Unmatched *)
8.Invalid token.

HANDLING THE ERRORS:
1.Unterminated string constant occurs when a string contains unescaped new line.This error is handled in the regrex ERRORSTRING where it checks for an unescaped newline after the opening quote.

2.EOF in string occurs when end of the file is encountered in a string before the close quote.This error is handled in EOF_STRING where it checks for EOF after the opening quote.

3.String contains null/escaped null character occurs when a null character is encountered in a string.This is handled in the processstring().
A null character may also occur after the opening quotes,this is handled in NULL.

4..String constant too long occurs when the number of characters between the double quotes is more than 1024.This is handled in the processstring() by iterating through the whole string with \c denoting c with exceptions of b,t,n,f.

5.Backslash at the end of the file occurs when a single slash is encoutered in a string at the end of the file.This is handled in BACKSLASH.

6.EOF in a comment occurs when *) is not encountered to match the opening(*.This is handled in MULTICOMMENT.

7.Unmatched *) occurs if a opening(* is not encountered.This is handled in ERRORCOMMENT.

8.Invalid token occurs when a token in cool does not match to any defined tokens.This error is reported using a invalid() function kept in INVALID.

All the rules are intentionally kept in a order because ANTLR lexically matches the tokens from top to bottom.
This is the reason why ERRORSTRING(which identifies unescaped newline),EOF_STRING(identifies eof in a string),BACKSLASH(backslash at the end of the string) these rules are kept before STR_CONST.
These errors are identified before and reported accordingly.
  
In the test cases I have included all the errors which can be generated when given as input to the lexical analyser.
