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
          -- , onKeyDownAttr config currentValue
        , onKeyUpAttr config currentValue
        , style config.inputStyles
        , value currentValue
        ]
        []


eventOptions =
    { stopPropagation = False
    , preventDefault = True
    }


type KeyCodeName
    = Backspace
    | Dot
    | Other


toKeyCodeName : Int -> KeyCodeName
toKeyCodeName keyCode =
    case keyCode of
        8 ->
            Backspace

        46 ->
            Dot

        _ ->
            Other


{-|
On Key down filters out non number values from being typed
-}
onKeyDownAttr : Config msg -> String -> Attribute msg
onKeyDownAttr config currentValue =
    let
        isValidKeydown keyCode =
            case toKeyCodeName keyCode of
                Backspace ->
                    True

                Dot ->
                    True

                _ ->
                    isNumberKeycode keyCode

        filterDecoder keyCode =
            if isValidKeydown keyCode then
                -- Fails lets the value through
                Decode.fail "Not valid"
            else
                currentValue |> config.onChange |> Decode.succeed

        decoder =
            keyCode
                |> Decode.andThen filterDecoder
    in
        onWithOptions "keydown" eventOptions decoder


{-|
On Key up filters out non number values from going out
-}
onKeyUpAttr : Config msg -> String -> Attribute msg
onKeyUpAttr config currentValue =
    let
        filterDecoder =
            makeNewValue currentValue
                >> config.onChange
                >> Decode.succeed

        decoder =
            targetValue
                |> Decode.andThen filterDecoder
    in
        onWithOptions "keyup" eventOptions decoder



-- onChangeAttr : Config msg -> Attribute msg
-- onChangeAttr config =
--     let
--         valueDecoder =
--             config.onChange
--                 >> Decode.succeed
--         decoder =
--             targetValue
--                 |> Decode.andThen valueDecoder
--     in
--         on "change" decoder


isNumberKeycode : Int -> Bool
isNumberKeycode keyCode =
    (keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105)


makeNewValue : String -> String -> String
makeNewValue currentValue newValue =
    if newValue == "" then
        newValue
    else
        case String.toFloat newValue of
            Ok n ->
                newValue

            Err _ ->
                currentValue
