import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Char

main =
  App.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { name : String
  , age: String
  , password : String
  , passwordAgain : String
  , hideErrors: Bool
  }


model : Model
model =
  Model "" "" "" "" True



-- UPDATE


type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | ShowErrors


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | hideErrors = True, name = name }
      
    Age age ->
      { model | hideErrors = True, age = age }

    Password password ->
      { model | hideErrors = True, password = password }

    PasswordAgain password ->
      { model | hideErrors = True, passwordAgain = password }
      
    ShowErrors ->
      { model | hideErrors = False }



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "text", placeholder "Age", onInput Age] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , button [ onClick ShowErrors ] [ text "Submit" ]
    , viewValidation model
    ]


viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if String.all Char.isDigit model.age /= True then
        ("red", "Age must be an integer")
      else if model.password /= model.passwordAgain then
        ("red", "Passwords do not match!")
      else if String.length model.password <= 8 then
        ("red", "Password is too short")
      else if containsAllRequiredCharacters model.password /= True then
        ("red", "The password must contain mixed case with at least one number")
      else
        ("green", "OK")
  in
    div [ style [("color", color), ("visibility", hideErrorsVisibility model.hideErrors)] ] [ text message ]

hideErrorsVisibility hideErrorsValue =
  if hideErrorsValue == True then
    "hidden"
  else
    "visible"

containsAllRequiredCharacters password =
  String.any Char.isDigit password &&
  String.any Char.isUpper password &&
  String.any Char.isLower password
