# free-calculator-a137

In order to run an interpreter, just write run in ghci after loading Run.hs file

This project extends on my previous project, which was a primitive and limited applicative parser. This one however,
is a full on "REPL"-like interpreter for a mini language that I constructed. Language consists of two simple units,
mainly expressions and statements 

Expressions range from various binary and unary operations, while there's only one type of statement - assignment. 

In order to parse a language, I used a famous algorithm - recursive descent parser. The principle of it is simple - 
in order to parse a certain rule, we must first parse its subrules, hence name recursive. As to the model of parsers
themselves, I used parser combinators, where a parser is an effectful computation, a wrapper of a function which takes
in a string and then returns parsed value with string residual, all wrapped in the context of failure - hence 
Maybe (a, String). Below is specified BNF of the language. 


RULES OF THE LANGUAGE:

<stmt>     ::= <assgn> | <expr> 
<assgn>    ::= LET IDENTIFIER ASSGN_OP <expr>
<expr>     ::= <term> ((PLUS|MINUS) <term>)*
<term>     ::= <factor> ((STAR|DASH) <factor>)*
<factor>   ::= <unary> (POW <factor>)* 
<unary>    ::= <postfix> | MINUS <unary> | LOG <unary> | SIN <unary> | COS <unary> | TAN <unary> 
<postfix>  ::= <primary> (FACT)*
<primary>  ::= LBR <expr> RBR | NUM | IDENTIFIER 

TERMINAL TOKENS:

IDENTIFIER ::= CHAR (CHAR | DIGIT)*
NEWLINE    ::= "\n"
LET        ::= "let"
ASSGN_OP   ::= "<<"
PLUS       ::= "+"
MINUS      ::= "-"
STAR       ::= "*"
DASH       ::= "/"
POW        ::= "^"
LOG        ::= "log"
SIN        ::= "sin"
COS        ::= "cos"
TAN        ::= "TAN"
FACT       ::= "!"
LBR        ::= "("
RBR        ::= ")"
EXIT       ::= ":q"
NUM        handled internally 
CHAR       handled internally 