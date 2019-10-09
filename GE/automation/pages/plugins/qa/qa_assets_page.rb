$:.unshift File.dirname('../pages/common/grid_methods')
class Plugin_QAAssets  < GridMethods
include PageObject

# Page Objects:
    h1            :page_header,                        :class => 'name'
    elements      :indicator_titles,    :h4,       :xpath=>'//div[@class="panel-heading"]/div[2]/h4'
    divs          :grid_title,                               :xpath=>'//div[contains(@class, "panel-title")]/h4'
    button        :button_map_feed,                    :xapth=>'//*[@id="header"]/div[2]/div[1]'
    h1            :interactive_map_feed_text,          :xpath=>'//*[@id="mapControlPaneContent"]/div/h1'
    button        :left_slider_open,                   :id=>'leftSlider-openBtn'
    div           :interactive_map_left_slider_button, :xpath=>'//*[@id="leftSlider-openBtn"]'

end

