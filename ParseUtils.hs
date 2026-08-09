module ParseUtils where 

import Data.Char 
import Control.Applicative 


newtype Parser a = Parser {runParse :: String -> Maybe (a, String)}


instance Functor Parser where 
    -- fmap :: (a -> b) -> Parser a -> Parser b 
    fmap f px = Parser $ \s ->
        (\(x, s') -> (f x, s')) <$> runParse px s


instance Applicative Parser where 
    -- pure :: a -> Parser a 
    pure x = Parser $ \s -> Just (x, s)

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
    px <|> py = Parser $ \s -> 
        (runParse px s) <|> (runParse py s)


-- Parser utility functions 

satisfy :: (Char -> Bool) -> Parser Char 
satisfy f = Parser $ \s -> case s of 
    []                 -> Nothing 
    (c:cs) | f c       -> Just (c, cs) 
           | otherwise -> Nothing 


-- Character parsers 


item :: Parser Char 
item = satisfy $ const True


char :: Char -> Parser Char
char = satisfy . (==) 


string :: String -> Parser String 
string [] = Parser $ \s -> Just ("", s)
string (c:cs) = (:) <$> char c <*> string cs 


-- Numeric parsers 


digit :: Parser Char 
digit = satisfy isDigit


digits :: Parser String 
digits = some digit 


double :: Parser Double 
double = read <$> ((:) <$> char '-' <*> double' <|> double') 


double' :: Parser String 
double' = (++) <$> digits <*> (parseFrac) <|> digits 
  where 
    parseFrac :: Parser String 
    parseFrac = (:) <$> char '.' <*> digits 