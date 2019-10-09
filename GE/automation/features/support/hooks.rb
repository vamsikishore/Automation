

# Called by cucumber framework before scenario starts executing
FileUtils::mkpath './results' #Used by cucumber.yml

# Global Variables
$platform_url=ENV['URL']
$environment=ENV['ENV']
$username=ENV['UNAME']
$password=ENV['PASSWORD']
$sso_id=ENV['SSOID']
$build_number = ENV['JENKINS_BUILD']

# Ensure un-necessary failures do not occur with the user passing
# in a slightly different input from what is expected for $host_server
# In this case, we want to normalize the input
$url_scheme=ENV['URL'].split("://").first
$host_server=ENV['URL'].split("://").last

# in case if the url_scheme value isn't passed in, normalize this to https
if $url_scheme == $host_server or $url_scheme.nil?
  $url_scheme = 'https'
end

# Now if the host_server contains a / i.e abc.predix.studio/director
# then separate the server name from the application path
if $host_server.include? "/"
  $app_name=$host_server.partition("/").last
  $host_server=$host_server.split("/").first
end

# In case if the host_server started out as abc.predix.studio/ or
# abc.predix.studio then set the default application path as director
if $app_name.eql? "" or $app_name.nil?
  $app_name = "director"
end

# finally combine all parts of the URL protol, i.e the scheme, server and application
$platform_url="#{$url_scheme}://#{$host_server}/#{$app_name}"
$host_name_is_ip=(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/ === $host_server)

$browser_name = ENV['BROWSER']
$useProxy=ENV['USE_PROXY']
$proxy=ENV['PROXY']

# Verify if all of the "must have" inputs were provided from the command line
if ($username.nil? ) or ( $password.nil?) or( $environment.nil?) or ($sso_id.nil?)  or ($platform_url.nil?)
  raise 'Please provide "URL","UNAME" ,"PASSWORD", "ENV" and "SSOID" as part of the cucumber command line'
end

if ($useProxy.eql? "true") and ($proxy.nil?)
  raise 'Please provide a Proxy Server Address following the format PROXY=server:port as part of the cucumber command line'
end

$sys_os=RbConfig::CONFIG['host_os']
$page_load_time = PageObject.default_element_wait
$check_data_entered_time = 3
$click_time = 3
$app_urls = YAML.load_file('./test_data/urls.yml')
$class_names = YAML.load_file('./test_data/class_names.yml')

# Throw an error in case if UNAME parameter and the PASSWORD parameter do not match in length of inputs
if $environment == 'APPENGINE'
  if $username.include? "," and (($username.split(",").length) != ($password.split(",").length))
    raise("The number username and password inputs are not equal")
  end
else
  if $username.include? "," and (($username.split(",").length) != ($password.split(",").length)) and (($password.split(",").length) == ($sso_id.split(",").length))
    raise("The number username, password and sso_id inputs are not equal")
  end
end

# Called by cucumber framework before a scenario executed
Before do |scenario|
  # Initializing the log file
  @scenario_tags = scenario.source_tag_names
  log_initialization
  log_header(scenario)

  # Opening the browser
  if $browser_name.eql? "none"
    $log.info("Running without browser")
  elsif $browser_name.eql? "Saucelabs"
    saucelabs_session_start scenario
  else
    launch_browser
  end
end

# Called by cucumber framework after a scenario executed
After do |scenario|
  if $browser_name.eql? "none"
    $log.info("Finished running without browser")
  elsif $browser_name.eql? "Saucelabs"
    saucelabs_session_end scenario
  elsif scenario.failed?
    fetch_failed_tags
    $log.info("Failed tags added to the failed_tags.txt file")
    take_screenshot
    $log.info("Screenshot from failed tags attached to the html report")
  end
    $browser.quit
    $log.info "Browser closed"
    log_footer(scenario)
end

