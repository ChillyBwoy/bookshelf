module Api exposing (ResponseList)

import Dict exposing (Dict)
import Model exposing (Flags)


type alias ResponseList entity =
    { count : Int
    , next : Maybe String
    , previous : Maybe String
    , results : List entity
    }


type EndpointMap
    = BookList
    | BookDetail Int


endpoints : Flags -> Dict String String
endpoints flags =
    let
        { api } =
            flags
    in
    Dict.fromList [ ( "books", api ++ "/books" ) ]
