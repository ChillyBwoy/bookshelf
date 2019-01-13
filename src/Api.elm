module Api exposing (Msg(..), loadList)

import Http
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


type alias ResponseList a =
    { count : Int
    , results : List a
    }


type Msg entity
    = OnFetchList (Result Http.Error (ResponseList entity))


entityListDecoder : Decoder entity -> Decoder (ResponseList entity)
entityListDecoder withDecoder =
    Decode.map2 ResponseList
        (Decode.field "count" Decode.int)
        (Decode.field "results" (Decode.list withDecoder))


loadList : String -> Decoder entity -> Cmd (Msg entity)
loadList endpoint decoder =
    Http.get
        { url = endpoint
        , expect = Http.expectJson OnFetchList (entityListDecoder decoder)
        }
