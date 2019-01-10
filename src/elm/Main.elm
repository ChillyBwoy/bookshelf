module Main exposing (Msg(..), main, update, view)

import Browser
import CssModules exposing (css)
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)


type Msg
    = Increment
    | Decrement


styles =
    css "./Main.css"
        { root = "root"
        , button = "button"
        , counter = "counter"
        }


main =
    Browser.sandbox { init = 0, update = update, view = view }


update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view model =
    div [ styles.class .root ]
        [ button [ styles.class .button, onClick Decrement ] [ text "-" ]
        , div [ styles.class .counter ] [ text (String.fromInt model) ]
        , button [ styles.class .button, onClick Increment ] [ text "+" ]
        ]
