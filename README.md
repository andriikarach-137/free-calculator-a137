# free-calculator-a137
This repository extends on my previous project, which was applicative parser. Here I will implement fully free written expression calculator

Backus-Naur-Form for the calculator 

RULES OF THE LANGUAGE:

<program>  ::= (<stmt>)*
<stmt>     ::= <assgn> | <expr> 
<assgn>    ::= <let> IDENTIFIER ASSGN_OP <expr>
<expr>     ::= <term> ((PLUS|MINUS) <term>)*
<term>     ::= <factor> ((STAR|DASH) <factor>)*
<factor>   ::= <unary> | <unary> <POW> <factor> 
<unary>    ::= <postfix> | MINUS <unary> | LOG <unary> | SIN <unary> | COS <unary> | TAN <unary> 
<postfix>  ::= <primary> postfix' 
<postfix'> ::= FACT postfix' | EPS
<primary>  ::= LBR <expr> RBR | NUM | IDENTIFIER | EXIT

TERMINAL TOKENS:

IDENTIFIER ::= CHAR (CHAR | DIGIT)*
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
EPS        handled internally 