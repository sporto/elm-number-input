module NumberInput
    exposing
        ( Config
        , newConfig
        , withInputClass
        , withInputStyles
        , withPlaceholder
        , view
        )

{-|
# Types
@docs Config

# Configuration
@docs newConfig, withInputClass, withInputStyles, withPlaceholder

# View
@docs view
-}

import Html exposing (Html)
import NumberInput.Models as Models
import NumberInput.View as View


{-|
TODO
-}
type Config msg
    = PrivateConfig (Models.Config msg)


{-|
TODO
-}
newConfig : (String -> msg) -> Config msg
newConfig onInputMsgCtr =
    PrivateConfig (Models.newConfig onInputMsgCtr)


{-|
TODO
-}
withInputClass : String -> Config msg -> Config msg
withInputClass classes config =
    let
        fn c =
            { c | inputClass = classes }
    in
        fmapConfig fn config


{-|
TODO
-}
withInputStyles : List ( String, String ) -> Config msg -> Config msg
withInputStyles styles config =
    let
        fn c =
            { c | inputStyles = styles }
    in
        fmapConfig fn config


{-|
TODO
-}
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


{-|
TODO
-}
view : Config msg -> String -> Html msg
view config currentValue =
    let
        config_ =
            unwrapConfig config
    in
        View.view config_ currentValue


{-|
@priv
-}
unwrapConfig : Config msg -> Models.Config msg
unwrapConfig (PrivateConfig config) =
    config
