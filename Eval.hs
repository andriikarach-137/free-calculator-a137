module Eval where 

import Expr 


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
