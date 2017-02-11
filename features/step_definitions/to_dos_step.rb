

Given(/^a traveller has a to do in their bucket list$/) do
  @destination = Destination.create!(name: "India")
  ToDo.create!(description: "Ride Elephant", address: "Delhi", destination: @destination)
end


Given(/^a traveller has some to dos in their bucket list$/) do
  @destination = Destination.create!(name: "India")
  ToDo.create!(description: "Ride Elephant", address: "Delhi", destination: @destination)

  @uk = Destination.create!(name: "UK")
  ToDo.create!(description: "Ride in an aircraft", address: "Torquay", destination: @uk)
 
end

Given(/^There are at least (\d+) destinations$/) do |arg1|
  Destination.create!(name: "India")
  Destination.create!(name: "Finland")

end

Given(/^A traveller is on the homepage$/) do
  visit root_path
end

Given(/^A traveller chooses to add a ToDo$/) do
  click 'btn__new_to_do'
end

When(/^A traveller selects a destination$/) do
  select "India", from: "to_do[destination_id]"
end

When(/^Enters valid ToDo details$/) do
  fill_in "to_do[description]", with: "Get Spiritual"
  fill_in "to_do[address]", with: "Delhi"
end

When(/^Submits the ToDo$/) do
  click_on "btn__add-to_do"
  save_and_open_page
end

Then(/^The ToDo is added to the list$/) do
  sleep 1
  expect(page).to have_content "Get Spiritual"
  expect(page).to have_content "Delhi"
end

When(/^a traveller chooses to edit$/) do
  click_link "for-test-edit-link"
end

Then(/^a traveller sees edit form$/) do
  within('#to_dos') do 
    expect(page).to have_content("Bucket It")
  end
end

When(/^a traveller cancels edit$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the unedited ToDo is restored$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^a traveller fills edit form with valid details$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^a traveller chooses to delete$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^they are asked to confirm they'd like to delete$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^they confirm they'd like to delete$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the ToDo item is deleted$/) do
  pending # express the regexp above with the code you wish you had
end
