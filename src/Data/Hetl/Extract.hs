{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl.Extract (fromCsv) where

import Conduit (sourceFile, (.|))
import qualified Data.ByteString as BS
import Data.Conduit.Combinators (linesUnboundedAscii)
import Data.Hetl.Extract.Internal (toRow)
import Data.Hetl.Internal (Table)
import Data.Word (Word8)

fromCsv :: FilePath -> Table
fromCsv fp = fromSv fp (BS.head ",")

fromTsv :: FilePath -> Table
fromTsv fp = fromSv fp (BS.head "\t")

fromSv :: FilePath -> Word8 -> Table
fromSv fp sep = sourceFile fp .| linesUnboundedAscii .| toRow sep