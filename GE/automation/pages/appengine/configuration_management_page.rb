require_relative '../common/grid_methods'

class AppEngine_ConfigurationManagement < GridMethods
  include PageObject
  include PageFactory

# Page Objects:
  text_field      :record_value,                :id => 'value'
  div             :popup_title,                 :class => 'ui-jqdialog-title'
  text_field      :category,                    :id => 'category'
  text_field      :group,                       :id => 'group'
  text_field      :type,                        :id => 'type'
  text_field      :name,                        :id => 'name'
  text_field      :description,                 :id => 'description'
  elements        :manage_configuration_grid_values, :tr,  :xpath=>'//*[@id="259"]'

# Expected Elements:
    expected_element(:page_header, $page_load_time)
    expected_title /Configuration Management | Predix/
    expected_url $platform_url + $app_urls["Configuration Manager"]
    expected_header "Configuration Management"

# Methods:
  # Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
    check_page_header?
  end


end
