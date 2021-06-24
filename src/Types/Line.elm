module Types.Line exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline

type alias Line =
    { name : String
    , lineType : LineType
    , direction : String
    , isNight : Bool
    }

-- all means of public transport in Prague + unknown for unusual data
type LineType
    = Metro
    | Tram
    | Train
    | Funicular
    | Bus
    | Ferry
    | Trolleybus
    | Unknown

-- decode lineTzpe from string to extra type
lineTypeDecoder : Decode.Decoder LineType
lineTypeDecoder = 
        Decode.string
        |> Decode.andThen (\str ->
           case str of
                "metro" ->
                    Decode.succeed Metro
                "tram" ->
                    Decode.succeed Tram
                "train" ->
                    Decode.succeed Train
                "funicular" ->
                    Decode.succeed Funicular
                "bus" ->
                    Decode.succeed Bus
                "ferry" ->
                    Decode.succeed Ferry
                "trolleybus" ->
                    Decode.succeed Trolleybus
                somethingElse ->
                    Decode.succeed Unknown
        )

lineDecoder : Decode.Decoder Line
lineDecoder =
    Decode.succeed Line
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "type" lineTypeDecoder
        |> Pipeline.required "direction" Decode.string
        |> Pipeline.optional "isNight" Decode.bool False