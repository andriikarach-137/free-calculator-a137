module BNF where 

-- Backus-Naur-Form for the calculator 

{-
<code>     ::= (<stmt>)*
<stmt>     ::= <assgn> | <expr> 
<assgn>    ::= <var> <asgn_op> <expr>
<expr>     ::= <term> ((<add>|<sub>) <term>)*
<term>     ::= <factor> ((<mul>|<div>) <factor>)*
<factor>   ::= <unary> | <unary> <pow> <factor> 
<unary>    ::= <postfix> | <neg> <unary> | <log> <unary> | <sin> <unary> | <cos> <unary> | <tan> <unary> 
<postfix>  ::= primary postfix' 
<postfix'> ::= <fact> postfix' | <eps>
<primary>  ::= <lbr> <expr> <rbr> | <num> | <var>
<var>      ::= <char> (<char> | <num>)*
-}

