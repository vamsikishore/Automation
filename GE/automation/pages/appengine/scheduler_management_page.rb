require_relative '../common/grid_methods'

class AppEngine_SchedulerManagement < GridMethods
  include PageObject
  include PageFactory

# Page Objects:
    cell       :pause_scheduler,                                          :xpath => '//*[@title="Pause Scheduler"]'
    cell       :stop_scheduler,                                           :xpath => '//*[@title="Stop Scheduler"]'
    cell       :start_scheduler,                                          :xpath => '//*[@title="Start Scheduler"]'
   elements    :scheduled_jobs_grid_values,        :tr,                   :xpath =>'//*[@id="gdGridTable_panel_823"]'
    elements   :scheduled_groups_grid_values,      :tr,                   :xpath =>'//*[@id="gdGridTable_panel_823"]'
    text_field :schedule_name,                                            :id => 'Name'
    text_field :group,                                                    :id => 'Group1'
    text_field :end_point,                                                :id => 'Action'
    text_field :description,                                              :id => 'Description'
    text_field :execution_count,                                          :id => 'Repeat'
    text_field :execution_interval,                                       :id => 'RepeatInterval'
    text_field :max_errors,                                               :id => 'MaxErrors'
    text_field :scheduled_time,                                           :id => 'ScheduledTime'
    text_field :end_time,                                                 :id => 'JobEndTime'
    text_field :success_action,                                           :id => 'ReplyTo'
    text_field :failure_action,                                           :id => 'FaultTo'
    div        :reload_confirmation_popup,                                :class =>'mdModal'


# Expected Elements:
    expected_element(:pause_scheduler, $page_load_time)
    expected_title /Scheduler Manager | Predix/
    expected_url $platform_url + $app_urls["Scheduler Management"]
    expected_header "Scheduler Manager"

# Methods:
  # Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
    check_page_header?
  end

  #Creates Scheduler job
  def create_scheduler_job record
    file_name = record + ".yml"
    create_record(record, data = {})
    select_start_time_as_current_time
    must_wait $check_data_entered_time, "to check #{record} is populated on Add Scheduled Job"
    save
  end
#Creates Scheduler job with end time
  def create_scheduler_job_with_endtime record
    select_end_time
    create_scheduler_job record
    must_wait $click_time * 10, "to check #{record} populated on the form "
  end
#Selects start time in add Scheduler job pop up
  def select_end_time
    @end_date_time = (Time.now + (1 * 15)).strftime "%Y-%m-%d %H:%M:%S"
    end_time_element.click
    end_time_element.clear
    for i in 1..25
      end_time_element.send_keys("\u0008")
    end
    end_time_element.send_keys @end_date_time
  end

  #Selects start time in add Scheduler job pop up
  def select_start_time_as_current_time
    @start_date_time = (Time.now).strftime "%Y-%m-%d %H:%M:%S"
    $start_date_time = (Time.now).strftime "%Y-%m-%d %H:%M:%S"
    scheduled_time_element.clear
    scheduled_time_element.send_keys @start_date_time
  end

  #Method to check Scheduler job status
  def check_job_status (grid_name, record_name, status)
    must_wait $check_data_entered_time, "to wait until the status is changed"
    return (get_data_grid_records(grid_name).map(&:text).find {|f| f.include?(record_name)}).include?(status)
  end

  #Method to search record in a grid
  def search_record_in_grid(search_data, column_name, grid_name)
    element = (input_text_in_filter grid_name).find {|f| f.scroll_into_view and f.attribute("name").downcase.gsub(" ", "") == column_name.downcase.gsub(" ", "")}
    element.clear
    element.send_keys search_data
    element.click
    element.send_keys :enter
    $log.info("Entered #{search_data} text into #{column_name} search field and hit enter")
    must_wait $click_time, "after hitting enter for searching"
  end

  #fetch records from Schedulers grid
  def get_records_from_schedulers_grid
    return  cell_elements(:xpath=>'//*[@id="1"]/td').map(&:text)
  end

  def enter_value_in_field_scheduler_job_grid value, control_name, control_type
    if control_type.eql?("date/time") && control_name.eql?("START TIME")
      scheduled_time_element.clear
      for i in 1..25
        scheduled_time_element.send_keys("\u0008")
      end
      scheduled_time_element.send_keys value if value.eql?("Test")
      select_start_time_as_current_time if value.eql?("current time")
    elsif control_type.eql?("date/time") && control_name.eql?("END TIME")
      end_time_element.clear
      for i in 1..25
        end_time_element.send_keys("\u0008")
      end
      end_time_element.send_keys value if value.eql?("Test")
      end_time_element.clear if value.eql?("20 seconds more than the current time")
      end_time_element.click if value.eql?("current time")
      else
        enter_value_in_field value, control_name, control_type
    end
    save
    must_wait $click_time + 5 , "after clicking on submit button in the form" if value.eql?("current time")
  end

  def filter_start_date_in_job_execution_date_text_field column_name
    grid_name = "Scheduler Log"
    element = (input_text_in_filter grid_name).find {|f| f.scroll_into_view and f.attribute("name").downcase.gsub(" ", "")  == column_name.downcase.gsub(" ", "") }
    element.clear
    for i in 1..25
      element.send_keys("\u0008")
    end
    element.send_keys $start_date_time
    element.click
    element.send_keys :enter
  end

  def return_start_time
    return @start_date_time

  end
  def return_end_time
    return @end_date_time
  end

