require_relative '../common/grid_methods'

class AppEngine_RegistryManagement < GridMethods
  include PageObject
  include PageFactory

#Registry services form elements

  text_field  :id,                                  :id=>'id'
  text_field  :name,                                :id=>'name'
  text_field  :description,                         :id=>'description'
  text_field  :group,                               :id=>'groupName'
  elements    :registry_services_grid_values, :tr,  :id=>'gdGridTable_panel_834'
  link        :delete_button,                       :id=>'dData'

#Registry locations form elements

  text_field  :service_id,                           :id=>'serviceId'
  text_field  :location_id,                          :id=>'locationId'
  text_field  :description,                          :id=>'description'
  text_field  :group,                                :id=>'groupName'
  text_field  :endpoint,                             :id=>'endpoint'
  elements    :registry_locations_grid_values, :tr,  :id=>'gdGridTable_panel_835'
  button      :save_registry_location,               :id=>'lnk-save'


# Expected Elements:
    expected_element(:page_header, $page_load_time)
    expected_title /Registry Manager | Predix/
    expected_url $platform_url + $app_urls["Registry Management"]
    expected_header "Registry Manager"

# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
      check_page_header?
    end

#Creates Registry record
  def create_registry_record (file_name, key_name, data = {})
    @record_details = DataMagic.load("#{file_name}.yml")
    populate_page_with data_for(:"#{key_name}", data)
    must_wait $check_data_entered_time, "to check #{key_name} is populated on the form"
    button_element(:xpath=>"//button[contains(text(),'Save')]").click
  end

  #update the end point field
  def update_end_point_value value
    for i in 1..14
      endpoint_element.send_keys("\u0008")
    end
    endpoint_element.send_keys(value)
    save_registry_location
  end
#Method to delete record from the grid
  def delete_record_from_grid(record_name, grid_name)
    element = get_data_grid_records(grid_name).select {|f| f.text.include?(record_name)}[0]
    element.scroll_into_view
    element.click
    button_name = "Delete selected Registry Service"
    click_grid_Pager_panel_icons(grid_name, button_name)
    must_wait $click_time, "to wait after  #{button_name} click "
    delete_button
    must_wait $click_time, "after deleting #{record_name} record from #{grid_name} grid"
  end

end

