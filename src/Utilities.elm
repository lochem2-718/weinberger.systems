module Utilities exposing (..)

import Html exposing (Attribute, Html, button, div, h1, i, p)
import Html.Attributes exposing (attribute, class)


container : List (Attribute msg) -> List (Html msg) -> Html msg
container attributes children =
    div (class "container" :: attributes) children


row : List (Attribute msg) -> List (Html msg) -> Html msg
row attributes children =
    div (class "row" :: attributes) children


col : List (Attribute msg) -> List (Html msg) -> Html msg
col attributes children =
    div (class "col" :: attributes) children


display : Int -> List (Attribute msg) -> List (Html msg) -> Html msg
display level attributes children =
    let
        l =
            if level < 1 then
                1

            else if level > 6 then
                6

            else
                level
    in
    h1
        (class ("display-" ++ String.fromInt level) :: attributes)
        children


lead : List (Attribute msg) -> List (Html msg) -> Html msg
lead attributes children =
    p (class "lead" :: attributes) children


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn attributes children =
    button (class "btn" :: attributes) children


icon : String -> List (Attribute msg) -> List (Html msg) -> Html msg
icon fontAwesomeStr attributes children =
    i (class ("fas fa-" ++ fontAwesomeStr) :: attributes) children
