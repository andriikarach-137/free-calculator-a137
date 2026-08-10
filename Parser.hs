module Parser where 

import ParseUtils
import Expr 

import Control.Applicative


-- Terminal rules parsers 

parseNUM :: Parser Expr 
parseNUM = Num <$> double 


parseIDENTIFIER :: Parser Expr 
parseIDENTIFIER = Identifier <$> ((:) <$> alpha <*> many (alpha <|> digit))

-- Parsers for non-terminal rules 

parsePrimary :: Parser Expr 
parsePrimary = char '(' *> parseExpr <* char ')' <|> parseNUM <|> parseIDENTIFIER


parsePostfix :: Parser Expr 
parsePostfix = combine <$> parsePrimary <*> (many $ char '!')
  where
    combine :: Expr -> String -> Expr 
    combine = foldl (\e _ -> UnOp Fact e)


parseUnary :: Parser Expr 
parseUnary = parsePostfix 
  <|> UnOp Neg <$> (char '-' *> parseUnary)
  <|> UnOp Log <$> (string "log" *> parseUnary)
  <|> UnOp Sin <$> (string "sin" *> parseUnary)
  <|> UnOp Cos <$> (string "cos" *> parseUnary)
  <|> UnOp Tan <$> (string "tan" *> parseUnary)


parseFactor :: Parser Expr 
parseFactor = combine <$> parseUnary <*> parseFactor' 
  where
    combine :: Expr -> [Expr] -> Expr 
    combine e [] = e 
    combine e es = BinOp Pow e $ foldr1 (BinOp Pow) es 

    parseFactor' :: Parser [Expr]
    parseFactor' = many $ char '^' *> parseFactor  


combine :: Expr -> [(BinOp, Expr)] -> Expr 
combine = foldl (\e (op, e') -> BinOp op e e') 


parseTerm :: Parser Expr 
parseTerm = combine <$> parseFactor <*> many parseTerm' 
  where
    parseTerm' :: Parser (BinOp, Expr) 
    parseTerm' = (Mul, ) <$> (char '*' *> parseFactor) <|> 
                 (Div, ) <$> (char '/' *> parseFactor)


parseExpr :: Parser Expr 
parseExpr = combine <$> parseTerm <*> many parseExpr' 
  where
    parseExpr' :: Parser (BinOp, Expr)
    parseExpr' = (Add, ) <$> (char '+' *> parseTerm) <|>
                 (Sub, ) <$> (char '-' *> parseTerm)