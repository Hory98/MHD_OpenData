module Main exposing (main)

import Browser
import File.Select as Select
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
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
    | GetStops (Result Http.Error (List String))


type alias Model =
    { stops : List String
    , currentStop : String
    }


stopsDecoder : Decode.Decoder (List String)
stopsDecoder =
    Decode.field "stopGroups" (Decode.list (Decode.field "name" Decode.string))



--(Decode.list stopDecoder)


getStops : Cmd Msg
getStops =
    Http.get
        { url = "http://data.pid.cz/stops/json/stops.json"
        , expect = Http.expectJson GetStops stopsDecoder
        }



init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] ""
    , getStops
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetStops result ->
            case result of
                Ok list ->
                    ( Model list "", Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


rowItem : Stop -> Html Msg
rowItem stop =
    Html.div []
        [ Html.text stop.uniqueName ]


rowItem0 : List String -> Html Msg
rowItem0 stops =
    Html.div []
        [ Html.text (Debug.toString (List.length stops)) ]


rowItem1 : String -> Html Msg
rowItem1 stop =
    Html.div []
        [ Html.text stop ]


view : Model -> Html Msg
view model =
    --(rowItem0 model.stops)
    Html.div [] (List.map rowItem1 model.stops)



--Html.div [] (List.map rowItem model.stops)


introductionContent : Html Msg
introductionContent =
    Html.div []
        [ Html.p [] [ Html.text "Jenny Giantbulb had always loved sunny Philadelphia with its frightened, fragile fields. It was a place where she felt relaxed." ]
        , Html.p [] [ Html.text "She was a noble, predatory, tea drinker with red lips and fragile feet. Her friends saw her as a hungry, hilarious hero. Once, she had even helped a puny kitten recover from a flying accident. That's the sort of woman he was." ]
        ]


plotContent : Html Msg
plotContent =
    Html.div []
        [ Html.p [] [ Html.text "Jenny walked over to the window and reflected on her idyllic surroundings. The sun shone like walking horses." ]
        , Html.p [] [ Html.text "Then she saw something in the distance, or rather someone. It was the figure of John Thunder. John was an optimistic giant with beautiful lips and short feet." ]
        , Html.p [] [ Html.text "Jenny gulped. She was not prepared for John." ]
        , Html.p [] [ Html.text "As Jenny stepped outside and John came closer, she could see the super glint in his eye." ]
        , Html.p [] [ Html.text "John gazed with the affection of 9175 spiteful broad bears. He said, in hushed tones, \"I love you and I want justice.\"" ]
        , Html.p [] [ Html.text "Jenny looked back, even more cross and still fingering the squidgy newspaper. \"John, hands up or I'll shoot,\" she replied." ]
        ]


conclusionContent : Html Msg
conclusionContent =
    Html.div []
        [ Html.p [] [ Html.text "They looked at each other with surprised feelings, like two faffdorking, faithful frogs cooking at a very cowardly Halloween party, which had piano music playing in the background and two stingy uncles bouncing to the beat." ]
        , Html.p [] [ Html.text "Jenny regarded John's beautiful lips and short feet. \"I feel the same way!\" revealed Jenny with a delighted grin." ]
        , Html.p [] [ Html.text "John looked irritable, his emotions blushing like a sleepy, squashed sausage." ]
        , Html.p [] [ Html.text "Then John came inside for a nice cup of tea." ]
        ]


pageStyle : List (Attribute Msg)
pageStyle =
    [ Attributes.style "width" "45rem"
    , Attributes.style "margin" "auto"
    ]


subheadlineStyle : List (Attribute Msg)
subheadlineStyle =
    [ Attributes.style "font-style" "italic"
    ]


tabsStyle : List (Attribute Msg)
tabsStyle =
    [ Attributes.style "display" "flex"
    , Attributes.style "width" "100%"
    , Attributes.style "border-bottom" "1px solid #000"
    ]


tabStyle : List (Attribute Msg)
tabStyle =
    [ Attributes.style "flex-grow" "1"
    , Attributes.style "text-align" "center"
    , Attributes.style "cursor" "pointer"
    , Attributes.style "padding" "0.5rem"
    , Attributes.style "color" "blue"
    ]


tabStyleActive : List (Attribute Msg)
tabStyleActive =
    [ Attributes.style "font-weight" "bold"
    , Attributes.style "color" "black"
    ]
