module Types.Line exposing (..)


type alias Line =
    { name : String
    , lineType : LineType
    , direction : String
    }


type LineType
    = Metro
    | Tram
    | Train
    | Funicular
    | Bus
    | Ferry
    | Trolleybus
