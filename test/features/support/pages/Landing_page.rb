require 'selenium-webdriver'
require 'page-object'

class LandingPage
  include PageObject
  include PageFactory



  link :start_reading_button, :class => 'button_start'
  elements :menu_items, :link, :xpath => '//header/nav/a'
  link :publishers_link, :xpath=>'//header/nav/a[1]'
  link :brands,          :xpath=>'//header/nav/a[2]'
  link :enterprise,      :xpath=>'//header/nav/a[3]'
  link       :start_read_what_matters_to_you, :text=>'Start reading whats matters to you'
  span       :announcement_image_text,    :xpath=>'/html/body/div[1]/div/div[1]/span'
  elements :header_text, :h1, :xpath => '/html/body/div[1]/div/h1/span'







  def navigate_to_url
    $browser.navigate.to ENV['URL']
  end




end


