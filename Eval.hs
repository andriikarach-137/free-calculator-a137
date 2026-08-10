module Eval where 

import Expr 

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
unOp Sin = Just . sin 
unOp Cos = Just . cos 
unOp Tan = Just . tan 
unOp Fact = safeFact 
  where
    safeFact x | x < 0 || (snd (properFraction x) /= 0) = Nothing 
               | otherwise = Just $ product [1..x]


eval :: Env -> Expr -> Maybe (Double, Env)
eval env (BinOp op e e') = do
    (x, env') <- eval env e 
    (y, env'') <- eval env' e' 
    v <- binOps op x y 
    pure (v, env'')  
eval env (UnOp op e) = do 
    (x, env') <- eval env e 
    v <- unOps op x 
    pure (v, env') 
eval env (Val x) = Just (x, env)
eval env (Var x) = do 
    v <- Map.lookup x env 
    pure (v, env) 
eval env (Assign x e) = do
    (v, env') <- eval env e 
    pure (v, Map.insert x v env') 