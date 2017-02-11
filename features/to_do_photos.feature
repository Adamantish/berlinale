Feature: To Do Photos
  
  @javascript
  Scenario: 
    Given a traveller has a to do in their bucket list
      And A traveller is on the homepage
    When they select the photos link
    Then they should see photos of their to do item
