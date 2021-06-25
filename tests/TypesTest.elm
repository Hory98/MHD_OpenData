module TypesTest exposing
    ( testDecodeStop
    , testDecodeStops
    , testDecodePlatformAndLines
    )

import Dict
import Expect exposing (Expectation, FloatingPointTolerance(..))
import Json.Decode exposing (Decoder, decodeString)
import Main exposing (..)
import Test exposing (..)
import Types.Stop
import Types.Platform
import Types.Line


inputStops : String
inputStops =
    """
{
  "generatedAt": "2021-06-24T05:06:57",
  "dataFormatVersion": "2",
  "stopGroups": [
    {
      "name": "Albertov",
      "districtCode": "AB",
      "idosCategory": 301003,
      "idosName": "Albertov",
      "fullName": "Albertov",
      "uniqueName": "Albertov",
      "node": 876,
      "cis": 58936,
      "avgLat": 50.0679169,
      "avgLon": 14.4207983,
      "avgJtskX": -743138.3,
      "avgJtskY": -1045162.44,
      "municipality": "Praha",
      "stops": []
    }
    ]
}
"""


inputStop : String
inputStop =
    """
{
      "name": "Albertov",
      "districtCode": "AB",
      "idosCategory": 301003,
      "idosName": "Albertov",
      "fullName": "Albertov",
      "uniqueName": "Albertov",
      "node": 876,
      "cis": 58936,
      "avgLat": 50.0679169,
      "avgLon": 14.4207983,
      "avgJtskX": -743138.3,
      "avgJtskY": -1045162.44,
      "municipality": "Praha",
      "stops": []
}
"""

inputPlatform : String
inputPlatform = """
{
          "id": "876/2",
          "platform": "B",
          "altIdosName": "Albertov",
          "lat": 50.0686836,
          "lon": 14.4204512,
          "jtskX": -743151.3,
          "jtskY": -1045074.5,
          "zone": "P",
          "wheelchairAccess": "possible",
          "lines": [
            {
              "id": 14,
              "name": "14",
              "type": "tram",
              "direction": "Spořilov"
            },
            {
              "id": 93,
              "name": "93",
              "type": "tram",
              "isNight": true,
              "direction": "Vozovna Pankrác"
            }
          ]
        }
"""

testDecodeStops : Test
testDecodeStops =
    describe "decodeStops - check count"
        [ test "transformation from JSON to List Stop type" <|
            \_ ->
                let
                    stops =
                        decodeString Types.Stop.stopsDecoder inputStops
                in
                case stops of
                    Ok res ->
                        Expect.equal (List.length res) 1

                    Err err ->
                        Expect.fail "Result is Error"
        ]


testDecodeStop : Test
testDecodeStop =
    describe "decodeStop"
        [ test "transformation from JSON to one Stop type" <|
            \_ ->
                let
                    stops =
                        decodeString Types.Stop.stopDecoder inputStop
                in
                case stops of
                    Ok res ->
                        Expect.equal res (Types.Stop.Stop 876 "Albertov" 50.0679169 14.4207983 "Praha" [])

                    Err err ->
                        Expect.fail "Result is Error"
        ]

testDecodePlatformAndLines : Test
testDecodePlatformAndLines =
    describe "decodePlatformAndLines"
        [ test "transformation from JSON to one Platform type with Lines" <|
            \_ ->
               let
                    stop =
                        decodeString Types.Platform.platformDecoder inputPlatform
                in
                case stop of
                    Ok res ->
                        Expect.equal res
                            (Types.Platform.Platform
                                "876/2"
                                "P"
                                Types.Platform.Possible
                                [ Types.Line.Line "14" Types.Line.Tram "Spořilov" False
                                , Types.Line.Line "93" Types.Line.Tram "Vozovna Pankrác" True
                                ]
                            )

                    Err err ->
                        Expect.fail "Result is Error"
        ]

