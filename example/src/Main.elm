module Main exposing (..)

import Example1
import Html exposing (..)
import Html.Attributes exposing (class, href)


type alias Model =
    { example1a : Example1.Model
    }


initialModel : Model
initialModel =
    { example1a = Example1.initialModel
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.none


init : ( Model, Cmd Msg )
init =
    ( initialModel, initialCmds )


type Msg
    = NoOp
    | Example1aMsg Example1.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Example1aMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example1.update sub model.example1a
            in
                ( { model | example1a = subModel }, Cmd.map Example1aMsg subCmd )

        NoOp ->
            ( model, Cmd.none )


url =
    "https://github.com/sporto/elm-number-input"


view : Model -> Html Msg
view model =
    div [ class "p3" ]
        [ h1 [] [ text "Elm Number Input" ]
        , a [ class "h3", href url ] [ text url ]
        , div [ class "clearfix mt2" ]
            [ div [ class "col col-6" ]
                [ Html.map Example1aMsg (Example1.view model.example1a)
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
