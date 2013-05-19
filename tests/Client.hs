{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import qualified Data.ByteString as B
import System.Environment

import Test.HUnit hiding (Test)
import Test.Framework
import Test.Framework.Providers.HUnit

import Remote.KRPC
import Shared


addr :: RemoteAddr
addr = (0, 6000)

main :: IO ()
main = defaultMain tests

(==?) :: (Eq a, Show a) => a -> IO a -> Assertion
expected ==? action = do
  actual <- action
  expected @=? actual

tests :: [Test]
tests =
  [ testCase "unit" $
      () ==? call addr unitM ()

  , testCase "echo int" $
      1234 ==? call addr echoM 1234

  , testCase "reverse 1..100" $
      reverse [1..100] ==? call addr reverseM [1..100]

  , testCase "reverse empty list" $
      reverse [] ==? call addr reverseM []

  , testCase "reverse singleton list" $
      reverse [1] ==? call addr reverseM [1]

  , testCase "swap pair" $
      (1, 0) ==? call addr swapM (0, 1)

  , testCase "shift triple" $
      ([2..10], (), 1) ==? call addr shiftR ((), 1, [2..10])

  , testCase "echo bytestring" $
      let bs = B.replicate 400 0 in
      bs ==? call addr echoBytes bs
  ]