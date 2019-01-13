module Genre exposing (Genre, Model, Msg(..), formView)

import Html exposing (Html, form)


type alias Genre =
    { name : String
    }


type alias Model =
    List Genre


type Msg
    = Create


formView : Model -> Html Msg
formView model =
    form [] []
