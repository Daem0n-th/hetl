{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl.Load where

import Conduit (runConduitRes, sinkFile, (.|))
import Data.Hetl.Internal (Table)
import Data.Hetl.Load.Internal (fromRow)
import Data.Text (Text)

toCsv :: FilePath -> Table -> IO ()
toCsv fp = toSv fp ","

toTsv :: FilePath -> Table -> IO ()
toTsv fp = toSv fp "\t"

toSv :: FilePath -> Text -> Table -> IO ()
toSv fp sep input = runConduitRes $ input .| fromRow sep .| sinkFile fp
