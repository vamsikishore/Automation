require 'rspec'
require 'page-object'
require 'data_magic'
require 'logging'
require 'logger'
require 'pry'
require 'webdrivers'
require 'selenium-webdriver'
require 'faker'


World(PageObject::PageFactory)

PageObject.default_element_wait = 5
PageObject.default_page_wait = 120


DataMagic.yml_directory ='test_data'
