module Shapes
  (
   ..
  ) where

import Color exposing (..)
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)

import Debug exposing (..)

diamond color =
  let c = log "color" color in
  rotate (degrees 45) (filled color (square 100))
