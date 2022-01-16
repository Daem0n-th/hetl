module Data.Hetl.Transform.Conversions where

import Conduit
import Data.Hetl.Internal (Row, RowDict, Table, Value (..))
import Data.Text (Text)
import Data.Vector (Vector)
import qualified Data.Vector as Vector

convert :: Value -> (Value -> Value) -> Table -> Table
convert = undefined

convertMany :: [Value] -> (Value -> Value) -> Table -> Table
convertMany = undefined

convertMany' :: [(Value, Value -> Value)] -> Table -> Table
convertMany' = undefined

convertWithRowVector :: Value -> (Value -> Row -> Value) -> Table -> Table
convertWithRowVector = undefined

convertWithRowMap :: Value -> (Value -> RowDict -> Value) -> Table -> Table
convertWithRowMap = undefined

cast :: Value -> Text -> Table -> Table
cast = undefined

castMany :: [Value] -> Text -> Table -> Table
castMany = undefined

castMany' :: [(Value, Text)] -> Table -> Table
castMany' = undefined

replace :: Value -> Value -> Value -> Table -> Table
replace = undefined

replaceOn :: (Value -> Bool) -> Value -> Table -> Table
replaceOn = undefined