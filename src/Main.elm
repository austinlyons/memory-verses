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
type alias Model = { attempt : String }

model : Model
model =
  Model ""


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
  div []
    [ input [ type' "text", placeholder "Type verse here", onInput Attempt ] []
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if String.contains model.attempt "In the beginning" then
        ("green", "OK")
      else
        ("red", "Nope")
  in
    div [ style [("color", color)] ] [ text message ]

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
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
