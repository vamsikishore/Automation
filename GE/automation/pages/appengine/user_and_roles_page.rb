require_relative '../common/grid_methods'

class AppEngine_UsersAndRoles < GridMethods
  include PageObject
  include DataMagic


  # Expected elements:
  expected_element(:page_header, $page_load_time)
  expected_title /Roles Management | Predix/
  expected_url $platform_url + $app_urls["Roles Management"]
  expected_header "Roles Management"


  # Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
    check_page_header?
  end

  # Methods:

#--------------page elements hidden by a shadow DOM
    def get_dom_ele variable_name, grid_name
      if grid_name == "groups"
        grid = "document.getElementsByTagName('px-data-grid-paginated')[0]"
      elsif grid_name == "policies"
        grid = "document.getElementsByTagName('px-data-grid-paginated')[1]"
      elsif grid_name == "roles"
        grid = "document.querySelectorAll('div.panel.panel-default.element')[3]"
      else
        raise("#{grid_name} not defined or unknown")
      end

      var_array = {
          # Roles grid shadow DOM element are listed here
          "duplicate_role_error_message"   => "document.querySelector('small#invalidTitleError.caps.form-field__help.validation-error').innerText",
          "roles_grid_filter"              => "document.querySelector('px-typeahead').root.querySelector('input.text-input.search__box')",
          "select_first_role"              => "document.querySelector(\"px-tile.px-tile[style='display: block;']\").root.querySelector('px-tile-action-buttons#pxTilePrimaryBtns').root.querySelector(\"px-icon[icon='px-nav:open-context']\")",
          "edit_role_pencil_icon"          => "document.querySelector(\"px-tile.px-tile[style='display: block;']\").root.querySelector('px-tile-action-buttons#pxActionButtons').root.querySelector(\"px-icon[icon='px-utl:edit']\")",
          "delete_role_trash_icon"         => "document.querySelector(\"px-tile.px-tile[style='display: block;']\").root.querySelector('px-tile-action-buttons#pxActionButtons').root.querySelector(\"px-icon[icon='px-utl:delete']\")",
          "confirm_role_edit_check_icon" => "document.querySelector(\"px-tile.px-tile[style='display: block;']\").root.querySelector('px-tile-action-buttons#pxActionButtons').root.querySelector(\"px-icon[icon='px-utl:confirmed']\")",
          "confirm_role_create_check_icon" => "document.querySelector(\"px-tile.px-tile\").root.querySelector('px-tile-action-buttons#pxActionButtons').root.querySelector(\"px-icon[icon='px-utl:confirmed']\")",
          "cancel_role_edit_close_icon"  => "document.querySelector(\"px-tile.px-tile\").root.querySelector('px-tile-action-buttons#pxActionButtons').root.querySelector(\"px-icon[icon='px-utl:close']\")",

          # Policies and Groups grid shadow DOM element are listed here
          "grid"                   => grid,
          "grid_filter"            => "#{grid}.root.querySelector('px-data-grid').root.querySelector('px-auto-filter-field').root.querySelector('input.text-input')",
          "grid_data"              => "#{grid}.getData()",
          "pages_list"             => "#{grid}.root.querySelector('px-data-grid-navigation').root.querySelectorAll('button.page-button.page-number')",
          "next_page_arrow"        => "#{grid}.root.querySelector('px-data-grid-navigation').root.querySelector('button.page-button.arrow.next')",
          "prev_page_arrow"        => "#{grid}.root.querySelector('px-data-grid-navigation').root.querySelector('button.page-button.arrow.back')",
      }
      return var_array[variable_name]
    end

  #This method is to get total number of records in the grid
  def get_tot_num_of_records_all_pages grid_name
    case grid_name
    when "roles"
      return $browser.execute_script("return document.querySelectorAll('div.px-tile-container').length").to_i
    when "policies", "groups"
      return ($browser.execute_script("return #{get_dom_ele 'grid', grid_name}.size")).to_i
    else
      raise("LOGIC NOT IMPLEMENTED FOR #{grid_name} GRID")
    end
  end

  end

