module Model exposing (Book, Flags, ResponseList)

import Date exposing (Date)


type alias Flags =
    { api : String
    , urlPrefix : String
    }


type alias ResponseList entity =
    { count : Int
    , next : Maybe String
    , previous : Maybe String
    , results : List entity
    }


type alias Book =
    { id : Int
    , description : String
    , isbn : String
    , title : String
    , publishedAt : Maybe Date
    }
