Feature: BAT (Smoke Tests)

  @Studio
  @Studio_BAT
  @Studio_BAT_01
  Scenario: SE - Valid Login
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I should be able to see the menu items and the logged user name
    When I click on log out under user profile
    Then I should be displayed with the "Predix development network" page

  @Studio
  @Studio_BAT
  @Studio_BAT_02
  Scenario: OT - Validate Alert Analysis Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Alerts Analysis Workbench menu item from Predix Apps category
    Then I should be displayed with the "Alert Analysis" page
    And I confirm the Alerts Analysis url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=alerts_analysis
    And I see Alerts Analysis title as the page header

  @Studio
  @Studio_BAT
  @Studio_BAT_03
  Scenario: CM - Validate Interactive Map Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Configuration Manager" page
    And I should see more than or equal to 1 records in Manage Configuration grid
    When I search and select the "__GOOGLE_MAPS_API_KEY_" record using the "name" field
    And I click "Edit" button
    And I enter "AIzaSyALxYGGr6eHrEojBO7dJum4vPnr6xJQIaU" in the "Value" field of "Edit Record"
    And I click "Update" button
    And I select Flush Web Cache menu item from Administration category
    And I select Flush Service Cache menu item from Administration category
    And I select Flush Cluster Caches menu item from Administration category
    And I refresh the page
    And I select Full Map View menu item from Predix Apps category
    Then I should be displayed with the "Interactive Map" page
    Then I confirm the Interactive Map url SystemServices/main?system:runTemplate=html/view/EventMap.xml
    When I search for "Vancouver" using the "query" search field
    Then I see "Vancouver" marker

  @Studio
  @Studio_BAT
  @Studio_BAT_04
  Scenario: OT - Validate Data Dictionary Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Data Dictionary menu item from Data Integration category
    Then I should be displayed with the "Data Dictionary" page
    And I confirm the Data Dictionary url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=dictionary_management
    And I see Data Dictionary Manager title as the page header

  @Studio
  @Studio_BAT
  @Studio_BAT_06
  Scenario: OT - Validate Dynamic Adapters Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Dynamic Adapters menu item from Data Integration category
    Then I should be displayed with the "Dynamic Adapters" page
    And I confirm the Dynamic Adapters url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=plugin_adapters
    And I see Dynamic Adapters title as the page header

  @Studio
  @Studio_BAT
  @Studio_BAT_16
  Scenario:  OT - Validate Indexer Search Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Indexer Search menu item from Data Integration category
    Then I should be displayed with the "Indexer Search" page
    And I confirm the Indexer Search url SystemServices/main?system:runTemplate=plugins/manage/com.bitstew.director-services.indexersearch/search.xml
    And I see Indexer Search title as the page header


  @Studio
  @Studio_BAT
  @Studio_BAT_17
  Scenario:  OT - Validate Run Import Adapters Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Run Import Adapters menu item from Data Integration category
    Then I should see The import process has been started, please review the import log for a status update. message on a growler

  @Studio
  @Studio_BAT
  @Studio_BAT_25
  Scenario:  OT - Validate Plugin Manager Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Plugins Manager menu item from Tools category
    Then I should be displayed with the "Plugins Manager" page
    And I confirm the Plugins Manager url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=plugins_management
    And I see Plugins Manager title as the page header

  @Studio
  @Studio_BAT
  @Studio_BAT_32
  Scenario:  OT - Validate Indexer Backup Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Indexer Backup" page
    And I should be displayed with the "Repositories" grid
    And I should be displayed with the "Snapshots" grid
    And I confirm the Indexer Backup url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=indexer_backup
    And I see Indexer Backup title as the page header

  @Studio
  @Studio_BAT
  @Studio_BAT_33
  Scenario:  OT - Validate About Studio Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select About Predix Studio menu item from Support category
    Then I should be displayed with the "About Predix Studio" page
    And I confirm the About Predix Studio url SystemServices/main?system:runTemplate=html/view/About.xml

  @Studio
  @Studio_BAT
  @Studio_BAT_34
  Scenario: AA-Check grid in Alert Analysis page
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Alerts Analysis" page
    Then I should be displayed with the "Manage Status and Alerts Definitions" grid
    And I should be displayed with the "Active Alarms" ribbon
    And I should be displayed with the "Muted Alarms" ribbon
    And I should be displayed with the "Assurance" ribbon
    And I should be displayed with the "Dispatch" ribbon
    And I should be displayed with the "Caution" ribbon

  @Studio
  @Studio_BAT
  @Studio_BAT_35
  Scenario: DD-Check grid and click Sync canonical model in Data Dictionary page
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Data Dictionary" page
    Then I should be displayed with the "Manage Data Dictionary" grid
    When I click on "Sync canonical model" button
    And I should see more than or equal to 12000 records in Manage Data Dictionary grid

  @Studio
  @Studio_BAT
  @Studio_BAT_36
  Scenario: DD-Check grid in Plugin manager page
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Plugins Manager" page
    Then I should be displayed with the "Manage Plugins" grid
    And I should see more than or equal to 41 records in Manage Plugins grid
    When I search for "Asset Tree" using the "name" search field
    When I delete "Asset Tree" record from the grid
    When I search for "Asset Tree" using the "name" search field
    Then I should not see "Asset Tree" record in the "Manage Plugins" grid
    When I click "import_all_from_disk" button
    When I search for "Asset Tree" using the "name" search field
    Then I should see "Asset Tree" record in the "Manage Plugins" grid


