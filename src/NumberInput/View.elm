module NumberInput.View exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (on, onWithOptions, keyCode, targetValue)
import Json.Decode as Decode
import NumberInput.Models exposing (..)
import String


view : Config msg -> String -> Html msg
view config currentValue =
    input
        [ class config.inputClass
        , onChangeAttr config
        , onKeyDownAttr config currentValue
        , style config.inputStyles
        , value currentValue
        ]
        []


onKeyDownAttr : Config msg -> String -> Attribute msg
onKeyDownAttr config currentValue =
    let
        eventOptions =
            { stopPropagation = False
            , preventDefault = True
            }

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

                        concat =
                            currentValue ++ charAsString

                        isValidNumberResult =
                            String.toFloat concat

                        newValue =
                            case isValidNumberResult of
                                Ok n ->
                                    concat

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
            config.onChange
                >> Decode.succeed

        decoder =
            targetValue
                |> Decode.andThen valueDecoder
    in
        on "change" decoder


isNumber : Int -> Bool
isNumber keyCode =
    (keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105)
