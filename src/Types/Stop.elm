module Types.Stop exposing (..)

import Types.Platform exposing (Platform)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Json.Decode exposing (float)
import Types.Platform exposing (platformDecoder)


type alias Stop =
    { id : Int
    , uniqueName : String
    , avgLat : Float
    , avgLon : Float
    , municipality : String
    , platforms : List Platform
    }

stopDecoder : Decode.Decoder Stop
stopDecoder =
    Decode.map6 Stop
        (Decode.field "node" Decode.int)
        (Decode.field "uniqueName" Decode.string)
        (Decode.field "avgLat" Decode.float)
        (Decode.field "avgLon" Decode.float)
        (Decode.field "municipality" Decode.string)
        (Decode.field "stops" (Decode.list platformDecoder))


stopsDecoder : Decode.Decoder (List Stop)
stopsDecoder =
    Decode.field "stopGroups" (Decode.list stopDecoder)
       

