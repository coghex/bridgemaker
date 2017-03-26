import qualified Data.Map as M
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BSC
import Data.List.Split

type Database = M.Map String Int

main :: IO ()
main = do
  let stringinput = splitOn " " "string1 string2 string3 string1"

  s <- BS.readFile ("data/state")
  let s' = BSC.unpack s
  let s2 = read s' :: Database

  BS.writeFile ("data/state") (BSC.pack ( show (alterState s2 stringinput)))


alterState :: M.Map String Int -> [String] -> M.Map String Int
alterState m []     = m
alterState m (s:ss)
  | ((M.lookup s m) > Just 0) = alterState (M.adjust increment s m) ss
  | otherwise                 = alterState (M.insert s 1 m) ss

increment :: Int -> Int
increment a = a + 1
