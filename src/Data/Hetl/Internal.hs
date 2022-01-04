module Data.Hetl.Internal (Table, Row) where

import Conduit (ConduitT, ResourceT)
import Data.Text (Text)
import Data.Vector (Vector)

type Row = Vector Text

type Table = ConduitT () Row (ResourceT IO) ()
