Given(/^a traveller is on the homepage$/) do
  visit root_path
end

When(/^the page is reloaded$/) do
  visit current_path
end

Given(/^A traveller is logged in$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^A traveller logs out$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^Nothing$/) do
  pending # express the regexp above with the code you wish you had
end
