module CounterList (..) where

import Html exposing (..)
import Html.Events exposing (onClick)

import Counter

-- MODEL
type alias Model =
  { counters : List (ID, Counter.Model)
  , nextID : ID
  }

type alias ID = Int

init : Int -> Model
init count =
  let counters =
        if count == 0 then []
        else List.map (\id -> (id, Counter.init 0)) [0..count-1]
  in
  { counters = counters, nextID = count }


-- UPDATE
type Action
  = Ins
  | Rem ID
  | Modify ID Counter.Action


update : Action -> Model -> Model
update action model =
  case action of
    Ins ->
      let newCounter = (model.nextID, Counter.init 0)
          newCounters = model.counters ++ [ newCounter ]
      in
        { model |
                  counters <- newCounters,
                  nextID <- model.nextID + 1
        }

    Rem id ->
      { model | counters <- List.filter (\(cid, _) -> cid /= id) model.counters }

    Modify id act ->
      let updateCounter (cid, model) =
            if cid == id then (cid, Counter.update act model)
            else (cid, model)
      in
        { model | counters <- List.map updateCounter model.counters }


view : Signal.Address Action -> Model -> Html
view address model =
  let counters = List.map (viewCounter address) model.counters
      insert = button [ onClick address Ins ] [text "Insert"]
  in
  div []
      (insert :: counters)


viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
  let context =
        Counter.Context
               (Signal.forwardTo address (Modify id))
               (Signal.forwardTo address (always (Rem id)))
  in
  Counter.viewWithRemoveButton context model
