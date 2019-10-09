Feature: BAT (Smoke Tests)

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_01
  @DMW_BAT
  Scenario: OT - Validate Data Management Workbench Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Data Management Workbench menu item from Data Integration category
    Then I should be displayed with the "Data Management Workbench" page
    And I confirm the Data Management Workbench url SystemServices/main?system:runTemplate=plugins/datamap/com.bitstew.dataingestion/DI_Workbench.xml
    And I see Data Management Workbench title as the page header
    And I should be displayed with the "Data Integration Projects" panel

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_02
  @TMW_BAT
  Scenario: OT - Validate Tag Mapping Workbench Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Tag Mapping Workbench menu item from Data Integration category
    Then I should be displayed with the "Tag Mapping Workbench" page
    And I confirm the Tag Mapping Workbench url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=tag_mapping
    And I see Tag Mapping Workbench title as the page header
    And I should be displayed with the "Project Selection" panel

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_03
  Scenario:  OT - Validate Application Definition Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Application Definition menu item from Tools category
    Then I should be displayed with the "Application Definition" page
    And I confirm the Application Definition url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=application_packaging
    And I see Application Definition title as the page header
    And I should be displayed with the "Application Definition Projects" panel

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_04
  @Debugger_BAT
  Scenario: OT - Validate Director Debugger Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Director Debugger menu item from Tools category
    Then I should be displayed with the "Director Debugger" page
    And I confirm the Director Debugger url SystemServices/main?system:runTemplate=html/view/debugger/director-debugger.xml
    And I see XML Template Debugger title as the page header

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_05
  @Debugger_BAT
  Scenario: OT - Validate Director Service Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Director Services Debugger menu item from Tools category
    Then I should be displayed with the "Director Services Debugger" page
    And I confirm the Director Service Debugger url SystemServices/main?system:runTemplate=html/view/debugger/director-services-debugger.xml
    And I see XML Template Debugger title as the page header

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_06
  @StudioCatalog_BAT
  Scenario:  OT - Validate Studio Catalog Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Studio Catalog menu item from Tools category
    Then I should be displayed with the "Studio Catalog" page
    And I confirm the Studio Catalog url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=com_bitstew_bd_workbench1
    And I see Studio Catalog title as the page header

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_07
  @AppLogs_BAT
  Scenario:  OT - Validate Application Logs Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Application Logs menu item from Administration category
    Then I should be displayed with the "Application Logs" page
    And I confirm the Application Logs url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=logs_application
    And I see Application Logs title as the page header

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_08
  @AppLogs_BAT
  Scenario: DD-Check grid in Studio Catalog page
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I should not see Sensor Deployment menu item under Predix Apps menu category
    And I navigate to "Studio Catalog" page
    Then I should be displayed with the "Plugin Catalog" grid
    And I should be displayed with the "Catalog Plugins" ribbon
    And I should be displayed with the "Installed Plugins" ribbon
    And I should see more than or equal to 90 records in Plugin Catalog grid
    When I search for "sensor" using the "name" search field
    Then I should see "Sensor Deployment" record in the "Plugin Catalog" grid
    When I click "install" button
    And I select Flush Web Cache menu item from Administration category
    And I select Flush Service Cache menu item from Administration category
    And I select Flush Cluster Caches menu item from Administration category
    And I refresh the page
    And I navigate to "Sensor Deployment" page
    And I should be displayed with the "Installed" ribbon
    And I should be displayed with the "Exchanged" ribbon
    And I should be displayed with the "Planned" ribbon
    And I should be displayed with the "UTC" ribbon
    And I navigate to "Studio Catalog" page
    Then I should be displayed with the "Plugin Catalog" grid
    When I search for "sensor" using the "name" search field
    Then I should see "Sensor Deployment" record in the "Plugin Catalog" grid
    When I click "uninstall" button
    Then I should see Plugin has been successfully uninstalled. message on a growler
    And I refresh the page
    And I should not see Sensor Deployment menu item under Predix Apps menu category

  @Plugins
  @Plugins_BAT
  @Plugins_BAT_09
  @AppLogs_BAT
  Scenario: DD-Check grid in Application Logs page
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Application Logs" page
    Then I should be displayed with the "Application Logs" grid
    When I click on "Refresh logs grid." button
    And I should see more than or equal to 20 records in Application Logs grid
    When I search for "director-services.log" using the "name" search field
    Then I select first record from Application Logs grid
    When I click on "Open log file in new tab" button
    Then I switch to new tab and check for WARN text in the page
