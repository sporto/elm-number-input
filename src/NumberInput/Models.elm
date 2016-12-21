module NumberInput.Models exposing (..)


type alias Config msg =
    { inputClass : String
    , inputStyles : List ( String, String )
    , onChange : Float -> msg
    , placeholder : Maybe String
    }


newConfig : (Float -> msg) -> Config msg
newConfig onChange =
    { inputClass = ""
    , inputStyles = []
    , onChange = onChange
    , placeholder = Nothing
    }



-- type alias State =
--     { id : String
--     }
-- initialState : String -> State
-- initialState id =
--     { id = id
--     }
