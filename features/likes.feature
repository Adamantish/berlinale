
Feature: Likings
  
  Background:
    Given Kurt and Previn sadly exist as travellers

  Scenario: A visitor cannot click like button
    Given a traveller has a to do in their bucket list
    Then   There are no Like buttons visible

  @javascript
  Scenario: A traveller likes a ToDo which isn't already liked
    Given Previn has logged in
      And a traveller has a to do in their bucket list
      And A traveller is on the homepage
      And The ToDo has no likes
    Then There is "" likes
    
    When The ToDo is liked by current traveller
    Then There is "1" likes
      And the like option is replaced with an unlike option
    When the page is reloaded
    Then There is "1" likes

  @javascript
  Scenario: A traveller likes a ToDo which already has been liked
    Given Previn has logged in
      And a traveller has a to do in their bucket list
      And A traveller is on the homepage
    Given The ToDo is already liked by "kurt"
     When The ToDo is liked by current traveller
    Then There is "2" likes
      And the like option is replaced with an unlike option
    When the page is reloaded
    Then There is "2" likes
