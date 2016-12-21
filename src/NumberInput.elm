module NumberInput
    exposing
        ( Config
        , newConfig
        , withInputClass
        , withInputStyles
        , withPlaceholder
        , view
        )

import Html exposing (Html)
import NumberInput.Messages as Messages
import NumberInput.Models as Models
import NumberInput.Update as Update
import NumberInput.View as View


type Config msg
    = PrivateConfig (Models.Config msg)



-- type State
--     = PrivateState Models.State
-- type Msg
--     = PrivateMsg Messages.Msg


newConfig : (Float -> msg) -> Config msg
newConfig onInputMsgCtr =
    PrivateConfig (Models.newConfig onInputMsgCtr)


withInputClass : String -> Config msg -> Config msg
withInputClass classes config =
    let
        fn c =
            { c | inputClass = classes }
    in
        fmapConfig fn config


withInputStyles : List ( String, String ) -> Config msg -> Config msg
withInputStyles styles config =
    let
        fn c =
            { c | inputStyles = styles }
    in
        fmapConfig fn config


withPlaceholder : String -> Config msg -> Config msg
withPlaceholder placeholder config =
    let
        fn c =
            { c | placeholder = Just placeholder }
    in
        fmapConfig fn config


{-|
@priv
-}
fmapConfig : (Models.Config msg -> Models.Config msg) -> Config msg -> Config msg
fmapConfig fn config =
    let
        config_ =
            unwrapConfig config
    in
        PrivateConfig (fn config_)



-- initialState : String -> State
-- initialState id =
--     PrivateState (Models.initialState id)


view : Config msg -> Maybe Float -> Html msg
view config maybeValue =
    let
        config_ =
            unwrapConfig config

        -- model_ =
        --     unwrapState model
    in
        View.view config_ maybeValue



-- Html.map PrivateMsg (View.view config_ maybeValue)
-- update : Config msg -> Msg -> State -> ( State, Cmd msg )
-- update config msg model =
--     let
--         config_ =
--             unwrapConfig config
--         msg_ =
--             unwrapMsg msg
--         model_ =
--             unwrapState model
--     in
--         let
--             ( mdl, cmd ) =
--                 Update.update config_ msg_ model_
--         in
--             ( PrivateState mdl, cmd )


{-|
@priv
-}
unwrapConfig : Config msg -> Models.Config msg
unwrapConfig (PrivateConfig config) =
    config



-- unwrapMsg : Msg -> Messages.Msg
-- unwrapMsg (PrivateMsg msg) =
--     msg
-- unwrapState : State -> Models.State
-- unwrapState (PrivateState state) =
--     state
