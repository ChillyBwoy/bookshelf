module Routes exposing (Route(..), parseUrl, pathFor, routes)

import Url exposing (Url)
import Url.Parser exposing ((</>), int, map, oneOf, parse, s, top)


type Route
    = HomeRoute
    | NotFoundRoute
    | BookListRoute


parseUrl : Url -> Route
parseUrl url =
    let
        parser =
            oneOf
                [ map HomeRoute top
                , map BookListRoute (s "books")
                ]
    in
    case parse parser url of
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
