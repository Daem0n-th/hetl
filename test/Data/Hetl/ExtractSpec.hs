module Data.Hetl.ExtractSpec (spec) where

import Test.Hspec

spec :: Spec
spec =
  describe "head" $
    it "Should get the first element" $
      head "sample" `shouldBe` 's'