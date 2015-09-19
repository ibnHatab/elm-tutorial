
import TaskTutorial exposing (getCurrentTime, print)
import Time exposing (second, Time)
import Task exposing (Task, andThen)
import Graphics.Element exposing (show, Element)

clock : Signal Time
clock =
  Time.every (2 * second)

printTask : Signal (Task x ())
printTask =
  Signal.map print clock

printTime : Task x ()
printTime =
  getCurrentTime `andThen` print


printTimeVerbose : Task x ()
printTimeVerbose =
  getCurrentTime `andThen` \time -> print time

port runner : Task x ()
port runner =
  printTimeVerbose



contentMailbox : Signal.Mailbox String
contentMailbox =
  Signal.mailbox ""


port updateContent : Task x ()
port updateContent =
  Signal.send contentMailbox.address "hello!"


main : Signal Element
main =
  Signal.map show contentMailbox.signal
  -- show "F12"
