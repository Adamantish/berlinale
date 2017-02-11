Given(/^Kurt and Previn sadly exist as travellers$/) do
  @kurt = Traveller.create!(name: "Kurt", email: "new@sage.trav.com", password: "LikeTotally")
  @previn = Traveller.create!(name: "Previn", email: "Sweety@sage.trav.com", password: "LikeYahally")
end

Given(/^Previn has logged in$/) do
  visit root_path
  click_on "Log In"
  fill_in :Email, with: "Sweety@sage.trav.com"
  fill_in :Password, with: "LikeYahally"  
  click_on "Log in"
end

Given(/^The ToDo is already liked by "(.*?)"$/) do |traveller|
  case traveller
  when "kurt"
    trav = @kurt
  when "previn"
    trav = @previn
  end

  Like.create!(traveller: trav, to_do: @to_do)
end

Given(/^The ToDo has no likes$/) do
 
end

Then(/^There is "(.*?)" likes$/) do |likes_digits|
  expect(find('.num_of_likes')).to have_content likes_digits
end


When(/^The ToDo is liked by current traveller$/) do
   click_link "Like"
 end

Then(/^the like option is replaced with an unlike option$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^There are no Like buttons visible$/) do
  pending # express the regexp above with the code you wish you had
end