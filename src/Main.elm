import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick, onInput )
import String

-- APP
main : Program Never
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = { attempt : String, verse : String }

model : Model
model =
  Model "" "In the beginning"


-- UPDATE
type Msg
  = Attempt String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Attempt attempt ->
      { model | attempt = attempt }


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
        viewValidation model
      ]
    ]
  ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    (cls, message) =
      if model.attempt == model.verse then
        ("text-success", "Correct!!")
      else if String.contains model.attempt model.verse then
        ("", "OK so far ...")
      else
        ("text-danger", "Incorrect")
  in
    div [ class cls ] [ text message ]

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
