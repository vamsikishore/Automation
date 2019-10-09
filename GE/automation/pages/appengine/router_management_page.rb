require_relative '../common/grid_methods'

class AppEngine_RouterManagement < GridMethods
  include PageObject
  include PageFactory

# Page Objects:
    cell :pause_router, :xpath => '//*[@title="Pause Router"]'
    cell :stop_router,  :xpath => '//*[@title="Stop Router"]'
    cell :start_router, :xpath => '//*[@title="Start Router"]'

# Expected Elements:
    expected_element(:page_header, $page_load_time)
    expected_title /Router Manager | Predix/
    expected_url $platform_url + $app_urls["Router Management"]
    expected_header "Router Manager"

# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
      check_page_header?
    end


end
