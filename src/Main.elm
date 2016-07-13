module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing (onClick, onInput)
import String
import Verses exposing (Entry, entryById)


main : Program Never
main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    { attempt : String, entry : Entry, idx : Int }


model : Model
model =
    Model "" (entryById 0) 0


type Msg
    = Attempt String
    | Next
    | Back
    | Show
    | Clear


update : Msg -> Model -> Model
update msg model =
    let
        -- write to console.log (just for reference on how this works)
        _ =
            Debug.log "model" model
    in
        case msg of
            Attempt attempt ->
                { model | attempt = attempt }

            Next ->
                let
                    i =
                        (model.idx + 1)
                in
                    { model
                        | idx = i
                        , entry = entryById i
                        , attempt = ""
                    }

            Back ->
                let
                    i =
                        (model.idx - 1)
                in
                    { model
                        | idx = i
                        , entry = entryById i
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
            model.entry

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
            model.entry

        attemptLen =
            toString (String.length model.attempt)

        actualLen =
            toString (String.length entry.text)

        -- twitter style counter
        txt =
            text (attemptLen ++ "/" ++ actualLen)

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
            model.entry

        status =
            attemptStatus model
    in
        div [ class "container-fluid text-center main" ]
            [ div [ class "row" ]
                [ div [ class "col-md-12" ]
                    [ h1 [] [ text "Memory Verses" ]
                    , h3 [] [ text (entry.book ++ " " ++ entry.verse ++ " " ++ entry.translation) ]
                    , h5 [ class "gray" ] [ text (String.toUpper entry.category) ]
                    , inputArea status model.attempt
                    , counter status model
                    , statusMessage status
                    , div [ class "inputs" ]
                        [ button [ onClick Back, class "btn btn-primary" ] [ text "back" ]
                        , button [ onClick Next, class "btn btn-primary" ] [ text "next" ]
                        , a [ onClick Show ] [ text "show" ]
                        , a [ onClick Clear ] [ text "clear" ]
                        ]
                    ]
                ]
            ]
