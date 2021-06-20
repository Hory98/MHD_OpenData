module Lib exposing
    ( Triangle
    , TriangleType(..)
    , doubleFirst1
    , doubleFirst2
    , filterTrianglesByType
    , filterValidTriangles
    , indexOf
    , makeTriangles
    , parseValues
    , sortTrianglesByArea
    , sumTrianglesArea
    )

import Dict exposing (Dict)


{-| Represents a triangle with sides a, b, c.
-}
type alias Triangle =
    { a : Float
    , b : Float
    , c : Float
    }


{-| Defines the type of a triangle
-}
type TriangleType
    = RightAngled
    | Isosceles
    | Equilateral


{-| Write a function that lists of sides (as, bs and cs) and creates a list of
triangles from those sides.
-}
makeTriangles : List Float -> List Float -> List Float -> List Triangle
makeTriangles xs ys zs =
    Debug.todo "implement"


{-| Write a function that takes a list of triangles and returns a list of only
valid triangles.
-}
filterValidTriangles : List Triangle -> List Triangle
filterValidTriangles triangles =
    Debug.todo "implement"


{-| Write a function that takes a triangle type and a list of triangles and
returns a list of triangles that conforms the given type.
-}
filterTrianglesByType : TriangleType -> List Triangle -> List Triangle
filterTrianglesByType triangleType triangles =
    Debug.todo "implement"


{-| Write a function that takes a list of triangles and returns a list of
triangles sorted by their area.
-}
sortTrianglesByArea : List Triangle -> List Triangle
sortTrianglesByArea triangles =
    Debug.todo "implement"


{-| Write a function that takes a list of triangles and returns their area
-}
sumTrianglesArea : List Triangle -> Float
sumTrianglesArea triangles =
    Debug.todo "implement"


{-| Write a function that has argument of type Maybe (List Int) and returns
the first number of the list mulitplied by 2.
If the list is Nothing or empty, it should return 0.

Do not use pattern matching or conditions, use helper functions from Maybe
package and |> operator to chain them together.

-}
doubleFirst1 : Maybe (List Int) -> Int
doubleFirst1 maybeList =
    Debug.todo "implement"


{-| Write a function that works in the same way as doubleFirst1 but use point free
style and >> or << operators to chain needed functions together.
-}
doubleFirst2 : Maybe (List Int) -> Int
doubleFirst2 =
    Debug.todo "implement"


{-| Write a function that takes a string that contains property names and
float values e.g.:

""""
a = 12.5
b = 5.4

tx = 18
"""

It converts the string into a dict with string keys and float values. Empty
lines and whitespaces should be skipped. The return value should be wrapped in
result and it should return an error if it cannot be parsed.

-}
parseValues : String -> Result String (Dict String Float)
parseValues str =
    Debug.todo "implement"


{-| This function should return an index of the given element in the list. If
the element does not exist, it should return Nothing.

Do not implement this function by yourself. Find an Elm package that
already has the function and use it here.

-}
indexOf : a -> List a -> Maybe Int
indexOf =
    Debug.todo "implement"
