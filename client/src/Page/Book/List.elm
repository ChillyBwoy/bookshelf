module Page.Book.List exposing (Model, Msg(..), fetchBooks, init, subscriptions, update, view)

import Date exposing (Date)
import Decoder exposing (decodeBook, entityListDecoder)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Model exposing (Book, Flags, ResponseList)
import RemoteData exposing (WebData)
import Router


type alias Model =
    { books : WebData (ResponseList Book)
    , flags : Flags
    }


type Msg
    = RequestBookList
    | ReceiveBookList (WebData (ResponseList Book))


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { books = RemoteData.NotAsked, flags = flags }, fetchBooks flags )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestBookList ->
            ( { model | books = RemoteData.Loading }, fetchBooks model.flags )

        ReceiveBookList response ->
            ( { model | books = response }, Cmd.none )


fetchBooks : Flags -> Cmd Msg
fetchBooks flags =
    Http.get
        { url = flags.api ++ "/books"
        , expect = Http.expectJson (RemoteData.fromResult >> ReceiveBookList) (entityListDecoder decodeBook)
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


viewList : Model -> ResponseList Book -> Html a
viewList model books =
    let
        listView =
            viewListItem model
    in
    ul [] (List.map listView books.results)


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
                RemoteData.NotAsked ->
                    div [] [ text "" ]

                RemoteData.Loading ->
                    div [] [ text "Loading..." ]

                RemoteData.Success books ->
                    viewList model books

                RemoteData.Failure err ->
                    let
                        _ =
                            Debug.log "err" err
                    in
                    div [] [ text "Error" ]
            ]
        ]
