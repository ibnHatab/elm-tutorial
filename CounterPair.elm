module CounterPair where

import Html exposing (..)
import Html.Events exposing (onClick)
import Counter

-- MODEL
type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }

init : Int -> Int -> Model
init c1 c2 =
  { topCounter = Counter.init c1, bottomCounter = Counter.init c2 }


-- UPDATE

type Action
  = Reset
    | Top Counter.Action
    | Bottom Counter.Action

update : Action -> Model -> Model
update action model =
  case action of
    Reset ->
      init 0 0
    Top act ->
      { model |
        topCounter <- Counter.update act model.topCounter
      }

    Bottom act ->
      { model |
        bottomCounter <- Counter.update act model.bottomCounter
      }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
      [ Counter.view (Signal.forwardTo address Top) model.topCounter
      , Counter.view (Signal.forwardTo address Bottom) model.bottomCounter
      , button [ onClick address Reset ] [text "Reset"]
      ]
