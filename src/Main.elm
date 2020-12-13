port module Main exposing (main)

import Browser exposing (Document)
import Browser.Dom as Dom
import Browser.Navigation as Nav
import Debug
import Html exposing (div, img, option, p, span, text)
import Html.Attributes exposing (class, classList, id, selected, src, style, value)
import Html.Events exposing (on, onClick, targetValue)
import Json.Decode as Decode
import Result
import Task
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
    { scrollButtonVisible : Bool
    , language : Language
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( Model False English, Cmd.none )


port scrolled : (Int -> msg) -> Sub msg


port language : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ scrolled (always Scrolled)
        , language (parseLanguageCode >> LanguageChanged)
        ]


parseLanguageCode : String -> Language
parseLanguageCode langCode =
    if String.startsWith "de" (String.toLower langCode) then
        Deutsch

    else
        English


view : Model -> Document Msg
view model =
    { title = ""
    , body =
        [ div
            [ class "fixed-bottom px-4 py-2" ]
            [ div [ id "language-selector" ]
                [ span [] [ text "Language: " ]
                , select
                    [ onChange (parseLanguageCode >> LanguageChanged)
                    ]
                    [ option
                        [ selected (model.language == English)
                        , value "en-US"
                        ]
                        [ text "English" ]
                    , option
                        [ selected (model.language == Deutsch)
                        , value "de-DE"
                        ]
                        [ text "Deutsch" ]
                    ]
                ]
            , btn
                [ onClick ScrollToTopRequested
                , classList [ ( "d-none", not model.scrollButtonVisible ) ]
                ]
                [ icon "angle-up" [] [], text " Back to top" ]
            ]
        , container
            [ id "title-section"
            , class "text-center h-100 py-5"
            ]
            [ img
                [ class "rounded-circle img-fluid headshot mb-3"
                , id "me"
                , src "/images/professional-photo-jared.png"
                ]
                []
            , display 2 [ class "mt-3" ] [ text "Jared Weinberger" ]
            , lead [] [ text "For the joy of programming" ]
            , div [ class "d-flex justify-content-center" ]
                [ div [ class "border-top border-bottom" ]
                    [ btn [ onClick AboutMeClicked ] [ text "About Me" ]
                    , btn [ onClick CvClicked ] [ text "Curriculum Vitae" ]
                    ]
                ]
            ]
        , container [ id "about-me-section", class "p-5 h-100" ]
            [ display 4 [ class "text-center" ] [ text "About Me" ]
            , p [] [ text "" ]
            ]
        , container [ id "cv-section", class "p-5 h-100" ]
            [ display 4 [ class "text-center" ] [ text "Curriculum Vitae" ]
            , p [] [ text "" ]
            ]
        ]
    }


type Language
    = English
    | Deutsch


type Msg
    = AboutMeClicked
    | CvClicked
    | ScrollToTopRequested
    | Scrolled
    | ScrolledOutOfTitle
    | ScrolledIntoTitle
    | LanguageChanged Language
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AboutMeClicked ->
            ( model, scrollTo "about-me-section" )

        CvClicked ->
            ( model, scrollTo "cv-section" )

        ScrollToTopRequested ->
            ( model, scrollTo "title-section" )

        Scrolled ->
            ( model, checkIfOutOfTitle )

        ScrolledOutOfTitle ->
            ( { model | scrollButtonVisible = True }, Cmd.none )

        ScrolledIntoTitle ->
            ( { model | scrollButtonVisible = False }, Cmd.none )

        LanguageChanged newLang ->
            ( Debug.log "Model" { model | language = newLang }, Cmd.none )

        None ->
            ( model, Cmd.none )


scrollTo : String -> Cmd Msg
scrollTo elementId =
    Dom.getElement elementId
        |> Task.andThen (\vp -> Dom.setViewport 0 vp.element.y)
        |> Task.attempt (always None)


checkIfOutOfTitle : Cmd Msg
checkIfOutOfTitle =
    Task.map2
        (\vp titleElem ->
            if vp.viewport.y > titleElem.element.y + (titleElem.element.height / 2) then
                ScrolledOutOfTitle

            else
                ScrolledIntoTitle
        )
        Dom.getViewport
        (Dom.getElement "title-section")
        |> Task.attempt
            (Result.withDefault None)
