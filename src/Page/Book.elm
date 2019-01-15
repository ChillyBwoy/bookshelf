module Page.Book exposing (Model, Msg(..), init, subscriptions, update, view)

import Book exposing (Book)
import Html exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


type alias Model =
    { book : RemoteData Book
    , id : Int
    }


type Msg
    = OnFetch (Result Http.Error Book)


init : Flags -> Int -> ( Model, Cmd Msg )
init flags id =
    ( { book = Loading, id = id }, fetch flags id )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetch (Ok book) ->
            ( { model | book = Loaded book }, Cmd.none )

        OnFetch (Err err) ->
            ( { model | book = Failure }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Book" ]
        , case model.book of
            Loading ->
                div [] [ text "Loading..." ]

            Loaded book ->
                div []
                    [ h4 [] [ text book.title ]
                    , div [] [ text ("isbn: " ++ book.isbn) ]
                    , div [] [ text book.description ]
                    ]

            Failure ->
                div [] [ text "Error" ]
        ]


fetch : Flags -> Int -> Cmd Msg
fetch flags id =
    Http.get
        { url = flags.api ++ "/books/" ++ String.fromInt id
        , expect = Http.expectJson OnFetch Book.decode
        }
