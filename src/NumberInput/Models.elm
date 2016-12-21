module NumberInput.Models exposing (..)


type alias Config msg =
    { inputClass : String
    , inputStyles : List ( String, String )
    , onChange : String -> msg
    , placeholder : Maybe String
    }


newConfig : (String -> msg) -> Config msg
newConfig onChange =
    { inputClass = ""
    , inputStyles = []
    , onChange = onChange
    , placeholder = Nothing
    }
