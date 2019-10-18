
Given(/^I hit news360 url$/) do
  on(LandingPage).navigate_to_url
  $log.info "Navigated to news360 page"
end


And(/^I verify the start reading button in the page$/) do
  expect(on_page(LandingPage).start_reading_button?).to be_truthy,"Element not available"
end


# When(/^I click on start reading button$/) do
#   on_page(LandingPage).start_reading_button
# end

And(/^I verify the below menu items:$/) do |table|
  expected = table.raw.flatten
  actual = on(LandingPage).menu_items_elements.map(&:text)
  for i in 0..table.raw.size - 1
    expect(actual.include?(expected[i])).to be_truthy, "#{expected[i]}is not available"
  end
end

When(/^I click on (.*)$/) do |menu|

  case menu
  when 'Publishers'
    on_page(LandingPage).publishers_link
  when 'Brands'
    on_page(LandingPage).brands
  when 'Enterprise'
    on_page(LandingPage).enterprise
  when 'Start reading whats matters to you'
    on_page(LandingPage).start_read_what_matters_to_you
  when 'start reading button'
    on_page(LandingPage).start_reading_button
    sleep 4
  when 'use your email'
    @current_page.use_your_email
  when 'signupnews360'
    sleep 2
    @current_page.sign_up_button
  when 'signup button'
    sleep 2
    @current_page.sign_up
  when 'Avatar_icon'
    sleep 2
    @current_page.avatar
  when'signout_button'
    sleep 2
    @current_page.signout
  when 'start reading button signin'
    sleep 6

    @current_page.start_reading_signin
  when 'signin_button'
    @current_page.signin
  end
end

And(/^I should verify the (.*)$/) do |page_title|
  expect($browser.title.include?(page_title)).to be_truthy, "#{page_title} title not matching"
end

When(/^I click for "([^"]*)" link in the page$/) do |arg|
  binding.pry
end

When(/^I Naviagate and check the page tile and url for the below menus :$/) do |table|
  # table is a table.hashes.keys # => [:Publishers]
  expected = table.raw.flatten
  for i in 0..expected.size-1
    on(LandingPage).menu_items_elements.find{|f| f.text.include?(expected[i])}.click
    $browser.navigate.back
    sleep 2
  end

end

And(/^I should see "([^"]*)"$/) do |text|
  expect(on(LandingPage).announcement_image_text.eql?(text)).to be_truthy,"#{text}text is displayed"
end

Then(/^I should see "([^"]*)" form$/) do |arg|
  expect(@current_page.model_title.eql?(arg)).to be_truthy,"#{arg} not matching"
end

And(/^I verify and click the signin button$/) do
  sleep 5
  expect(on(HomePage).signin_button?).to be_truthy,"button not available"
  sleep 1
  @current_page.signin_button
end

And(/^I enter random email id$/) do
  @email=Faker::Internet.email
  puts @email
  @current_page.email_field = Faker::Internet.email
end

And(/^I enter random password$/) do
  @password1=Faker::Internet.password(min_length = 10)
  puts @password1
  @current_page.password = @password1
end

And(/^I enter email$/) do
  @current_page.email_field =@email
end

And(/^I enter password$/) do
  @current_page.password =@password1
end