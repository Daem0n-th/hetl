module Data.Hetl.Transform.Filter where

import Conduit (await, dropC, filterC, (.|))
import Data.Hetl.Internal (NamedRow (..), Row, Table)

filterRow :: (Row -> Bool) -> Table -> Table
filterRow f inp = inp .| (dropC 1 >> filterC f)

filterNamedRow :: (NamedRow -> Bool) -> Table -> Table
filterNamedRow f inp = inp .| flt
  where
    flt = do
      Just hrow <- await
      filterC (f . NamedRow hrow)
