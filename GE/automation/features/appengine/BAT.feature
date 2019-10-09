Feature: BAT (Smoke Tests)

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_01
  Scenario: CM - Add Google Key and display the Interactive Map
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
    And I navigate to "Interactive Map" page
    Then I confirm the Interactive Map url SystemServices/main?system:runTemplate=html/view/EventMap.xml
    When I search for "Vancouver" using the "query" search field
    Then I see "Vancouver" marker

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_02
  Scenario: SE - Invalid Login
    Given I navigate to AppEngine/Studio/Portal/AppExt url
    Then I should be displayed with the "Open Application" page
    When I click "Open Application" button
    Then I should be displayed with the "Predix_login" page
    When I enter invalid credentials I see an error message
      | admin |         | Unable to verify email or password. Please try again. |
      |       | Prov1ng | Unable to verify email or password. Please try again. |

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_03
  Scenario: OT - Validate Dynamic Adapters Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Dynamic Adapters menu item from Tools category
    Then I should be displayed with the "Dynamic Adapters" page
    And I confirm the Dynamic Adapters url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=plugin_adapters
    And I see Dynamic Adapters title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_04
  Scenario:  OT - Validate Indexer Search Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Indexer Search menu item from Tools category
    Then I should be displayed with the "Indexer Search" page
    And I confirm the Indexer Search url SystemServices/main?system:runTemplate=plugins/manage/com.bitstew.director-services.indexersearch/search.xml
    And I see Indexer Search title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_05
  @Studio
  @Studio_BAT
  @Studio_BAT_05
  Scenario:  OT - Validate Business Rules Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Business Rules menu item from Tools category
    Then I should be displayed with the "Business Rules" page
    And I confirm the Business Rules url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=rules_management
    And I see Business Rules Manager title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_06
  Scenario:  OT - Validate Application Manager Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Application Management menu item from Administration category
    Then I should be displayed with the "Application Management" page
    And I confirm the Application Management url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=application_management
    And I see Application Management title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_07
  @Studio
  @Studio_BAT
  @Studio_BAT_07
  Scenario:  OT - Validate Roles Management Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Roles Management menu item from Administration category
    Then I should be displayed with the "Roles Management" page
    And I confirm the Roles Management url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=role_management
    And I see Roles Management title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_08
  @Studio
  @Studio_BAT
  @Studio_BAT_08
  Scenario:  OT - Validate Menu Manager Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Menu Manager menu item from Administration category
    Then I should be displayed with the "Menu Manager" page
    And I confirm the Menu Manager url SystemServices/main?system:runTemplate=html/view/SiteMapManagement.xml
    And I see Menu Manager title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_09
  @Studio
  @Studio_BAT
  @Studio_BAT_09
  Scenario:  OT - Validate Configuration Manager Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Configuration Manager menu item from Administration category
    Then I should be displayed with the "Configuration Manager" page
    And I confirm the Configuration Manager url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=config_management
    And I see Configuration Management title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_10
  @Studio
  @Studio_BAT
  @Studio_BAT_10
  Scenario:  OT - Validate System Activity Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select System Activity menu item from Administration category
    Then I should be displayed with the "System Activity" page
    And I confirm the System Activity url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=system_activity
    And I see System Activity title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_11
  @Studio
  @Studio_BAT
  @Studio_BAT_11
  Scenario:  OT - Validate Router Management Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Router Management menu item from Administration category
    Then I should be displayed with the "Router Management" page
    And I confirm the Router Management url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=router_management
    And I see Router Manager title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_12
  @Studio
  @Studio_BAT
  @Studio_BAT_12
  Scenario:  OT - Validate Scheduler Management Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Scheduler Management menu item from Administration category
    Then I should be displayed with the "Scheduler Management" page
    And I confirm the Scheduler Management url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=scheduler_management
    And I see Scheduler Manager title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_13
  @Studio
  @Studio_BAT
  @Studio_BAT_13
  Scenario:  OT - Validate Registry Management Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Registry Management menu item from Administration category
    Then I should be displayed with the "Registry Management" page
    And I confirm the Registry Management  url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=registry_management
    And I see Registry Manager title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_14
  @Studio
  @Studio_BAT
  @Studio_BAT_14
  Scenario:  OT - Validate Log Files Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Log Files menu item from Administration category
    Then I should be displayed with the "Log Files" page
    And I confirm the Log Files url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=log_management
    And I see Manage Logs title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_15
  @Studio
  @Studio_BAT
  @Studio_BAT_15
  Scenario:  OT - Validate Indexer Health Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Indexer Health menu item from Administration category
    Then I should be displayed with the "Indexer Health" page
    And I should be displayed with the "Cluster" grid
    And I should see more than or equal to 1 records in Cluster grid
    And I should be displayed with the "Nodes" grid
    And I should see more than or equal to 1 records in Nodes grid
    And I should be displayed with the "Indices" grid
    And I should see more than or equal to 1 records in Indices grid
    And I confirm the Indexer Health url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=indexer_health
    And I see Indexer Health title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_17
  Scenario:  OT - Validate About App Engine Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select About App Engine menu item from Support category
    Then I should be displayed with the "About AppEngine" page
    And I confirm the About AppEngine url SystemServices/main?system:runTemplate=html/view/About.xml

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_18
  @Studio
  @Studio_BAT
  @Studio_BAT_18
  Scenario:  OT - Validate Flush Web Cache Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Flush Web Cache menu item from Administration category
    Then I should see The Web cache has been flushed. message on a growler

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_19
  @Studio
  @Studio_BAT
  @Studio_BAT_19
  Scenario:  OT - Validate Flush Service Cache Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Flush Service Cache menu item from Administration category
    Then I should see The Service cache has been flushed. message on a growler

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_20
  @Studio
  @Studio_BAT
  @Studio_BAT_20
  Scenario:  OT - Validate Flush Cluster Caches Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Flush Cluster Caches menu item from Administration category
    Then I should see The cluster caches have been flushed. message on a growler

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_21
  @Studio
  @Studio_BAT
  @Studio_BAT_21
  Scenario:  OT - Validate Reload Indexer Aliases Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Reload Indexer Aliases menu item from Administration category
    Then I should see Indexer aliases have been reloaded message on a growler

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_22
  @Studio
  @Studio_BAT
  @Studio_BAT_22
  Scenario:  OT - Validate Reload Map Plugins Page Rendering
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I select Reload Map Plugins menu item from Administration category
    Then I should see Interactive Map plugins have been reloaded message on a growler

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_23
  @Studio
  @Studio_BAT
  @Studio_BAT_23
  Scenario: DA - Import and Run a Dynamic Adapter then query data with Indexer Search
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Indexer Search" page
    When I enter "assets" in the "indices" field of "Search Conditions panel"
    And I click "Search" button
    #Then I should not see "AST_1" record in the "Indexer Results" grid
    When I navigate to "Dynamic Adapters" page
    And I search for "AppEngine_BAT_DA" using the "Adapter Id" search field
    And I find an existent "AppEngine_BAT_DA" record
    Then I delete "AppEngine_BAT_DA" record from the grid
    When I click "Restore" button
    Then I should be displayed with the "Import XML" popup
    When I enter the "AppEngine_BAT_DA" adapter definition in the text area
    And I click "Import" button
    Then I should see Configuration XML successfully restored. message on a growler
    When I search and select the "AppEngine_BAT_DA" record using the "Adapter Id" field
    And I click "Run" button
    Then I should see Action completed with no errors. message on a growler
    When I navigate to "Indexer Search" page
    And I enter "assets" in the "indices" field of "Search Conditions panel"
    And I enter "Asset" in the "types" field of "Search Conditions panel"
    And I uncheck "displayCharts" on Search Conditions panel
    And I select Match Query option on Search Conditions panel
    And I enter {"match":{ "id":"AST_1"}} into query definition
    And I click "Search" button
    Then I should see "AST_1" record in the "Indexer Results" grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_23
  @Studio
  @Studio_BAT
  @Studio_BAT_23
  Scenario: DA - Delete Dynamic Adapter
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Dynamic Adapters" page
    When I search for "AppEngine_BAT_DA" using the "Adapter Id" search field
    And I find an existent "AppEngine_BAT_DA" record
    Then I delete "AppEngine_BAT_DA" record from the grid
    When I search for "AppEngine_BAT_DA" using the "Adapter Id" search field
    Then I should not see "AppEngine_BAT_DA" record in the "Manage Adapter Configuration" grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_24
  @Studio
  @Studio_BAT
  @Studio_BAT_24
  Scenario: BR - Create and Delete a Business Rules
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Business Rules" page
    Then I should see more than or equal to 1 records in Rules Configuration grid
    When I click "Add" button
    Then I should be displayed with the "Add Rule" popup
    When I populate the popup with "AppEngine_BAT_BR" data and save
    Then I should see The record with ID ??? has been saved message on a growler
    When I search for "AppEngine_BAT_BR" using the "name" search field
    And I find an existent "AppEngine_BAT_BR" record
    Then I delete "AppEngine_BAT_BR" record from the grid
    When I search for "AppEngine_BAT_BR" using the "name" search field
    Then I should not see "AppEngine_BAT_BR" record in the "Rules Configuration" grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_25
  Scenario: AM - Install and Uninstall an App
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Application Management" page
    When I search for "qa.assets" using the "name" search field
    Then I should not see "qa.assets" record in the "Application Manager" grid
    When I drag and drop "AppEngine_BAT_AM.gz" file to the grid
    Then I should see "qa.assets" record in the "Application Manager" grid
    When I click "Install" icon
    Then I should see Installed the application artifacts message on a growler
    And I refresh the page
    When I select QA Assets menu item from Predix Apps category
    Then I should be displayed with the "QA Assets" page
    And I confirm the QA Assets url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=qaassetsperformance
    And I see QA Assets title as the page header
    When I navigate to "Application Management" page
    And I click "uninstall_app" icon
    Then I should see Application is successfully uninstalled message on a growler
    And I delete "qa.assets" record from the grid
    Then I should not see "qa.assets" record in the "Application Manager" grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_26
  @Studio
  @Studio_BAT
  @Studio_BAT_26
  Scenario: UR - Check grids
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Roles Management" page
    Then I should see more than or equal to 1 records in groups grid
    And I should see more than or equal to 1 records in policies grid
    #And I should see more than or equal to 1 records in UAA Groups grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_27
  @Studio
  @Studio_BAT
  @Studio_BAT_27
  Scenario: MM - Create Menu Item/Topic/Category
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Menu Manager" page
    When I click "Add New Item" button
    Then I should be displayed with the "New Item" panel
    When I populate the panel with "AppEngine_BAT_MM_Category" data and save
    Then I should see "AppEngine BAT MM Cat" category
    When I click "Add New Item" button
    Then I should be displayed with the "New Item" panel
    When I populate the panel with "AppEngine_BAT_MM_Topic" data and save
    Then I should see "AppEngine BAT MM Top" topic
    When I click "Add New Item" button
    Then I should be displayed with the "New Item" panel
    When I populate the panel with "AppEngine_BAT_MM_Item" data and save
    #Then I should see Package and Header records created for AppEngine BAT MM Item. message on a growler
    Then I should see "AppEngine BAT MM Item" item
    When I select AppEngine BAT MM Item menu item from AppEngine BAT MM Cat category
    Then I should be displayed with the "AppEngine BAT MM Item" page
    And I confirm the AppEngine BAT MM Item  url SystemServices/main?system:runTemplate=html/render/Portal.xml&Id=appenginebatmmitem
    And I see AppEngine BAT MM Item title as the page header

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_27
  @Studio
  @Studio_BAT
  @Studio_BAT_27
  Scenario: MM - Add and Remove an Indicator
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "AppEngine BAT MM Item" page
    When I click "Page Settings" button
    Then I should be displayed with the "Content" panel
    When I click "Add Indicator" section
    And I select "General" as "Category"
    And I select "General Data Grid" as "Indicator"
    And I click "Insert" button
    And I click "Close" button
    Then I should be displayed with the "General Data Grid" grid
    When I click "Grid Settings" button
    And I click "Delete" button
    And I click "Confirm Delete" button
    Then I should not see the "General Data Grid" grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_27
  @Studio
  @Studio_BAT
  @Studio_BAT_27
  Scenario: MM - Delete Menu Item/Topic/Category
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Menu Manager" page
    When I click "AppEngine BAT MM Item" settings
    And I click "Delete" button
    #Then I should see Successfully deleted AppEngine BAT MM Item from menu message on a growler
    When I click "AppEngine BAT MM Top" settings
    And I click "Delete" button
    #Then I should see Successfully deleted AppEngine BAT MM Top from menu message on a growler
    When I click "AppEngine BAT MM Cat" settings
    And I click "Delete" button
    #Then I should see Successfully deleted AppEngine BAT MM Cat from menu message on a growler
    Then I should not see the "AppEngine BAT MM Cat" menu

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_28
  Scenario: SE - Valid Login
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I should be able to see the menu items and the logged user name
    When I click on log out under user profile
    Then I should be displayed with the "Open Application" page

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_29
  @Studio
  @Studio_BAT
  @Studio_BAT_29
  Scenario: RT - Router Operations
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Router Management" page
    And I select first record from Routers grid
    And I click "Pause Router" button
    Then I should see Action completed with no errors message on a growler
    And I see the "Router icon" turn "yellow" in "Routers" grid
    Then I select first record from Routers grid
    When I click "Stop Router" button
    Then I should see Action completed with no errors message on a growler
    And I see the "Router icon" turn "red" in "Routers" grid
    Then I select first record from Routers grid
    When I click "Start Router" button
    Then I should see Action completed with no errors message on a growler
    And I see the "Router icon" turn "green" in "Routers" grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_30
  @Studio
  @Studio_BAT
  @Studio_BAT_30
  Scenario: SC - Scheduler Operations
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I select first record from Scheduler grid
    When I click "Pause Scheduler" button
    Then I should see Action completed with no errors message on a growler
    And I see the "Scheduler icon" turn "yellow" in "Schedulers" grid
    Then I select first record from Scheduler grid
    When I click "Start Scheduler" button
    #Then I should see Action completed with no errors message on a growler
    And I see the "Scheduler icon" turn "green" in "Schedulers" grid

  @AppEngine
  @AppEngine_BAT
  @AppEngine_BAT_31
  @Studio
  @Studio_BAT
  @Studio_BAT_31
  Scenario: RG - Navigate to Registry
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Registry Management" page
    Then I should see more than or equal to 1 records in Registry Services grid
    And I should see more than or equal to 1 records in Registry Locations grid

