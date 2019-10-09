Given(/^I log into (.*) application with (.*) credentials$/) do |application, role_type|

  # Acceptable inputs for role_type =  admin, power, user, developer, env_owner

  if $environment == "STUDIO"
    steps %Q{
    Given I navigate to AppEngine/Studio/Portal/AppExt url
    Then I should be displayed with the "Studio_landing" page
    When I click "Open Application" button
    Then I should be displayed with the "Predix Studio Login" page
    When I enter #{role_type} credentials on "Predix Studio Login" page
    Then I should be displayed with the "Welcome" page
      }
  elsif $environment == "APPENGINE"
    steps %Q{
   Given I navigate to AppEngine/Studio/Portal/AppExt url
    Then I should be displayed with the "Predix_landing" page
    When I click "Open Application" button
    Then I should be displayed with the "Predix_login" page
    When I enter #{role_type} credentials on "Predix_Login" page
    And I click on authorization button on authorization popup
    Then I should be displayed with the "Welcome" page
      }
  elsif $environment == "PORTAL"
    steps %Q{
    Given I navigate to AppEngine/Studio/Portal/AppExt url
    Then I should be displayed with the "Portal_landing" page
    When I click "Open Application" button
    Then I should be displayed with the "Predix_Portal_Login" page
    When I enter #{role_type} credentials on "Predix_Portal_Login" page
    Then I should be displayed with the "Welcome" page
      }
  else
    raise('Invalid environment')
  end
end

When(/^I must wait for (.*) seconds$/) do |time_in_seconds|
  must_wait time_in_seconds.to_i, ""
end

#-----------------------------------------------------------------------------------------------------------------------
# PAGE LOAD & PAGE VALIDATION (RENDERING)
#-----------------------------------------------------------------------------------------------------------------------

Given(/^I navigate to (.*) url$/) do |application|
  on(LandingPage)
end

And(/^I navigate to "([^"]*)" page$/) do |pagename|
  @current_page.navigate_to_page pagename
  $log.info "Navigated to #{pagename} URL"
  on($class_names[pagename])
  must_wait $page_load_time * 2, "for the #{pagename} to load"

end

And(/^I refresh the page$/) do
  $browser.navigate.refresh
  must_wait $page_load_time, "for the page to refresh"
end

Then(/^I should be displayed with the "([^"]*)" ([^"]*)$/) do |name, type|
  must_wait $page_load_time, "before #{name} #{type} is loaded"
  case type
    when 'page'
      case name
        when 'Predix_landing','Studio_landing','Portal_landing'
          on(LandingPage) do |page|
            $log.info("Predix landing page displayed")
            expect(page.open_application?).to be_truthy, "Open Application button not found"
            $log.info("Open Application button validated")
            expect(page.title).to eq("Predix Login"), "Page title doesn't match with 'Predix Login'"
            $log.info("Page Title matches 'Predix Login'")
            host_name = $platform_url.split("/director").first
            host_server = host_name.split("https://").last
            redirection_url = host_name+"/director/landing?landing_uri=https%3A%2F%2F#{host_server}%2Fdirector%2F"
            expect(page.current_url).to include(redirection_url), "Invalid landing page URL"
            $log.info("Predix landing page URL validated")
           end
        when 'Predix_login'
          on(AppEngine_LoginPage) do |page|
            $log.info("Predix Login page displayed")
            # Steps commented out due to AppExtensibility
            #expect(page.forgot_password?).to be_truthy, "Navigated to wrong page"
            #expect(page.title).to eq("Predix"), "Page title is not matching on login page"
            #redirection_url = $platform_url.split("/director").first+":8543/login"
            #page.current_url == (redirection_url) ? $log.info("Successfully navigated to login page") : raise("Navigated to wrong page")
            $log.info("Predix Login page NOT validated")
          end
        when 'Open Application'
            if $environment == "APPENGINE"
              steps %Q{
                    Then I should be displayed with the "Predix_landing" page
                    }
            elsif $environment == "PORTAL"
              steps %Q{
                    Then I should be displayed with the "Developer_landing" page
                    }
            else
              raise('Invalid environment')
            end
          else
          on($class_names[name])
          $log.info("#{name}is displayed")
          $log.info("Validated expected element in  #{name} page")
          $log.info("Validated expected url in  #{name} page")
          $log.info("Validated expected title in  #{name} page")

      end
    when 'popup'
      case name
         when 'Import XML'
          element = @current_page.div_elements(:class => 'mdDialog').find { |f| f.attribute('class').include?("open") }
          expect(element.div_element(:class => 'mdDialog-body').text.downcase).to include("paste xml here or drag and drop an xml file:".downcase), "Popup subtitle doesn't match with 'paste xml here or drag and drop an xml file'"
          $log.info("Popup subtitle matches with 'paste xml here or drag and drop an xml file'")
          @browser.execute_script("document.getElementById('rawXmlImpExp').style.display='block';")
          expect(@current_page.manage_adapter_configuration_grid_paste_xml_text_area?).to be_truthy, "Copy/Paste on popup text area not enabled"
          $log.info("Copy/Paste on popup text area enabled")
         when 'Add Record'
          expect(@current_page.popup_title_element.text).to eq("Add Record"), "#{name} #{type} not displayed"
          $log.info("#{name} #{type} displayed")
        when 'Delete Adapter Config'

        else
          element = @current_page.div_elements(:class => 'ui-dialog').reject{ |f| f.attribute('style').include?("display: none;") }
          expect(element[0].span_element(:class => 'ui-dialog-title').text.downcase).to eq(name.downcase), "Popup title doesn't match #{name}"
          $log.info("Popup title matches #{name}")
      end
  when 'ribbon'
    expect(@current_page.check_ribbon_in_workbench (name)).to be_truthy,"#{name} not available in the workbench"
    $log.info("#{name} ribbon displayed")
    when 'grid'
        @grid_name = name
        expect(@current_page.list_of_grids_in_page).to include(name)
      $log.info("#{name} grid displayed")
    when 'panel'
      case name
      when 'Data Integration Projects','Project Selection','Application Definition Projects'
        expect(@current_page.check_panel_title(name)).to be_truthy,"#{name} title is not displayed"
        when 'New Item'
          expect(@current_page.new_item_header.downcase).to eq(name.downcase)
        when 'Content'
          expect(@current_page.package_details.downcase).to include(name.downcase.gsub(' ', '_'))
      end
      $log.info("#{name} panel displayed")
    else
      raise('Invalid type (page/popup/panel/grid)')
  end
