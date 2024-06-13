module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test ejercicio 11" $ do
    it "Dispersion entre los dias 1, 2 y 3" $ do
      dispersion (NivelesDelRio 322 283 294) `shouldBe` 39
    
    it "Es dia parejo" $ do
      diasParejos (NivelesDelRio 322 283 294) `shouldBe` False

    it "Es dia loco" $ do
      diasLocos (NivelesDelRio 322 283 294) `shouldBe` False

    it "Es dia normal" $ do
      diasNormales (NivelesDelRio 322 283 294) `shouldBe` True

