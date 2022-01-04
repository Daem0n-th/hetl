module Data.Hetl.Transform.Headers where

import Data.Hetl.Internal (Table)
import Data.Text (Text)

renameOne :: Table -> Text -> Text -> Table
renameOne = undefined

renameMany :: Table -> [(Text, Text)] -> Table
renameMany = undefined

setHeader :: Table -> [Text] -> Table
setHeader = undefined

extendHeader :: Table -> [Text] -> Table
extendHeader = undefined

pushHeader :: Table -> [Text] -> Table
pushHeader = undefined