end


#-----------------------------------------------------------------------------------------------------------------------
# ACTION STEPS
#-----------------------------------------------------------------------------------------------------------------------

When(/^I click "([^"]*)" (link|button|div|checkbox|icon)(?: on the (.*) page)?$/) do |control_name, control_type, page_name|
  begin
    page_name == nil ? page = @current_page : page = on(create_page_class page_name)
    control_name = control_name.strip.downcase.gsub(' ', '_')
    page.public_send("#{control_name}_element").hover if page.public_send("#{control_name}_element").visible?
    must_wait $click_time / 2, "for the mouse to hove over the #{control_name} #{control_type}"
    page.public_send("#{control_name}_element").click if page.public_send("#{control_name}_element").visible?
    $log.info "Clicked on #{control_name} button on the #{page_name} page"
    must_wait $click_time, "after clicking #{control_name} #{control_type}"
    case control_name
    when 'install'
      if @current_page.div_element(:class=>'mdDialog').exists?
        if @grid_name ="Plugin Catalog"
          steps %Q{
            And I click "OK" button on the popup
            And I click "Cancel" button on the popup
            }
        else
        steps %Q{
            And I click "Yes" button on the popup
            }
        end
      end
    when 'uninstall'
      steps %Q{
            And I click "OK" button on the popup
            }
    when 'import_all_from_disk'
      steps %Q{
            And I click "Ok" button on the popup
            }
    end
  rescue => exception
    raise
  end
end


And(/^I click "([^"]*)" section$/) do |button_name|
  case button_name
    when 'Add Indicator'
      $browser.execute_script("return document.querySelector('.addIndicatorFormOpen ').querySelector('px-accordion').root.querySelector('.accordion__container').querySelector('#header').querySelector('#headerValue').click()")
      $log.info("Clicked on #{button_name} section")
    else
      @current_page.span_elements(:xpath => '//px-accordion/section/div/div[1]/span').find {|f| f.text.downcase == button_name.downcase }.click
      $log.info("Clicked on #{button_name} section")
  end
end

And(/^I click "([^"]*)" settings$/) do |menu_item|
  case menu_item
  when 'AppEngine BAT MM Item', 'AppEngine BAT MM Top', 'AppEngine BAT MM Cat'
    must_wait $click_time, "before clicking #{menu_item} setting"
      @current_page.select_edit_button menu_item
    else
      raise  ("#{menu_item} setting not found in #{@current_page} page")
  end
  $log.info("Clicked on #{menu_item} setting")
  must_wait $click_time, "after clicking #{menu_item} setting"
end

And(/^I click "([^"]*)" button on the popup$/) do |button|
  begin
    @current_page.div_elements(:class => 'btn').find{|f|f.text==button}.click
  rescue
    element = @current_page.div_elements(:class => 'ui-widget').find { |f| f.attribute('style').include?("display: block;") }
    element.link_elements(:class => 'ui-state-default').find { |f| f.text == button }.click
  end
  $log.info("Clicked on #{button} button on the popup")
  must_wait $click_time, "after clicking #{button} on the popup "
end

When(/^I click on log out under user profile$/) do
  expect(@current_page.index_page_account_tab?).to be_truthy, "User Profile badge not displayed on the page"
  @current_page.index_page_account_tab_element.click
  expect(@current_page.index_page_logout_button?).to be_truthy, "No Logout button on the page"
  @current_page.index_page_logout_button
  $log.info "Clicked Logout from the application"
end

