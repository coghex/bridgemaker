import qualified Data.Map as M
import Data.List.Split
import System.IO
import Control.Monad
import System.Exit
import System.Posix.Signals
import Control.Concurrent
import Data.List
import Data.Ord (comparing)
import System.Process

type Database = M.Map String Int

main :: IO ()
main = do
  putStrLn "Input: "
  inp <- getLine
  installHandler keyboardSignal (Catch (do exitSuccess)) Nothing
  --t1 <- readProcess "python" (["src/twitter.py"] ++ (splitOn " " inp)) ""
  --print t1

  --t2 <- readProcess "sh" (["src/reddit.sh"] ++ (splitOn " " inp)) ""

  (_, Just so1, _, ph1) <- createProcess (proc "python" (["src/twitter.py"] ++ (splitOn " " inp))){std_out = CreatePipe}
  (_, Just so2, _, ph2) <- createProcess (proc "sh" (["src/reddit.sh"] ++ (splitOn " " inp))){std_out = CreatePipe}
  waitForProcess ph1
  r1 <- hGetContents so1
  r2 <- hGetContents so2
  contents1 <- readFile "data/twitter_data.txt"
  contents2 <- readFile "data/reddit_data.txt"

  let stringinput = splitOn " " $ contents1 ++ contents2
  let s = alterState (M.empty) stringinput
  mapM_ print $ sortBy (comparing snd) $ M.toList s


alterState :: M.Map String Int -> [String] -> M.Map String Int
alterState m []     = m
alterState m (s:ss)
  | ((M.lookup s m) == Nothing) = alterState (M.insert s 1 m) ss
  | otherwise                   = alterState (M.adjust increment s m) ss

increment :: Int -> Int
increment a = a + 1

findMax m = go [] Nothing (M.toList m)
    where
        go ks _        []           = ks 
        go ks Nothing  ((k,v):rest) = go (k:ks) (Just v) rest
        go ks (Just u) ((k,v):rest)
            | v < u     = go ks     (Just u) rest
            | v > u     = go [k]    (Just v) rest
            | otherwise = go (k:ks) (Just v) rest
