module BNF where 

-- Backus-Naur-Form for the calculator 

{-
<assign>   ::= <var> <asgn_op> <expr>
<expr>     ::= <term> ((<add>|<sub>) <term>)*
<term>     ::= <factor> ((<mul>|<div>) <factor>)*
<factor>   ::= <unary> | <unary> <pow> <factor> 
<unary>    ::= <postfix> | <neg> <unary> | <log> <unary> | <sin> <unary> | <cos> <unary> | <tan> <unary> 
<postfix>  ::= primary postfix' 
<postfix'> ::= <fact> postfix' | <eps>
<primary>  ::= <lbr> <expr> <rbr> | <val> | <var>
<var>      ::= <char> (<char> | <num>)*
-}