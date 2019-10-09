class PageMethods
  include PageObject
  include PageFactory
  include DataMagic

# Page Objects:
    div           :index_page_logo,                              :class => 'logoDiv'
    links         :menu_category_names,                          :xpath => '//li/span/span'
    links         :menu_items_list,                              :xpath => '//li[@class="item"]/a'
    h1            :page_header,                                  :class => 'name'


# Common methods:
    # Click on a menu category based on category name
    def click_menu_category (menu)
      unless el = menu_category_names_elements.find do |e|
        must_wait 5, menu
        begin
          menu_next_button_element.click if e.attribute('style').include?('display: none;') or e.text == ""
          must_wait 4, menu
          e.text.upcase == menu.upcase
        rescue Exception => e
          e.text.upcase == menu.upcase
        end
      end
        raise "Menu category with name \"#{menu}\" does not exist"
      else
        el.click
      end
    end

    # Click on a menu item based on name and category
    def click_menu_item (menu_item, menu)
      click_menu_category(menu)
      unless ele = menu_items_list_elements.find {|e| e.text.upcase == menu_item.upcase}
        raise "Menu Item #{menu_item} does not exist under #{menu} menu category"
      else
        ele.click
      end
    end

   # Validate URL
    def self.expected_url expected_url
      define_method 'has_expected_url?' do
        has_expected_url = expected_url.kind_of?(String) ? @browser.current_url.include?(expected_url) : false
        raise "Expected url '#{expected_url}' instead of '#{@browser.current_url}'" unless has_expected_url
      end
    end

    # Validate page header
    def self.expected_header expected_header
      define_method 'check_page_header?' do
        check_page_header = expected_header.kind_of?(String) ? self.page_header.eql?(expected_header) : false
        raise "Expected header '#{expected_header}' instead of '#{self.page_header}'" unless check_page_header
      end
    end

    # Navigate to a URL
    def open_page
      $browser.execute_script("window.location.href = '#{$platform_url}'")
      if $browser_name == 'ie'
        must_wait $check_data_entered_time, "before hitting the browser url"
        $browser.get "javascript:document.getElementById('overridelink').click()"
      end
    end

    # Populate a form
    def create_record(file_name, data = {})
     @record_details = DataMagic.load("#{file_name}.yml")
      populate_page_with data_for(:"#{file_name}", data)
    end

    # Mouse hove over a grid based on grid name
    def mouse_hover_on_element grid_name
      grid_id = get_grid_id grid_name
      cell_element(:xpath => "//*[@id=\"gdGridPager_panel_#{grid_id}_left\"]")
    end

   # Navigate to pages hitting direct url
    def navigate_to_page page_name
      url = $platform_url + $app_urls[page_name]
      $browser.execute_script("window.location.href = '#{url}'")
    end

  #To check return application  version
   def get_application_version page_name
    navigate_to_page page_name
    must_wait $page_load_time * 2, "for the #{page_name} to load"
    version_number =p_element(:class=>'form-control').text
    return version_number
   end

  #Switch to final tab
  def switch_to_final_tab
    all_windows = @browser.window_handles
    @browser.switch_to.window(all_windows.last)
  end

  #check menu exists in the menu category
  def check_menu_existance (menu_item, menu)
    click_menu_category(menu)
   return menu_items_list_elements.map(&:text).include? menu_item
  end


end

