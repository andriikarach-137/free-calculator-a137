module Eval where 

import Expr 
import ParseUtils
import Parser 

import Data.Map (Map)
import Data.Map qualified as Map 


type Env = Map String Double


lift :: (Eq a, Fractional a) => (a -> a -> a) -> a -> a -> Maybe a 
lift = (.) (Just .) 


binOps :: BinOp -> Double -> Double -> Maybe Double
binOps Add = lift (+)
binOps Sub = lift (-)
binOps Mul = lift (*)
binOps Div = safeDiv 
  where
    safeDiv _ 0 = Nothing 
    safeDiv m n = Just $ m / n 
binOps Pow = safePow 
  where
    safePow x y | x < 0 && (snd (properFraction y) /= 0) = Nothing 
                | otherwise = Just $ x ** y 


unOps :: UnOp -> Double -> Maybe Double 
unOps Neg = Just . negate 
unOps Exp = Just . exp 
unOps Log = safeLog 
  where 
    safeLog x | x < 0 = Nothing 
              | otherwise = Just $ log x 
unOps Sin = Just . sin 
unOps Cos = Just . cos 
unOps Tan = Just . tan 
unOps Fact = safeFact 
  where
    safeFact x | x < 0 || (snd (properFraction x) /= 0) = Nothing 
               | otherwise = Just $ product [1..x]


eval :: Env -> Expr -> Maybe Double 
eval env (BinOp op e e') = do
    x <- eval env e 
    y <- eval env e' 
    binOps op x y 
eval env (UnOp op e) = do 
    x <- eval env e 
    unOps op x 
eval _ (Val x) = Just x  
eval env (Var x) = Map.lookup x env 


assign :: Env -> Assign -> Maybe Env 
assign env (Let s e) = do 
    v <- eval env e 
    pure $ Map.insert s v env 

  
execStmt :: Env -> Stmt -> IO Env 
execStmt env (Expr e) = case eval env e of 
  Nothing -> do
    putStrLn "Evaluation Error" 
    pure env 
  Just v -> do
    print v 
    pure env 
execStmt env (Assign a) = case assign env a of 
  Nothing -> do 
    putStrLn "Evaluation Error"
    pure env 
  Just env' -> pure env' 
