module Page.BookList exposing (Model, Msg(..), fetchBooks, init, subscriptions, update, view)

import Book exposing (Book)
import Date exposing (Date)
import Html exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


type alias Model =
    { books : RemoteData (List Book)
    }


type Msg
    = OnFetchBooks (Result Http.Error (List Book))


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { books = Loading }, fetchBooks flags )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchBooks (Ok books) ->
            ( { model | books = Loaded books }, Cmd.none )

        OnFetchBooks (Err err) ->
            ( { model | books = Failure }, Cmd.none )


fetchBooks : Flags -> Cmd Msg
fetchBooks flags =
    Http.get
        { url = flags.api ++ "/books.json"
        , expect = Http.expectJson OnFetchBooks (Decode.list Book.decode)
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Books" ]
        , case model.books of
            Loaded books ->
                Book.viewList books

            Loading ->
                div [] [ text "Loading..." ]

            Failure ->
                div [] [ text "Error" ]
        ]
