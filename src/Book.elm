module Book exposing (Book, Msg(..), decode, view, viewList)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


type Msg
    = NoOp


type alias Book =
    { id : Int
    , description : Maybe String
    , isbn : Maybe String
    , title : String
    , publishedAt : Maybe Date
    }


decode : Decoder Book
decode =
    Decode.map5 Book
        (Decode.field "id" Decode.int)
        (Decode.maybe (Decode.field "description" Decode.string))
        (Decode.maybe (Decode.field "isbn" Decode.string))
        (Decode.field "title" Decode.string)
        (Decode.maybe (Decode.field "publishedAt" decodeDate))


view : Book -> Html a
view model =
    div []
        [ h4 [] [ text model.title ]
        , dl []
            [ dt [] [ text "isbn" ]
            , dd []
                [ case model.isbn of
                    Just isbn ->
                        text isbn

                    Nothing ->
                        text ""
                ]
            ]
        ]


viewListItem : Book -> Html a
viewListItem book =
    li []
        [ a [ href "#" ] [ text book.title ]
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
