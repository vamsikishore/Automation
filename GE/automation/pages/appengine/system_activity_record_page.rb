require_relative '../common/grid_methods'

class AppEngine_SystemActivityRecord < GridMethods
  include PageObject
  include PageFactory

# Expected Elements:
    expected_element(:page_header, $page_load_time)
    expected_url $platform_url + $app_urls["System Activity"]
    expected_title /System Activity | Predix/
    expected_header "System Activity"

# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
      check_page_header?
    end

end