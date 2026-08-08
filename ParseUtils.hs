module ParseUtils where 

import Data.Functor
import Control.Applicative
import Data.Char 


newtype Parser a = Parser {runParse :: String -> Maybe (a, String)}


instance Functor Parser where 
    -- fmap :: (a -> b) -> Parser a -> Parser b 
    fmap f px = Parser $ \s ->
        (\(x, s') -> (f x, s')) <$> runParse px s 


instance Applicative Parser where 
    -- pure :: a -> Parser a 
    pure x = Parser $ \s -> Just (x, "")

    -- (<*>) :: Parser (a -> b) -> Parser a -> Parser b 
    pf <*> px = Parser $ \s -> do 
        (f, s') <- runParse pf s 
        (x, s'') <- runParse px s' 
        return (f x, s'') 


instance Monad Parser where 
    -- return :: a -> Parser a 
    return = pure 

    -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b 
    mx >>= mf = Parser $ \s -> do 
        (x, s') <- runParse mx s
        runParse (mf x) s' 


instance Alternative Parser where 
    -- empty :: Parser a 
    empty = Parser $ \s -> Nothing 

    -- (<|>) :: Parser a -> Parser a -> Parser a 
    px <|> py = Parser $ \s -> runParse px s <|> runParse py s 


satisfy :: (Char -> Bool) -> Parser Char 
satisfy f = Parser $ \s -> case s of 
    ""                 -> Nothing 
    (c:cs) | f c       -> Just (c, cs) 
           | otherwise -> Nothing  


char :: Char -> Parser Char 
char = satisfy . (==) 


digit :: Parser Char 
digit = satisfy (isDigit) 


digits :: Parser String 
digits = some digit 


numDouble :: Parser Double 
numDouble = (read <$> ((++) <$> digits <*> (frac))) <|> (read <$> digits) <|> (read <$> frac)
  where
    frac :: Parser String
    frac = (:) <$> char '.' <*> digits 


double :: Parser Double 
double = signDouble <*> numDouble 
  where 
    signDouble :: Parser (Double -> Double)
    signDouble = (char '-' $> negate) <|> pure id 


spaces :: Parser ()
spaces = () <$ many (satisfy isSpace)


lexeme :: Parser a -> Parser a 
lexeme p = p <* spaces 