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
import Types.Line exposing (Line, LineType)
import Types.Platform exposing (Platform, WheelchairAccess)
import Types.Stop exposing (Stop, stopDecoder, stopsDecoder)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



{--
    GetStops - msg for downloading data
    ChangedStopSearchBox - changes in searchBox
--}


type Msg
    = GetStops (Result Http.Error (List Stop))
    | ChangedStopSearchBox (SearchBox.ChangeEvent Stop)



{--
    Loading - initial state before data are loaded
    Loaded - data are loaded
    Failed - data loading failed
--}
type Model
    = Loading
    | Loaded DataModel
    | Failed


type alias DataModel =
    { stops : Maybe (List Stop)
    , stop : Maybe Stop
    , stopText : String
    , stopSearchBox : SearchBox.State
    }

-- download data of stops from opendata web
getStops : Cmd Msg
getStops =
    Http.get
        { url = "http://data.pid.cz/stops/json/stops.json"
        , expect = Http.expectJson GetStops Types.Stop.stopsDecoder
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , getStops
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetStops result ->
            case result of
                Ok stops ->
                    ( Loaded
                        (DataModel
                            (Just stops)
                            Nothing
                            ""
                            SearchBox.init
                        )
                    , Cmd.none
                    )

                Err _ ->
                    ( Failed, Cmd.none )

        ChangedStopSearchBox changeEvent ->
            case model of
                Loaded dataModel ->
                    case changeEvent of
                        -- change selected item
                        SearchBox.SelectionChanged stop ->
                            ( Loaded { dataModel | stop = Just stop }
                            , Cmd.none
                            )

                        -- change text in searchBox
                        SearchBox.TextChanged text ->
                            ( Loaded
                                { dataModel
                                    | stop = Nothing
                                    , stopText = text
                                    , stopSearchBox = SearchBox.reset dataModel.stopSearchBox
                                }
                            , Cmd.none
                            )

                        -- searchBox change
                        SearchBox.SearchBoxChanged subMsg ->
                            ( Loaded { dataModel | stopSearchBox = SearchBox.update subMsg dataModel.stopSearchBox }
                            , Cmd.none
                            )

                somethingElse ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- size of lineType image
lineIconsSize : Int
lineIconsSize =
    80


-- get picture for lineType with specified path
lineTypeImage : String -> Html Msg
lineTypeImage path =
    Html.img
        [ Attributes.src path
        , Attributes.width lineIconsSize
        , Attributes.height lineIconsSize
        ]
        []


-- get picture for lineType with specified path
lineTypeView : LineType -> Html Msg
lineTypeView lineType =
    case lineType of
        Types.Line.Metro ->
            lineTypeImage "pictures/metro.png"

        Types.Line.Tram ->
            lineTypeImage "pictures/tram.png"

        Types.Line.Train ->
            lineTypeImage "pictures/train.png"

        Types.Line.Funicular ->
            lineTypeImage "pictures/funicular.png"

        Types.Line.Bus ->
            lineTypeImage "pictures/bus.png"

        Types.Line.Ferry ->
            lineTypeImage "pictures/ferry.png"

        Types.Line.Trolleybus ->
            lineTypeImage "pictures/trolleybus.png"

        somethingElse ->
            lineTypeImage "pictures/unknown.png"


-- picture for day/night line
isNightView : Bool -> Html Msg
isNightView isNight =
    if isNight then
        Html.img
            [ Attributes.src "pictures/night.png"
            , Attributes.width lineIconsSize
            , Attributes.height lineIconsSize
            ]
            []

    else
        Html.img
            [ Attributes.src "pictures/day.png"
            , Attributes.width lineIconsSize
            , Attributes.height lineIconsSize
            ]
            []


-- HTML view of one line
lineView : Line -> Html Msg
lineView line =
    Html.div [ Attributes.style "display" "flex", Attributes.style "font-size" "18px" ]
        [ lineTypeView line.lineType
        , isNightView line.isNight
        , Html.ul []
            [ Html.li [] [ Html.text ("Line name: " ++ line.name) ]
            , Html.li [] [ Html.text ("Line direction: " ++ line.direction) ]
            ]
        ]


-- image for wheelchair access
wheelchairAccessImage : WheelchairAccess -> Html Msg
wheelchairAccessImage wheelchairAccess =
    case wheelchairAccess of
        Types.Platform.Possible ->
            Html.div [ Attributes.style "border-style" "solid" ]
                [ Html.img
                    [ Attributes.src "pictures/wheelchair.png"
                    , Attributes.width lineIconsSize
                    , Attributes.height lineIconsSize
                    ]
                    []
                , Html.img
                    [ Attributes.src "pictures/yes.png"
                    , Attributes.width lineIconsSize
                    , Attributes.height lineIconsSize
                    ]
                    []
                ]

        Types.Platform.NotPossible ->
            Html.div [ Attributes.style "border-style" "solid" ]
                [ Html.img
                    [ Attributes.src "pictures/wheelchair.png"
                    , Attributes.width lineIconsSize
                    , Attributes.height lineIconsSize
                    ]
                    []
                , Html.img
                    [ Attributes.src "pictures/no.png"
                    , Attributes.width lineIconsSize
                    , Attributes.height lineIconsSize
                    ]
                    []
                ]

        somethingElse ->
            Html.div [ Attributes.style "border-style" "solid" ]
                [ Html.img
                    [ Attributes.src "pictures/wheelchair.png"
                    , Attributes.width lineIconsSize
                    , Attributes.height lineIconsSize
                    ]
                    []
                , Html.img
                    [ Attributes.src "pictures/unknown.png"
                    , Attributes.width lineIconsSize
                    , Attributes.height lineIconsSize
                    ]
                    []
                ]


-- HTML view of one platform with N lines
platformView : Platform -> Html Msg
platformView platform =
    Html.div []
        [ Html.div [ Attributes.style "font-size" "20px", Attributes.style "background" "lightgrey" ]
            [ Html.ul []
                [ Html.li [] [ Html.text ("Platform name: " ++ platform.name) ]
                , Html.li [] [ Html.text ("Platform zone(s): " ++ platform.zone) ]
                ]
            , wheelchairAccessImage platform.wheelchairAccess
            ]
        , Html.div [] (List.map lineView platform.lines)
        ]


-- build link to Google Maps from latitude, longitude and fixed zoom
getGoogleMapsLink : Float -> Float -> String
getGoogleMapsLink lat lon =
    "https://www.google.cz/maps/@" ++ String.fromFloat lat ++ "," ++ String.fromFloat lon ++ ",18z"


-- HTML view of one stop with N platforms
stopView : DataModel -> Html Msg
stopView dataModel =
    let
        stopMaybe =
            dataModel.stop
    in
    case stopMaybe of
        Nothing ->
            Html.div [] []

        Just stop ->
            Html.div []
                [ Html.ul [ Attributes.style "font-size" "22px", Attributes.style "font-weight" "bold" ]
                    [ Html.li [] [ Html.text ("Stop name: " ++ stop.uniqueName) ]
                    , Html.li [] [ Html.text ("Municipality: " ++ stop.municipality) ]
                    , Html.li [] [ Html.text ("Latitude: " ++ String.fromFloat stop.avgLat) ]
                    , Html.li [] [ Html.text ("Longitude: " ++ String.fromFloat stop.avgLon) ]
                    , Html.a [ Attributes.href (getGoogleMapsLink stop.avgLat stop.avgLon), Attributes.target "_blank" ] [ Html.text "Redirect to Google Maps" ]
                    ]
                , Html.div [] (List.map platformView stop.platforms)
                ]


-- HTML view for Model Loading (state before loaded data)
loadingView : Html Msg
loadingView =
    Html.div []
        [ Html.img [ Attributes.src "pictures/spinner.gif", Attributes.width 200, Attributes.height 200 ] []
        ]

-- HTML view for Model Failed (loading of data failed)
failedView : Html Msg
failedView =
    Html.div []
        [ Html.img [ Attributes.src "pictures/no.png", Attributes.width 200, Attributes.height 200 ] [] ]

-- HTML view for Model Loaded (data are loaded in DataModel)
loadedView : DataModel -> Html Msg
loadedView dataModel =
    Html.div []
        [
          Element.layout [] <|
            column []
                [ SearchBox.input []
                    { onChange = ChangedStopSearchBox
                    , text = dataModel.stopText
                    , selected = dataModel.stop
                    , options = dataModel.stops
                    , label = Input.labelAbove [] (text "Search and choose stop")
                    , placeholder = Nothing
                    , toLabel = \stop -> stop.uniqueName ++ " (" ++ String.fromInt stop.id ++ ")"
                    , filter =
                        \query stop ->
                            String.contains (String.toLower query) (String.toLower stop.uniqueName)
                    , state = dataModel.stopSearchBox
                    }
                ]
        , stopView dataModel
        ]

-- main view function, just switch for 3 models
view : Model -> Html Msg
view model =
    case model of
        Loading ->
            loadingView

        Failed ->
            failedView

        Loaded dataModel ->
            loadedView dataModel
