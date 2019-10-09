
$:.unshift File.dirname('../pages/common/grid_methods')

class Plugin_ApplicationManagement < GridMethods
include PageObject
include PageFactory

# Page Objects:
     span                       :install,                                           :title => 'Install Application'
     span                       :uninstall_app,                                         :title => 'Uninstall Application'
     span                       :growl_success_message,                             :class => 'px-alert-message'
     elements                   :application_manager_grid_values,       :tr,        :xpath =>'//*[@id="gdGridTable_panel_30202"]'
     text_field                 :hidden_field,                                      :class => 'dz-hidden-input'
     button                     :delete,                                            :id => 'dData'

# Expected Elements:
      expected_element(:page_header, $page_load_time)
      expected_title /Application Management | Predix/
      expected_url $platform_url + $app_urls["Application Management"]
      expected_header "Application Management"

# Methods:
      # Initial page validation
      def initialize_page
        has_expected_element?
        has_expected_title?
        has_expected_url?
        check_page_header?
      end

end
