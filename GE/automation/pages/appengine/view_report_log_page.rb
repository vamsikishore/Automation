require_relative '../common/grid_methods'

class AppEngine_LogFiles < GridMethods
  include PageObject

# Expected Elements:
  expected_element(:page_header, $page_load_time)
  expected_title /Manage Logs | Predix/
  expected_url $platform_url + $app_urls["Log Files"]
  expected_header "Manage Logs"


# Methods:
  #Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
    check_page_header?
  end

end