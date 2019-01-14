module Book exposing (Book, decode)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


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
