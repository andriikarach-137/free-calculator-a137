module Run where 


import ParseUtils 
import Parser 
import Eval 


import Data.Map (Map)
import Data.Map qualified as Map 


run :: IO () 
run = run' Map.empty 


run' :: Env -> IO ()
run' env = do
    putStr ">>> "
    input <- getLine 

    if input == ":q" 
        then pure ()
        else case runParse parseStmt input of 
            Nothing -> do 
                putStrLn "Parse Error"
                run' env 
            
            Just (stmt, "") -> do 
                env' <- execStmt env stmt 
                run' env' 

            Just _ -> do 
                putStrLn "Parse Error"
                run' env 