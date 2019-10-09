$:.unshift File.dirname('../pages/common/page_methods')
class DirectorDebugger < PageMethods

  include PageObject
  include PageFactory

# Page Objects:



# Expected elements:
  expected_element(:page_header, $page_load_time)
  expected_title /XML Template Debugger | Predix/
  expected_url $platform_url + $app_urls["Director Debugger"]


# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
  end

end
