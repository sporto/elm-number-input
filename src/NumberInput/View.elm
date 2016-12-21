module NumberInput.View exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (class, style, value)
import Html.Events as Events
import Json.Decode as Decode
import NumberInput.Models exposing (..)
import String


view : Config msg -> String -> Html msg
view config currentValue =
    input
        [ class config.inputClass
        , onKeyDownAttr config currentValue
          -- , onKeyUpAttr config currentValue
        , style config.inputStyles
        , value currentValue
        ]
        []


eventOptions : Events.Options
eventOptions =
    { stopPropagation = False
    , preventDefault = True
    }


type Key
    = Backspace
    | Dot
    | OtherKey


toKeyCodeName : Int -> Key
toKeyCodeName keyCode =
    case keyCode of
        8 ->
            Backspace

        46 ->
            Dot

        _ ->
            OtherKey


type alias KeyDownEvent =
    { keyCode : Int
    , currentValue : String
    }


keyDownEventDecoder : Decode.Decoder KeyDownEvent
keyDownEventDecoder =
    Decode.map2 KeyDownEvent
        (Decode.field "keyCode" Decode.int)
        (Decode.at [ "target" ] (Decode.field "value" Decode.string))


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

        filterDecoder keyDownEvent =
            if isValidKeydown keyDownEvent.keyCode then
                keyDownEvent.keyCode
                    |> makeNewValueFromKeyCode keyDownEvent.currentValue
                    |> config.onChange
                    |> Decode.succeed
            else
                Decode.fail "Stop!"

        decoder =
            keyDownEventDecoder
                |> Decode.andThen filterDecoder
    in
        Events.onWithOptions "keydown" eventOptions decoder


{-|
On Key up filters out non number values from going out
Keyup receives the new value
-}
onKeyUpAttr : Config msg -> String -> Attribute msg
onKeyUpAttr config currentValue =
    let
        filterDecoder =
            makeNewValue currentValue
                >> config.onChange
                >> Decode.succeed

        decoder =
            Events.targetValue
                |> Decode.andThen filterDecoder
    in
        Events.onWithOptions "keyup" eventOptions decoder


isNumberKeycode : Int -> Bool
isNumberKeycode keyCode =
    (keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105)


makeNewValueFromKeyCode : String -> Int -> String
makeNewValueFromKeyCode currentValue keyCode =
    let
        char =
            Char.fromCode keyCode

        charAsStr =
            String.fromChar char
    in
        case toKeyCodeName keyCode of
            Backspace ->
                String.dropRight 1 currentValue

            _ ->
                currentValue ++ charAsStr


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
