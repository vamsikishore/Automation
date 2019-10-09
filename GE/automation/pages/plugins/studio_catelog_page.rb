$:.unshift File.dirname('../pages/common/grid_methods')
class StudioCatalogPage < GridMethods

  include PageObject
  include PageFactory

# Page Objects:
  span                       :install,                                           :title => 'Click here to retrieve plugin'
  span                       :uninstall,                                         :title => 'Click here to uninstall plugin.'
  span                       :growl_success_message,                             :class => 'px-alert-message'
  elements                   :plugin_catalog_grid_values, :tr,               :id=>'gdGridTable_panel_888802'


# Expected elements:
  expected_element(:page_header, $page_load_time)
  expected_title /Studio Catalog | Predix/
  expected_url $platform_url + $app_urls["Studio Catalog"]


# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
  end

end
