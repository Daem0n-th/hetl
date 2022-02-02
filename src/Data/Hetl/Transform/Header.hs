module Data.Hetl.Transform.Header (applyHeader, renameOne, renameMany, setHeader, extendHeader, pushHeader) where

import Conduit
import Data.ByteString.Char8 (unpack)
import Data.Hetl.Internal (Table, Value, valueToBS)
import Data.Maybe (fromJust)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Vector (Vector)
import qualified Data.Vector as Vector

applyHeader :: (Vector Value -> Vector Value) -> Table -> Table
applyHeader f inp =
  inp .| do
    hrow <- await
    yield $ f (fromJust hrow)
    awaitForever yield

renameOne :: Value -> Value -> Table -> Table
renameOne oldh newh =
  applyHeader
    ( \x -> case Vector.elemIndex oldh x of
        Just n -> x Vector.// [(n, newh)]
        Nothing -> error $ "Header \"" ++ unpack (valueToBS oldh) ++ "\" not found."
    )

renameMany :: [(Value, Value)] -> Table -> Table
renameMany pairs inp = foldl (flip (uncurry renameOne)) inp pairs

setHeader :: [Value] -> Table -> Table
setHeader newh = applyHeader (\_ -> Vector.fromList newh)

extendHeader :: [Value] -> Table -> Table
extendHeader newh = applyHeader (\oldh -> Vector.concat [oldh, Vector.fromList newh])

pushHeader :: [Value] -> Table -> Table
pushHeader newh inp =
  inp .| do
    yield (Vector.fromList newh)
    awaitForever yield