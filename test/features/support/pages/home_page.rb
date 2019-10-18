require 'selenium-webdriver'
require 'page-object'

class HomePage
  include PageObject
  include PageFactory


button  :signin_button,     :class=>'ap-intro-signin-button'
  h1          :model_title,  :class=>'modal-title'
  button      :use_your_email,  :class=>'common-button'
  link              :sign_up_button,  :text=>'Sign up to News360'
  text_field      :email_field,       :xpath=>'//div/div/form/div[1]/input'
  text_field            :password,     :xpath=>'//div/div/form/div[2]/input'
  button                  :sign_up,     :xpath=>'//div/form/button[2]'
  link                          :signout,  :text=>'Sign out'
  link                        :avatar,      :class=>'topbar-avatar'
  button               :start_reading_signin, :class =>'recommendation-build-button'
  button                      :signin,      :xpath=>'//div/div/form/button'

end
