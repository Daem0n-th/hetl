{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl.Load where

import Conduit (runConduitRes, sinkFile, (.|))
import qualified Data.ByteString as BS
import Data.Conduit.Combinators as CC (print)
import Data.Hetl.Internal (Table)
import Data.Hetl.Load.Internal (fromRow)
import Data.Text (Text)
import Data.Word (Word8)

toCsv :: FilePath -> Table -> IO ()
toCsv fp = toSv fp (BS.head ",")

toTsv :: FilePath -> Table -> IO ()
toTsv fp = toSv fp (BS.head "\t")

toSv :: FilePath -> Word8 -> Table -> IO ()
toSv fp sep input = runConduitRes $ input .| fromRow sep .| sinkFile fp

toStdout :: Table -> IO ()
toStdout input = runConduitRes $ input .| CC.print