#This method is used for generating html and Json reports:
at_exit do
  ReportBuilder.configure do |config|
    config.report_types = [:json, :html]
    config.report_title = 'PREDIX'+' '+$environment.capitalize
    config.additional_info = {Browser: $browser_name, Environment: $environment ,URL: $platform_url}
  end
  ReportBuilder.build_report
end


# This method is used to initialize the logs in framework
def log_initialization
  $log = Logger.new("./log//cucumber_#{Time.now.strftime('%Y_%m_%d-%HH_%MM_%SS_%LS')}.log")
  $log.formatter = proc do |severity, datetime, progname, msg|
    "#{msg}\n"
  end
end

#This method is to create session for Sauce labs
def saucelabs_session_start scenario
  opt = {name: "#{scenario.feature.name} - #{scenario.name}",
         build: $build_number,
         username: "vsundara",
         accessKey: "ac9da40f-6cde-450f-8c67-903fe6e2f759"}
  opt.merge! YAML.safe_load(IO.read('features/support/platforms.yml'))[platform]
  caps = Selenium::WebDriver::Remote::Capabilities.send(opt.delete('browser_name').to_sym, opt)
  url = "https://ondemand.saucelabs.com:443/wd/hub"
  $browser = Selenium::WebDriver.for(:remote, url: url, desired_capabilities: caps)
  $log.info "Browser opened"
  # #clearing the cookies:
  $browser.manage.delete_all_cookies
  $log.info "Browser cookies deleted"
  @browser = $browser
  $log.info "Browser ready"
end

def submit_results(session_id, result)
  SauceWhisk::Jobs.change_status(session_id, result)
end

def platform
  ENV['PLATFORM'] || 'parallel_run'
end

def saucelabs_session_end scenario
  submit_results($browser.session_id, scenario.passed?)
  $browser.quit
end

# This method is used to launch the particular browser, clear the cookies and maximize the browser
def launch_browser
  if $browser_name.eql? "firefox"
    setting_profile_for_firefox_browser
    $log.info "Browser opened"
  elsif $browser_name.eql? "headless-firefox"
    display = "999"
    @headless = Headless.new(:display => display)
    @headless.start
    setting_profile_for_firefox_browser
    $log.info "Browser opened in headless mode"
  elsif $browser_name.eql? "windows-chrome"
    Selenium::WebDriver::Chrome.driver_path = File.join(Dir.pwd, './drivers/windows/chromedriver.exe')
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: {browser: 'ALL'})
    $browser = Selenium::WebDriver.for(:chrome, desired_capabilities: caps)
    $log.info "Browser opened"
  elsif $browser_name.eql? "mac-chrome"
    Selenium::WebDriver::Chrome.driver_path = File.join(Dir.pwd, './drivers/mac/chromedriver')
    if $useProxy.eql? "true"
      caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: {browser: 'ALL'}, "chromeOptions" => {"args" => ["--ignore-certificate-errors", "--proxy-server=" + $proxy]})
    else
      caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: {browser: 'ALL'})
    end
    $browser = Selenium::WebDriver.for :chrome, desired_capabilities: caps
    $log.info "Browser opened"
  elsif $browser_name.eql? "headless-chrome"
    attempts = 0
    begin
      display = "999"
      @headless = Headless.new(:display => display)
      @headless.start
      if $useProxy.eql? "true"
        caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => { 'args' => ['--no-sandbox', '--headless', "--ignore-certificate-errors", "--proxy-server=" + $proxy]})
      else
        caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => { 'args' => ['--no-sandbox', '--headless']})
      end
      $browser = Selenium::WebDriver.for(:chrome, desired_capabilities: caps)
    rescue Net::ReadTimeout => e
      if attempts == 0
        attempts += 1
        $log.info("Trying to open the browser again")
        retry
      else
        raise 'Browser could not be launched'
      end
    end
    $log.info "Browser opened"

  elsif $browser_name.eql? "ie"
    Selenium::WebDriver::IE.driver_path = File.join(Dir.pwd, './drivers/windows/IEDriverServer.exe')
    $browser=Selenium::WebDriver.for :ie
    $log.info "Browser opened"
    #Use this "windows-headless-chrome" as BROWSER to run automation in Windows on headless mode
  elsif $browser_name.eql? "windows-headless-chrome"
    Selenium::WebDriver::Chrome.driver_path = File.join(Dir.pwd, './drivers/windows/chromedriver.exe')
    # configure the driver to run in headless mode
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    $browser = Selenium::WebDriver.for :chrome, options: options
    $browser.manage.window.resize_to(1366, 768)
  #Use this "mac-headless-chrome" as BROWSER to run automation in Mac  headless mode
  elsif $browser_name.eql? "mac-headless-chrome"
    Selenium::WebDriver::Chrome.driver_path = File.join(Dir.pwd, './drivers/mac/chromedriver')
    # configure the driver to run in headless mode
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    $browser = Selenium::WebDriver.for :chrome, options: options
    $browser.manage.window.resize_to(1366, 768)
  else
    raise 'Invalid browser'
  end

  # Resizing the browser:
  #$browser.manage.window.maximize
  $browser.manage.window.resize_to(1366, 768)
  $browser.manage.window.move_to(-8,-8)
  $log.info "Browser window maximized"

  # Clearing the cookies:
  $browser.manage.delete_all_cookies
  $log.info "Browser cookies deleted"
  @browser=$browser
