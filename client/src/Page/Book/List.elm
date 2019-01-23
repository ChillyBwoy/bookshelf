module Page.Book.List exposing (Model, Msg(..), fetchBooks, init, subscriptions, update, view)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Model exposing (Book, decodeBook)
import Router
import Shared exposing (..)


type alias Model =
    { books : RemoteData (List Book)
    , flags : Flags
    }


type Msg
    = OnFetchBooks (Result Http.Error (List Book))


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { books = Loading, flags = flags }, fetchBooks flags )


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
        { url = flags.api ++ "/books"
        , expect = Http.expectJson OnFetchBooks (Decode.list decodeBook)
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewListItem : Model -> Book -> Html a
viewListItem model book =
    let
        { urlPrefix } =
            model.flags

        url =
            Router.pathFor urlPrefix (Router.Book book.id)
    in
    li []
        [ a [ href url ] [ text book.title ]
        , text (" (isbn: " ++ book.isbn ++ ")")
        ]


viewList : Model -> List Book -> Html a
viewList model books =
    let
        listView =
            viewListItem model
    in
    ul [] (List.map listView books)


view : Model -> Html Msg
view model =
    let
        { urlPrefix } =
            model.flags
    in
    div []
        [ h1 [] [ text "Books" ]
        , div []
            [ a [ href (Router.pathFor urlPrefix Router.BookNew) ] [ text "add new one" ]
            ]
        , div []
            [ case model.books of
                Loading ->
                    div [] [ text "Loading..." ]

                Loaded books ->
                    viewList model books

                Failure ->
                    div [] [ text "Error" ]
            ]
        ]
