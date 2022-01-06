{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl.Load.Internal (fromRow) where

import Conduit (ConduitT, ResourceT, awaitForever, yield)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Hetl.Internal (Row, Value (..), valueToBS)
import qualified Data.Vector as Vector
import Data.Word (Word8)

writeRow :: Word8 -> Row -> ByteString
writeRow sep inp = Vector.foldl1 (\acc -> BS.append (acc `BS.snoc` sep)) bsRow `BS.append` "\n"
  where
    bsRow = Vector.map valueToBS inp

fromRow :: Word8 -> ConduitT Row ByteString (ResourceT IO) ()
fromRow sep = awaitForever $ \row -> yield $ writeRow sep row