module Types.Platform exposing (..)

import Types.Line exposing (Line)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.Line exposing (lineDecoder)


type alias Platform =
    { name : String
    , zone : String
    , wheelchairAccess : WheelchairAccess
    , lines : List Line
    }

-- platform has (not) wheelcheir access or we do not know
type WheelchairAccess
    = Possible
    | NotPossible
    | Unknown

platformDecoder : Decode.Decoder Platform
platformDecoder =
    Decode.map4 Platform
        (Decode.field "id" Decode.string)
        (Decode.field "zone" Decode.string)
        (Decode.field "wheelchairAccess" wheelchairAccessDecoder)
        (Decode.field "lines" (Decode.list lineDecoder))

-- decode wheelchair access from string to extra type
wheelchairAccessDecoder : Decode.Decoder WheelchairAccess
wheelchairAccessDecoder = 
        Decode.string
        |> Decode.andThen (\str ->
           case str of
                "possible" ->
                    Decode.succeed Possible
                "notPossible" ->
                    Decode.succeed NotPossible
                somethingElse ->
                    Decode.succeed Unknown
        )
