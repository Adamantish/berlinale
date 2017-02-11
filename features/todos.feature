Feature: ToDo Editing
  
Scenario: A traveller opens Bucket List for the first time
  Given Nothing

Scenario: A traveller adds a ToDo item without javascript
  Given There are at least 2 destinations
    And A traveller is on the homepage
  When A traveller selects a destination 
  When A traveller chooses to add a ToDo
    And Enters valid ToDo details
    And Submits the ToDo
  Then The ToDo is added to the list


@javascript
Scenario: A traveller adds a ToDo item
  Given There are at least 2 destinations
    And A traveller is on the homepage
  When A traveller selects a destination 
  When A traveller chooses to add a ToDo
    And Enters valid ToDo details
    And Submits the ToDo
  Then The ToDo is added to the list

@javascript
Scenario: A traveller cancels their edit of a ToDo item
  Given a traveller has a to do in their bucket list
    And a traveller is on the homepage
  When a traveller chooses to edit
  Then a traveller sees edit form
  When a traveller cancels edit
  Then the unedited ToDo is restored


@javascript
Scenario: A traveller cancels their edit of a ToDo item
  Given a traveller has a to do in their bucket list
    And a traveller is on the homepage
  When a traveller chooses to edit
  Then a traveller sees edit form
  When a traveller fills edit form with valid details

@javascript
Scenario: A traveller deletes a todo item
    Given a traveller has a to do in their bucket list
    And a traveller is on the homepage
    When a traveller chooses to delete
    Then they are asked to confirm they'd like to delete
    When they confirm they'd like to delete
    Then the ToDo item is deleted

  


