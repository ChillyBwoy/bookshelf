module Page.Book.Detail exposing (Model, Msg(..), init, subscriptions, update, view)

import Decoder exposing (decodeBook)
import Html exposing (..)
import Http
import Model exposing (Book, Flags)
import RemoteData exposing (WebData)


type alias Model =
    { book : WebData Book
    , id : Int
    }


type Msg
    = RequestBook
    | ReceiveBook (WebData Book)


init : Flags -> Int -> ( Model, Cmd Msg )
init flags id =
    ( { book = RemoteData.Loading, id = id }, fetchBook flags id )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestBook ->
            ( { model | book = RemoteData.Loading }, Cmd.none )

        ReceiveBook response ->
            ( { model | book = response }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Book" ]
        , case model.book of
            RemoteData.NotAsked ->
                div [] []

            RemoteData.Loading ->
                div [] [ text "Loading..." ]

            RemoteData.Success book ->
                div []
                    [ h4 [] [ text book.title ]
                    , div [] [ text ("isbn: " ++ book.isbn) ]
                    , div [] [ text book.description ]
                    ]

            RemoteData.Failure err ->
                let
                    _ =
                        Debug.log "err" err
                in
                div [] [ text "Error" ]
        ]


fetchBook : Flags -> Int -> Cmd Msg
fetchBook flags id =
    Http.get
        { url = flags.api ++ "/books/" ++ String.fromInt id
        , expect = Http.expectJson (RemoteData.fromResult >> ReceiveBook) decodeBook
        }
