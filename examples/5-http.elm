import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task



main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  , error: Bool
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" False
  , getRandomGif topic
  )



-- UPDATE


type Msg
  = MorePlease
  | SetTopic String
  | FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetTopic newTopic ->
      ({model | topic = newTopic}, Cmd.none)    

    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl False, Cmd.none)

    FetchFail _ ->
      (Model model.topic model.gifUrl True, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ selectTopic ["cats", "dogs", "bunnies"]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , img [src model.gifUrl] []
    , errorIfPresent model.error
    ]

errorIfPresent: Bool -> Html Msg
errorIfPresent error =
  if error == True then
    p [] [text "There was an error"]
  else
    text ""

selectTopic: List String -> Html Msg
selectTopic options =
  select [ on "change" (Json.map SetTopic targetValue) ]
    (List.map topicOption options)

topicOption: String -> Html Msg
topicOption title =
  option [value title] [text title]
   

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
