module Page.Book.List exposing (Model, Msg(..), fetchBooks, init, subscriptions, update, view)

import Api exposing (ResponseList)
import Date exposing (Date)
import Decoder exposing (decodeBook, decodeListWith)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Model exposing (Book, Flags)
import RemoteData exposing (WebData)
import Router


type alias Model =
    { books : WebData (ResponseList Book)
    , pageSize : Int
    , flags : Flags
    }


type Msg
    = RequestBookList
    | ReceiveBookList (WebData (ResponseList Book))
    | GoToPage Int


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { books = RemoteData.NotAsked
            , flags = flags
            , pageSize = 3
            }
    in
    ( model, fetchBooks model )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestBookList ->
            ( { model | books = RemoteData.Loading }, fetchBooks model )

        ReceiveBookList response ->
            ( { model | books = response }, Cmd.none )

        GoToPage pageNum ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


fetchBooks : Model -> Cmd Msg
fetchBooks model =
    let
        url =
            model.flags.api ++ "/books?page_size=" ++ String.fromInt model.pageSize
    in
    Http.get
        { url = url
        , expect = Http.expectJson (RemoteData.fromResult >> ReceiveBookList) (decodeListWith decodeBook)
        }


viewListItem : Model -> Book -> Html Msg
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


viewList : Model -> ResponseList Book -> Html Msg
viewList model books =
    let
        listView =
            viewListItem model
    in
    ul [] (List.map listView books.results)


viewPagination : Model -> ResponseList Book -> Html Msg
viewPagination model books =
    div [] []


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