end

# This method is used to sleep the browser during a given time
def must_wait time, text
  sleep time
  $log.info("Sleeping for #{time} seconds #{text}")
end

# This is method is used to scroll up the page
def scroll_up
  $browser.get "javascript:window.scrollBy(0,0)"
end

# This method is used to scroll down the page
def scroll_down
  $browser.execute_script("scroll(0, 260)")
end

# This method is used to scroll left the page
def scroll_left
  $browser.execute_script("scroll(260, 0)")
end
# This method is used to add header for the log file
def log_header(scenario)
  $log.info"\n**************************************************************************************"
  $log.info "Feature: #{scenario.feature.short_name}"
  $log.info "Scenario: #{scenario.name}"
  $log.info "Tags: #{@scenario_tags}"
  $log.info "Total steps: #{scenario.step_count}"
  $log.info"***************************************************************************************\n"
end

# This method is used to add footer for the log file
def log_footer(scenario)
  $log.info"\n**************************************************************************************"
  $log.info "Status: #{scenario.status}"
  $log.info"***************************************************************************************\n"
end

def fetch_failed_tags
  failed_tags = File.new("failed_tags.txt", "a+")
  failed_tags.puts("#{@scenario_tags[2]}")
  failed_tags.close
end

# This method is used to take the screen shot and attach it to the reports
def take_screenshot
  Dir::mkdir('screenshots_failed_tests') if not File.directory?('screenshots_failed_tests')
  screenshot_file ="./screenshots_failed_tests/screenshot-#{Time.now.strftime('%Y-%m-%d %H-%M-%S')}.png"
  $browser.save_screenshot(screenshot_file)
  encoded_img = $browser.screenshot_as(:base64)
  embed("data:image/png;base64,#{encoded_img}",'image/png')
end

# this method is used to setting profile to firefox browser to download file from application...etc
def setting_profile_for_firefox_browser
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = Dir.pwd
  profile['browser.download.folderList'] = 2
  profile['browser.helperApps.neverAsk.saveToDisk'] = "text/xml"
  profile['pdfjs.disabled'] = true
  profile['browser.download.manager.showWhenStarting'] = false
  profile['browser.loggingPrefs'] = 'level'
  begin
    $browser = Selenium::WebDriver.for :firefox, :profile => profile
    $log.info("Trying to open the browser - first try")
  rescue Selenium::WebDriver::Error::WebDriverError
    $browser = Selenium::WebDriver.for :firefox, :profile => profile
    $log.info("Trying to open the browser - second try")
  rescue Selenium::WebDriver::Error::WebDriverError
    $browser = Selenium::WebDriver.for :firefox, :profile => profile
    $log.info("Trying to open the browser - third try")
  end
