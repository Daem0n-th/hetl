{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl (Table, Row) where

import Conduit
import Data.Hetl.Extract
import Data.Hetl.Internal (Row, Table, Value (..))
import Data.Hetl.Load
import Data.Hetl.Transform.Headers

transform :: Table -> Table
transform pipe = pipe .| mapC id

pipeline :: FilePath -> FilePath -> IO ()
pipeline out = toCsv out . renameOne (VText "a") (VText "b") . fromCsv

rp :: IO ()
rp = pipeline "files/out.csv" "files/sample.csv"