When(/^I click on authorization button on authorization popup$/) do
  unless @current_page.application_authorization?
    $log.info("Application authorization not needed")
  else
    must_wait $page_load_time, "before authorization page is loaded"
    $log.info("Authorization page displayed")
    expect(@current_page.application_authorization).to eq("Application Authorization"), "Page title doesn't match with 'Application Authorization'"
    $log.info("Page Title matches 'Application Authorization'")
    env_url = $platform_url.split("/director").first
    url = env_url.split("https://").last
    redirection_url = env_url+":8543/oauth/authorize?"
    expect(@current_page).current_url.to include(redirection_url), "Invalid Application Authorization page URL"
    $log.info("Authorization page URL validated")
    @current_page.authorize_button
    $log.info("Clicked on authorize button")
  end
end

When(/^I enter "([^"]*)" in the "([^"]*)" field of "([^"]*)"$/) do |value, field, element|
  case element
    when 'Search Conditions panel'
      case field
        when 'indices'
          htmlelement="indexer_search_indices_textbox_element"
        when 'types'
          htmlelement="indexer_search_types_textbox_element"
        else
          raise  ("#{field} field not found in #{element}")
      end
   when 'Add Record'
     case field
      when 'Category'
         htmlelement="category_element"
      when 'Type'
         htmlelement="type_element"
      when 'Name'
        htmlelement="name_element"
    end
    when 'Edit Record'
      case field
        when 'Value'
          htmlelement="record_value_element"
        else
          raise  ("#{field} field not found in #{element}")
      end
    else
      raise  ("#{element} not found in #{@current_page} page")
  end
  @current_page.send( htmlelement).clear
  @current_page.send( htmlelement).value=value
  $log.info "Entered #{value}  in the #{field} field"
  must_wait $check_data_entered_time, "to check #{value} entered in the #{field} field"
end


When(/^I enter (.*) credentials on "([^"]*)" page$/) do |role_name, page_name|
  username_input = get_role_credentials(role_name, "username")
  password_input = get_role_credentials(role_name, "password")
  case page_name
    when 'Predix_Login'
        @current_page.user_name = username_input
        @current_page.password = password_input
        $log.info "Entered credentials and clicked Sign In"
        must_wait $check_data_entered_time, "to check credentials on #{page_name} page"
        @current_page.login
     else
        @user_name = @current_page.predix_studio_email_text_element.send_keys(username_input)
        $log.info "Entered email and clicked Next"
        must_wait $check_data_entered_time, "to check credentials on #{page_name} page"
        @current_page.predix_studio_next_or_login_button
        must_wait $page_load_time, "before #{page_name} page is loaded"
        $log.info "Single Sign On page displayed"
        $log.info "Single Sign On page NOT validated"
        steps %Q{
          And I enter #{role_name} credentials on Single Sign On page
        }
  end
end

And(/^I enter (.*) credentials on Single Sign On page$/) do |role_name|
  sso_id_input = get_role_credentials(role_name, "sso_id")
  password_input = get_role_credentials(role_name, "password")
  @current_page.ge_user_name = sso_id_input
  @current_page.ge_passowrd  = password_input
  $log.info("Entered SSO #{sso_id_input} credentials and clicked Log In")
  must_wait $check_data_entered_time, "to check credentials on Single Sign On page"
  @current_page.ge_login_button
end

When(/^I enter invalid credentials I see an error message$/) do |table|
  table_data = table.raw
  for i in 0...table_data.size
    @current_page.user_name = table_data[i][0]
    @current_page.password = table_data[i][1]
    $log.info "Entered invalid credentials and clicked Sign In"
    must_wait $check_data_entered_time, "to check invalid credentials on AppEngine login page"
    @current_page.login
    expect(@browser.current_url).to include("login?error=login_failure"), "Invalid login page URL"
    $log.info("AppEngine login page URL validated")
    expect(@current_page.login_invalid_message).to eq(table_data[i][2]), "Invalid login message not correct"
    $log.info("Invalid login message validated")
  end
end

When(/^I enter the "([^"]*)" adapter definition in the text area$/) do |payload_name|
  @current_page.manage_adapter_configuration_grid_paste_xml_text_area_element.clear
  definition= File.read("./test_data/#{payload_name}.xml")
  $log.info("Read data from ./test_data/#{payload_name}.xml")
  puts "<xmp>" + definition + "</xmp>"
  @browser.execute_script("var t = document.getElementById('rawXmlImpExp'); "+"t.value = arguments[0];",definition)
  $log.info("Entered #{payload_name} definition in the text area")
  must_wait $check_data_entered_time, "to check #{payload_name} definition pasted in the text area"
end

When(/^I enter \{"([^"]*)":\{ "([^"]*)":"([^"]*)"\}\} into query definition$/) do |arg1, arg2, arg3|
  $browser.execute_script("$('#queryInput').val('{\"#{arg1}\": { \"#{arg2}\": \"#{arg3}\" } }')")
  $log.info("Entered search criteria")
  must_wait $check_data_entered_time, "to ckeck the search criteria"
end

And(/^I update the (.*) with "([^"]*)" data and save$/) do |field_name, value|
  @current_page.update_end_point_value value
  $log.info("#{value} is updated in #{field_name} field ")
end

