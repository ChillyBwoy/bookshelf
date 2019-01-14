module Page.BookList exposing (Model, Msg(..), fetchBooks, init, subscriptions, update, view)

import Book exposing (Book)
import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Router exposing (Route(..))
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


viewListItem : Book -> Html a
viewListItem book =
    let
        url =
            Router.pathFor (BookRoute book.id)
    in
    li []
        [ a [ href url ] [ text book.title ]
        , text " (isbn: "
        , case book.isbn of
            Just isbn ->
                text isbn

            Nothing ->
                text "unknown"
        , text ")"
        ]


viewList : List Book -> Html a
viewList books =
    ul [] (List.map viewListItem books)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Books" ]
        , case model.books of
            Loaded books ->
                viewList books

            Loading ->
                div [] [ text "Loading..." ]

            Failure ->
                div [] [ text "Error" ]
        ]
