module Counter exposing (Model, Msg(..), emptyModel, identity, init, styles, subscriptions, update, view)

import Browser
import CssModules exposing (css)
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Task


type Msg
    = Increment Int
    | Decrement Int
    | UpdateClicked
    | NoOp


type alias Model =
    { count : Int
    , clicked : Int
    }


styles =
    css "../css/Counter.css"
        { root = "root"
        , button = "button"
        , counter = "counter"
        }


emptyModel : Model
emptyModel =
    { count = 0
    , clicked = 0
    }


init : Maybe Model -> ( Model, Cmd Msg )
init maybeModel =
    ( Maybe.withDefault emptyModel maybeModel, Cmd.none )


identity : a -> a
identity a =
    a


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment by ->
            ( { model | count = model.count + by }, Task.succeed UpdateClicked |> Task.perform identity )

        Decrement by ->
            ( { model | count = model.count - by }, Task.succeed UpdateClicked |> Task.perform identity )

        UpdateClicked ->
            ( { model | clicked = model.clicked + 1 }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ styles.class .root ]
        [ button [ styles.class .button, onClick (Decrement 2) ] [ text "--" ]
        , button [ styles.class .button, onClick (Decrement 1) ] [ text "-" ]
        , div [ styles.class .counter ] [ text (String.fromInt model.clicked) ]
        , div [ styles.class .counter ] [ text (String.fromInt model.count) ]
        , button [ styles.class .button, onClick (Increment 1) ] [ text "+" ]
        , button [ styles.class .button, onClick (Increment 2) ] [ text "++" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
