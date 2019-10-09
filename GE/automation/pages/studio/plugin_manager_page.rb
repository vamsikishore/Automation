$:.unshift File.dirname('../pages/common/grid_methods')
class PluginManagerPage < GridMethods

  include PageObject
  include PageFactory

# Page Objects:

  span                       :import_all_from_disk,                               :xpath=>'//*[@id="btn_0"]/div/span[2]'
  elements                   :manage_plugins_grid_values, :tr,               :id=>'gdGridTable_panel_74'
# Expected elements:
  expected_element(:page_header, $page_load_time)
  expected_title /Plugins Manager | Predix/
  expected_url $platform_url + $app_urls["Plugins Manager"]


# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
  end

end
