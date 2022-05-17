module Main where

import Data.IORef (IORef, modifyIORef, newIORef, readIORef)
import System.Environment (getArgs)
import System.IO (IOMode (ReadMode), hFlush, hGetContents, openFile, stdout)

main :: IO ()
main = do
  args <- getArgs
  let executionType = parseArgs args
  t <- newIORef tape
  case executionType of
    InlineInput s -> execute (parse s) t
    FileInput s -> do
      contents <- getFileContents s
      execute (parse contents) t
    Repl -> repl t
    Help -> printHelp

getFileContents :: String -> IO String
getFileContents filename = do
  handle <- openFile filename ReadMode
  hGetContents handle

printHelp :: IO ()
printHelp = do
  putStrLn "Brainhask v0.1.0"
  putStrLn "Usage:\n"
  putStrLn "\tbhs <filename> Executes the program passed by the input file."
  putStrLn "\tbhs -i <input> Executes the program passed by the input line."
  putStrLn "\tbhs repl       Starts the Brainhask repl. Use ':q' to quit."
  putStrLn "\tbhs help       Prints this prompt.\n"
  putStrLn "Full details can be found in the official repository:\n"
  putStrLn "\thttps://github.com/Forensor/brainhask\n"

repl :: IORef (Tape Int) -> IO ()
repl iot = do
  putStr "bhs> "
  hFlush stdout
  str <- getLine
  if str == ":q"
    then putStrLn "Goodbye!"
    else do
      execute (parse str) iot
      repl iot

-- TYPES
data Tape a = Tape [a] a [a]

data Action
  = IncrementByte
  | DecrementByte
  | IncrementPointer
  | DecrementPointer
  | OutputByte
  | InputByte
  | Loop [Action]
  deriving (Show)

data Argument
  = InlineInput String
  | FileInput String
  | Repl
  | Help

-- RUNTIME
parseArgs :: [String] -> Argument
parseArgs ["-i", str] = InlineInput str
parseArgs ["repl"] = Repl
parseArgs ["help"] = Help
parseArgs [filename] = FileInput filename
parseArgs _ = Help

tape :: Tape Int
tape = Tape (repeat 0) 0 (repeat 0)

inc :: IORef (Tape Int) -> IO ()
inc iot = do
  modifyIORef iot (\(Tape l n r) -> Tape l (n + 1) r)
  pure ()

dec :: IORef (Tape Int) -> IO ()
dec iot = do
  modifyIORef iot (\(Tape l n r) -> Tape l (n -1) r)
  pure ()

out :: IORef (Tape Int) -> IO ()
out iot = do
  n <- cur iot
  print n

inp :: IORef (Tape Int) -> IO ()
inp iot = do
  i <- getLine
  if any ((== False) . (`elem` "1234567890")) i
    then putStrLn "*** Error: input accepts numbers only."
    else do
      let x = read i :: Int
      modifyIORef iot (\(Tape l n r) -> Tape l x r)

right :: IORef (Tape Int) -> IO ()
right iot = do
  modifyIORef iot (\(Tape l n (r : rs)) -> Tape (n : l) r rs)
  pure ()

left :: IORef (Tape Int) -> IO ()
left iot = do
  modifyIORef iot (\(Tape (l : ls) n r) -> Tape ls l (n : r))
  pure ()

cur :: IORef (Tape Int) -> IO Int
cur iot = do
  Tape _ n _ <- readIORef iot
  pure n

execute :: [Action] -> IORef (Tape Int) -> IO ()
execute [] _ = pure ()
execute (a : as) iot =
  case a of
    IncrementByte -> do
      inc iot
      execute as iot
    DecrementByte -> do
      dec iot
      execute as iot
    OutputByte -> do
      out iot
      execute as iot
    Loop bs -> do
      c <- cur iot
      if c == 0
        then execute as iot
        else do
          execute bs iot
          execute (a : as) iot
    InputByte -> do
      inp iot
      execute as iot
    IncrementPointer -> do
      right iot
      execute as iot
    DecrementPointer -> do
      left iot
      execute as iot

-- PARSER
removeLoop :: Int -> String -> String
removeLoop n ('[' : xs) = removeLoop (n + 1) xs
removeLoop n (']' : xs) = removeLoop (n -1) xs
removeLoop 0 xs = xs
removeLoop _ [] = []
removeLoop n (x : xs) = removeLoop n xs

parse :: String -> [Action]
parse ('<' : xs) = DecrementPointer : parse xs
parse ('>' : xs) = IncrementPointer : parse xs
parse ('+' : xs) = IncrementByte : parse xs
parse ('-' : xs) = DecrementByte : parse xs
parse (',' : xs) = InputByte : parse xs
parse ('.' : xs) = OutputByte : parse xs
parse ('[' : xs) = Loop (parse xs) : parse (removeLoop 1 xs)
parse (']' : xs) = []
parse xs = []