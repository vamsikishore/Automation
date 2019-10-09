$:.unshift File.dirname('../pages/common/page_methods')
class StudioLoginPage < PageMethods
    include PageObject
    include PageFactory
# Expected elements:
    expected_element(:predix_studio_next_or_login_button, $page_load_time)
    expected_title /Predix/
    expected_url "https://login.system.aws-usw02-dev.ice.predix.io/login"

# Methods:
# Initial page validation
    def initialize_page
        has_expected_element?
        has_expected_title?
        has_expected_url?
    end

# Page Objects:
        h4                     :predix_studio_sign_in_text,          :xpath => '//div/div/div[2]/h4'
        button                 :predix_studio_next_or_login_button,  :xpath =>'//form/div[2]/input'
        h4                     :predix_studio_email_text,            :id =>'email'
        h1                     :application_authorization,           :xpath => '//div[1]/div[2]/div/h1'
        button                 :authorize_button,                    :id => 'authorize'
        text_field             :ge_user_name,                        :id =>'username'
        text_field             :ge_passowrd,                         :id=>'password'
        button                 :ge_login_button,                     :id =>'submitFrm'
        h4                     :login_page_header,                   :xpath => '//*[@id="row"]/h4'
        div                    :ge_login_page_validation_message,    :xpath => '//*[@id="passid"]/table/tbody/tr/td/table/tbody/tr/td/div/div'

 end
