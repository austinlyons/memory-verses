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
  Model "" 0

-- verses to memorize
type alias Entry = { verse : String, text : String, translation : String }
versesList =
  [ (0, Entry "Romans 3:23" "For all have sinned and fall short of the glory of God" "ESV" )
  , (1, Entry "Romans 6:23" "for the wages of sin is death, but the free gift of God is eternal life in Christ Jesus our Lord" "ESV" )
  , (2, Entry "Romans 5:8" "but God shows his love for us in that while we were still sinners, Christ died for us" "ESV")
  , (3, Entry "Romans 10:9" "if you confess with your mouth that Jesus is Lord and believe in your heart that God raised him from the dead, you will be saved" "ESV")
  , (4, Entry "Romans 8:1" "There is therefore now no condemnation for those who are in Christ Jesus" "ESV")
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
            attempt = getEntryText (Dict.get model.idx verses)
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
    actual = String.toLower (getEntryText (Dict.get model.idx verses))
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
