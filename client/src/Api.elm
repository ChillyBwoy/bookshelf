module Api exposing (Msg(..), loadList)

import Http
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


type alias ResponseList entity =
    { count : Int
    , total : Int
    , next : Maybe String
    , previous : Maybe String
    , results : List entity
    }


type ResponseItem entity
    = Just entity


type Msg entity
    = OnFetchList (Result Http.Error (ResponseList entity))
    | OnFetchItem (Result Http.Error (ResponseItem entity))


entityListDecoder : Decoder entity -> Decoder (ResponseList entity)
entityListDecoder withDecoder =
    Decode.map5 ResponseList
        (Decode.field "count" Decode.int)
        (Decode.field "total" Decode.int)
        (Decode.maybe (Decode.field "next" Decode.string))
        (Decode.maybe (Decode.field "previous" Decode.string))
        (Decode.field "results" (Decode.list withDecoder))


entityDecoder : Decoder entity -> Decoder entity
entityDecoder withDecoder =
    withDecoder


loadList : String -> Decoder entity -> Cmd (Msg entity)
loadList endpoint decoder =
    Http.get
        { url = endpoint
        , expect = Http.expectJson OnFetchList (entityListDecoder decoder)
        }
