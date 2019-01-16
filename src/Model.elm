module Model exposing (Book, decodeBook)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


type alias Book =
    { id : Int
    , description : String
    , isbn : String
    , title : String
    , publishedAt : Maybe Date
    }


decodeBook : Decoder Book
decodeBook =
    Decode.map5 Book
        (Decode.field "id" Decode.int)
        (Decode.field "description" Decode.string)
        (Decode.field "isbn" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.maybe (Decode.field "publishedAt" decodeDate))
