module Data.Hetl.Internal (Table, Row, NamedRow (..), Value (..), valueToBS) where

import Conduit (ConduitT, ResourceT)
import Data.ByteString (ByteString, empty)
import Data.ByteString.Conversion (toByteString')
import Data.Map.Strict (Map)
import Data.Text (Text)
import Data.Text.Encoding (encodeUtf8)
import Data.Vector (Vector)

type Row = Vector Value

data NamedRow = NamedRow Row Row

type Table = ConduitT () Row (ResourceT IO) ()

data Value = VInt Int | VDouble Double | VText Text | None deriving (Show, Eq)

valueToBS :: Value -> ByteString
valueToBS (VText t) = encodeUtf8 t
valueToBS (VInt n) = toByteString' n
valueToBS (VDouble n) = toByteString' n
valueToBS None = empty