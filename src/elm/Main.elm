module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.BookList as BookList
import Pages.Home as Home
import Routes exposing (Route)
import Shared exposing (..)
import Url exposing (Url)


type alias Model =
    { flags : Flags
    , navKey : Nav.Key
    , route : Route
    , page : Page
    }


type Page
    = PageNone
    | PageHome Home.Model
    | PageBookList BookList.Model


type Msg
    = OnUrlRequest UrlRequest
    | OnUrlChange Url
    | BookListMsg BookList.Msg
    | HomeMsg Home.Msg


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { flags = flags
            , route = Routes.parseUrl url
            , navKey = key
            , page = PageNone
            }
    in
    ( model, Cmd.none ) |> loadPage


loadPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
loadPage ( model, cmd ) =
    let
        ( page, newCmd ) =
            case model.route of
                Routes.HomeRoute ->
                    let
                        ( pageModel, pageCmd ) =
                            Home.init model.flags
                    in
                    ( PageHome pageModel, Cmd.map HomeMsg pageCmd )

                Routes.NotFoundRoute ->
                    ( PageNone, Cmd.none )

                Routes.BookListRoute ->
                    let
                        ( pageModel, pageCmd ) =
                            BookList.init model.flags
                    in
                    ( PageBookList pageModel, Cmd.map BookListMsg pageCmd )
    in
    ( { model | page = page }, Cmd.batch [ cmd, newCmd ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( OnUrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        ( OnUrlChange url, _ ) ->
            ( { model | route = Routes.parseUrl url }, Cmd.none ) |> loadPage

        ( HomeMsg subMsg, PageHome pageModel ) ->
            let
                ( newPageModel, newCmd ) =
                    Home.update subMsg pageModel
            in
            ( { model | page = PageHome newPageModel }, Cmd.map HomeMsg newCmd )

        ( BookListMsg subMsg, PageBookList pageModel ) ->
            let
                ( newPageModel, newCmd ) =
                    BookList.update subMsg pageModel
            in
            ( { model | page = PageBookList newPageModel }, Cmd.map BookListMsg newCmd )

        ( _, _ ) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        PageNone ->
            Sub.none

        PageHome pageModel ->
            Sub.map HomeMsg (Home.subscriptions pageModel)

        PageBookList pageModel ->
            Sub.map BookListMsg (BookList.subscriptions pageModel)


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

                PageNone ->
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
