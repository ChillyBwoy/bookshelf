module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Book.Add as BookAddPage
import Page.Book.Detail as BookDetailPage
import Page.Book.List as BookListPage
import Page.Home as HomePage
import Router
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
    | PageHome HomePage.Model
    | PageBookList BookListPage.Model
    | PageBookDetail BookDetailPage.Model
    | PageBookAdd BookAddPage.Model


type Msg
    = NoOp
    | OnUrlRequest UrlRequest
    | OnUrlChange Url
    | HomeMsg HomePage.Msg
    | BookListMsg BookListPage.Msg
    | BookDetailMsg BookDetailPage.Msg
    | BookAddMsg BookAddPage.Msg



-- INIT


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { flags = flags
            , key = key
            , page = PageNotFound
            }
    in
    loadPage url model



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
                    loadPageHome model (HomePage.update msg home)

                _ ->
                    ( model, Cmd.none )

        BookListMsg msg ->
            case model.page of
                PageBookList bookList ->
                    loadBookListPage model (BookListPage.update msg bookList)

                _ ->
                    ( model, Cmd.none )

        BookDetailMsg msg ->
            case model.page of
                PageBookDetail book ->
                    loadBookDetailPage model (BookDetailPage.update msg book)

                _ ->
                    ( model, Cmd.none )

        BookAddMsg msg ->
            case model.page of
                PageBookAdd m ->
                    loadBookAddPage model (BookAddPage.update msg m)

                _ ->
                    ( model, Cmd.none )


loadPageHome : Model -> ( HomePage.Model, Cmd HomePage.Msg ) -> ( Model, Cmd Msg )
loadPageHome model ( m, cmds ) =
    ( { model | page = PageHome m }
    , Cmd.map HomeMsg cmds
    )


loadBookListPage : Model -> ( BookListPage.Model, Cmd BookListPage.Msg ) -> ( Model, Cmd Msg )
loadBookListPage model ( bookList, cmds ) =
    ( { model | page = PageBookList bookList }
    , Cmd.map BookListMsg cmds
    )


loadBookDetailPage : Model -> ( BookDetailPage.Model, Cmd BookDetailPage.Msg ) -> ( Model, Cmd Msg )
loadBookDetailPage model ( book, cmds ) =
    ( { model | page = PageBookDetail book }
    , Cmd.map BookDetailMsg cmds
    )


loadBookAddPage : Model -> ( BookAddPage.Model, Cmd BookAddPage.Msg ) -> ( Model, Cmd Msg )
loadBookAddPage model ( m, cmds ) =
    ( { model | page = PageBookAdd m }
    , Cmd.map BookAddMsg cmds
    )


loadPage : Url -> Model -> ( Model, Cmd Msg )
loadPage url model =
    let
        { urlPrefix } =
            model.flags
    in
    case Router.parseUrl urlPrefix url of
        Router.NotFound ->
            ( { model | page = PageNotFound }, Cmd.none )

        Router.Home ->
            loadPageHome model (HomePage.init model.flags)

        Router.BookList ->
            loadBookListPage model (BookListPage.init model.flags)

        Router.Book id ->
            loadBookDetailPage model (BookDetailPage.init model.flags id)

        Router.BookNew ->
            loadBookAddPage model (BookAddPage.init model.flags)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        PageNotFound ->
            Sub.none

        PageHome m ->
            Sub.map HomeMsg (HomePage.subscriptions m)

        PageBookList m ->
            Sub.map BookListMsg (BookListPage.subscriptions m)

        PageBookDetail m ->
            Sub.map BookDetailMsg (BookDetailPage.subscriptions m)

        PageBookAdd m ->
            Sub.map BookAddMsg (BookAddPage.subscriptions m)



-- VIEW


viewNavItem : ( String, String ) -> Html Msg
viewNavItem ( label, url ) =
    li []
        [ a [ href url ] [ text label ]
        ]


viewNav : Model -> Html Msg
viewNav model =
    let
        { urlPrefix } =
            model.flags

        routeList : List ( String, String )
        routeList =
            [ ( "Home", Router.pathFor urlPrefix Router.Home )
            , ( "Books", Router.pathFor urlPrefix Router.BookList )
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
                    HomePage.view m |> Html.map HomeMsg

                PageBookList m ->
                    BookListPage.view m |> Html.map BookListMsg

                PageBookDetail m ->
                    BookDetailPage.view m |> Html.map BookDetailMsg

                PageBookAdd m ->
                    BookAddPage.view m |> Html.map BookAddMsg
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
