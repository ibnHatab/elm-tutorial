module Fun
  (
   ..
  ) where

import Json.Decode
import Maybe as M

(?) : Maybe a -> a -> a
(?) maybe default =
  M.withDefault default maybe

infix 9 ?
