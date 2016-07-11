module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing (onClick, onInput)
import String
import Verses exposing (versesCount, entryById)


-- APP


main : Program Never
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { attempt : String, idx : Int }


model : Model
model =
    Model "" 0



-- UPDATE


type Msg
    = Attempt String
    | Next
    | Back
    | Show
    | Clear


update : Msg -> Model -> Model
update msg model =
    let
        _ =
            Debug.log "model" model

        -- write to console.log
    in
        case msg of
            Attempt attempt ->
                { model | attempt = attempt }

            Next ->
                { model
                    | idx = (model.idx + 1) % versesCount
                    , attempt =
                        ""
                        -- clear textarea
                }

            Back ->
                { model
                    | idx = (model.idx - 1) % versesCount
                    , attempt = ""
                }

            Show ->
                { model
                    | attempt = .text (entryById model.idx)
                }

            Clear ->
                { model
                    | attempt = ""
                }



-- VIEW


type Status
    = Correct
    | OK
    | Incorrect


attemptStatus : Model -> Status
attemptStatus model =
    let
        entry =
            entryById model.idx

        actual =
            String.toLower entry.text

        attempt =
            String.toLower model.attempt
    in
        if attempt == actual then
            Correct
        else if String.startsWith attempt actual then
            OK
        else
            Incorrect


statusMessage : Status -> Html msg
statusMessage status =
    let
        ( cls, message ) =
            case status of
                Correct ->
                    ( "status text-correct", "Correct!" )

                OK ->
                    ( "status text-ok", "OK so far ..." )

                Incorrect ->
                    ( "status text-incorrect", "Incorrect" )
    in
        div [ class cls ] [ text message ]


inputArea : Status -> String -> Html Msg
inputArea status txt =
    let
        cls =
            case status of
                Correct ->
                    "border-correct"

                OK ->
                    "border-ok"

                Incorrect ->
                    "border-incorrect"
    in
        textarea
            [ rows 4
            , cols 80
            , placeholder "Type verse here"
            , value txt
            , onInput Attempt
            , class cls
            ]
            []


counter : Status -> Model -> Html Msg
counter status model =
    let
        entry =
            entryById model.idx

        attemptLen =
            toString (String.length model.attempt)

        actualLen =
            toString (String.length entry.text)

        txt =
            text (attemptLen ++ "/" ++ actualLen)

        -- twitter style counter
        cls =
            case status of
                Correct ->
                    "counter text-correct"

                OK ->
                    "counter text-ok"

                Incorrect ->
                    "counter text-incorrect"
    in
        div [ class cls ] [ txt ]


view : Model -> Html Msg
view model =
    let
        entry =
            entryById model.idx

        status =
            attemptStatus model
    in
        div [ class "container-fluid text-center main" ]
            [ div [ class "row" ]
                [ div [ class "col-md-12" ]
                    [ h1 [] [ text "Memory Verses" ]
                    , h3 [] [ text (entry.verse ++ " " ++ entry.translation) ]
                    , h5 [ class "gray" ] [ text (String.toUpper entry.category) ]
                    , inputArea status model.attempt
                    , counter status model
                    , statusMessage status
                    , div [ class "inputs" ]
                        [ button [ onClick Back ] [ text "back" ]
                        , button [ onClick Next ] [ text "next" ]
                        , a [ onClick Show ] [ text "show" ]
                        , a [ onClick Clear ] [ text "clear" ]
                        ]
                    ]
                ]
            ]
