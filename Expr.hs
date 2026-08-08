module Expr where 

data BinOp = Add | Sub | Mul | Div | Pow

data UnOp = Neg | Inv | Exp | Log | Fact 

data Expr 
    = BinOp Expr Expr 
    | UnOp Expr 

