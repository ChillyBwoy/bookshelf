module Shared exposing (Flags, RemoteData(..), decodeDate)

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)


type alias Flags =
    { api : String
    }


type RemoteData a
    = Loading
    | Loaded a
    | Failure


decodeDate : Decoder Date
decodeDate =
    Decode.string
        |> Decode.andThen
            (\str ->
                case Date.fromIsoString str of
                    Err err ->
                        Decode.fail err

                    Ok date ->
                        Decode.succeed date
            )
