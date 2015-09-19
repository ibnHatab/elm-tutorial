module Model
  (
   ..
  ) where

import List exposing (sum, map, length)
import Maybe
import Result
import String
import Html exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


fortyTwo : Int
fortyTwo =
  42

book : { title : String, page : Int }
book =
  {title = "Moby dick", page = 10}


averagenamelength : List String -> Float
averagenamelength names =
  toFloat(sum (map String.length names)) / toFloat(length names)

isLong : { resord | page : Int } -> Bool
isLong book =
  book.page > 7

type Visibility = All | Active | Completed

toString : Visibility -> String
toString visibility =
  case visibility of
    All ->
      "All"
    Active ->
      "Active"
    Completed ->
      "Completed"

type User = Anonymouse | LoggedIn String

userAvatar user =
  case user of
    Anonymouse ->
      "anon.png"
    LoggedIn userName ->
      "users/" ++ userName ++ "/photo.png"

activeUsers : List User
activeUsers =
  [
   Anonymouse,
   LoggedIn "Tom",
   LoggedIn "Stevacte"
  ]

photos = activeUsers |> List.map userAvatar

type Scale = Normal | Logarithmic

type Widget
  = ScatterPlot (List (Int, Int))
  | LogData (List String)
  | TimePlot Scale (List (Int, Int))

view : Widget -> Element
view widget =
  case widget of
    ScatterPlot points ->
      viewScatterPlot points
    LogData logs ->
      flow down (map viewLog logs)
    TimePlot scale occurences ->
      viewTimePlot occurences

viewScatterPlot _ = collage 200 200 [toForm (show "Any element can go here!")]
viewLog  _ = collage 200 200 [toForm (show "Any element can go here!")]
viewTimePlot _ = collage 200 200 [toForm (show "Any element can go here!")]

toMonth : String -> Maybe Int
toMonth str =
  case String.toInt str of
    Ok n ->
      if n > 0 && n <= 12 then Just n else Nothing
    Err err ->
      Nothing

type Lst a = Empt | Nd a (Lst a)

ll = Nd 3 (Nd 2 (Nd 1 Empt))

sm : Lst Int -> Int
sm xs =
  case xs of
    Empt ->
      0
    Nd fst rst ->
      fst + sm rst

type Tr a = TEmpt | TNd a (Tr a) (Tr a)
