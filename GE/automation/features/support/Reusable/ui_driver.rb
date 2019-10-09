module UIDriver
  def login(username, password)
    $log.info "Logging In with Username: #{username} and Password: #{password}"
    on_page(create_page_class('Landing')).open_page
    click_control_on_page('login', 'Landing', nil)
    input_keys(username, 'user name', 'Login', nil)
    input_keys(password, 'password', 'Login', nil)
    click_control_on_page('Login', nil, nil)
    compare_control_text(nil, username.upcase, 'User Name', 'Index')
    $log.info "User #{username} is Logged In."
  end

  #Method to click the menu Category
  def click_menu_category (menu)
    raise "Given #{menu}-category not exists in index page" unless on_page(create_page_class('Index')).menu_list_names_elements.find{|e|e.text == menu.upcase }.click
    $log.info("Given #{menu}-category clicked in index page")
  end

  #Click on the Sub category
  def click_sub_menu (sub_menu, menu)
    click_menu_category(menu)
    raise "Given #{sub_menu}-sub-menu not exists under #{menu}-menu item in index page" unless on_page(create_page_class('Index')).sub_menu_list_elements.find{|e|e.text.upcase == sub_menu.upcase}.click
    $log.info("Given #{sub_menu}-menu-item clicked under #{menu}-menu category in index page")
  end


  #--------------------------------------------------------------------------------------------------------------------------------
  #Functions that interact with web controls
  #--------------------------------------------------------------------------------------------------------------------------------
  def get_element(control_name, page_name, indicator_name)
    begin
      control_name = control_name.strip.downcase.gsub(' ', '_')
      page_name == nil ? page = @current_page : page = on_page(create_page_class page_name)
      indicator_name == nil ? element =  page.public_send("#{control_name}_element") : element =  get_grid_element(control_name, page, indicator_name)
      raise "Element #{control_name} is not found" unless element
      return element
    rescue => exception
      puts exception.backtrace
    end
  end

  def get_grid_element(control_name, page, indicator_name)
    begin
      return page.public_send(control_name, indicator_name)
    rescue
      control_name = "#{indicator_name} #{control_name}".strip.downcase.gsub(' ', '_')
      $log.info "#{page.public_send("#{control_name}_element")}"
      return page.public_send("#{control_name}_element")
    end
  end

  def click_control_on_page(control_name, page_name, indicator_name)
    begin
      elem = get_element(control_name, page_name, indicator_name)
      elem.click
      $log.info "Clicked on #{control_name} button on the #{page_name} page"
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def input_keys(keys, control_name, page_name, indicator_name)
    begin
      if keys.start_with?('@')
        raise "@test_data must be defined to use keys which begin with an ampersand: #{keys}" unless @test_data
        keys = @test_data[keys[1..-1]] # note: http://stackoverflow.com/questions/3614389/what-is-the-easiest-way-to-remove-the-first-character-from-a-string
      end
      elem = get_element(control_name, page_name, indicator_name)
      elem.clear
      elem.send_keys keys
      $log.info "Entered #{keys} to #{control_name} control on the #{page_name} page"
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def select_dropdown_option_by_text(option, dropdown_control_name, page_name)
    begin
      set_implicit_wait(DEFAULT_VALIDATION_WAIT_TIME)
      elem = get_element(dropdown_control_name, page_name, nil)
      elem.click
      elem.send_keys option
      elem.click
      all_options = elem.text
      selected_option = all_options.split("\n").first
      $log.info "Selected #{selected_option} for #{dropdown_control_name}"
    rescue => exception
      puts exception.backtrace
      raise
    ensure
      set_implicit_wait(DEFAULT_WAIT_TIME)
    end
  end

  def press_enter_on_form_field(control_name, page_name, indicator_name)
    begin
      elem = get_element(control_name, page_name, indicator_name)
      elem.send_keys :enter
      $log.info "Pressed enter to #{control_name} control on the #{page_name} page"
      must_wait(2)
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def scroll_to_object(control_name, page_name, indicator_name)
    begin
      elem = get_element(control_name, page_name, indicator_name)
      elem.scroll_into_view
      $log.info "Scrolled to #{control_name} control on the #{page_name} page"
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def save_control_text(control_name, variable_name)
    begin
      elem = get_element(control_name, nil, nil)
      variable_name = variable_name.strip.downcase.gsub(' ', '_')
      control_text = elem.text
      if control_text == ''
        control_text = elem.attribute('value')
      end
      instance_variable_set("#{variable_name}", control_text)
      $log.info "Saved #{control_text} of #{control_name} into #{variable_name} variable"
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def click_link_by_text(text)
    begin
      $browser.find_element(:link_text => text).click
      $log.info "clicked #{text} link"
    rescue Selenium::WebDriver::Error::NoSuchElementError
      raise "The #{text} link is not found"
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def get_control_text(control_name, page_name)
    begin
      set_implicit_wait(DEFAULT_VALIDATION_WAIT_TIME)
      elem = get_element(control_name, page_name, nil)
      return elem.text
    rescue => exception
      puts exception.backtrace
      raise
    ensure
      set_implicit_wait(DEFAULT_WAIT_TIME)
    end
  end

  def compare_notification_dialog_box_text(notification_message, timeout)
    if notification_message.start_with?('@')
      notification_message=get_saved_data(notification_message)
    end
    must_wait 3
    expect(@current_page.confirmation_content_pane).to be_truthy, "Notification pop up is not displayed"
    $log.info "#{notification_message} is displayed on the pop up"
    actual = @current_page.confirmation_content_pane.gsub("\n", ' ').strip
    $log.info actual
    $log.info notification_message
    if actual == notification_message
      return true
    else
      raise "Value did not match, Expected: #{notification_message} Actual: #{actual}"
    end
  end

  def increment_variable(variable_name, number)
    begin
      if variable_name.start_with?('@')
        variable_name=get_saved_data(variable_name)
      end
      $log.info "Begin increment"
      variable_name = variable_name.to_i
      $log.info variable_name
      variable_name += Integer(number.to_i)
      $log.info variable_name
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def wait_until_control_text(expected_text, control_name,timeout)
    wait = Selenium::WebDriver::Wait.new(timeout: Integer(timeout))
    if expected_text.start_with?('@')
      expected_text=get_saved_data(expected_text)
    end
    wait.until { get_element(control_name, nil, nil).text.include? expected_text}
  end

  def wait_for_po_web_element_by_attribute(control_name, page_name, indicator_name, attribute, attribute_value, timeout)
    begin
      elem = get_element(control_name, page_name, indicator_name)
      $log.info elem.attribute(attribute)
      $log.info attribute_value
      $log.info elem.attribute(attribute).include? attribute_value
      raise "Unable to find element with page_name: #{page_name} indicator_name: #{indicator_name} control_name: #{control_name} check your PageObject element decleration." unless elem
      wait = Selenium::WebDriver::Wait.new(timeout: Integer(timeout))
      wait.until { elem.attribute(attribute).include? attribute_value }
    rescue => exception
      puts exception.backtrace
      raise
    end
  end

  def wait_until_control_value(expected_value, control_name,timeout)
    wait = Selenium::WebDriver::Wait.new(timeout: Integer(timeout))
    if expected_value.start_with?('@')
      expected_value=get_saved_data(expected_value)
    end
    wait.until { get_element(control_name, nil, nil).value.include? expected_value}
  end

end #Module UIDriver
World(UIDriver)