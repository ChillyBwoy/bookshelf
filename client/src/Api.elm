module Api exposing (RemoteData(..), ResponseList, WebData, endpoints, loadList)

import Dict exposing (Dict)
import Http
import Json.Decode as Decode exposing (Decoder)
import Shared exposing (..)


type RemoteData err entity
    = NotAsked
    | Loading
    | Success entity
    | Failure err


type alias WebData response =
    RemoteData Http.Error response


type alias ResponseList entity =
    { count : Int
    , next : Maybe String
    , previous : Maybe String
    , results : List entity
    }


type ResponseItem entity
    = Just entity


type Msg entity
    = OnFetchList (Result Http.Error (ResponseList entity))
    | OnFetchItem (Result Http.Error (ResponseItem entity))



-- endpoints : Flags -> Dict String String


endpoints : Flags -> Dict String String
endpoints flags =
    let
        { api } =
            flags
    in
    Dict.fromList [ ( "books", api ++ "/books" ) ]


entityListDecoder : Decoder entity -> Decoder (ResponseList entity)
entityListDecoder withDecoder =
    Decode.map4 ResponseList
        (Decode.field "count" Decode.int)
        (Decode.nullable (Decode.field "next" Decode.string))
        (Decode.nullable (Decode.field "previous" Decode.string))
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
