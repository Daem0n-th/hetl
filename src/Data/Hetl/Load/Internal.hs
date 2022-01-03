{-# LANGUAGE OverloadedStrings #-}

module Data.Hetl.Load.Internal (fromRow) where

import Conduit (ConduitT, ResourceT, await, awaitForever, yield)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Hetl.Internal (Header (..), Row)
import Data.Map.Strict (Map, elems, keys)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (encodeUtf8)

writeRow :: Text -> [Text] -> ByteString
writeRow sep = encodeUtf8 . Text.intercalate sep

writeValueRow :: Monad m => Text -> ConduitT Row ByteString m ()
writeValueRow sep = awaitForever $ \row -> yield $ BS.concat [writeRow sep $ elems row, "\n"]

writeHeaderRow :: Monad m => Text -> ConduitT Row ByteString m ()
writeHeaderRow sep = do
  mrow <- await
  case mrow of
    Nothing -> return ()
    Just row -> yield $ BS.concat [writeRow sep $ map (\(Header _ x) -> x) $ keys row, "\n", writeRow sep $ elems row, "\n"]

fromRow :: Text -> ConduitT Row ByteString (ResourceT IO) ()
fromRow sep = writeHeaderRow sep >> writeValueRow sep