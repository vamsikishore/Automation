require_relative '../../pages/common/page_methods'


class WelcomePage < PageMethods
  include PageObject
  include PageFactory

# Page Objects:
    h1        :welcome_page_text,            :class => 'global-respond'
    span      :index_login_user_name,        :xpath => '//*[@id="row"]/span'
    div       :index_page_account_tab,       :class => 'account'
    button    :index_page_logout_button,     :id => 'logoutBtn'

# Expected Elements:
    expected_title /Home | Predix/
    expected_element(:welcome_page_text, $page_load_time)
    expected_url $platform_url + $app_urls["Welcome"]

# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
    end

end