When(/^I drag and drop "([^"]*)" file to the (.*)$/) do |file_name, type|
  if File.file?(Dir.pwd+"/test_data/#{file_name}")
    file_path = Dir.pwd+"/test_data/#{file_name}"
  else
    raise("File #{file_name} not available at ./test_data/ folder")
  end
  @current_page.hidden_field_element.send_keys file_path
  puts 'https://bitbucket.org/bitstew/bsqa/src/54906b0533fb727dbedee4949596a060e6cf5d9c/cucumber/automation/test_data/AppEngine_BAT_AM.gz'
  $log.info("File #{file_name} uploaded into the #{type}")
  must_wait $click_time * 2, "for the #{file_name} file to be uploaded into the #{type}"
end

When(/^I populate the (.*) with "([^"]*)" data and save$/) do |type, data|
  case data
  when 'AppEngine_BAT_BR'
    @current_page.create_new_macro_business_rule(data, data = {})
    must_wait $click_time, "after clicking insert/save on #{type}"
    puts DataMagic.yml
  when 'AppEngine_BAT_MM_Category', 'AppEngine_BAT_MM_Topic', 'AppEngine_BAT_MM_Item'
    @current_page.create_new_menu_manager_item(data, data = {})
    puts DataMagic.yml
  when 'AppEngine_Scheduler_RegistryServices_Record01','AppEngine_Scheduler_RegistryLocations_Record01','AppEngine_RegistryLocations_Record02'
    filename ="AppEngine_Scheduler_ClearCacheCheck"
    @current_page.create_registry_record(filename, data, data = {})
    puts DataMagic.yml
  when 'AppEngine_Scheduler_CreateJob', 'AppEngine_Scheduler_SuccessJobWithEndtime', 'AppEngine_Scheduler_CreateFailJobWithEndtime', 'AppEngine_Scheduler_CheckGroupOperations','AppEngine_Scheduler_CreateFailJobWithMaxErrors','AppEngine_Scheduler_CheckMasterSlaveFilter1','AppEngine_Scheduler_JobOperations','AppEngine_Scheduler_CheckMasterSlaveFilter2','AppEngine_Scheduler_SuccessExecCount','AppEngine_Scheduler_FailedExecCount','AppEngine_Scheduler_ClearCacheCheck'
    if data.eql?('AppEngine_Scheduler_CreateJob')||data.eql?('AppEngine_Scheduler_CreateFailJobWithMaxErrors') ||data.eql?('AppEngine_Scheduler_JobOperations') ||data.eql?('AppEngine_Scheduler_SuccessExecCount')||data.eql?('AppEngine_Scheduler_FailedExecCount')||data.eql?('AppEngine_Scheduler_ClearCacheCheck')
    must_wait $click_time * 2, "after clicking insert/save on #{type}"
       @current_page.create_scheduler_job data
      puts  "{Start time => #{@current_page.return_start_time}}"
    elsif data.eql?('AppEngine_Scheduler_CheckMasterSlaveFilter1')||data.eql?('AppEngine_Scheduler_CheckMasterSlaveFilter2')
      @current_page.create_multiple_jobs data
    else
      @current_page.create_scheduler_job_with_endtime data
      puts  "{Start time => #{@current_page.return_start_time},End time => #{@current_page.return_end_time}}"
    end
    puts DataMagic.yml
      when 'AppEngine_Configuration_CreateRecord'
    file_name = data
    @current_page.create_record file_name
    puts DataMagic.yml
    @current_page.submit
    must_wait $click_time, "after clicking insert/submit on #{type}"
  else
    raise("Invalid #{data} data")
  end
  $log.info("#{data} data populated into the #{type} and inserted/saved")
end

When(/^I populate the (.*) with "([^"]*)" data and click reload/) do |type, data|
  @current_page.populate_date_in_add_scheduler_job_form_and_click_reload data
  puts DataMagic.yml
  puts  "{Start time => #{@current_page.return_start_time},End time => #{@current_page.return_end_time}}"
  must_wait $click_time * 2, "after clicking reload on #{type}"
  $log.info("#{data} data populated into the #{type} and reload")
end

