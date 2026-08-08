module Expr where 

data BinOp = Add | Sub | Mul | Div | Pow

data UnOp = Neg | Exp | Log | Sin | Cos | Tan 

data Expr 
    = BinOp BinOp Expr Expr 
    | UnOp UnOp Expr 
    | Num Int 
    | IDENTIFIER String 

data Assgn = Let String Expr 

data Stmt = Expr Expr | Assgn Assgn 