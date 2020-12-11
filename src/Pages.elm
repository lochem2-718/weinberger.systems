module Pages exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (title)
import Pages.About as About
import Pages.Home as Home
import Pages.NotFound as NotFound
import Url exposing (Url)
import Url.Parser


type PageModel
    = HomeModel Home.Model
    | AboutModel About.Model
    | NotFoundModel NotFound.Model


type PageMsg
    = HomeMsg Home.Msg
    | AboutMsg About.Msg
    | NotFoundMsg NotFound.Msg


initPage : Url -> ( PageModel, Cmd PageMsg )
initPage url =
    case url.path of
        "/" ->
            Tuple.mapBoth HomeModel (Cmd.map HomeMsg) (Home.init ())

        "/home" ->
            Tuple.mapBoth HomeModel (Cmd.map HomeMsg) (Home.init ())

        "/about" ->
            Tuple.mapBoth AboutModel (Cmd.map AboutMsg) (About.init ())

        _ ->
            Tuple.mapBoth NotFoundModel (Cmd.map NotFoundMsg) (NotFound.init url.path)


updatePage : PageMsg -> PageModel -> ( PageModel, Cmd PageMsg )
updatePage msg model =
    case ( msg, model ) of
        ( HomeMsg homeMsg, HomeModel oldHomeModel ) ->
            Tuple.mapBoth
                (\newHomeModel -> HomeModel newHomeModel)
                (\homeCmd -> Cmd.map HomeMsg homeCmd)
                (Home.update homeMsg oldHomeModel)

        ( AboutMsg aboutMsg, AboutModel oldAboutModel ) ->
            Tuple.mapBoth
                (\newAboutModel -> AboutModel newAboutModel)
                (\aboutCmd -> Cmd.map AboutMsg aboutCmd)
                (About.update aboutMsg oldAboutModel)

        ( NotFoundMsg notFoundMsg, NotFoundModel oldNotFoundModel ) ->
            Tuple.mapBoth
                (\newNotFoundModel -> NotFoundModel newNotFoundModel)
                (\notFoundCmd -> Cmd.map NotFoundMsg notFoundCmd)
                (NotFound.update notFoundMsg oldNotFoundModel)

        ( _, _ ) ->
            Tuple.mapBoth HomeModel (Cmd.map HomeMsg) (Home.init ())


viewPage : PageModel -> Html PageMsg
viewPage model =
    case model of
        HomeModel m ->
            Html.map HomeMsg (Home.view m)

        AboutModel m ->
            Html.map AboutMsg (About.view m)

        NotFoundModel m ->
            Html.map NotFoundMsg (NotFound.view m)


pageTitle : PageModel -> String
pageTitle pageModel =
    case pageModel of
        HomeModel m ->
            "Home"

        AboutModel m ->
            "About"

        NotFoundModel m ->
            "Page Not Found"