And(/^I select "([^"]*)" as "([^"]*)"$/) do |value, element|
  case element
    when 'Category'
      htmlelement="category_element"
    when 'Indicator'
      htmlelement="indicator_element"
    else
      raise("Appropriate element match not found")
  end
  @current_page.send(htmlelement).options.find {|f| f.text.downcase == value.downcase }.click
  $log.info ("#{value}  selected")
  must_wait $click_time, "after selecting #{value}"
end

When(/^I select (.*) record from (.*) grid and click on (.*) button$/) do |record_name, grid_name, button_name|
  (@current_page.get_data_grid_element grid_name).scroll_into_view
  @current_page.select_record_from_grid_and_perform_operation(record_name, grid_name ,button_name)
  $log.info ("I select #{record_name} from  #{grid_name} and perform #{button_name} operation")
end

When(/^I select Match Query option on Search Conditions panel$/) do
  @current_page.public_send("indexer_search_example_queries_list_element").scroll_into_view
  @current_page.public_send("indexer_search_example_queries_list_element").click
  @current_page.public_send("indexer_search_example_queries_list_element").select "Match Query"
end

And(/^I select (.*) menu item from (.*) category$/) do |menu_item, main_menu|
  @current_page.click_menu_item(menu_item, main_menu)
end

When(/^I select (.*) record from (.*) grid$/) do |record_name, grid_name|
  grid_elements = (@current_page.get_data_grid_records grid_name)
  @grid_name = grid_name
  case record_name
    when "first"
      element = grid_elements.first
    when "last"
      element = grid_elements.last
    when "any"
      element = grid_elements.sample
    else
      element = grid_elements.find {|f| f.text.include?(record_name)}
  end
  element.fire_event :click
  $log.info("Clicked on #{record_name} record from #{grid_name} grid")
  must_wait $click_time, "waiting after clicking on #{record_name} record from #{grid_name} grid" unless record_name==("AppEngine_Scheduler_Job_12")
end

And(/^I uncheck "([^"]*)" on ([^"]*)$/) do |check_box_name,element|
  case element
    when 'Search Conditions panel'
      case check_box_name
        when 'displayCharts'
          @current_page.div_elements(:xpath => '//*[@class="optionsCheckbox"]/input')[0].click # this should be moved to PO
          $log.info("Unchecked #{check_box_name} from #{element}")
          must_wait $check_data_entered_time, "to confirm #{check_box_name} is unchecked"
        when 'formatResults'
          @current_page.div_elements(:xpath => '//*[@id="codeMirrorFormatted"]')[0].click # this should be moved to PO
          $log.info("Unchecked #{check_box_name} from #{element}")
          must_wait $check_data_entered_time, "to confirm #{check_box_name} is unchecked"
        else
          raise  ("#{check_box_name} field not found in #{element}")
      end
    else
      raise   ("#{element} not found in #{@current_page} page")
  end
end

And(/^I search and select the "([^"]*)" record using the "([^"]*)" field$/) do |search_data,column_name|
    steps %Q{
      And I search for "#{search_data}" using the "#{column_name}" search field
     }
    grid_elements = (@current_page.get_data_grid_records @grid_name)
    element = grid_elements.find {|f| f.text.include?(search_data)}
    if element.nil?
      raise "#{search_data} not found"
    else
      element.fire_event :click
    end
    $log.info("Clicked on #{search_data} from #{@grid_name} grid")
end

And(/^I search for "([^"]*)" using the "([^"]*)" search field$/) do |search_data, column_name|
  case search_data
  when 'AppEngine_BAT_DA'
    @grid_name = "Manage Adapter Configuration"
    @column_name = column_name
  when 'AppEngine_BAT_BR'
    @grid_name = "Rules Configuration"
    @column_name = column_name
  when 'qa.assets'
    @grid_name = "Application Manager"
    @column_name = "urn"
  when '__GOOGLE_MAPS_API_KEY_','__APPENGINE_CONFIGURATIONMANAGEMENT_01_','__APPENGINE_CONFIGURATIONMANAGEMENT_02_','BusinessRules','General','circuit_stroke','#FF0000'
    @grid_name = "Manage Configuration"
    @column_name = column_name
  when 'AppEngine_Scheduler_Job_01', 'AppEngine_Scheduler_Job_02', 'AppEngine_Scheduler_Job_03', 'AppEngine_Scheduled_Job_start_time','AppEngine_Scheduler_Job_06','FAILURE','AppEngine_Scheduler_Job_10','AppEngine_Scheduler_Job_12','AppEngine_Scheduler_Job_07','AppEngine_Scheduler_Job_08','AppEngine_Scheduler_Job_09'
    @column_name = column_name
  when 'Vancouver'
    @grid_name = ""
    @column_name = ""
  when 'AppEngine_Scheduler_RegistryServices_Record01'
    @grid_name = "Registry Services"
    @column_name = column_name
  when 'com.ge.scheduler.check.clear.cache'
    @grid_name = "Registry Locations"
    @column_name = column_name
  when '__APPENGINE_CONFIGURATIONMANAGEMENT_02_'
    @grid_name = "Manage Configuration"
    @column_name = column_name
  when 'director-services.log'
    @grid_name = "Application Logs"
    @column_name = column_name
  when 'sensor'
    @grid_name = "Plugin Catalog"
    @column_name = column_name
  when 'Asset Tree'
    @grid_name = "Manage Plugins"
    @column_name = column_name
  else
    raise('Invalid Search Data')
  end
  if search_data == 'Vancouver'
    element = @current_page.query_edit_box_element
  else
    must_wait $check_data_entered_time * 3, "before entering values in  search box"
    element = (@current_page.input_text_in_filter @grid_name).find {|f| f.scroll_into_view and f.attribute("name").downcase.gsub(" ", "") == @column_name.downcase.gsub(" ", "")}
  end
  if search_data == 'AppEngine_Scheduled_Job_start_time'
    @current_page.filter_start_date_in_job_execution_date_text_field column_name
  else
    element.clear
    element.send_keys search_data
    element.click
    element.send_keys :enter
  end
  $log.info("Entered #{search_data} text into #{column_name} search field and hit enter")
  must_wait $click_time, "after hitting enter for searching"
end

Then(/^I delete "([^"]*)" record from the grid$/) do |record_name|
  case record_name
  when 'AppEngine_BAT_DA'
    @list_of_records = (@current_page.get_data_in_column @grid_name, @column_name)
    unless record = @list_of_records.find {|f| f.scroll_into_view and f.text.downcase == record_name.downcase}
      $log.info("#{record_name} record is not available in #{@grid_name} grid ")
    else
      record.fire_event :click
      @current_page.manage_adapter_configuration_grid_delete_icon_element.click
      if @current_page.div_element(:class => 'ui-jqdialog').exists?
        steps %Q{
            And I click "Delete" button on the popup
            }
      end
      $log.info("#{record_name} record deleted from #{@grid_name} grid ")
      must_wait $click_time, "after deleting #{record_name} record from #{@grid_name} grid"
    end
  when 'AppEngine_Scheduler_RegistryServices_Record01'
    @current_page.delete_record_from_grid record_name, @grid_name
  when 'AppEngine_BAT_BR'
    @current_page.delete_business_rule @grid_name
    when 'AppEngine_Scheduler_Job_01','AppEngine_Scheduler_Job_02','AppEngine_Scheduler_Job_03','AppEngine_Scheduler_Job_04','AppEngine_Scheduler_Job_04','AppEngine_Scheduler_Job_05','AppEngine_Scheduler_Job_06','AppEngine_Scheduler_Job_07','AppEngine_Scheduler_Job_08','AppEngine_Scheduler_Job_09','AppEngine_Scheduler_Job_10','AppEngine_Scheduler_Job_11','AppEngine_Scheduler_Job_12','AppEngine_Scheduler_Job_13'
  @current_page.delete_record_from_grid record_name, @grid_name
  else
    @current_page.select_first_record_from_grouped_records @grid_name
    begin
      @current_page.click_on_left_pager_icons @grid_name, "Delete Application", "left"
    rescue
      @current_page.click_on_left_pager_icons @grid_name, "Delete selected row", "left"
    end
    must_wait $click_time, "after clicking on delete button from #{@grid_name} grid "
    if @current_page.ok_button_element.exists?
      steps %Q{
            And I click "OK" button on the popup
            }
    end
    if @current_page.div_element(:class => 'ui-jqdialog').exists? && @current_page.div_element(:class => 'ui-jqdialog').attribute("aria-hidden") == "false"
      steps %Q{
            And I click "Delete" button on the popup
            }
    end
    $log.info("#{record_name} record deleted from #{@grid_name} grid ")
    must_wait $click_time * 4, "after deleting #{record_name} record from #{@grid_name} grid"
  end
