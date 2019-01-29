module Model exposing (Book, Flags, RemoteData(..))

import Date exposing (Date)


type RemoteData a
    = Loading
    | Loaded a
    | Failure


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
