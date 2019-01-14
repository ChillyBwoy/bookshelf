module Router exposing (Route(..), parseUrl, pathFor)

import Url exposing (Url)
import Url.Parser exposing ((</>), int, map, oneOf, parse, s, top)


type Route
    = HomeRoute
    | NotFoundRoute
    | BookListRoute
    | BookRoute Int


parseUrl : Url -> Route
parseUrl url =
    let
        parser =
            oneOf
                [ map HomeRoute top
                , map BookListRoute (s "books")
                , map BookRoute (s "books" </> int)
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

        NotFoundRoute ->
            "/404"

        BookListRoute ->
            "/books"

        BookRoute id ->
            "/books/" ++ String.fromInt id
