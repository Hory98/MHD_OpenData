module Main exposing (main)

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


type alias Model =
    { stops : Maybe (List Stop)
    , stop : Maybe Stop
    , stopText : String
    , stopSearchBox : SearchBox.State
    }


stopsDecoder : Decode.Decoder (List Stop)
stopsDecoder =
    Decode.field "stopGroups" (Decode.list stopDecoder)



--Decode.field "stopGroups" (Decode.list (Decode.field "name" Decode.string))
--(Decode.list stopDecoder)


getStops : Cmd Msg
getStops =
    Http.get
        { url = "http://data.pid.cz/stops/json/stops.json"
        , expect = Http.expectJson GetStops stopsDecoder
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { stops = Nothing
      , stop = Nothing
      , stopText = ""
      , stopSearchBox = SearchBox.init
      }
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
                    ( { model
                        | stops = Just stops
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        ChangedStopSearchBox changeEvent ->
            case changeEvent of
                SearchBox.SelectionChanged stop ->
                    ( { model | stop = Just stop }
                    , Cmd.none
                    )

                SearchBox.TextChanged text ->
                    ( { model
                        | stop = Nothing
                        , stopText = text
                        , stopSearchBox = SearchBox.reset model.stopSearchBox
                      }
                    , Cmd.none
                    )

                SearchBox.SearchBoxChanged subMsg ->
                    ( { model | stopSearchBox = SearchBox.update subMsg model.stopSearchBox }
                    , Cmd.none
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
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


rowItem : Maybe Stop -> Html Msg
rowItem stop =
    case stop of
        Nothing -> Html.div [] []
        Just st -> 
            Html.div []
                [ Html.text (st.uniqueName ++ " " ++ Debug.toString st.avgLat ++ " " ++ Debug.toString st.avgLon)
                , Html.div [] (List.map rowItemPlatform st.platforms)
                ]


rowItem0 : List Stop -> Html Msg
rowItem0 stops =
    Html.div []
        [ Html.text (Debug.toString (List.length stops)) ]


view : Model -> Html Msg
view model =
    Html.div [] [
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
                ],
        --Html.h1 [] [ Html.text "Sunny Philadelphia" ]
        rowItem model.stop
    ]


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
