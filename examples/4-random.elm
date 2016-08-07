import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Html.Attributes exposing (src, style)
import Random



main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { die1Face : Int
  , die2Face : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1 1, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace (Int, Int)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace ( Random.pair (Random.int 1 6) (Random.int 1 6) ) )

    NewFace (newFace1, newFace2) ->
      (Model newFace1 newFace2, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ div []
        [ img [ src (dicePicture model.die1Face), style [("width", "50px")] ] []
        , img [ src (dicePicture model.die2Face), style [("width", "50px")] ] []
    ] , button [ onClick Roll ] [ text "Roll" ]
    ]

dicePicture value =
  case value of
    1 -> "http://www.wpclipart.com/recreation/games/dice/die_face_1.png"
    2 -> "http://www.wpclipart.com/recreation/games/dice/die_face_2.png"
    3 -> "http://www.wpclipart.com/recreation/games/dice/die_face_3.png"
    4 -> "http://www.wpclipart.com/recreation/games/dice/die_face_4.png"
    5 -> "http://www.wpclipart.com/recreation/games/dice/die_face_5.png"
    6 -> "http://www.wpclipart.com/recreation/games/dice/die_face_6.png"
    _ -> ""
