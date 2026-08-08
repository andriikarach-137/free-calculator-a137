module Expr where 

data BinOp = Add | Sub | Mul | Div | Pow

data UnOp = Neg | Exp | Log | Sin | Cos | Tan 

data Expr 
    = BinOp Expr Expr 
    | UnOp Expr 

