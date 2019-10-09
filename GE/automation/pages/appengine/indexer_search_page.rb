require_relative '../common/grid_methods'

class AppEngine_IndexerSearch < GridMethods
  include PageObject

# Page Objects:
    text_field      :indexer_search_indices_textbox,                   :id => 'indices-input'
    text_field      :indexer_search_types_textbox,                     :id => 'types-input'
    button          :search_button,                                    :id => 'run'
    select_list     :indexer_search_example_queries_list,              :id => 'exampleQueries'
    elements        :indexer_search_indices_values,          :tr,      :xpath => './/*[@class="docsTblRow"]'
    button          :search,                                           :id => 'run'

# Expected Elements:
    expected_element(:search_button, $page_load_time)
    expected_title /Indexer Search | Predix/
    expected_url $platform_url + $app_urls["Indexer Search"]
    expected_header "Indexer Search"

# Methods:
    # Initial page validation
    def initialize_page
      has_expected_element?
      has_expected_title?
      has_expected_url?
      check_page_header?
    end

end

