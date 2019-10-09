require_relative '../../pages/common/page_methods'

class GridMethods < PageMethods
  include PageObject
  include PageFactory
  include DataMagic

#Page Objects:
    divs          :grid_panel_top,                :class => 'panelTop'
    divs          :grid_title,                    :xpath => '//div[contains(@class, "panel-title")]/h4'
    buttons       :all_metric_columns,            :xpath => '//*[contains(@class, "metricColumn")]'
    span          :add,                     :class => 'ui-icon-plus'
    span          :edit,                    :class => 'ui-icon-pencil'
    button        :update,                  :id => 'sData'
    div           :ok_button,               :class => 'btn-primary'
    button        :submit,                  :id=>'sData'
    span          :reload,                  :class =>'ui-icon-refresh'
    cell          :form_error_message,      :id => 'FormError'
    button        :save,                    :id => 'lnk-submit'


#Grid Methods:

    # Returns grid id based on grid name
    def get_grid_id grid_name
      grid_panel_top_elements.find {|f| f.div_element(:class => "panel-title").text.include?(grid_name)}.attribute('id')
    end

    # Returns list of grids from the page
    def list_of_grids_in_page
      grid_title_elements.map(&:text)
    end

    # Returns elements from a grid based on grid name
    def get_data_grid_element grid_name
      grid_panel_top_elements.find {|f| f.div_element(:class => "panel-title").text.include?(grid_name)}
    end

    # Returns data from a grid base on grid name
    def get_data_grid_records grid_name
      grid = get_data_grid_element grid_name
      grid.table_element(:class => 'ui-jqgrid-btable').cell_elements(:class => 'ui-widget-content')
    end

    # Returns data from a grid base on grid name (starting from second row - i.e. Business Rules/Application Management)
    def get_data_grid_records_from_second_row grid_name
      grid = get_data_grid_element grid_name
      grid.table_element(:class => 'ui-jqgrid-btable').cell_elements(:class => 'ui-widget-content').reject {|e| e.attribute('id').include?('gdGridTable_panel_')}
    end

    # Returns help icon text from a grid base on grid name
    def grid_level_help_icon grid_name
      grid_id = get_grid_id grid_name
      span_element(:xpath => "//*[@id=\"#{grid_id}\"]/div/div[1]/div[1]/div/img")
    end

    # Opens manage indicator popup based on grid name
    def grid_level_edit_icon grid_name
      grid_id = get_grid_id grid_name
      button_element(:xpath => "//*[@id=\"#{grid_id}\"]/div/div[1]/div[1]/div/span[1]/img")
    end

    # Returns action icons (add/edit/delete/view...etc) from a grid based on grid name and action type
    def grid_left_pager_details name, mode
      grid_id = get_grid_id name
      cell_elements(:xpath => "//*[@id=\"gdGridPager_panel_#{grid_id}_#{mode}\"]/table/tbody/tr/td")
    end

    # Perform actions for a grid
    def click_on_left_pager_icons grid_name, button_name, mode
      left_pager_elements = grid_left_pager_details grid_name, mode
      left_pager_elements.find {|f| f.attribute("title") == button_name}.click
    end

    # Returns the number of records from a grid based on grid name
    def grid_right_pager_details name, mode
      grid_id = get_grid_id name
      cell_element(:xpath => "//*[@id=\"gdGridPager_panel_#{grid_id}_#{mode}\"]/div").text
    end


    # Returns fields that can be used for filtering
    def input_text_in_filter grid_name
      cell_elements(:xpath => "//*[@class=\"ui-search-input\"]/input")
    end

    # Returns data from a column based on grid name and grid column
    def get_data_in_column grid_name, column_name
      grid = get_data_grid_element grid_name
      index_number = grid.cell_elements(:class => 'ui-jqgrid-sortable').find_index {|f| f.text.downcase == column_name.downcase}
      grid.cell_elements(:xpath => "//*[@class=\"ui-jqgrid-btable\"]/tbody/tr[contains(@class, \"ui-widget-content\")]/td[#{index_number + 1}]")
    end

    # Returns grid title based on grid name ???
    def get_block_title grid_name
      grid_id = get_grid_id grid_name
      div_element(:xpath => "//*[@id=\"#{grid_id}\"]/div/div[1]/div[1]/button").text
    end

    # Returns columns from a grid based on grid name
    def get_all_column_names grid_name
      grid_id = get_grid_id grid_name
      cell_elements(:xpath => "//*[@id=\"gview_gdGridTable_panel#{grid_id}\"]/div[2]/div/table/thead/tr").map(&:text)
    end

   #Method to check records in the grid when there is no search option
    def check_record_in_grid (grid_name, record_name)
      get_data_grid_records(grid_name).map(&:text).find {|f| return f.include?(record_name)}
    end

   #Selecting first record from the grouped records grid
    def select_first_record_from_grouped_records grid_name
      @list_of_records = get_data_grid_records_from_second_row grid_name
      raise("#{record_name} record is not available in #{grid_name} grid ")  if (@list_of_records.empty?)
      @list_of_records[0].fire_event :click
    end
#Method to click action icons (ex:add,edit,delete)
  def click_grid_Pager_panel_icons (grid_name, button_name)
    begin
      grid_name_element = (mouse_hover_on_element grid_name)
      grid_name_element.hover if grid_name_element.attribute('class').include?('extender')
      must_wait $click_time, "to wait before  #{button_name} click "
      click_on_left_pager_icons grid_name, button_name, "left"
    rescue
      click_on_left_pager_icons grid_name, button_name, "left"
    end
    $log.info("Successfully clicked on #{button_name} on #{grid_name}")
  end

 #Check Ribbons in the workbench:
  def check_ribbon_in_workbench (ribbon_name)
   return div_elements(:class=>'mlabel').map(&:text).include?(ribbon_name)
  end

#Check Panel in the workbench:
  def check_panel_title(panel_title)
    return h4_elements(:class=>'panel-title').map(&:text).reject(&:empty?).include?(panel_title)
  end

#Method to enter values in the field  (Form validation)
  def enter_value_in_field value, control_name, control_type
    control_name = control_name.strip.downcase.gsub(' ', '_')
    self.public_send("#{control_name}_element").hover if self.public_send("#{control_name}_element").visible?
    must_wait $click_time / 2, "for the mouse to hover over the #{control_name} #{control_type}"
    self.public_send("#{control_name}_element").clear  if control_type.eql?("text")
    self.public_send("#{control_name}_element").send_keys value  if control_type.eql?("text")
  end
#Method to enter values in the field and click on save button (Form validation)
  def enter_value_in_field_click_Save value, control_name, control_type
    enter_value_in_field value, control_name, control_type
    submit
    must_wait $click_time, "after hitting enter for searching"
  end
#method to check records count in the grid
  def check_records_count_in_the_grid record_name, grid_name
    return get_data_grid_records(grid_name).select {|f| f.text.include?(record_name)}.length
  end
end
