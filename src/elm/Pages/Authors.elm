module Author exposing (Author, Model)


type alias Author =
    { id : Int
    , name : String
    }


type alias Model =
    List Author


type Msg
    = Init
    | Create


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init ->
            ( [], Cmd.none )

        Create ->
            ( model, Cmd.none )
