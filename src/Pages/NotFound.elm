module Pages.NotFound exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Platform.Cmd as Cmd exposing (Cmd)


type alias Model =
    { attemptedRoute : String
    , timeToRedirect : Bool
    }


init : String -> ( Model, Cmd Msg )
init attemptedRoute =
    ( Model attemptedRoute False, Cmd.none )


view : Model -> Html msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "col" ]
                [ p [] [ text "I am the Senate" ]
                ]
            ]
        ]


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
