import Http
import Markdown
import Html exposing (Html)
import Task exposing (Task, andThen, onError, succeed)

main : Signal Html
main =
  Signal.map Markdown.toHtml readme.signal

readme : Signal.Mailbox String
readme =
  Signal.mailbox ""

report : String -> Task x ()
report markdown =
  Signal.send readme.address markdown


port fetchReadme : Task Http.Error ()
port fetchReadme =
  Http.getString readmeUrl `onError` (\err -> succeed ("ERROR: " ++ toString err))  `andThen` report

readmeUrl =
  "https://raw.githubusercontent.com/elm-lang/core/master/README.md1"
