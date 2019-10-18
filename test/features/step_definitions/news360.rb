
Then(/^I should be navigated to news360 page$/) do
  landing_page_title = "News360: Your personalized news reader app"
  landing_page_url = "https://news360.com/"
  expect($browser.title.eql?(landing_page_title)).to be_truthy, "landing page title not matching"
  $log.info "landing page title matched"
  expect($browser.current_url.eql?(landing_page_url)).to be_truthy, "url not matching"
  $log.info "landing page url matched"
end

# And(/^I should verify the start reading button in the page$/) do
# expect($browser.find_element(:class=>'button_start')).to be_truthy,"Start reading button not available"
# $log.info "Start reading button available"
# end


# When(/^I click on start reading button$/) do
#   $browser.find_element(:class=>'button_start').click
#   $log.info "Start reading button is clicked"
#   sleep 5
# end

Then(/^I should be navigated to news360 home page$/) do
  home_page_url = "https://news360.com/home"
  expect($browser.current_url.eql?(home_page_url)).to be_truthy, "url not matching"
  $log.info "home page url matched"
end

Then(/^I should fetch the menu values$/) do
  elements = $browser.find_elements(:xpath=>'//header/nav/a')
  puts elements.map(&:text)
end

# And(/^I verify the below menu items:$/) do |table|
#   expected = table.raw.flatten
#   actual = $browser.find_elements(:xpath => '//header/nav/a').map(&:text)
#   for i in 0..table.raw.size - 1
#     expect(actual.include?(expected[i])).to be_truthy, "#{expected[i]}is not available"
#   end
# end


# When(/^I click on (.*)$/) do |menu|
#   $browser.find_elements(:xpath => '//header/nav/a').find{|f|f.text.eql?(menu)}.click
# end

# And(/^I should verify the (.*)$/) do |page_title|
#   expect($browser.title.include?(page_title)).to be_truthy, "landing page title not matching"
# end

Then(/^I should check the (.*)$/) do |url|
  check_url=ENV['URL']+url
  expect($browser.current_url.eql?(check_url)).to be_truthy, "url not matching"
end

