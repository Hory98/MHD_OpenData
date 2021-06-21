module Types.Stop exposing (..)

import Types.Platform exposing (Platform)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Json.Decode exposing (float)
import Types.Platform exposing (platformDecoder)


type alias Stop =
    { uniqueName : String
    , avgLat : Float
    , avgLon : Float
    , platforms : List Platform
    }

stopDecoder : Decode.Decoder Stop
stopDecoder =
    Decode.map4 Stop
        (Decode.field "uniqueName" Decode.string)
        (Decode.field "avgLat" Decode.float)
        (Decode.field "avgLon" Decode.float)
        (Decode.field "stops" (Decode.list platformDecoder))
       

{--
stopDecoder : Decode.Decoder Stop
stopDecoder =
    Decode.succeed Stop
        |> Pipeline.required "uniqueName" Decode.string
        |> Pipeline.required "avgLat" Decode.float
        |> Pipeline.required "avgLon" Decode.float
        --|> Pipeline.required "stops" (Decode.list platformDecoder)
     --}