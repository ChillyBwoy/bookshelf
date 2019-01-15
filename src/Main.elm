module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Book as Book
import Page.BookList as BookList
import Page.Home as Home
import Router exposing (Route(..))
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
    | PageBook Book.Model


type Msg
    = NoOp
    | OnUrlRequest UrlRequest
    | OnUrlChange Url
    | HomeMsg Home.Msg
    | BookListMsg BookList.Msg
    | BookMsg Book.Msg



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

        BookMsg msg ->
            case model.page of
                PageBook book ->
                    loadBookPage model (Book.update msg book)

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


loadBookPage : Model -> ( Book.Model, Cmd Book.Msg ) -> ( Model, Cmd Msg )
loadBookPage model ( home, cmds ) =
    ( { model | page = PageBook home }
    , Cmd.map BookMsg cmds
    )


loadPage : Url -> Model -> ( Model, Cmd Msg )
loadPage url model =
    case Router.parseUrl url of
        NotFoundRoute ->
            ( { model | page = PageNotFound }, Cmd.none )

        HomeRoute ->
            loadPageHome model (Home.init model.flags)

        BookListRoute ->
            loadBookListPage model (BookList.init model.flags)

        BookRoute id ->
            loadBookPage model (Book.init model.flags id)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        PageNotFound ->
            Sub.none

        PageHome m ->
            Sub.map HomeMsg (Home.subscriptions m)

        PageBookList m ->
            Sub.map BookListMsg (BookList.subscriptions m)

        PageBook m ->
            Sub.map BookMsg (Book.subscriptions m)



-- VIEW


viewNavItem : ( String, String ) -> Html Msg
viewNavItem ( label, url ) =
    li []
        [ a [ href url ] [ text label ]
        ]


viewNav : Model -> Html Msg
viewNav model =
    let
        routeList : List ( String, String )
        routeList =
            [ ( "Home", Router.pathFor HomeRoute )
            , ( "Books", Router.pathFor BookListRoute )
            ]
    in
    nav []
        [ ul [] (List.map viewNavItem routeList)
        ]


viewLayout : Model -> Html Msg
viewLayout model =
    let
        content =
            case model.page of
                PageNotFound ->
                    notFoundView

                PageHome m ->
                    Home.view m |> Html.map HomeMsg

                PageBookList m ->
                    BookList.view m |> Html.map BookListMsg

                PageBook m ->
                    Book.view m |> Html.map BookMsg
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
