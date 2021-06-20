module Types.Stop exposing (..)

import Types.Platform exposing (Platform)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Stop =
    { uniqueName : String
    , avgLat : String
    , avgLon : String
    --, platforms : List Platform
    }

stopDecoder : Decode.Decoder Stop
stopDecoder =
    Decode.succeed Stop
        |> Pipeline.required "uniqueName" Decode.string
        |> Pipeline.required "avgLat" Decode.string
        |> Pipeline.required "avgLon" Decode.string
        