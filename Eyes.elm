import Color exposing (black, white)
import Graphics.Collage exposing (Form, collage, filled, group, move, moveX, oval)
import Graphics.Element exposing (Element)

import Mouse
import Signal
import Window

eyeBorder : Float -> Float -> Form
eyeBorder w h =
    group [
        filled black <| oval w h,
        filled white <| oval (w*9/10) (h*9/10)
    ]


eyePupil : Float -> Float -> Form
eyePupil w h = filled black <| oval w h


eyesView : (Int, Int) -> (Float, Float, Float, Float) -> Element
eyesView (w, h) (xPl, yPl, xPr, yPr) =
    let xC = (toFloat w) / 4
        yC = (toFloat h) / 2
    in
        collage w h [
                eyeBorder (2*xC) (2*yC) |> moveX (-xC),
                eyeBorder (2*xC) (2*yC) |> moveX xC,
                eyePupil (xC/5) (yC/5) |> move (xPl,yPl),
                eyePupil (xC/5) (yC/5) |> move (xPr,yPr)
            ]

calculateP : (Float, Float) -> (Float, Float) -> (Float, Float) -> (Float, Float)
calculateP (xR, yR) (xC, yC) (xM, yM) =
    let (xA, yA) =
            if (yM/xM < yC/xC)
                then (xC,xC*yM/xM)
                else (xM*yC/yM,yC)
        xB = xR*yR / sqrt (yR^2+(xR*yM/xM)^2)
        yB = xR*yR / sqrt (xR^2+(yR*xM/yM)^2)
        xP = xB*xM/xA
        yP = yB*yM/yA
    in
        (xP,yP)

pupilsCoordinates : (Int, Int) -> (Int, Int) -> (Float, Float, Float, Float)
pupilsCoordinates (w, h) (x, y) =
  let xC = (toFloat w)/4
      yC = (toFloat h)/2
      xM = toFloat x
      yM = (toFloat (h-y)) - yC
      xR = xC*9/10
      yR = yC*9/10
      sign x = x / (abs x)
      (xPr,yPr) =
          if xM >= 3*xC
              then calculateP (xR,yR) (xC,yC) (xM-3*xC,yM)
                       |> \(xP,yP) -> (xP+xC, yP * sign yM)
              else calculateP (xR,yR) (3*xC,yC) (3*xC-xM,yM)
                  |> \(xP,yP) -> (xC-xP, yP * sign yM)
      (xPl,yPl) =
          if xM >= xC
              then calculateP (xR,yR) (3*xC,yC) (xM-xC,yM)
                       |> \(xP,yP) -> (xP-xC, yP * sign yM)
              else calculateP (xR,yR) (xC,yC) (-xM+xC,yM)
                       |> \(xP,yP) -> (-xP-xC, yP * sign yM)
  in
      (xPl,yPl,xPr,yPr)


main = Signal.map2 eyes Window.dimensions Mouse.position


eyes (w,h) (x,y) = eyesView (w,h) (pupilsCoordinates (w,h) (x,y))
