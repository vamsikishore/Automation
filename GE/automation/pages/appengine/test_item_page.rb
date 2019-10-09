require_relative '../common/grid_methods'

class TestItemPage < GridMethods
    include PageObject

# Page Objects:
    button        :page_settings,                       :id=>'configPage'
    label         :package_details,                     :class=>'px-label-header'
    select_list   :category,                            :id=>'indicatorCategory'
    select_list   :indicator,                           :id=>'indicatorOptions'
    button        :insert,                              :id=>'insertAnalytic'
    button        :close,                               :id=>'close'
    button        :delete,                              :id=>'delete'
    button        :confirm_delete,                      :id=>'delete'
    span          :grid_settings,                       :class=>'editAnalyticsFormBtn'

end
