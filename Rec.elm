module Rec
  (
   ..
  ) where

point2D = { x = 0, y = 0 }

point3D = { x = 3, y = 4, z = 12 }

point2andHalfD = {point2D | x <- point3D.x, y <- point3D.y}

-- Structural subtyping
point3DOne = {point2andHalfD | z = point3D.z}
point2DOne = {point3D - z}


assertTrue = point3D == point3DOne &&
             point2DOne == point2andHalfD &&
             {point3D - z | z = point3D.z} == point3D

type alias Point = {x : Int, y : Int}

-- Polymorphism

lib =
  { id x = x
  , flip f x y = f y x
  }

group =
  { zero = []
  , op a b = a ++ b
  }

test =
  let n = lib.id 42 in                      -- 42
          lib.id 'b'                     -- 'b'
  -- lib.flip (++) "ab" "cd"        -- "cdab"
  -- lib.flip (::) [2,3] 1          -- [1,2,3]
  -- group.op "Hello" group.zero    -- "Hello"
  -- group.op [1,2] [3,4]           -- [1,2,3,4]

type alias Positioned a  =
  { a |
    x : Int
  , y : Int
  }

type alias Named a =
  { a |
    name : String
  }

type alias Moving a =
  { a |
    velocity : Float
  , angle : Float
  }

lady : Named { age : Int }
lady =
  { name = "suzane"
  , age = 57
  }

dude : Named(Moving(Positioned({})))
dude =
  { x = 0
  , y = 10
  , angle = 42.0
  , velocity = 360.0
  , name = "Dude"
  }
