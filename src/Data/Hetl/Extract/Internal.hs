{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl.Extract.Internal (toRow) where

import Conduit (ConduitT, awaitForever, yield)
import Data.Bifunctor (first)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Hetl.Internal (Row)
import Data.Text (Text)
import Data.Text.Encoding (decodeUtf8)
import Data.Vector (unfoldr)
import Data.Word (Word8)

readRow :: Word8 -> ByteString -> Maybe (Text, ByteString)
readRow _ "" = Nothing
readRow sep inp = Just $
  first decodeUtf8 $ case BS.elemIndex sep inp of
    Nothing -> (inp, "")
    Just n -> (BS.take n inp, BS.drop (succ n) inp)

toRow :: Monad m => Word8 -> ConduitT ByteString Row m ()
toRow sep = awaitForever $ \row -> yield $ unfoldr (readRow sep) row