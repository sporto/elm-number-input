module Example1 exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (class)
import NumberInput


{-|
In your main application model you should store:

- The selected item e.g. selectedMovieId
- The state for the select component
-}
type alias Model =
    { value : Maybe Float
    }


{-|
Your model should store the selected item and the state of the Select component(s)
-}
initialModel : Model
initialModel =
    { value = Just 1.5
    }


{-|
Your application messages need to include:
- OnSelect item : This will be called when an item is selected
- SelectMsg (Select.Msg item) : A message that wraps internal Select library messages. This is necessary to route messages back to the component.
-}
type Msg
    = NoOp
    | OnChange Float


{-|
Create the configuration for the Select component

`Select.newConfig` takes two args:

- The selection message e.g. `OnSelect`
- A function that extract a label from an item e.g. `.label`
-}
inputConfig : NumberInput.Config Msg
inputConfig =
    NumberInput.newConfig OnChange
        |> NumberInput.withInputClass "col-12"
        |> NumberInput.withInputStyles [ ( "padding", "0.5rem" ) ]
        |> NumberInput.withPlaceholder "$"


{-|
Your update function should route messages back to the Select component, see `SelectMsg`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        -- OnSelect is triggered when a selection is made on the Select component.
        OnChange value ->
            ( { model | value = Just value }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


{-|
Your view renders the select component passing the config, state, list of items and the currently selected item.
-}
view : Model -> Html Msg
view model =
    div [ class "bg-silver p1" ]
        [ h3 [] [ text "Basic example" ]
        , text (toString model.value)
        , NumberInput.view inputConfig model.value
        ]
