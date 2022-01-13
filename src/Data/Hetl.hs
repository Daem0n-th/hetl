{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl (Table, Row) where

import Conduit
import Data.Hetl.Extract
import Data.Hetl.Internal (Row, Table, Value (..))
import Data.Hetl.Load
import Data.Hetl.Transform.Basics
import Data.Hetl.Transform.Headers

transform :: Table -> Table
transform pipe = pipe .| mapC id

pipeline :: IO ()
pipeline = toCsv "files/out.csv" $ addField (VText "new") (VInt 42) $ fromCsv "files/sample2.csv"
