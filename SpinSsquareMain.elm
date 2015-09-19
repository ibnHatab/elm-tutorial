import Effects exposing (Never)
-- import SpinSquare exposing (init, update, view)
import StartApp
import Task

import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import SpinSquare


-- MODEL

type alias Model =
    { left : SpinSquare.Model
    , right : SpinSquare.Model
    }


init : (Model, Effects Action)
init =
  let
    (left, leftFx) = SpinSquare.init
    (right, rightFx) = SpinSquare.init
  in
    ( Model left right
    , Effects.batch
        [ Effects.map Left leftFx
        , Effects.map Right rightFx
        ]
    )


-- UPDATE

type Action
    = Left SpinSquare.Action
    | Right SpinSquare.Action


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Left act ->
      let
        (left, fx) = SpinSquare.update act model.left
      in
        ( Model left model.right
        , Effects.map Left fx
        )

    Right act ->
      let
        (right, fx) = SpinSquare.update act model.right
      in
        ( Model model.left right
        , Effects.map Right fx
        )



-- VIEW

(=>) : a -> b -> (a, b)
(=>) = (,)


view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ "display" => "flex" ] ]
    [ SpinSquare.view (Signal.forwardTo address Left) model.left
    , SpinSquare.view (Signal.forwardTo address Right) model.right
    , SpinSquare.view (Signal.forwardTo address Right) model.right
    , SpinSquare.view (Signal.forwardTo address Right) model.right
    ]


-- APPLICATION

app :
  { html : Signal Html
  , model : Signal Model
  , tasks : Signal (Task.Task Never ())
  }
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }

main : Signal Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
