module NumberInput.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (on, onWithOptions, keyCode, targetValue)
import Json.Decode as Decode
import NumberInput.Models exposing (..)
import String


view : Config msg -> Maybe Float -> Html msg
view config maybeValue =
    let
        val =
            maybeValue
                |> Maybe.map toString
                |> Maybe.withDefault ""
    in
        input
            [ class config.inputClass
            , onChangeAttr config
            , onKeyDownAttr config maybeValue
            , style config.inputStyles
            , value val
            ]
            []


onKeyDownAttr : Config msg -> Maybe Float -> Attribute msg
onKeyDownAttr config maybeValue =
    let
        eventOptions =
            { stopPropagation = False
            , preventDefault = True
            }

        filterDecoder code =
            if isNumber code then
                Decode.fail "Number"
            else
                Decode.succeed code

        decoder =
            keyCode
                |> Decode.andThen filterDecoder
                |> Decode.map (always (config.onChange maybeValue))
    in
        onWithOptions "keydown" eventOptions decoder


onChangeAttr : Config msg -> Attribute msg
onChangeAttr config =
    let
        valueDecoder =
            String.toFloat
                >> Result.toMaybe
                >> config.onChange
                >> Decode.succeed

        decoder =
            targetValue
                |> Decode.andThen valueDecoder
    in
        on "change" decoder


isNumber : Int -> Bool
isNumber keyCode =
    (keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105)
