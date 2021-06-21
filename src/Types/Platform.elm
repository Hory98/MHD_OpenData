module Types.Platform exposing (..)

import Types.Line exposing (Line)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.Line exposing (lineDecoder)


type alias Platform =
    { name : String
    , zone : String
    --, wheelchairAccess : WheelchairAccess
    , lines : List Line
    }


type WheelchairAccess
    = Possible
    | NotPossible
    | Unknown

platformDecoder : Decode.Decoder Platform
platformDecoder =
    Decode.map3 Platform
        (Decode.field "id" Decode.string)
        (Decode.field "zone" Decode.string)
        (Decode.field "lines" (Decode.list lineDecoder))

{--
platformDecoder : Decode.Decoder Platform
platformDecoder =
    Decode.succeed Platform
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "zone" Decode.string
--}