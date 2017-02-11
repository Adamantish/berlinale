Feature: A traveller gets stuff done

Background:
  Given A visitor is on the homepage

Scenario: A visitor registers as a traveller
  When A visitor selects Register
  Then A visitor is shown a sign up form
  When A visitor fills sign up with valid details
    And A visitor chooses to sign up
  Then They see a flash "notice" "You are a bucketter!"

Scenario: A visitor signs in as a traveller
  Given A traveller exists
  When A visitor Logs In as that traveller
  Then They will be shown the Log In Form
  When A visitor fills Log In with valid details
    And A visitor chooses to Log In
  Then They see a flash "notice" "Signed in successfully."

Scenario: A traveller cannot see sign up or log in options if they are signed in

Scenario: A traveller logs out
  Given A traveller is logged in
  When A traveller logs out 

