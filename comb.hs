import Control.Monad
import System.IO

data Term = Var Char | K | S | App Term Term 
          | Empty | K1 Term | S1 Term | S2 Term Term
          deriving (Show, Eq)

nextParens :: String -> String -> Integer -> (String, String)
nextParens xs ys 0 = (reverse xs, ys)
nextParens xs ('(':ys) ps = nextParens ('(':xs) ys (ps + 1)
nextParens xs (')':ys) ps = nextParens (')':xs) ys (ps - 1)
nextParens xs (y:ys) ps = nextParens (y:xs) ys ps
nextParens xs [] _ = (xs, []) -- no deberia pasar

data Token = Simple Char | Complex [Token]
             deriving Show

tokenize :: String -> [Token]
tokenize ('K':xs) = (Simple 'K'):(tokenize xs)
tokenize ('S':xs) = (Simple 'S'):(tokenize xs)
tokenize ('(':xs) = (Complex (tokenize ys)) : (tokenize zs)
                    where (ys, zs) = nextParens [] xs 1
tokenize (')':xs) = tokenize xs
tokenize (x:xs) = (Simple x):(tokenize xs)
tokenize [] = []

parseAccum :: Term -> [Token] -> Term
parseAccum term [] = term
parseAccum Empty ((Simple x):xs) = 
        if x == 'K' then parseAccum K xs else 
            if x == 'S' then parseAccum S xs else 
                parseAccum (Var x) xs 
parseAccum Empty ((Complex x):xs) = 
        parseAccum (parseAccum Empty x) xs
parseAccum term ((Simple x):xs) =
        if x == 'K' then parseAccum (App term K) xs else 
            if x == 'S' then parseAccum (App term S) xs else 
                parseAccum (App term (Var x)) xs 
parseAccum term ((Complex x):xs) = 
        parseAccum (App term (parseAccum Empty x)) xs

parse :: String -> Term
parse = (parseAccum Empty) . tokenize

reduce :: Term -> Term
reduce (Var x) = Var x
reduce K = K
reduce S = S
reduce (K1 p) = K1 p -- App K p
reduce (S1 p) = S1 p -- App S p
reduce (S2 p q) = S2 p q --  App (App S p) q
reduce (App K p) = K1 (reduce p)
reduce (App (K1 p) _) = reduce p
reduce (App S p) = S1 (reduce p)
reduce (App (S1 p) q) = S2 (reduce p) (reduce q)
reduce (App (S2 p q) r) = App (App p r) (App q r)
reduce (App (App p q) r) = reduce (App (reduce (App p q)) (reduce r))
reduce (App (Var x) p) = App (Var x) (reduce p)
-- Estos no deberían suceder
reduce Empty = Empty
reduce (App Empty _) = Empty

mostrarLindo :: Term -> Term
mostrarLindo (K1 p) = App K (mostrarLindo p)
mostrarLindo (S1 p) = App S (mostrarLindo p)
mostrarLindo (S2 p q) = App (App S (mostrarLindo p)) (mostrarLindo q)
mostrarLindo (App p q) = App (mostrarLindo p) (mostrarLindo q)
mostrarLindo x = x

stabilize :: Eq a => (a -> a) -> a -> a
stabilize f x = if f x == x then x else stabilize f (f x)

run :: String -> Term
run xs = mostrarLindo $ stabilize reduce parsed
      where parsed = parse xs

main :: IO()
main = do
  putStr "> "
  hFlush stdout
  line <- getLine
  unless (line == "quit") $ do
    putStrLn $ show $ run line
    main
