module Validations

  def find_indicator indicator, page_name
    !on(create_page_class page_name).indicator_titles_elements.find{|e| e.text.eql?(indicator) }.nil? ? $log.info("#{indicator} indicator is found") : raise("#{indicator} is not found")
  end

  def check_axis_labels axis, indicator_name, page_name, table
    ax_ele = on_page(create_page_class page_name).public_send('axis_element', axis, indicator_name)
    expected_axis_labels = table.raw

    unless ax_ele.size == expected_axis_labels[0].size
      raise("Number of labels does not match. Expected: #{expected_axis_labels[0].size}; Actual: #{ax_ele.size}")
    end

    for i in 0..expected_axis_labels[0].size - 1
      unless ax_ele[i].text.include?(expected_axis_labels[0][i])
        $log.info("#{axis} label #{ax_ele[i].text} is not found, expected: #{expected_axis_labels[0][i]}, actual: #{ax_ele[i].text}")
        raise ("#{axis} label #{ax_ele[i].text} is not found, expected: #{expected_axis_labels[0][i]}, actual: #{ax_ele[i].text}")
      end
    end
  end

  def check_control_existence(should_exist, control_name, page_name, indicator_name)
    if(should_exist.eql? " not" )
      begin
        set_implicit_wait(DEFAULT_VALIDATION_WAIT_TIME)
        elem = get_element(control_name, page_name, indicator_name)
        # Conversion was necessary to use string library functions to catch exceptions.
        element_to_string=elem.to_s
        #If an element is returned it would be in the format  "#<PageObject::Elements::...". Therefore, element_to_strings["Elements::"] will help us catch exceptions.
        if element_to_string["Elements::"]
          should_exist ? (expect(elem).not_to exist) : (expect(elem).to exist)
        else
          raise "#{control_name} should#{should_exist} exist"
        end
      rescue => exception
        puts exception.backtrace
      end
    else
      begin
        set_implicit_wait(DEFAULT_VALIDATION_WAIT_TIME)
        elem = get_element(control_name, page_name, indicator_name)
        should_exist ? (expect(elem).not_to exist) : (expect(elem).to exist)
      rescue
        raise "#{control_name} should#{should_exist} exist"
      ensure
        set_implicit_wait(DEFAULT_WAIT_TIME)
      end
    end
  end

  def compare_control_text(should_equal, expected_text, control_name, page_name)
    begin
      set_implicit_wait(DEFAULT_VALIDATION_WAIT_TIME)
      expected_text = get_saved_data(expected_text).downcase.strip
      elem = get_element(control_name, page_name, nil)
      actual_text = elem.text.gsub("\n", " ").downcase.strip
      if (should_equal)
        expect(actual_text).not_to eql(expected_text), "Text should NOT matched. Expected Result: not equal to #{expected_text}, Actual Result: #{actual_text}"
      else
        expect(actual_text).to eql(expected_text), "Text do NOT matched. Expected Result: #{expected_text}, Actual Result: #{actual_text}"
      end
    rescue => exception
      puts exception.backtrace
      raise
    ensure
      set_implicit_wait(DEFAULT_WAIT_TIME)
    end
  end

  def compare_form_field_value(should_equal, expected_text, control_name, page_name)
    begin
      set_implicit_wait(DEFAULT_VALIDATION_WAIT_TIME)
      should_equal ? should_equal = false : should_equal = true
      elem = get_element(control_name, page_name, nil)
      actual_text = elem.attribute("value")
      if should_equal == true
        actual_text.should be_eql(expected_text), "Text do NOT matched. Expected Result: #{expected_text}, Actual Result: #{actual_text}"
      else
        actual_text.should_not be_eql(expected_text), "Text should NOT matched. Expected Result: not equal to #{expected_text}, Actual Result: #{actual_text}"
      end
    rescue => exception
      puts exception.backtrace
      raise
    ensure
      set_implicit_wait(DEFAULT_WAIT_TIME)
    end
  end

  #Checks if main_string includes expected_text. Passes if main_string should include(should_include = true) and contains the expected_text or
  #should not contain(should_include = false) and the main string does not contain the expected_text. Else, function throws exception
  def is_substring(should_include, main, expected_text, strict = true)
    begin
      if expected_text.start_with?('@')
        expected_text=get_saved_data(expected_text)
      end
      # if not strict remove newlines, leading/trailing whitespace, and downcase both strings.
      if (not strict)
        main = main.downcase.gsub("\n", " ").strip
        expected_text = expected_text.downcase.gsub("\n", " ").strip
      end
      set_implicit_wait(DEFAULT_VALIDATION_WAIT_TIME)
      if should_include == true
        expect(main).not_to include(expected_text), "Actual text should not include #{expected_text}. Actual: #{main}"
      else
        expect(main).to include(expected_text), "Actual text does not include #{expected_text}. Actual: #{main}"
      end
    rescue => exception
      puts exception.backtrace
      raise
    ensure
      set_implicit_wait(DEFAULT_WAIT_TIME)
    end
  end
end

def compare_content_on_xml(should_equal,tagname,tagvalue,xmlDoc)
  begin
    if xmlDoc.start_with?('@')
      xmlDoc=get_saved_data(xmlDoc)
    end
    xml_doc=Nokogiri::XML(xmlDoc)
    $log.info("Testing Doc: #{xml_doc} ")
    tag_xpath="//"+tagname
    value=xml_doc.xpath(tag_xpath).first.content
    $log.info("Value: #{value}")
    if tagvalue.start_with?('@')
      tagvalue=get_saved_data(tagvalue)
    end
    if (should_equal)
      expect(value).not_to eql(tagvalue), "XML Tag Content should NOT matched. Expected Result: not equal to #{tagvalue}, Actual Result: #{value}"
    else
      expect(value).to eql(tagvalue), "XML Tag Content  do NOT matched. Expected Result: #{tagvalue}, Actual Result: #{value}"
    end

  rescue => exception
    puts exception.backtrace
    raise
  ensure
    set_implicit_wait(DEFAULT_WAIT_TIME)
  end
end

def check_columns_on_grid (column_name,grid_name)
  grid_id = @current_page.get_grid_id grid_name
  column_names = @current_page.cell_elements(:xpath => "//*[@id=\"gview_gdGridTable_#{grid_id}_dynamic\"]/div[2]/div/table//th/div").map(&:text)
  expect(column_names).to include(column_name.upcase), "#{column_name} value is not displayed "
  $log.info("#{column_name} value is displayed ")
end


World(Validations)