import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick, onInput )
import String
import Dict
import Maybe

-- APP
main : Program Never
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = { attempt : String, idx : Int }

model : Model
model =
  Model "" 1

-- verses to memorize
type alias Entry = { verse : String, text : String, translation : String }
versesList =
  [ (0, Entry "Romans 3:23" "For all have sinned and fall short of the glory of God" "ESV" )
  , (1, Entry "Romans 6:23" "For the wages of sin is death, but the free gift of God is eternal life in Christ Jesus our Lord" "ESV" )
  ]

-- look up table (integer indexed dictionary)
verses = Dict.fromList(versesList)

getEntryText :  Maybe Entry -> String
getEntryText entry =
  case entry of
    Just entry -> entry.text
    Nothing -> ""

getEntryVerse :  Maybe Entry -> String
getEntryVerse entry =
  case entry of
    Just entry -> entry.verse
    Nothing -> ""

-- UPDATE
type Msg
  = Attempt String
  | Next
  | Back

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

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  let
    currentVerse = getEntryVerse (Dict.get model.idx verses)
  in
    div [ class "container-fluid text-center main" ][
      div [ class "row"][
        div [ class "col-md-12" ][
          h1 [][ text "Memory Verses" ],
          h3 [][ text currentVerse ],
          textarea [ rows 4, cols 80, placeholder "Type verse here",  value model.attempt, onInput Attempt ] [],
          viewValidation model,
          div [] [
            button [ onClick Back ] [ text "back" ],
            button [ onClick Next ] [ text "next" ]
          ]
        ]
      ]
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    actual = String.toLower (getEntryText (Dict.get model.idx verses))
    attempt = String.toLower model.attempt
    (cls, message) =
      if attempt == actual then
        ("status text-success", "Correct!!")
      else if String.startsWith attempt actual then
        ("status text-ok", "OK so far ...")
      else
        ("status text-danger", "Incorrect")
  in
    div [ class cls ] [ text message ]
