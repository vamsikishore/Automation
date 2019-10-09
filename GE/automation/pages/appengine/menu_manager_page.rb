require_relative '../../pages/common/page_methods'

class AppEngine_MenuManger < PageMethods
  include PageObject
  include PageFactory


# Page Objects:
    div             :menu_item_category_list,                                 :class=>'panel-body'
    checkbox        :show_in_menu,                                            :name=>'IsMenu'
    text_field      :menu_item_title,                                         :id=>'ItemName'
    select_list     :menu_item_type,                                          :id=>'ItemType'
    text_field      :menu_item_order,                                         :id=>'ItemOrder'
    select_list     :menu_parent,                                             :id=>'ParentItem'
    select_list     :menu_item_path_type,                                     :id=>'UrlType'
    select_list     :menu_package_display_style,                              :id=>'TemplateType'
    text_field      :menu_description,                                        :id=>'Description'
    button          :delete,                                                  :id=>'delete'
    button          :update_button,                                           :id=>'update'
    select_list     :menu_predix_icon_type,                                   :id=>'selectPXIcons'
    label           :new_item_header,                                         :class => 'px-label-header'
    button          :add_new_item,                                            :id=>'new'
    select_list     :menu_icon_type,                                          :class=>'pxIconType'

# Expected Elements:
    expected_element(:page_header, $page_load_time)
    expected_title /Menu Manager | Predix/
    expected_url $platform_url + $app_urls["Menu Manager"]
    expected_header "Menu Manager"

# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
      check_page_header?
    end

    # Method used to click edit button of particular menu item
    def select_edit_button ele
      el = menu_item_category_list_element.div_elements.find {|e| e.scroll_into_view and e.text.downcase == ele.downcase}
      el.button_element.click
    end

    # Method to create a new menu item
  def create_new_menu_manager_item (file_name, data = {})
    create_record(file_name, data = {})
    update_button
    must_wait $click_time*2, "after creating record"
  end

end


