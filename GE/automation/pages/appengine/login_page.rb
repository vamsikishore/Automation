class AppEngine_LoginPage
    include PageObject
    include PageFactory

# Page Objects:
    div                    :landing_page_logo,                   :id => 'logo-header'
    paragraph              :login_invalid_message,               :class =>'alert-error'
    text_field             :user_name,                           :name =>'username'
    text_field             :password,                            :name =>'password'
    button                 :login,                               :class =>'island-button'
    h1                     :application_authorization,           :xpath => '//div[1]/div[2]/div/h1'
    button                 :authorize_button,                    :id => 'authorize'

end
