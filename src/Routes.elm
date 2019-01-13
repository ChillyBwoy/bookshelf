module Routes exposing (Route(..), matchRoute, parseUrl, pathFor, routes)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, top)


type Route
    = HomeRoute
    | BookListRoute
    | NotFoundRoute


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map HomeRoute top
        , map BookListRoute (s "books")
        ]


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


pathFor : Route -> String
pathFor route =
    case route of
        HomeRoute ->
            "/"

        BookListRoute ->
            "/books"

        NotFoundRoute ->
            "/404"


routes : List ( String, String )
routes =
    [ ( "Home", pathFor HomeRoute )
    , ( "Books", pathFor BookListRoute )
    ]
