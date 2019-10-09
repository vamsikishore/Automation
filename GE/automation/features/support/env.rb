#Documentation for libraries usage and examples https://www.rubydoc.info/
#Documentation for DOM http://docs.w3cub.com/

require 'rspec'
require 'selenium-webdriver'
require 'page-object'
require 'rubygems'
require 'data_magic'
require 'yaml'
require 'require_all'
require 'yml_reader'
require 'logging'
require 'logger'
require 'fileutils'
require 'clipboard'
require 'csv'
require 'rest-client'
require 'nokogiri'
require 'pry'
require 'headless'
require 'sauce_whisk'
require 'open-uri'
require 'report_builder'
include DataMagic

World(PageObject::PageFactory) # Injecting PageFactory into Cucumber World instance
PageObject.default_element_wait = 5
PageObject.default_page_wait = 120
DataMagic.yml_directory ='test_data'

#Method to wait until web page gets completely loaded
def wait_for_page_load
  @current_page.wait_until(300) do
    expect($browser.execute_script("return document.readyState == 'complete' ")).to be_truthy,"#{@current_page} page wasn’t loaded"
  end
end
