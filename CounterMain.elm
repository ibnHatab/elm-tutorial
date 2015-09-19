
import Html exposing (..)
import CounterList exposing (init, update, view)
import StartApp.Simple exposing (start)


main : Signal Html
main =
  start
    { model = init 4
    , update = update
    , view = view
    }
