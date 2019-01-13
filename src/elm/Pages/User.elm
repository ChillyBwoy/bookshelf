module User exposing (Model)


type alias Model =
    { id : Int
    , firstName : String
    , lastName : String
    }


init : String -> String -> Model
init fName lName =
    { id = 0
    , firstName = fName
    , lastName = lName
    }
