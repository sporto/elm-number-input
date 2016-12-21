module NumberInput.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (onClick)


-- import UI.NumberInput.Messages exposing (..)

import NumberInput.Models exposing (..)


view : Config msg -> Maybe Float -> Html msg
view config maybeValue =
    let
        val =
            case maybeValue of
                Nothing ->
                    ""

                Just number ->
                    toString number
    in
        input
            [ class config.inputClass
            , style config.inputStyles
            , value val
            ]
            []
