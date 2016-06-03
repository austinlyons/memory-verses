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


-- UPDATE
type Msg
  = Attempt String
  | Next
  | Back

update : Msg -> Model -> Model
update msg model =
  let
    len = List.length versesList
    _ = Debug.log "model" model.idx -- write to console.log
  in
    case msg of
      Attempt attempt ->
        { model | attempt = attempt }

      Next ->
        { model | idx = (model.idx + 1) % len }

      Back ->
        { model | idx = (model.idx - 1) % len }


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container-fluid text-center main" ][
    div [ class "row"][
      div [ class "col-md-12" ][
        h1 [][ text "Memory Verses" ],
        textarea [ rows 4, cols 80, placeholder "Type verse here", onInput Attempt ] [],
        viewValidation model,
        button [ onClick Back ] [ text "back" ],
        button [ onClick Next ] [ text "next" ]
      ]
    ]
  ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    txt = getEntryText (Dict.get model.idx verses)
    (cls, message) =
      if model.attempt == txt then
        ("text-success", "Correct!!")
      else if String.contains model.attempt txt then
        ("", "OK so far ...")
      else
        ("text-danger", "Incorrect")
  in
    div [ class cls ] [ text message]

-- view model =
--   div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][    -- inline CSS (literal)
--     div [ class "row" ][
--       div [ class "col-xs-12" ][
--         div [ class "jumbotron" ][
--           img [ src "img/elm.jpg", style styles.img ] []                                    -- inline CSS (via var)
--           , hello model                                                                     -- ext 'hello' component (takes 'model' as arg)
--           , p [] [ text ( "Elm Webpack Starter" ) ]
--           , button [ class "btn btn-primary btn-lg", onClick Increment ] [                  -- click handler
--             span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
--             , span[][ text "FTW!" ]
--           ]
--         ]
--       ]
--     ]
--   ]


-- CSS STYLES
-- styles : { img : List ( String, String ) }
-- styles =
--   {
--     img =
--       [ ( "width", "33%" )
--       , ( "border", "4px solid #337AB7")
--       ]
--   }
