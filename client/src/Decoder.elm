module Decoder exposing (decodeBook, decodeDate, decodeListWith)

import Api exposing (ResponseList)
import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import Model exposing (Book)


decodeBook : Decoder Book
decodeBook =
    Decode.map5 Book
        (Decode.field "id" Decode.int)
        (Decode.field "description" Decode.string)
        (Decode.field "isbn" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.maybe (Decode.field "publishedAt" decodeDate))


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


decodeListWith : Decoder entity -> Decoder (ResponseList entity)
decodeListWith entityDecoder =
    Decode.map4 ResponseList
        (Decode.field "count" Decode.int)
        (Decode.field "next" (Decode.nullable Decode.string))
        (Decode.field "previous" (Decode.nullable Decode.string))
        (Decode.field "results" (Decode.list entityDecoder))
