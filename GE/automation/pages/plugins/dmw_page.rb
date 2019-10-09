$:.unshift File.dirname('../pages/common/grid_methods')
class DataManagementWorkbench < GridMethods

  include PageObject
  include PageFactory

# Page Objects:



# Expected elements:
  expected_element(:page_header, $page_load_time)
  expected_title /Data Management Workbench | Predix/
  expected_url $platform_url + $app_urls["Data Management Workbench"]


# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
  end

end
