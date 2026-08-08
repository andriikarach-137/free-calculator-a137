module Expr where 

data BinOp = Add | Sub | Mul | Div | Expr 

data UnOp = Neg | Fact 

data Expr 
    = BinOp Expr Expr 
    | UnOp Expr 

