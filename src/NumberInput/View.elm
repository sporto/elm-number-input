module NumberInput.View exposing (..)

import Char
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
onKeyDownAttr config currentValue =
    let
        eventOptions =
            { stopPropagation = False
            , preventDefault = True
            }

        unwrappedValue =
            currentValue
                |> Maybe.withDefault 0

        filterDecoder code =
            case code of
                13 ->
                    Decode.fail "Enter"
                        |> Decode.map (always (config.onChange currentValue))

                _ ->
                    -- Translated code to char
                    -- Concat and evaluate if valid number
                    let
                        charAsString =
                            Char.fromCode code
                                |> String.fromChar

                        unwrappedValueAsString =
                            toString unwrappedValue

                        concat =
                            unwrappedValueAsString ++ charAsString

                        result =
                            String.toFloat concat

                        newValue =
                            case result of
                                Ok n ->
                                    Just n

                                Err _ ->
                                    currentValue
                    in
                        newValue
                            |> config.onChange
                            |> Decode.succeed

        decoder =
            keyCode
                |> Decode.andThen filterDecoder
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
