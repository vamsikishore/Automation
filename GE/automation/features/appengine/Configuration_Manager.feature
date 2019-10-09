Feature: Configuration Manager (Functional Validation)

  @AppEngine_ConfigurationManagement
  @Studio_ConfigurationManagement
  @Portal_ConfigurationManagement
  @AppEngine_ConfigurationManagement_01
  Scenario: Create, edit and delete a record in Manage Configuration Grid
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Configuration Manager" page
    Then I should be displayed with the "Manage Configuration" grid
    When I click "Add" button
    Then I should be displayed with the "Add Record" popup
    When I populate the popup with "AppEngine_Configuration_CreateRecord" data and save
    Then I search and select the "__APPENGINE_CONFIGURATIONMANAGEMENT_01_" record using the "name" field
    And I click "Edit" button
    And I enter "__APPENGINE_CONFIGURATIONMANAGEMENT_01_Record_Updated" in the "Value" field of "Edit Record"
    And I click "Update" button
    When I click "Reload" button
    Then I should see "__APPENGINE_CONFIGURATIONMANAGEMENT_01_Record_Updated" record in the "Manage Configuration" grid
    Then I search and select the "__APPENGINE_CONFIGURATIONMANAGEMENT_01_" record using the "name" field
    When I delete "__APPENGINE_CONFIGURATIONMANAGEMENT_01_" record from the grid
    Then I should not see "__APPENGINE_CONFIGURATIONMANAGEMENT_01_" record in the "Manage Configuration" grid


  @AppEngine_ConfigurationManagement
  @Studio_ConfigurationManagement
  @Portal_ConfigurationManagement
  @AppEngine_ConfigurationManagement_02
  Scenario: Form validation for "Manage Configuration" grid
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Configuration Manager" page
    Then I should be displayed with the "Manage Configuration" grid
    When I click "Add" button
    And I click "Submit" button
    Then I should see "Category: Field is required" error message on "Add Record" popup
    And I enter with "text" "AppEngine_Configuration_02" in the "category" field and save
    Then I should see "Type: Field is required" error message on "Add Record" popup
    And I enter with "text" "default" in the "type" field and save
    Then I should see "Name: Field is required" error message on "Add Record" popup
    And I enter with "text" "APPENGINE_CONFIGURATIONMANAGEMENT_02" in the "name" field and save
    Then I should see "Name: Invalid Format. Name should be in __SETTINGS_NAME_FORMAT_" error message on "Add Record" popup
    And I enter with "text" "__APPENGINE_CONFIGURATIONMANAGEMENT_02_" in the "name" field and save
    When I click "Reload" button
    Then I should see "__APPENGINE_CONFIGURATIONMANAGEMENT_02_" record in the "Manage Configuration" grid
    Then I search and select the "__APPENGINE_CONFIGURATIONMANAGEMENT_02_" record using the "name" field
    When I delete "__APPENGINE_CONFIGURATIONMANAGEMENT_02_" record from the grid
    When I search for "__APPENGINE_CONFIGURATIONMANAGEMENT_02_" using the "name" search field
    Then I should not see "__APPENGINE_CONFIGURATIONMANAGEMENT_02_" record in the "Manage Configuration" grid

  @AppEngine_ConfigurationManagement
  @Studio_ConfigurationManagement
  @Portal_ConfigurationManagement
  @AppEngine_ConfigurationManagement_03
  Scenario: Validate grid filtering functionality for Manage Configuration grid
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Configuration Manager" page
    Then I should be displayed with the "Manage Configuration" grid
    And I search for "BusinessRules" using the "Category" search field
    Then I should see "Filtered on Category" record in the "Manage Configuration" grid
    And I see more than or equal to "1" "__INDEX_RULES_" records in the "Manage Configuration" grid
    When I click "Reload" button
    And I search for "General" using the "Group" search field
    Then I should see "Filtered on Group" record in the "Manage Configuration" grid
    And I see more than or equal to "1" "__LOGIN_ROLE_MESSAGE_" records in the "Manage Configuration" grid
    When I click "Reload" button
    And I search for "circuit_stroke" using the "Name" search field
    Then I should see "Filtered on Name" record in the "Manage Configuration" grid
    And I see more than or equal to "1" "__CIRCUIT_STROKE_WEIGHT_" records in the "Manage Configuration" grid
    When I click "Reload" button
    And I search for "#FF0000" using the "Value" search field
    Then I should see "Filtered on Value" record in the "Manage Configuration" grid
    And I see more than or equal to "1" "__FEEDER_LINE_COLOR_TYPE_B_" records in the "Manage Configuration" grid






