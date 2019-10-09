require_relative '../../pages/common/page_methods'

class Studio_About < PageMethods

  include PageObject
  include PageFactory

# Page Objects:
    div          :installation_details_section,                 :class => 'well'
    p            :version_number,                               :class=>'form-control'


# Expected Elements:
    expected_element(:version_number, $page_load_time)
    expected_title /About Predix Studio | Predix/
    expected_url $platform_url + $app_urls["About Predix Studio"]


# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
    end



end