module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Pages exposing (PageModel, PageMsg, initPage, pageTitle, updatePage, viewPage)
import Pages.About
import Pages.Home
import Pages.NotFound
import Tuple
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , pageModel : PageModel
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Tuple.mapBoth
        (\pageModel -> Model key url pageModel)
        (\pageCmd -> Cmd.map PageEvent pageCmd)
        (initPage url)


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PageEvent PageMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            Tuple.mapBoth
                (\pageModel -> { model | url = url, pageModel = pageModel })
                (\pageCmd -> Cmd.map PageEvent pageCmd)
                (initPage url)

        PageEvent pageMsg ->
            Tuple.mapBoth
                (\pageModel -> { model | pageModel = pageModel })
                (\pageCmd -> Cmd.map PageEvent pageCmd)
                (updatePage pageMsg model.pageModel)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view model =
    Document
        (pageTitle model.pageModel)
        [ -- [ Cdn.stylesheet
          -- , Cdn.fontAwesome
          -- ,
          Html.map PageEvent (viewPage model.pageModel)
        ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