end


And(/^I check the application version from "([^"]*)" page$/) do |page_name|
  @app_version =@current_page.get_application_version page_name
  $log.info("#{@app_version} is displayed as Appengine version in #{page_name} page ")
end


When(/^I click on "([^"]*)" button$/) do |button_name|
  (@current_page.get_data_grid_element @grid_name).scroll_into_view
  must_wait $click_time , "before clicking #{button_name} from #{@grid_name} grid"
  if  button_name.eql?("Sync canonical model")
    @current_page.click_sync_caninical_model button_name
  else
    @current_page.click_grid_Pager_panel_icons(@grid_name, button_name)
  end
  must_wait $click_time , "after clicking #{button_name} from #{@grid_name} grid" unless button_name ==("Pause Group")||button_name ==("Trigger Group")||button_name ==("Resume Group")||button_name ==("Start Scheduler")||button_name ==("Pause Scheduler")
  end

When(/^I enter with "([^"]*)" "([^"]*)" in the "([^"]*)" field and save$/) do |control_type, value, control_name|
  if @grid_name.eql?("Manage Configuration")
    @current_page.enter_value_in_field_click_Save value, control_name, control_type
  else
    @current_page.enter_value_in_field_scheduler_job_grid value, control_name, control_type
  end
  $log.info("#{value} is entered in #{control_name} field ")
end

Then(/^I switch to new tab and check for (.*) text in the page$/) do |value|
  must_wait $page_load_time, "wait until new tab is loaded"
  @current_page.switch_to_final_tab
  $log.info("Switched to new tab")
  expect(@browser.page_source).to include(value), "Invalid message is displayed"
end


#-----------------------------------------------------------------------------------------------------------------------
# VALIDATION STEPS
#-----------------------------------------------------------------------------------------------------------------------

And(/^I confirm the (.*) url (.*)$/) do |page_name, redirected|
  expect(@browser.current_url).to eq($platform_url+"/"+redirected), "Invalid #{page_name} page URL"
  $log.info("#{page_name} page URL validated")
end

And(/^I see (.*) title as the page header$/) do  |header|
  expect(@current_page.page_header).to eq(header), "Page title doesn't match with '#{header}'"
  $log.info("Page Title matches with '#{header}'")
end

Then(/^I see the "([^"]*)" turn "([^"]*)" in "([^"]*)" grid$/) do |service_name, color_name, grid_name|
  grid_elements = (@current_page.get_data_grid_records grid_name)
  expect(grid_elements.last.div_element(:class => 'statusIcon').attribute("class")).to include(color_name), "#{service_name} not displayed in #{color_name} color"
  $log.info("#{service_name} turned to #{color_name} color")
  must_wait $check_data_entered_time, "to check #{service_name} turned to #{color_name} color"
end

