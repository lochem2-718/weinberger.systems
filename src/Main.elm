module Main exposing (main)

import Browser exposing (Document)
import Browser.Dom as Dom
import Browser.Navigation as Nav
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (bool)
import Task
import Time
import Utilities exposing (..)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { scrollToTopRequested : Bool, scrollButtonDisappeared : Bool }


init : () -> ( Model, Cmd Msg )
init flags =
    ( Model False True, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.scrollToTopRequested && not model.scrollButtonDisappeared then
        Time.every 500 (always ScrollButtonDisappeared)

    else
        Sub.none


view : Model -> Document Msg
view model =
    { title = ""
    , body =
        [ container [ id "main", class "p-5 h-100" ]
            [ img
                [ class "rounded-circle d-block mx-auto mt-4"
                , id "me"
                , width 500
                , height 500
                , src "/images/professional-photo-jared.png"
                ]
                []
            , div [ class "text-center" ]
                [ display 2 [] [ text "Jared Weinberger" ]
                , lead [] [ text "For the joy of programming" ]
                ]
            , div [ class "d-flex justify-content-center" ]
                [ div [ class "border-top border-bottom" ]
                    [ btn [ onClick AboutMeClicked ] [ text "About Me" ]
                    , btn [ onClick CvClicked ] [ text "Curriculum Vitae" ]
                    ]
                ]
            ]
        , div
            [ class "w-100 p-1 justify-content-end fixed-bottom d-flex"
            , classList [ ( "d-none", model.scrollButtonDisappeared ) ]
            ]
            [ btn
                [ onClick ScrollToTopRequested ]
                [ icon "angle-up" [] [], text " Scroll to top" ]
            ]
        , container [ id "about-me", class "p-5 h-100" ]
            []
        , container [ id "cv", class "p-5 h-100" ]
            []
        ]
    }


type Msg
    = AboutMeClicked
    | CvClicked
    | ScrollToTopRequested
    | ScrollButtonDisappeared
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AboutMeClicked ->
            ( { model | scrollButtonDisappeared = False }, scrollTo "about-me" )

        CvClicked ->
            ( { model | scrollButtonDisappeared = False }, scrollTo "cv" )

        ScrollToTopRequested ->
            ( { model | scrollToTopRequested = True, scrollButtonDisappeared = False }, scrollTo "main" )

        ScrollButtonDisappeared ->
            ( { model | scrollToTopRequested = False, scrollButtonDisappeared = True }, scrollTo "main" )

        None ->
            ( model, Cmd.none )


scrollTo : String -> Cmd Msg
scrollTo elementId =
    Dom.getElement elementId
        |> Task.map (\elemInfo -> Debug.log "" elemInfo)
        |> Task.andThen (\vp -> Dom.setViewport 0 vp.element.y)
        |> Task.attempt (always None)
