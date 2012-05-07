module Main (main) where
import qualified Data.ByteString.Char8 as BS
import Data.Char
import Data.List
import Data.Maybe
import Control.Monad
import System.IO
import System.Environment
import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>))
import System.Console.GetOpt
import System.Cmd
import System.Process
import System.Exit
{- import Debug.Trace -}


{- rumcmd function -}
runcmd :: [String] -> String -> IO()
runcmd optargs stdin = do
    putStrLn $ "hasktagswrap " ++ show optargs
    {- putStrLn $ "stdin: " ++ show stdin -}
    s <- readProcess "hasktagswrap" optargs stdin
    putStrLn s

data Mode = Help
          | Version
          | All
          | Packages String
          | StandardPackages String
          | NoHsenv
          | AllowTestcode
          deriving (Ord, Eq, Show)

options :: [OptDescr Mode]
options = [ Option "h" ["help"]
            (NoArg Help) "show this help message and exit."
          , Option "v" ["version"]
            (NoArg Version) "output the version number."
          , Option "a" ["all"]
            (NoArg All) "all in virtualenv packages. ignore all options."
          , Option "p" ["packages"]
            (ReqArg Packages "PACKAGES") "give packages name. default is a `haskell` package."
          , Option "s" ["standard-packages"]
            (ReqArg StandardPackages "STANDARDPACKAGES") "give packages name. for the standard library."
          , Option "" ["no-hsenv"]
            (NoArg NoHsenv) "not include the hsenv library."
          , Option "" ["allow-testcode"]
            (NoArg AllowTestcode) "include the test code."
          ]


dirToFiles :: Bool -> FilePath -> IO [ FilePath ]
dirToFiles hsExtOnly p = do
      isD <- doesDirectoryExist p
      if isD then recurse p
             else return $ if not hsExtOnly || ".hs" `isSuffixOf` p || ".lhs" `isSuffixOf` p then [p] else []
      where recurse p = do
                names <- liftM (filter ( (/= '.') . head ) ) $ getDirectoryContents p
                                          -- skip . .. and hidden files (linux)
                liftM concat $ mapM (processFile . (p </>) ) names
            processFile f = dirToFiles True f

getMode :: [Mode] -> Mode
getMode [] = All
getMode xs = maximum xs

{- main -}
main :: IO ()
main = do
        progName <- getProgName
        args <- getArgs

        let usageString =
                   "Usage: " ++ progName ++ " [OPTION...] [PATH]\n\n"
                ++ "Options::\n"
        let a@(modes, files_or_dirs, errs) = getOpt Permute options args

        filenames <- liftM (nub . concat) $ mapM (dirToFiles False) files_or_dirs

        when (errs /= [] || elem Help modes || files_or_dirs == [])
             (do putStr $ unlines errs
                 putStr $ usageInfo usageString options
                 exitWith (ExitFailure 1))

        when (filenames == []) $ do
          putStrLn "warning: no files found!"

        let mode1 = (filter ( `elem` [All, NoHsenv, AllowTestcode] ) modes)
        {- let mode2 = (filter ( `elem` [((Packages ):_), ((StandardPackages :_))] ) modes) -}
        {- putStrLn $ "Flags: " ++ show (head files_or_dirs) -}

        runcmd files_or_dirs ""



{- vim: set et fenc=utf-8 ft=haskell ff=unix sts=4 sw=4 ts=4 : -}