And(/^I should be able to see the menu items and the logged user name$/) do
  expect(@current_page.menu_category_names_elements.count).not_to be_nil, 'No Menu Items displayed on the page'
  $log.info "Menu Items validated"
  expect(@current_page.index_login_user_name?).to be_truthy, 'No User Name displayed on the page'
  expect(@current_page.index_login_user_name_element.text.upcase).to include($last_used_username.upcase), "Logged with an different user"
  $log.info "User validated"
end

And(/^I should see more than or equal to (.*) records in (.*) grid$/) do |records_count, grid_name|
  case grid_name
  when 'groups', 'policies'
    expect(@current_page.get_tot_num_of_records_all_pages grid_name).to be >= records_count.to_i, "#{grid_name} grid has less than #{records_count} records"
  else
    expect((@current_page.grid_right_pager_details grid_name, "right").split(" ").last.gsub(",", "").to_i).to be >= records_count.to_i, "#{grid_name} grid has less than #{records_count} records"
  end
  $log.info("#{grid_name} grid has more than #{records_count} records")
  must_wait $check_data_entered_time, "to check #{grid_name} grid has more than #{records_count} records"
end

Then(/^I should not see the "([^"]*)" ([^"]*)$/) do |name,type|
  case type
    when 'grid'
      case name
        when 'General Data Grid'
            expect(@current_page.list_of_grids_in_page).not_to include(name)
            $log.info("#{name} grid not displayed")
      end
    when 'menu'
      case name
        when 'AppEngine BAT MM Cat'
          expect(@current_page.menu_category_names_elements.find{|e|e.text.upcase == name.upcase}).to be_nil, "#{name} menu still displayed"
          $log.info("#{name} menu not displayed")
      end
    else
      raise('Invalid type (page/popup/panel/grid/marker)')
  end
end

Then(/^I see "([^"]*)" ([^"]*)$/) do |name,type|
  case type
    when 'marker'
      expect(@current_page.div_elements(:title => "#{name}")).not_to be_nil, "#{name} #{type} not displayed"
      $log.info("#{name} #{type} displayed")
      must_wait $check_data_entered_time, "to check #{name} #{type} on the map"
    else
      raise('Invalid type (page/popup/panel/grid/marker)')
  end
end

Then(/^I (should|should not) see "([^"]*)" (category|topic|item)$/) do |condition, name, menu_type|
  menu_list = (@current_page.menu_item_category_list_element).text
  if condition == 'should'
    expect(menu_list).to include(name), "#{name} #{menu_type} not visible on the page"
    $log.info("#{name} #{menu_type} visible on the page")
    must_wait $check_data_entered_time, "to check #{name} #{menu_type} is visible on the page"
  end
  if condition == 'should not'
    expect(menu_list).to_not include(name), "#{name} #{menu_type} visible on the page"
    $log.info("#{name} #{menu_type} not visible on the page")
    must_wait $check_data_entered_time, "to check #{name} #{menu_type} is not visible on the page"
  end
end

Then(/^I should (.*) "([^"]*)" record in the "([^"]*)" grid$/) do |action, data, grid_name|
  if grid_name == 'Indexer Results'
    htmlelement="indexer_search_indices_values_elements"
  elsif grid_name == 'Manage Adapter Configuration'
    htmlelement="manage_adaptor_configuration_grid_values_elements"
  elsif grid_name == 'Rules Configuration'
    htmlelement="rules_configuration_grid_values_elements"
  elsif grid_name == 'Application Manager'
    htmlelement="application_manager_grid_values_elements"
  elsif grid_name == 'Scheduled Jobs'
    htmlelement="scheduled_jobs_grid_values_elements"
   @grid_name = grid_name
  elsif grid_name == 'Groups'
    htmlelement="scheduled_groups_grid_values_elements"
    @grid_name = grid_name
  elsif grid_name == 'Manage Configuration'
    htmlelement="manage_configuration_grid_values_elements"
  elsif grid_name == 'Registry Services'
    htmlelement="registry_services_grid_values_elements"
    @grid_name = grid_name
  elsif grid_name == 'Registry Locations'
    htmlelement="registry_locations_grid_values_elements"
    @grid_name = grid_name
    @grid_name = grid_name
  elsif grid_name == 'Plugin Catalog'
    htmlelement="plugin_catalog_grid_values_elements"
    @grid_name = grid_name
  elsif grid_name == 'Manage Plugins'
    htmlelement="manage_plugins_grid_values_elements"
    @grid_name = grid_name
  else
      raise('Invalid grid name')
  end
  case action
    when 'not see'
      values = @current_page.send( htmlelement).map(&:text)
      expect(values.find {|f| f.include?("#{data}") }).to be_nil, "#{data} displayed in the grid"
      $log.info "#{data} not displayed in the grid"
  when 'see'
      values = @current_page.send( htmlelement).map(&:text)
      expect(values.find {|f| f.include?("#{data}") }).not_to be_nil, "#{data} not displayed in the grid"
      $log.info "#{data} displayed in the grid"
    else
      raise('Invalid action')
  end
end

Then(/^I should see the "([^"]*)" popup$/) do |popup|
  if popup == "Import xml"
    element = @current_page.div_elements(:class => 'mdDialog').find { |f| f.attribute('class').include?("open") }
    expect(element.div_element(:class => 'mdDialog-body').text.downcase).to include("paste xml here or drag and drop an xml file:".downcase), "paste xml here or drag and drop an xml file: is not displayed in page"
  else
    element = @current_page.div_elements(:class => 'ui-dialog').reject{ |f| f.attribute('style').include?("display: none;") }
    expect(element[0].span_element(:class => 'ui-dialog-title').text.downcase).to eq(popup.downcase), "#{popup} is not displayed in page"
  end
