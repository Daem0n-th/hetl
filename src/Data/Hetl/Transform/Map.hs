module Data.Hetl.Transform.Conversions where

import Conduit
import Data.Hetl.Internal (NamedRow (..), Row, Table, Value (..))
import Data.Text (Text)
import Data.Vector (Vector)
import qualified Data.Vector as Vector

mapRow :: (Row -> Row) -> Table -> Table
mapRow f inp = inp .| mro
  where
    mro = do
      _ <- await
      awaitForever $ \row -> yield (f row)

mapNamedRow :: (NamedRow -> Row) -> Table -> Table
mapNamedRow f inp = inp .| mro
  where
    mro = do
      Just hrow <- await
      awaitForever $ \row -> yield (f (NamedRow hrow row))

mapField :: Value -> (Value -> Value) -> Table -> Table
mapField h f inp = inp .| mfd
  where
    mfd = do
      Just hrow <- await
      let Just i = Vector.elemIndex h hrow
      awaitForever $ \row -> yield (Vector.imap (\x v -> if x == i then f v else v) row)

-- TO DO
-- cast :: Value -> Text -> Table -> Table
-- cast = undefined
