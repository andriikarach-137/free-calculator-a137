module Expr where 

data BinOp = Add | Sub | Mul | Div | Pow deriving (Show, Eq)

data UnOp = Neg | Exp | Log | Sin | Cos | Tan | Fact deriving (Show, Eq)

data Expr 
    = BinOp BinOp Expr Expr 
    | UnOp UnOp Expr 
    | Num Double  
    | Identifier String 
    deriving (Show, Eq)

data Assgn = Let String Expr deriving (Show, Eq)

data Stmt = Expr Expr | Assgn Assgn | Exit deriving (Show, Eq) 

type Program = [Stmt]