end

Then(/^I should see (.*) message on a growler$/) do |step|
  @current_page.wait_until(180,'Message Popup not displayed') do
    if  $browser.execute_script("return document.querySelector('px-alert-message')").nil?.eql?(false)
      @alert_message_code = $browser.execute_script("return document.querySelector('px-alert-message').root.querySelector('div#alert').querySelector('div.message-column').querySelector('div.message-container').querySelector('div#message').innerText")
    end
  end
  if step.include? "???"
    message1 = step.slice(0..step.index('???')-1)
    message2 = step.slice(step.index('???')+4..step.length)
    expect(@alert_message_code).to include(message1), "#{message1} message not displayed. Expected message is #{@alert_message_code}"
    expect(@alert_message_code).to include(message2), "#{message1} message not displayed. Expected message is #{@alert_message_code}"
  else
    message = step
    expect(@alert_message_code).to include(message), "#{message1} message not displayed. Expected message is #{@alert_message_code}"
  end
  $log.info "#{@alert_message_code} message displayed"
  must_wait $check_data_entered_time, "to check #{@alert_message_code} message is displayed"
end

Then(/^I should see "([^"]*)" record with "([^"]*)" value in the "([^"]*)" of "([^"]*)" grid$/) do |record_name, value, field_name, grid_name|
  expect(@current_page.get_log_value grid_name, record_name, value).to be_truthy, "#{value}is not displayed in the  #{field_name}"
  $log.info("#{value} is displayed for #{record_name} job ")
end

Then(/^I should see "([^"]*)" record with "([^"]*)" status in the "([^"]*)" grid$/) do |record_name, job_status, grid_name|
   @grid_name = grid_name if grid_name =="Scheduled Jobs"||grid_name =="Groups"
  expect(@current_page.check_job_status grid_name, record_name, job_status).to be_truthy, "#{job_status}is not displayed for #{record_name}"
  $log.info("#{job_status} is displayed for #{record_name} job ")
end
And(/^I see (.*) to "([^"]*)" "([^"]*)" records in the "([^"]*)" grid$/) do |mode, num_of_records, record_name, grid_name|
    case mode
    when 'less than or equal'
  expect(@current_page.check_records_count_in_the_grid record_name, grid_name).to be <= num_of_records.to_i,"Execution count in #{grid_name} is #{mode} than or equal to #{num_of_records} execution_intervals"
    when 'more than or equal'
      expect(@current_page.check_records_count_in_the_grid record_name, grid_name).to be >= num_of_records.to_i,"Execution count in #{grid_name} is #{mode} than or equal to #{num_of_records} execution_intervals"
    end
    $log.info("Execution count in #{grid_name} is #{mode} than or equal to #{num_of_records} execution_intervals")
    end
Then(/^I should see all the fields in "([^"]*)" popup cleared$/) do |pop_up_name|
  expect(@current_page.check_field_is_blank pop_up_name).to be_truthy, "#{pop_up_name} fields are displayed blank"
  $log.info("#{pop_up_name} fields are not displayed blank ")
end
And(/^I should (.*) see (.*) menu item under (.*) menu category$/) do |mode, item, category|
  case mode
  when 'not'
    expect(@current_page.check_menu_existance item, category).to be_falsey,"#{item} is not available under #{category} "
  else
    expect(@current_page.check_menu_existance item, category).to be_truthy, "#{item} is not available under #{category} "
  end
end

And(/^I find an existent "([^"]*)" record$/) do |record_name|
      @list_of_records = (@current_page.get_data_in_column @grid_name, @column_name)
      unless @list_of_records.find { |f| f.scroll_into_view and f.text.downcase == record_name.downcase }
        $log.info("#{record_name} record is not available on the #{@grid_name} grid ")
      else
        $log.info("#{record_name} record displayed on the #{@grid_name} grid ")
      end
      must_wait $check_data_entered_time, "to check #{record_name} record is displayed on the #{@grid_name} grid"
end
When(/^I check for existent (.*) record from (.*) grid and delete if record exists$/) do |record_name, grid_name|
  @current_page.check_existing_record_and_delete_record_from_grid(record_name, grid_name)
end

And(/^I Compare Scheduler Manager version vs AppEngine version$/) do
  expect(@current_page.get_records_from_schedulers_grid).to include(@app_version.to_s),"AppEngine version#{@app_version} does not match the Scheduler Manager version"
  $log.info("AppEngine version #{@app_version} is matching with Scheduler Manager version")
end

Then(/^I should see "([^"]*)" error message on "([^"]*)" popup$/) do |error_message, popup|
  expect(@current_page.form_error_message).to eq(error_message), "Invalid message is displayed"
  $log.info("#{error_message} error message is displayed on #{popup} popup")
end

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
