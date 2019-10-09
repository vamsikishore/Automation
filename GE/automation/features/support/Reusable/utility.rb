def create_page_class(page_name)
  class_from_string "StudioPages::#{page_name}Page".delete(' ')
end

#returns original text if text does not start with @. Otherwise use the text as key to get the value from @test_data
def get_saved_data(key)
  if key.start_with?('@')
    retVal = instance_variable_get("#{key}")
    $log.info("get_saved_data, instance variable: #{retVal}")
    if retVal.to_s == ''
      #We didn't find it in the saved variables
      #Going to search the yaml file if there is one
      if @test_data
        if @test_data[key[1..-1]]
          retVal = @test_data[key[1..-1]]
        end
      end
    end
    return retVal
  else
    return key
  end
end

def set_implicit_wait(time_in_seconds)
  $browser.manage.timeouts.implicit_wait = time_in_seconds
end

#Common function to be used to fetch the raw indexer output which is application independent
def extract_raw_indexer_result
  @current_page.result_panel_heading_element.click
  @current_page.invisible_status_value_doc_count_element.scroll_into_view
  @search_data=@current_page.search_id_value_elements.map(&:text)
  @no_empty_values=@search_data.reject { |c| c.empty? }
  @result_set = Array.new
  @result_set = @no_empty_values.map { |m| m.gsub("newAgg::subAgg::", "") }
end

#Method to be used to fetch the even elements of an array
def extract_even_array(array)
  array_even= Array.new
  array.each_slice(2) { |x| array_even.push(x[0]) }
  array_even
end

#Method to be used to fetch the odd elements of an array
def extract_odd_array(array)
  array_odd= Array.new
  array.each_slice(2) { |x| array_odd.push(x[1]) }
  array_odd
end

#Common function to be used to retrieve the pie-chart fusion values which is application independent
def get_indicator_tool_tip_values
  fusion_values = []
  svg_element = @current_page.span_elements(:css => "#chartobject-1 > svg > g").find { |f| f.attribute("class").include?("dataset") }
  g_element = svg_element.span_elements(:css => "g").find { |e| e.attribute("class").include?("top-Side") }
  path_elements = g_element.span_elements(:css => "path")
  for i in 0...path_elements.size
    path_elements[i].fire_event "onmouseover"
    must_wait 3
    fusion_values << @current_page.span_element(:id => "fusioncharts-tooltip-element").text
  end
  fusion_values_even=extract_even_array(fusion_values)
  @indicator_tool_tip_values= fusion_values_even.reverse
end

#Common Indicators functions
def get_indicator_element indicator_name, page_name
  on_page(create_page_class page_name) do |page|
    for i in 0..page.indicator_parent_elements.size - 1
      if page.indicator_parent_elements[i].find_element(:class => 'panel-title').text.include?(indicator_name)
        return page.indicator_parent_elements[i]
      end
    end
  end
  raise("Indicator #{indicator_name} is not found")
end

def get_grid_id indicator_name
  indicator_parent_elements.find{|f| f.div_element(:class => "panel-title").text.include?(indicator_name)}.attribute('id')
end

def get_workbench_element indicator_name, page_name
  on_page(create_page_class page_name) do |page|
    for i in 0..page.workbench_parent_elements.size - 1
      if page.workbench_parent_elements[i].find_element(:class => 'col-lg-9').text.include?(indicator_name)
        return page.workbench_parent_elements[i]
      end
    end
  end
  raise("Indicator #{indicator_name} is not found")
end
