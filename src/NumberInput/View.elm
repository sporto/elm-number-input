module NumberInput.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (on, onWithOptions, targetValue)
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
            , style config.inputStyles
            , value val
            ]
            []



-- onKeyDownAttr : Config msg -> Attribute msg
-- onKeyDownAttr config =
--     let
--         eventOptions =
--             { stopPropagation = False
--             , preventDefault = True
--             }
--         -- callbackDecoder =
--         --     toFloat >> config.onChange >> Decode.succeed
--         filter =
--             .keyCode >> config.onChange >> Decode.succeed
--         -- Decode.succeed event.keyCode
--         decoder =
--             eventDecoder
--                 |> Decode.andThen filter
--     in
--         onWithOptions "keydown" eventOptions decoder


onChangeAttr : Config msg -> Attribute msg
onChangeAttr config =
    let
        valueDecoder =
            String.toFloat
                >> Result.withDefault 0
                >> config.onChange
                >> Decode.succeed

        decoder =
            targetValue
                |> Decode.andThen valueDecoder
    in
        on "change" decoder
