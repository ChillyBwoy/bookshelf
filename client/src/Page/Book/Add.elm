module Page.Book.Add exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Shared exposing (..)


type alias Model =
    {}


type Msg
    = NoOp


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Add book" ]
        , form []
            [ button [] [ text "Add" ]
            ]
        ]
