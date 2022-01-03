module Data.Hetl (Table, Row) where

import Conduit
import Data.Hetl.Extract
import Data.Hetl.Internal (Row, Table)
import Data.Hetl.Load

transform :: Table -> Table
transform pipe = pipe .| mapC id

pipeline :: FilePath -> FilePath -> IO ()
pipeline out = toCsv out . transform . fromCsv

rp :: IO ()
rp = pipeline "out.csv" "sample.csv"