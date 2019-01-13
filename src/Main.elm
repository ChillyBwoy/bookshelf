module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.BookList as BookList
import Page.Home as Home
import Routes exposing (Route)
import Shared exposing (..)
import Url exposing (Url)



-- MODEL


type alias Model =
    { flags : Flags
    , key : Nav.Key
    , page : Page
    }


type Page
    = PageNotFound
    | PageHome Home.Model
    | PageBookList BookList.Model


type Msg
    = NoOp
    | OnUrlRequest UrlRequest
    | OnUrlChange Url
    | BookListMsg BookList.Msg
    | HomeMsg Home.Msg



-- INIT


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    loadPage url
        { flags = flags
        , key = key
        , page = PageNotFound
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        OnUrlChange url ->
            loadPage url model

        HomeMsg msg ->
            case model.page of
                PageHome home ->
                    loadPageHome model (Home.update msg home)

                _ ->
                    ( model, Cmd.none )

        BookListMsg msg ->
            case model.page of
                PageBookList bookList ->
                    loadBookListPage model (BookList.update msg bookList)

                _ ->
                    ( model, Cmd.none )


loadPageHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
loadPageHome model ( home, cmds ) =
    ( { model | page = PageHome home }
    , Cmd.map HomeMsg cmds
    )


loadBookListPage : Model -> ( BookList.Model, Cmd BookList.Msg ) -> ( Model, Cmd Msg )
loadBookListPage model ( bookList, cmds ) =
    ( { model | page = PageBookList bookList }
    , Cmd.map BookListMsg cmds
    )


loadPage : Url -> Model -> ( Model, Cmd Msg )
loadPage url model =
    case Routes.parseUrl url of
        Routes.HomeRoute ->
            loadPageHome model (Home.init model.flags)

        Routes.BookListRoute ->
            loadBookListPage model (BookList.init model.flags)

        Routes.NotFoundRoute ->
            ( { model | page = PageNotFound }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        PageNotFound ->
            Sub.none

        PageHome pageModel ->
            Sub.map HomeMsg (Home.subscriptions pageModel)

        PageBookList pageModel ->
            Sub.map BookListMsg (BookList.subscriptions pageModel)



-- VIEW


viewNavItem : ( String, String ) -> Html Msg
viewNavItem ( label, url ) =
    li []
        [ a [ href url ] [ text label ]
        ]


viewNav : Model -> Html Msg
viewNav model =
    nav []
        [ ul [] (List.map viewNavItem Routes.routes)
        ]


viewLayout : Model -> Html Msg
viewLayout model =
    let
        content =
            case model.page of
                PageHome pageModel ->
                    Home.view pageModel |> Html.map HomeMsg

                PageBookList pageModel ->
                    BookList.view pageModel |> Html.map BookListMsg

                PageNotFound ->
                    notFoundView
    in
    div []
        [ viewNav model
        , content
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Bookshelf"
    , body =
        [ viewLayout model
        ]
    }


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }
