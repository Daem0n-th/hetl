module Data.Hetl.Transform.Basics where

import Conduit
import Data.Conduit.Internal (zipSources)
import Data.Hetl.Internal (Row, Table, Value (..))
import Data.Maybe
import Data.Vector (Vector)
import qualified Data.Vector as Vector

take :: Int -> Table -> Table
take n inp = inp .| takeC n

drop :: Int -> Table -> Table
drop n inp = inp .| dropC n

rowslice :: Int -> Int -> Table -> Table
rowslice i j inp = inp .| (dropC (succ i) >> takeC (succ (j - i)))

-- TO DO
-- rowSliceStep :: Int -> Int -> Int -> Table -> Table
-- rowSliceStep i j k inp = undefined

getElems :: Row -> [Int] -> Row
getElems row index = Vector.generate (length index) (\x -> fromMaybe None (row Vector.!? (index !! x)))

extract :: [Value] -> Table -> Table
extract xs inp = inp .| ext
  where
    ext = do
      Just hrow <- await
      let ix = mapMaybe (\x -> Vector.findIndex (== x) hrow) xs
      yield $ getElems hrow ix
      awaitForever (\x -> yield $ getElems x ix)

extractByIndex :: [Int] -> Table -> Table
extractByIndex xs inp = inp .| awaitForever (\x -> yield $ getElems x xs)

delete :: [Value] -> Table -> Table
delete xs inp = inp .| dlt
  where
    dlt = do
      Just hrow <- await
      let ix = Vector.toList $ Vector.imapMaybe (\i x -> if x `notElem` xs then Just i else Nothing) hrow
      yield $ getElems hrow ix
      awaitForever (\x -> yield $ getElems x ix)

deleteByIndex :: [Int] -> Table -> Table
deleteByIndex xs inp = inp .| dlt
  where
    dlt = do
      Just hrow <- await
      let ix = Vector.toList $ Vector.imapMaybe (\i _ -> if i `notElem` xs then Just i else Nothing) hrow
      yield $ getElems hrow ix
      awaitForever (\x -> yield $ getElems x ix)

concat :: Table -> Table -> Table
concat a b = zipSources a b .| mapC (uncurry (Vector.++))

stack :: Table -> Table -> Table
stack a b = a *> (b .| (dropC 1 >> mapC id))

addField :: Value -> Value -> Table -> Table
addField h v = addFieldWith h (const v)

addFieldWith :: Value -> (Row -> Value) -> Table -> Table
addFieldWith h f inp = inp .| func
  where
    func = do
      Just hrow <- await
      yield $ Vector.snoc hrow h
      awaitForever (\row -> yield $ Vector.snoc row (f row))

addColumn :: Vector Value
addColumn = undefined

addColumnVector = undefined

addIndex = undefined
