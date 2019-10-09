$:.unshift File.dirname('../pages/common/grid_methods')
class DataDictionary < GridMethods

  include PageObject
  include PageFactory

# Page Objects:

# Expected elements:
  expected_element(:page_header, $page_load_time)
  expected_title /Data Dictionary Manager | Predix/
  expected_url $platform_url + $app_urls["Data Dictionary"]


# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
  end

  def click_sync_caninical_model(button_name)
    span_element(:xpath=>"//span[contains(text(),'Sync Canonical Model')]").click
    must_wait $click_time/2, "to wait after  #{button_name} click "
    ok_button_element.click
    must_wait $click_time*2, "to wait after clicking ok button  "
  end

end
