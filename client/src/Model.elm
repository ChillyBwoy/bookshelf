module Model exposing (Book, Flags)

import Date exposing (Date)
import Dict exposing (Dict)


type alias Flags =
    { api : String
    , urlPrefix : String
    }


type alias Book =
    { id : Int
    , description : String
    , isbn : String
    , title : String
    , publishedAt : Maybe Date
    }


type alias Config =
    { endpoints : Dict String String
    }
