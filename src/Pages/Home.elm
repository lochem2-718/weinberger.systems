module Pages.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model, Cmd.none )


view : Model -> Html msg
view model =
    div
        [ class "container"
        ]
        [ text "Servus" ]


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )