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
parseFactor = do 
    u <- parseUnary 
    m <- optional (char '^' *> parseFactor )
    case m of 
        Nothing -> return u
        Just f  -> return $ BinOp Pow u f 


parseExpr :: Parser Expr 
parseExpr = undefined 