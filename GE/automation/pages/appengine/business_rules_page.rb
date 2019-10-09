require_relative '../common/grid_methods'

class AppEngine_BusinessRules < GridMethods
  include PageObject
  include PageFactory
  include DataMagic

# Page Objects:
    text_field        :category,                                               :class => 'auto-form-category'
    text_field        :name,                                                   :class => 'auto-form-name'
    text_field        :description,                                            :class => 'auto-form-description'
    text_field        :assertion,                                              :class => 'auto-form-assertion'
    select            :scope,                                                  :class => 'auto-form-scope'
    select            :accept_action,                                          :name => 'acceptAction'
    text_area         :accept_value,                                           :xpath => '//*[@id="acceptValueMacro"][contains(@class, "auto-form-acceptValueMacro")]'
    select            :status,                                                 :class => 'auto-form-status'
    select            :scope,                                                  :class => 'auto-form-scope'
    link              :submit_button,                                          :xpath => '//*[@id="lnk-submit"][contains(@class, "auto-action")]'
    elements          :rules_configuration_grid_values,       :tr,             :xpath =>'//*[@id="gdGridTable_panel_72"]'
    div               :rules_configuration_grid,                               :id=>'72'
    link                :delete_popup,                                         :id=>'dData'

# Expected Elements:
    expected_element(:page_header, $page_load_time)
    expected_title /Business Rules Manager | Predix/
    expected_url $platform_url + $app_urls["Business Rules"]
    expected_header "Business Rules Manager"

# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
      check_page_header?
    end

  def create_new_macro_business_rule (file_name, data = {})
     create_record(file_name, data = {})
     $browser.execute_script("document.getElementsByClassName('auto-form-acceptValueMacro')[0].setAttribute('style', 'display: block')")
     accept_value_element.send_keys @record_details[file_name]['macro_date']
     must_wait $check_data_entered_time, "to check #{file_name} is populated on Add Rule"
     submit_button
  end



  def delete_business_rule grid_name
    select_first_record_from_grouped_records grid_name
    click_on_left_pager_icons grid_name, "Delete selected Rule", "left"
    must_wait $click_time, "after clicking on delete button from #{grid_name} grid "
     delete_popup
  end

end
