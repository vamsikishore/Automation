$:.unshift File.dirname('../pages/common/page_methods')
class DeveloperNetWorkPage < PageMethods

  include PageObject
  include PageFactory

# Page Objects:
  link         :sign_in_button,                                :class=>'js-sign-in-link'


# Expected elements:
  expected_element(:sign_in_button, $page_load_time)
  expected_title /Cloud-based Platform-as-a-Service (PaaS) | Predix.io/
  expected_url "https://develop.predix.io/"


# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
  end

end