end


# Acceptable inputs for role_name =  admin, power, user, developer, env_owner
# Acceptable input for credentials_type = username, password, sso_id
# This step will check if multiple user roles were passed through the command line
# And return user login creds as specified in step definitions
def get_role_credentials role_name, credentials_type

  if ENV['UNAME'].include? ","

    # Default values to continue supporting the existing test cases
    valid_username = ENV['UNAME'].split(",")[0]
    valid_sso_id   = ENV['SSOID'].split(",")[0]
    valid_password = ENV['PASSWORD'].split(",")[0]

    # Check if the usernames contain  ","
    # If so, then we have a multiple users input

    num_of_users = ENV['UNAME'].count(",") + 1
    num_of_passwords = ENV['PASSWORD'].count(",") + 1
    num_of_sso_id = ENV['SSOID'].count(",") + 1

    if num_of_users > 3
      raise "Passing in more than 3 users for the UNAME parameter is not supported"
    elsif num_of_users != num_of_passwords
      raise "Number of users passed within UNAME parameter don't match with the number of passwords passed with PASSWORD parameter"
    end

    case $environment
    when 'STUDIO'
      # Studio related user roles
      if num_of_users != num_of_sso_id
        raise "Number of users passed within UNAME parameter don't match with the number of SSOs passed with SSOID parameter"
      end
      admin_username     = ENV['UNAME'].split(",")[0]
      developer_username = ENV['UNAME'].split(",")[1]
      env_owner_username = ENV['UNAME'].split(",")[2]

      admin_sso_id       = ENV['SSOID'].split(",")[0]
      developer_sso_id   = ENV['SSOID'].split(",")[1]
      env_owner_sso_id   = ENV['SSOID'].split(",")[2]

      admin_password     = ENV['PASSWORD'].split(",")[0]
      developer_password = ENV['PASSWORD'].split(",")[1]
      env_owner_password = ENV['PASSWORD'].split(",")[2]

    when 'APPENGINE'
      # AppEngine user roles
      admin_username = ENV['UNAME'].split(",")[0]
      power_username = ENV['UNAME'].split(",")[1]
      user_username  = ENV['UNAME'].split(",")[2]

      admin_sso_id   = ENV['SSOID'].split(",")[0]
      power_sso_id   = ENV['SSOID'].split(",")[1]
      user_sso_id    = ENV['SSOID'].split(",")[2]

      admin_password = ENV['PASSWORD'].split(",")[0]
      power_password = ENV['PASSWORD'].split(",")[1]
      user_password  = ENV['PASSWORD'].split(",")[2]

    when 'PORTAL'
      # Portal user roles
      if num_of_users != num_of_sso_id
        raise "Number of users passed within UNAME parameter don't match with the number of SSOs passed with SSOID parameter"
      end
      developer_username = ENV['UNAME'].split(",")[0]
      env_owner_username = ENV['UNAME'].split(",")[1]

      developer_sso_id   = ENV['SSOID'].split(",")[0]
      env_owner_sso_id   = ENV['SSOID'].split(",")[1]

      developer_password = ENV['PASSWORD'].split(",")[0]
      env_owner_password = ENV['PASSWORD'].split(",")[1]

    else
      raise("Please check if the environment name '#{$environment}' is correct")
    end
  else
    # Default values to continue supporting the existing test cases
    valid_username = ENV['UNAME']
    valid_sso_id   = ENV['SSOID']
    valid_password = ENV['PASSWORD']

    num_of_passwords = ENV['PASSWORD'].count(",") + 1
    # If the passwords include commas then we have a problem parsing them as a passed in string
    if num_of_passwords > 1
      puts 'WARNING: Having a "," (comma) in your password may cause unexpected failures in test automation'
      puts 'Please change your password to something without commas'
    end
  end

  $last_used_username = eval("#{role_name}_username")
  eval("#{role_name}_#{credentials_type}")
end
