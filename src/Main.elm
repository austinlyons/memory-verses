import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick, onInput )
import String
import Verses exposing ( versesList, entryText, entryVerse, entryById )

-- APP
main : Program Never
main =
  Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL
type alias Model = { attempt : String, idx : Int }

model : Model
model =
  Model "" 0

-- UPDATE
type Msg
  = Attempt String
  | Next
  | Back
  | Show

update : Msg -> Model -> Model
update msg model =
  let
    len = List.length versesList
    -- _ = Debug.log "model" model.idx -- write to console.log
  in
    case msg of
      Attempt attempt ->
        { model | attempt = attempt }

      Next ->
        { model |
            idx = (model.idx + 1) % len,
            attempt = "" -- clear textarea
        }

      Back ->
        { model |
            idx = (model.idx - 1) % len,
            attempt = ""
        }

      Show ->
        { model |
            attempt = entryText (entryById model.idx)
        }


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  let
    currentVerse = entryVerse (entryById model.idx)
  in
    div [ class "container-fluid text-center main" ][
      div [ class "row"][
        div [ class "col-md-12" ][
          h1 [][ text "Memory Verses" ],
          h3 [][ text currentVerse ],
          textarea [ rows 4, cols 80, placeholder "Type verse here",  value model.attempt, onInput Attempt ] [],
          viewValidation model,
          div [ class "inputs" ] [
            button [ onClick Back ] [ text "back" ],
            button [ onClick Next ] [ text "next" ],
            a [ onClick Show ] [ text "show" ]
          ]
        ]
      ]
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    actual = String.toLower (entryText (entryById model.idx))
    attempt = String.toLower model.attempt
    (cls, message) =
      if attempt == actual then
        ("status text-success", "Correct!")
      else if String.startsWith attempt actual then
        ("status text-ok", "OK so far ...")
      else
        ("status text-danger", "Incorrect")
  in
    div [ class cls ] [ text message ]
