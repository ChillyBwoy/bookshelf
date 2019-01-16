module Router exposing (Route(..), parseUrl, pathFor)

import Url exposing (Url)
import Url.Parser exposing ((</>), int, map, oneOf, parse, s, top)


type Route
    = Home
    | NotFound
    | BookList
    | Book Int
    | BookNew


parseUrl : Url -> Route
parseUrl url =
    let
        parser =
            oneOf
                [ map Home top
                , map BookList (s "books")
                , map Book (s "books" </> int)
                , map BookNew (s "books" </> s "new")
                ]
    in
    case parse parser url of
        Just route ->
            route

        Nothing ->
            NotFound


pathFor : Route -> String
pathFor route =
    case route of
        NotFound ->
            "/404"

        Home ->
            "/"

        BookList ->
            "/books"

        Book id ->
            "/books/" ++ String.fromInt id

        BookNew ->
            "/books/new"
