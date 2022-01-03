{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl.Extract (fromCsv) where

import Conduit (sourceFile, (.|))
import Data.Conduit.Combinators (linesUnboundedAscii)
import Data.Hetl.Extract.Internal (toRow)
import Data.Hetl.Internal (Table)
import Data.Text (Text)

fromCsv :: FilePath -> Table
fromCsv fp = fromSv fp ","

fromTsv :: FilePath -> Table
fromTsv fp = fromSv fp "\t"

fromSv :: FilePath -> Text -> Table
fromSv fp sep = sourceFile fp .| linesUnboundedAscii .| toRow sep