module Parser where 

import ParseUtils
import Expr 

import Control.Applicative


-- Terminal rules parsers 

parseNUM :: Parser Double 
parseNUM = double 


parseIDENTIFIER :: Parser String 
parseIDENTIFIER = ((:) <$> alpha <*> many (alpha <|> digit))

-- Parsers for non-terminal rules 

parsePrimary :: Parser Expr 
parsePrimary = charTok '(' *> parseExpr <* charTok ')' <|> Val <$> parseNUM <|> Var <$> parseIDENTIFIER


parsePostfix :: Parser Expr 
parsePostfix = combine <$> parsePrimary <*> (many $ char '!')
  where
    combine :: Expr -> String -> Expr 
    combine = foldl (\e _ -> UnOp Fact e)


parseUnary :: Parser Expr 
parseUnary = parsePostfix 
  <|> UnOp Neg <$> (charTok '-' *> parseUnary)
  <|> UnOp Log <$> (stringTok "log" *> parseUnary)
  <|> UnOp Sin <$> (stringTok "sin" *> parseUnary)
  <|> UnOp Cos <$> (stringTok "cos" *> parseUnary)
  <|> UnOp Tan <$> (stringTok "tan" *> parseUnary)


parseFactor :: Parser Expr 
parseFactor = combine <$> parseUnary <*> parseFactor' 
  where
    combine :: Expr -> [Expr] -> Expr 
    combine e [] = e 
    combine e es = BinOp Pow e $ foldr1 (BinOp Pow) es 

    parseFactor' :: Parser [Expr]
    parseFactor' = many $ charTok '^' *> parseFactor  


combine :: Expr -> [(BinOp, Expr)] -> Expr 
combine = foldl (\e (op, e') -> BinOp op e e') 


parseTerm :: Parser Expr 
parseTerm = combine <$> parseFactor <*> many parseTerm' 
  where
    parseTerm' :: Parser (BinOp, Expr) 
    parseTerm' = (Mul, ) <$> (charTok '*' *> parseFactor) <|> 
                 (Div, ) <$> (charTok '/' *> parseFactor)


parseExpr :: Parser Expr 
parseExpr = combine <$> parseTerm <*> many parseExpr' 
  where
    parseExpr' :: Parser (BinOp, Expr)
    parseExpr' = (Add, ) <$> (charTok '+' *> parseTerm) <|>
                 (Sub, ) <$> (charTok '-' *> parseTerm)


parseAssgn :: Parser Assign 
parseAssgn = Let <$> (stringTok "let" *> parseIDENTIFIER) <*> (stringTok "=" *> parseExpr)


parseStmt :: Parser Stmt  
parseStmt = (Assign <$> parseAssgn) <|> (Expr <$> parseExpr) 