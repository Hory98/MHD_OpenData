module Types.Platform exposing (..)

import Types.Line exposing (Line)


type alias Platform =
    { name : String
    , zone : String
    , wheelchairAccess : WheelchairAccess
    , lines : List Line
    }


type WheelchairAccess
    = Possible
    | NotPossible
    | Unknown
