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

        filterDecoder =
            makeNewValue currentValue
                >> config.onChange
                >> Decode.succeed

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


makeNewValue : String -> Int -> String
makeNewValue currentValue keycode =
    let
        charAsString =
            Char.fromCode keycode |> String.fromChar

        concatenated =
            currentValue ++ charAsString

        result =
            String.toFloat concatenated
    in
        case result of
            Ok n ->
                concatenated

            Err _ ->
                currentValue
