
# Called by cucumber framework before scenario starts executing
Before do
  # initializing the log file
  log_initialization
  launch_browser
end

# Called by cucumber framework after scenario executed
After do |scenario|
  if scenario.failed?
    take_screenshot
    $browser.quit
  end
  @browser.quit
  $log.info "closing the browser"
end


# this method is used to initialize the logs in framework
def log_initialization
  $log = Logger.new("./log//news360_#{Time.now.strftime('%Y_%m_%d')}.log")
  $log.info "log is initialized"
end

#launch_browser method is used to launch the particular browser, clear the cookies and maximize the browser
def launch_browser
  $browser = Selenium::WebDriver.for :chrome
  $browser.manage.window.maximize
  $log.info "Web browser Maximized"

  #clearing the cookies
  $browser.manage.delete_all_cookies
  $log.info "deleted all cookies"
  @browser=$browser
end

#take_screenshot is used to take the screen shot and attach the screenshot to the reports
def take_screenshot
  Dir::mkdir('screenshots_failed_tests') if not File.directory?('screenshots_failed_tests')
  screenshot_file ="./screenshots_failed_tests/screenshot-#{Time.now.strftime('%Y-%m-%d %H-%M-%S')}.png"
  $browser.save_screenshot(screenshot_file)
  encoded_img = @browser.screenshot_as(:base64)
  embed("data:image/png;base64,#{encoded_img}",'image/png')
end





