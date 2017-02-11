
Given(/^A visitor is on the homepage$/) do
  visit root_path
end

When(/^A visitor selects Register$/) do
  click_on "Register"
end

Then(/^A visitor is shown a sign up form$/) do
  expect(page).to have_content "Sign up"
end

When(/^A visitor fills sign up with valid details$/) do
  fill_in :Name, with: "Adam"
  fill_in :Email, with: "blah@blah.com"
  fill_in :Password, with: "password"
  fill_in "Password confirmation", with: "password"

end

When(/^A visitor chooses to sign up$/) do
  click_on "Sign up"
end


Given(/^A traveller exists$/) do
  Traveller.create!(name: "Adam", email: "blah@blah.com", password: "password")
end

When(/^A visitor Logs In as that traveller$/) do
  click_on "Log In"
end

Then(/^They will be shown the Log In Form$/) do
  expect(page).to have_content "Log in"
end

When(/^A visitor fills Log In with valid details$/) do
  fill_in :Email, with: "blah@blah.com"
  fill_in :Password, with: "password"  
end

When(/^A visitor chooses to Log In$/) do
  click_on "Log in"
end

Then(/^They see a flash "(.*?)" "(.*?)"$/) do |flash_type, message|
  expect(page).to have_content message
end