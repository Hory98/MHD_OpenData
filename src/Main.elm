module Main exposing (main)

import Bootstrap.Accordion as Accordion
import Bootstrap.Button as Button
import Bootstrap.Card.Block as Block
import Browser
import Browser.Dom exposing (Element)
import Element exposing (..)
import Element.Input as Input
import File.Select as Select
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import SearchBox
import Types.Line exposing (Line)
import Types.Platform exposing (Platform)
import Types.Stop exposing (Stop, stopDecoder)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type Msg
    = NoOp
    | GetStops (Result Http.Error (List Stop))
    | ChangedStopSearchBox (SearchBox.ChangeEvent Stop)
    | AccordionMsg Accordion.State


type Model
    = Loading
    | Loaded DataModel
    | Failed


type alias DataModel =
    { stops : Maybe (List Stop)
    , stop : Maybe Stop
    , stopText : String
    , stopSearchBox : SearchBox.State
    , accordionState : Accordion.State
    }


stopsDecoder : Decode.Decoder (List Stop)
stopsDecoder =
    Decode.field "stopGroups" (Decode.list stopDecoder)


getStops : Cmd Msg
getStops =
    Http.get
        { url = "http://data.pid.cz/stops/json/stops.json"
        , expect = Http.expectJson GetStops stopsDecoder
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , getStops
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetStops result ->
            case result of
                Ok stops ->
                    ( Loaded
                        (DataModel
                            (Just stops)
                            Nothing
                            ""
                            SearchBox.init
                            Accordion.initialState
                        )
                    , Cmd.none
                    )

                Err _ ->
                    ( Failed, Cmd.none )

        ChangedStopSearchBox changeEvent ->
            case model of
                Loaded dataModel ->
                    case changeEvent of
                        SearchBox.SelectionChanged stop ->
                            ( Loaded { dataModel | stop = Just stop }
                            , Cmd.none
                            )

                        SearchBox.TextChanged text ->
                            ( Loaded
                                { dataModel
                                    | stop = Nothing
                                    , stopText = text
                                    , stopSearchBox = SearchBox.reset dataModel.stopSearchBox
                                }
                            , Cmd.none
                            )

                        SearchBox.SearchBoxChanged subMsg ->
                            ( Loaded { dataModel | stopSearchBox = SearchBox.update subMsg dataModel.stopSearchBox }
                            , Cmd.none
                            )

                somethingElse ->
                    ( model, Cmd.none )

        AccordionMsg state ->
            case model of
                Loaded dataModel ->
                    ( Loaded { dataModel | accordionState = state }
                    , Cmd.none
                    )

                somethingElse ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Loaded dataModel ->
            Accordion.subscriptions dataModel.accordionState AccordionMsg

        somethingElse ->
            Sub.none


rowItemLine : Line -> Html Msg
rowItemLine line =
    Html.div []
        [ Html.text ("--- ---" ++ line.name) ]


rowItemPlatform : Platform -> Html Msg
rowItemPlatform platform =
    Html.div []
        [ Html.text ("---" ++ platform.name ++ " " ++ platform.zone)
        , Html.div [] (List.map rowItemLine platform.lines)
        ]

{--
getPlatformsAccordion : List Platform -> List Accordion
getPlatformsAccordion platforms =
    []
--}

stopView : DataModel -> Html Msg
stopView dataModel =
    let
        stopMaybe = dataModel.stop
    in
    case stopMaybe of
        Nothing ->
            Html.div [] []

        Just stop ->
            Html.div []
                [ Html.text (stop.uniqueName ++ " " ++ Debug.toString stop.avgLat ++ " " ++ Debug.toString stop.avgLon)
                , Html.div [] (List.map rowItemPlatform stop.platforms)
                , Accordion.config AccordionMsg
                    |> Accordion.withAnimation
                    |> Accordion.cards
                        [ Accordion.card
                            { id = "card1"
                            , options = []
                            , header =
                                Accordion.header [] <| Accordion.toggle [] [ Html.text "Card 1" ]
                            , blocks =
                                [ Accordion.block []
                                    [ Block.text [] [ Html.text "Lorem ipsum etc" ] ]
                                ]
                            }
                        ]
                    |> Accordion.view dataModel.accordionState
                ]




rowItem0 : List Stop -> Html Msg
rowItem0 stops =
    Html.div []
        [ Html.text (Debug.toString (List.length stops)) ]


loadingView : Html Msg
loadingView =
    Html.div []
        [ Html.img [ Attributes.src "../pictures/spinner.gif", Attributes.width 200, Attributes.height 200 ] []
        ]


failedView : Html Msg
failedView =
    Html.div []
        [ Html.img [ Attributes.src "../pictures/no.png", Attributes.width 200, Attributes.height 200 ] [] ]


loadedView : DataModel -> Html Msg
loadedView dataModel =
    Html.div []
        [ Html.div [] [ Html.text "Icons: https://icons8.com/icon/set/transport/color" ]
        , Element.layout [] <|
            column []
                [ SearchBox.input []
                    { onChange = ChangedStopSearchBox
                    , text = dataModel.stopText
                    , selected = dataModel.stop
                    , options = dataModel.stops
                    , label = Input.labelAbove [] (text "Stop")
                    , placeholder = Nothing
                    , toLabel = \stop -> stop.uniqueName
                    , filter =
                        \query stop ->
                            String.contains (String.toLower query) (String.toLower stop.uniqueName)
                    , state = dataModel.stopSearchBox
                    }
                ]
        , stopView dataModel
        , rowItem0 (Maybe.withDefault [] dataModel.stops)
        ]


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            loadingView

        Failed ->
            failedView

        Loaded dataModel ->
            loadedView dataModel



{--

Element.layout [] <|
        column []
            [ SearchBox.input []
                { onChange = ChangedStopSearchBox
                , text = model.stopText
                , selected = model.stop
                , options = model.stops
                , label = Input.labelAbove [] (text "Stop")
                , placeholder = Nothing
                , toLabel = \stop -> stop.uniqueName
                , filter =
                    \query stop ->
                        String.contains (String.toLower query) (String.toLower stop.uniqueName)
                , state = model.stopSearchBox
                }
            ]


--}
--Html.div [] (List.map rowItem (Maybe.withDefault [] model.stops))
--(rowItem0 model.stops)
--Html.div [] (List.map rowItem1 model.stops)
--Html.div [] (List.map rowItem model.stops)
