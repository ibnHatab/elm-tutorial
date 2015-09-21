import Graphics.Element exposing (Element, show)
import Color exposing (Color, blue, brown, green, orange, purple, red, yellow)
import Graphics.Collage exposing (Form, circle, collage, filled, move)
import Window
import Mouse
import Signal exposing (Signal, (~), (<~), constant)
import Time exposing (delay)
import List exposing ((::), map, foldr, length, repeat, drop, reverse)
import Array


color : Int -> Color
color n =
    let colors =
            Array.fromList [ green, red, blue, yellow, brown, purple, orange ]
        maybeColor = Array.get (n % (Array.length colors)) colors
    in
        Maybe.withDefault green maybeColor


circleForm : (Int, (Int, Int)) -> Form
circleForm (r, (x, y)) =
    circle (toFloat r*5)
        |> filled (color r)
        |> move (toFloat x,toFloat y)


drawCircles : List (Int, (Int, Int)) -> (Int, Int) -> Element
drawCircles d (w, h) = collage w h <| map circleForm d

combine : List (Signal a) -> Signal (List a)
combine = foldr (Signal.map2 (::)) (constant [])

delayedMousePositions : List Int -> Signal (List (Int, (Int, Int)))
delayedMousePositions rs =
    let adjust (w, h) (x, y) = (x-w//2,h//2-y)
        n = length rs
        position = adjust <~ Window.dimensions ~ Mouse.position
        positions = repeat n position -- List (Signal (Int, Int))
        delayedPositions =            -- List (Signal (Int, (Int, Int))
            List.map2
            (\r pos ->
                let delayedPosition = delay (toFloat r*100) pos
                in
                    (\pos -> (r,pos)) <~ delayedPosition)
            rs
            positions
    in
        combine delayedPositions

fibonacci : Int -> List Int
fibonacci n =
    let fibonacci' n k1 k2 acc =
            if n <= 0
                then acc
                else fibonacci' (n-1) k2 (k1+k2) (k2 :: acc)
    in
        fibonacci' n 0 1 [] |> reverse

main : Signal Element
main =
    drawCircles
        <~ delayedMousePositions (fibonacci 12 |> drop 1 |> reverse)
        ~ Window.dimensions
