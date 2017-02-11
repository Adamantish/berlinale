Feature: Travellers list

Background:
	Given: A visitor is signed in

@wip
Scenario: A traveller clicks to see a list of other travellers
	When A traveller selects the traveller list
	Then The list of travellers is displayed
	When They click on the first traveller
	Then The ToDos for the selected traveller are displayed
	And The Add Pebble Box is not visible
	And The Edit buttons are not visible
	And The Delete buttons are not visible