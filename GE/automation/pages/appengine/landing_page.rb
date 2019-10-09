require_relative '../../pages/common/page_methods'

class LandingPage < PageMethods
  include PageObject
  include PageFactory

# Page Objects:
    div                    :landing_page_logo,                   :id => 'logo-header'
    button                 :open_application,                    :class=>'enterStudio'

# Expected Elements:
  expected_element(:open_application, $page_load_time)
  expected_title /Predix Login/
  expected_element(:open_application, 10)
  expected_url $platform_url + "/landing?landing_uri=https%3A%2F%2F#{$host_server}%2Fdirector%2F"

# Methods:
# Initial page validation
  def initialize_page
    open_page
    has_expected_title?
    has_expected_element?
    has_expected_url?
  end

end
