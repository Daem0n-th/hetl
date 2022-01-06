module Data.Hetl.Internal (Table, Row, Value (..), valueToBS) where

import Conduit (ConduitT, ResourceT)
import Data.ByteString (ByteString, empty)
import Data.ByteString.Conversion (toByteString')
import Data.Text (Text)
import Data.Text.Encoding (encodeUtf8)
import Data.Vector (Vector)

type Row = Vector Value

type Table = ConduitT () Row (ResourceT IO) ()

data Value = VInt Int | VDouble Double | VText Text | None deriving (Show, Eq)

valueToBS :: Value -> ByteString
valueToBS (VText t) = encodeUtf8 t
valueToBS (VInt n) = toByteString' n
valueToBS (VDouble n) = toByteString' n
valueToBS None = empty