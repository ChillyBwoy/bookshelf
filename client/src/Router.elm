module Router exposing (Route(..), parseUrl, pathFor)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, top)


type Route
    = Home
    | NotFound
    | BookList
    | Book Int
    | BookNew


parser : String -> Parser (Route -> a) a
parser prefixUrl =
    s prefixUrl
        </> oneOf
                [ map Home top
                , map BookList (s "books")
                , map Book (s "books" </> int)
                , map BookNew (s "books" </> s "new")
                ]


parseUrl : String -> Url -> Route
parseUrl prefix url =
    case parse (parser prefix) url of
        Just route ->
            route

        Nothing ->
            NotFound


pathFor : String -> Route -> String
pathFor urlPrefix route =
    let
        prefix =
            "/" ++ urlPrefix
    in
    case route of
        NotFound ->
            prefix ++ "/404"

        Home ->
            prefix ++ "/"

        BookList ->
            prefix ++ "/books"

        Book id ->
            prefix ++ "/books/" ++ String.fromInt id

        BookNew ->
            prefix ++ "/books/new"
