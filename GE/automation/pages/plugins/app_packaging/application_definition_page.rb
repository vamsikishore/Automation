
$:.unshift File.dirname('../pages/common/grid_methods')

class Plugin_ApplicationDefinition< GridMethods
  include PageObject
  include PageFactory

# Page Objects:

# Expected Elements:
  expected_element(:page_header, $page_load_time)
  expected_title /Application Definition | Predix/
  expected_url $platform_url + $app_urls["Application Definition"]
  expected_header "Application Definition"

# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
    check_page_header?
  end
end
