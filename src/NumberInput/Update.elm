module NumberInput.Update exposing (..)

import Task
import NumberInput.Messages exposing (..)
import NumberInput.Models exposing (..)


foo =
    1



-- update : Config msg -> Msg -> State -> ( State, Cmd msg )
-- update config msg model =
--     case msg of
--         OnChange str ->
--             let
--                 cmd =
--                     2
--                         |> Task.succeed
--                         |> Task.perform config.onChange
--             in
--                 ( model, cmd )