def populate_date_in_add_scheduler_job_form_and_click_reload record
  select_start_time_as_current_time
  select_end_time
  file_name = record + ".yml"
  create_record(record, data = {})
  reload
  must_wait $click_time, "to wait after clicking reload button "
  button_elements(:xpath=>"//div[contains(text(),'OK')]")[3].click
  must_wait $click_time, "to wait after clicking ok button "
end
#Method to delete record from the grid
  def delete_record_from_grid(record_name, grid_name)
    element = get_data_grid_records(grid_name).select {|f| f.text.include?(record_name)}[0]
    element.scroll_into_view
    element.click
    button_name = "Delete selected row"
    click_grid_Pager_panel_icons(grid_name, button_name)
    must_wait $click_time, "to wait after  #{button_name} click "
    ok_button_element.click
    must_wait $click_time, "after deleting #{record_name} record from #{grid_name} grid"
  end

# #Method to select the record and perform action
  def select_record_from_grid_and_perform_operation (record_name, grid_name ,button_name)
    element = get_data_grid_records(grid_name).select {|f| f.text.include?(record_name)}[0]
    element.scroll_into_view
    element.click
    click_grid_Pager_panel_icons(grid_name, button_name)
    must_wait $click_time, "to wait after  #{button_name} clicked" if button_name.eql?("Delete selected row")
    ok_button_element.click if button_name.eql?("Delete selected row")
    must_wait $click_time*2, "after deleting #{record_name} record from #{grid_name} grid" if button_name.eql?("Delete selected row")
  end

  def check_field_is_blank pop_up_name
  elements_in_the_form = (text_field_elements(:class=>'text-input').map(&:value))
  elements_in_the_form.delete_at(0)
  return elements_in_the_form.join.empty?
  end

  def create_multiple_jobs (key_name, data = {})
    @record_details = DataMagic.load("AppEngine_Scheduler_CheckMasterSlaveFilter.yml")
    select_start_time_as_current_time
    populate_page_with data_for(:"#{key_name}", data)
    must_wait $check_data_entered_time, "to check #{key_name} is populated on Add Scheduled Job"
    save
  end
def get_log_value grid_name, record_name, value
  must_wait $check_data_entered_time, "to wait until the status is changed"
  return (get_data_grid_records(grid_name).map(&:text).find {|f| f.include?(record_name)}).include?(value)
end

  def check_existing_record_and_delete_record_from_grid(record_name, grid_name)
    delete_record_from_grid(record_name, grid_name) unless get_data_grid_records(grid_name).find {|f| f.text.include?(record_name)}.nil?
  end

end