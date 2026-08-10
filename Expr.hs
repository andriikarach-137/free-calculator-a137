module Expr where 

data BinOp = Add | Sub | Mul | Div | Pow deriving (Show, Eq)

data UnOp = Neg | Exp | Log | Sin | Cos | Tan | Fact deriving (Show, Eq)

data Expr 
    = BinOp BinOp Expr Expr 
    | UnOp UnOp Expr 
    | Val Double  
    | Var String 
    | Assign String Expr 
    deriving (Show, Eq)


type Program = [Expr]