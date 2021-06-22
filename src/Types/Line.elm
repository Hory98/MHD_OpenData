module Types.Line exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline

type alias Line =
    { name : String
    --, lineType : LineType
    --, direction : String
    }


type LineType
    = Metro
    | Tram
    | Train
    | Funicular
    | Bus
    | Ferry
    | Trolleybus
    | Unknown

lineDecoder : Decode.Decoder Line
lineDecoder =
    Decode.succeed Line
        |> Pipeline.required "name" Decode.string