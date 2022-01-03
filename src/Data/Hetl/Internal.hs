module Data.Hetl.Internal (Table, Header (..), Row) where

import Conduit (ConduitT, ResourceT)
import Data.Map.Strict (Map)
import Data.Maybe (fromJust)
import Data.Text (Text)

data Header = Header Int Text deriving (Eq, Show)

instance Ord Header where
  (Header i1 _) `compare` (Header i2 _) = i1 `compare` i2

type Value = Text

type Row = Map Header Value

type Table = ConduitT () Row (ResourceT IO) ()
