Feature: Search Bucketlist

  Background:
    Given a traveller has some to dos in their bucket list
      And a traveller is on the homepage
  
  @javascript
  Scenario: A traveller searches for an existing ToDo item
    Given they start searching for a todo item
    Then I should see all partially matching searches
    When I finish typing out my search
    Then I should see all matching searches

  Scenario: A traveller searches for an existing ToDo Item via HTML
    Given they start searching for a todo item
    When  I submit the search
    Then I should see all matching searches

  @javascript
  Scenario: A traveller searches for something that doesn't exist
    Given they search for something ridiculous
    Then I should see a caveat saying "No Results"


  @javascript
  @wip
  Scenario: A traveller makes search less than 3 characters
    Given they make a 2 character search
    Then The search results container should not be displayed

  @javascript
  Scenario: A traveller deletes their search term
    Given they start searching for a todo item
      And they delete the search
    Then  The search results container should not be displayed
