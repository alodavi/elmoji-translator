module Part5 exposing (Direction(..), Model, Msg(..), defaultKey, init, main, translateText, update, view)

import Browser
import EmojiConverter
import Html
import Html.Attributes
import Html.Events



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type Direction
    = TextToEmoji
    | EmojiToText


type alias Model =
    { currentText : String
    , direction : Direction
    }


init : Model
init =
    { currentText = ""
    , direction = TextToEmoji
    }


defaultKey : String
defaultKey =
    "😳"



-- UPDATE


type Msg
    = SetCurrentText String
    | ToggleDirection


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCurrentText newText ->
            { model | currentText = newText }

        ToggleDirection ->
            case model.direction of
                TextToEmoji ->
                    { model | direction = EmojiToText }

                EmojiToText ->
                    { model | direction = TextToEmoji }



-- VIEW


view : Model -> Html.Html Msg
view model =
    Html.div
        []
        [ Html.node "link"
            [ Html.Attributes.rel "stylesheet"
            , Html.Attributes.href "stylesheets/main.css"
            ]
            []
        , Html.nav
            []
            [ Html.div
                [ Html.Attributes.class "nav-wrapper light-blue lighten-2" ]
                [ Html.div
                    [ Html.Attributes.class "brand-logo center" ]
                    [ Html.text "Elmoji Translator" ]
                ]
            ]
        , Html.section
            [ Html.Attributes.class "container" ]
            [ Html.div
                [ Html.Attributes.class "input-field" ]
                [ Html.input
                    [ Html.Attributes.type_ "text"
                    , Html.Attributes.class "center"
                    , Html.Attributes.placeholder "Let's Translate!"
                    , Html.Events.onInput SetCurrentText
                    ]
                    []
                ]
            , Html.div
                [ Html.Attributes.class "switch center" ]
                [ Html.label
                    []
                    [ Html.text "Translate Text"
                    , Html.input
                        [ Html.Attributes.type_ "checkbox"
                        , Html.Events.onClick ToggleDirection
                        ]
                        []
                    , Html.span
                        [ Html.Attributes.class "lever" ]
                        []
                    , Html.text "Translate Emoji"
                    ]
                ]
            , Html.p
                [ Html.Attributes.class "center output-text emoji-size" ]
                [ Html.text (translateText model) ]
            ]
        ]


translateText : Model -> String
translateText model =
    case model.direction of
        TextToEmoji ->
            EmojiConverter.textToEmoji defaultKey model.currentText

        EmojiToText ->
            EmojiConverter.emojiToText defaultKey model.currentText
