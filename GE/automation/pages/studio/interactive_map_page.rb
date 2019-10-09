require_relative '../../pages/common/page_methods'
class Studio_MapVisualization < PageMethods

  include PageObject
  include PageFactory

# Page Objects:
    h1         :page_header,                                :id=>'pageTitle'
    div        :map,                                        :id=>'map_canvas'
    text_field :query_edit_box,                             :id=>'pac-input'

# Expected elements:
  expected_element(:query_edit_box, $page_load_time)
  expected_title /Interactive Map | Predix/
  expected_url $platform_url + $app_urls["Interactive Map"]


# Methods:
# Initial page validation
  def initialize_page
    has_expected_element?
    has_expected_title?
    has_expected_url?
  end

end



