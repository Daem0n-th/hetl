module Data.Hetl.Extract.Internal (toRow) where

import Conduit (ConduitT, ResourceT, await, leftover, yield)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Hetl.Internal (Header (..), Row)
import Data.Map.Strict (fromDistinctAscList)
import Data.Maybe (fromJust)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (decodeUtf8)

toHeader :: [Text] -> [Header]
toHeader ts = zipWith Header [1 .. length ts] ts

readRow :: Text -> ByteString -> ByteString -> Row
readRow sep h v
  | length hs == length vs = fromDistinctAscList $ zip (toHeader hs) vs
  | otherwise = error "Row does not match header length"
  where
    hs = Text.splitOn sep $ decodeUtf8 h
    vs = Text.splitOn sep $ decodeUtf8 v

toRow :: Text -> ConduitT ByteString Row (ResourceT IO) ()
toRow sep = loop
  where
    loop = do
      mx <- await
      my <- await
      case my of
        Nothing -> return ()
        Just x -> do
          yield (readRow sep (fromJust mx) (fromJust my))
          leftover (fromJust mx)
          loop