module Decoder exposing (decodeBook, decodeDate)

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
