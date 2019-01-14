module Page.BookPage exposing (Model, Msg(..), init, subscriptions, update, view)

import Book exposing (Book)
import Html exposing (..)
import Shared exposing (..)


type alias Model =
    { book : RemoteData Book
    }


type Msg
    = NoOp


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { book = Loading }, Cmd.none )


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
    h1 [] [ text "Book" ]
