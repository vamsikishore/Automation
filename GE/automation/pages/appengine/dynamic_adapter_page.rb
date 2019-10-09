require_relative '../common/grid_methods'


class AppEngine_DynamicAdapter < GridMethods
  include PageObject
  include PageFactory
  include DataMagic

# Page Objects:
    textarea           :manage_adapter_configuration_grid_paste_xml_text_area,                               :id=>'rawXmlImpExp'
    button             :import_adapter,                                                                :xpath => '//*[@class="btnGroup pull-right"]/div[1]'
    elements           :manage_adaptor_configuration_grid_values,       :tr,                       :xpath =>'//*[@id="gdGridTable_panel_253"]'
    button             :restore,                                                                       :xpath => '//*[@id="btn_2"]/div'
    button             :import,                                                                        :xpath=>'//*[@class="mdModal-footer"]/div/div'
    button             :run,                                                                           :xpath => '//*[@id="btn_0"]/div'
    button             :manage_adapter_configuration_grid_delete_icon,                                 :xpath => '//*[@id="del_gdGridTable_panel_253"]/div/span'

# Expected Elements:
    expected_element(:restore, $page_load_time)
    expected_title /Dynamic Adapters | Predix/
    expected_url $platform_url + $app_urls["Dynamic Adapters"]
    expected_header "Dynamic Adapters"

# Methods:
   # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
      check_page_header?
    end

end
