Feature: Scheduler Manager (Functional Validation)

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_01
  Scenario: Create and validate a scheduled job then delete it
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    When I check for existent AppEngine_Scheduler_Job_01 record from Scheduled Jobs grid and delete if record exists
    Then I should be displayed with the "Scheduled Jobs" grid
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_CreateJob" data and save
    Then I should see "AppEngine_Scheduler_Job_01" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_01" record in the "Groups" grid
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_01" record with "COMPLETED" status in the "Scheduled Jobs" grid
    When I search for "AppEngine_Scheduler_Job_01" using the "jobName" search field
    Then I should see "AppEngine_Scheduler_Job_01" record with "SUCCESS" status in the "Scheduler Log" grid
    When I select AppEngine_Scheduler_Job_01 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_01" record in the "Scheduled Jobs" grid

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_02
  Scenario: Create and validate successful runs of a scheduled job until it reaches the end time then delete it
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_02 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_SuccessJobWithEndtime" data and save
    Then I should see "AppEngine_Scheduler_Job_02" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_02" record in the "Groups" grid
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_02" record with "COMPLETED" status in the "Scheduled Jobs" grid
    When I search for "AppEngine_Scheduler_Job_02" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    Then I should see "AppEngine_Scheduler_Job_02" record with "SUCCESS" status in the "Scheduler Log" grid
    And I see less than or equal to "5" "AppEngine_Scheduler_Job_02" records in the "Scheduler Log" grid
    When I select AppEngine_Scheduler_Job_02 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_02" record in the "Scheduled Jobs" grid

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_03
  Scenario: Create and validate failed runs of a scheduled job until it reaches the end time then delete it
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_03 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_CreateFailJobWithEndtime" data and save
    Then I should see "AppEngine_Scheduler_Job_03" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_03" record in the "Groups" grid
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_03" record with "CANCELLED" status in the "Scheduled Jobs" grid
    When I search for "AppEngine_Scheduler_Job_03" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    Then I should see "AppEngine_Scheduler_Job_03" record with "FAILURE" status in the "Scheduler Log" grid
    And I see less than or equal to "5" "AppEngine_Scheduler_Job_03" records in the "Scheduler Log" grid
    When I select AppEngine_Scheduler_Job_03 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_03" record in the "Scheduled Jobs" grid

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_04
  Scenario: Compare Scheduler Manager version vs AppEngine version
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I check the application version from "About AppEngine" page
    And I navigate to "Scheduler Management" page
    Then I Compare Scheduler Manager version vs AppEngine version

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_05
  Scenario: Clean the Add Scheduled Job popup with the Reload button
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_ReloadButtonCheck" data and click reload
    Then I should see all the fields in "Add Scheduled Job" popup cleared

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_06
  Scenario: Confirm a scheduled job is cancelled after the max errors is reached then delete it
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_06 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_CreateFailJobWithMaxErrors" data and save
    Then I should see "AppEngine_Scheduler_Job_06" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_06" record in the "Groups" grid
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_06" record with "CANCELLED" status in the "Scheduled Jobs" grid
    When I search for "AppEngine_Scheduler_Job_06" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    And I search for "FAILURE" using the "state" search field
    Then I should see "AppEngine_Scheduler_Job_06" record with "FAILURE" status in the "Scheduler Log" grid
    And I see less than or equal to "4" "AppEngine_Scheduler_Job_06" records in the "Scheduler Log" grid
    When I select AppEngine_Scheduler_Job_06 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_06" record in the "Scheduled Jobs" grid

    #  Populate SUCCESS ACTION - MIX CODE TO SHOW SOMETHING ON THE LOG
#  Add extra step to see the Scheduled Log popup and look for the Log Message
  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_07
  Scenario: Create and validate successful runs of a scheduled job until it reaches the execution count then delete it
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_07 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_SuccessExecCount" data and save
    Then I should see "AppEngine_Scheduler_Job_07" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_07" record in the "Groups" grid
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_07" record with "COMPLETED" status in the "Scheduled Jobs" grid
    Then I should see "AppEngine_Scheduler_Job_07" record with "SUCCESS" status in the "Scheduler Log" grid
    When I search for "AppEngine_Scheduler_Job_07" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    Then I should see "AppEngine_Scheduler_Job_07" record with "The job execution is success. The execution endpoint and response was: <!doctype html><html itemscope=" value in the "log message" of "Scheduler Log" grid
    And I see less than or equal to "3" "AppEngine_Scheduler_Job_07" records in the "Scheduler Log" grid
    When I select AppEngine_Scheduler_Job_07 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_07" record in the "Scheduled Jobs" grid

  #  Populate FAILURE ACTION - MIX CODE TO SHOW SOMETHING ON THE LOG
#  Add extra step to see the Scheduled Log popup and look for the Log Message
  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_08
  Scenario: Create and validate failed runs of a scheduled job until it reaches the execution count then delete it
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_08 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_FailedExecCount" data and save
    Then I should see "AppEngine_Scheduler_Job_08" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_08" record in the "Groups" grid
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_08" record with "CANCELLED" status in the "Scheduled Jobs" grid
    Then I should see "AppEngine_Scheduler_Job_08" record with "FAILURE" status in the "Scheduler Log" grid
    When I search for "AppEngine_Scheduler_Job_08" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    Then I should see "AppEngine_Scheduler_Job_08" record with "The job execution is failure. The execution endpoint and response was: null" value in the "log message" of "Scheduler Log" grid
    And I see less than or equal to "3" "AppEngine_Scheduler_Job_08" records in the "Scheduler Log" grid
    When I select AppEngine_Scheduler_Job_08 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_08" record in the "Scheduled Jobs" grid

#  Use the google / cnn example
  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_09
  Scenario: Validate Scheduler Clear Cache
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Registry Management" page
    Then I should be displayed with the "Registry Services" grid
    When I click on "Add Registry Service" button
    Then I should be displayed with the "Add Registry Service" popup
    When I populate the popup with "AppEngine_Scheduler_RegistryServices_Record01" data and save
    When I search for "AppEngine_Scheduler_RegistryServices_Record01" using the "name" search field
    Then I should see "AppEngine_Scheduler_RegistryServices_Record01" record in the "Registry Services" grid
    Then I should be displayed with the "Registry Locations" grid
    When I click on "Add Registry Location" button
    Then I should be displayed with the "Add Registry Location" popup
    When I populate the popup with "AppEngine_Scheduler_RegistryLocations_Record01" data and save
    When I search for "com.ge.scheduler.check.clear.cache" using the "serviceId" search field
    Then I should see "com.ge.scheduler.check.clear.cache" record in the "Registry Locations" grid
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_09 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_ClearCacheCheck" data and save
    Then I should see "AppEngine_Scheduler_Job_09" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_09" record in the "Groups" grid
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_09" record with "COMPLETED" status in the "Scheduled Jobs" grid
    When I search for "AppEngine_Scheduler_Job_09" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    Then I should see "AppEngine_Scheduler_Job_09" record with "www.google.com" value in the "log message" of "Scheduler Log" grid
    And I navigate to "Registry Management" page
    Then I should be displayed with the "Registry Locations" grid
    When I search for "com.ge.scheduler.check.clear.cache" using the "serviceId" search field
    Then I select first record from Registry Locations grid
    When I click on "Edit selected Registry Location" button
    When I update the ENDPOINT with "www.cnn.com" data and save
    And I navigate to "Scheduler Management" page
    And I select first record from Schedulers grid
    When I click on "Clear Scheduler Cache" button
    When I select AppEngine_Scheduler_Job_09 record from Scheduled Jobs grid and click on Trigger Job button
    When I click on "Reload Grid" button
    When I search for "AppEngine_Scheduler_Job_09" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    Then I should see "AppEngine_Scheduler_Job_09" record with "www.cnn.com" value in the "log message" of "Scheduler Log" grid
    And I navigate to "Registry Management" page
    And I should be displayed with the "Registry Services" grid
    When I search for "AppEngine_Scheduler_RegistryServices_Record01" using the "name" search field
    When I delete "AppEngine_Scheduler_RegistryServices_Record01" record from the grid
    When I search for "AppEngine_Scheduler_RegistryServices_Record01" using the "name" search field
    Then I should not see "AppEngine_Scheduler_RegistryServices_Record01" record in the "Registry Services" grid
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I select AppEngine_Scheduler_Job_09 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_09" record in the "Scheduled Jobs" grid

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_10
  Scenario: Groups Operations
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_10 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_CheckGroupOperations" data and save
    Then I should see "AppEngine_Scheduler_Job_10" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_10" record in the "Groups" grid
    When I select AppEngine_Scheduler_Group_10 record from Groups grid and click on Pause Group button
    Then I should see Scheduler job has been paused. message on a growler
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_10" record with "PAUSED" status in the "Scheduled Jobs" grid
    When I search for "AppEngine_Scheduler_Job_10" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    And I see less than or equal to "1" "AppEngine_Scheduler_Job_10" records in the "Scheduler Log" grid
    Then I should see "AppEngine_Scheduler_Group_10" record with "SCHEDULED (0/1)" status in the "Groups" grid
    When I select AppEngine_Scheduler_Group_10 record from Groups grid and click on Trigger Group button
    Then I should see Scheduler job has been triggered. message on a growler
    When I search for "AppEngine_Scheduler_Job_10" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    And I see less than or equal to "2" "AppEngine_Scheduler_Job_10" records in the "Scheduler Log" grid
    When I click on "Reload Grid" button
    When I select AppEngine_Scheduler_Group_10 record from Groups grid and click on Resume Group button
    Then I should see Scheduler job has been resumed. message on a growler
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_10" record with "SCHEDULED" status in the "Scheduled Jobs" grid
    Then I should see "AppEngine_Scheduler_Group_10" record with "SCHEDULED (1/1)" status in the "Groups" grid
    When I select AppEngine_Scheduler_Group_10 record from Groups grid and click on Delete selected row button
    When I click on "Reload Grid" button
    Then I should not see "AppEngine_Scheduler_Group_10" record in the "Groups" grid
    Then I should not see "AppEngine_Scheduler_Job_10" record in the "Scheduled Jobs" grid

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_11
  Scenario: Validate master slave filtering between Groups and Scheduled jobs grids
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_11B record from Scheduled Jobs grid and delete if record exists
    When I check for existent AppEngine_Scheduler_Group_11A record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_CheckMasterSlaveFilter1" data and save
    Then I should see "AppEngine_Scheduler_Job_11A" record in the "Scheduled Jobs" grid
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_CheckMasterSlaveFilter2" data and save
    Then I should see "AppEngine_Scheduler_Job_11B" record in the "Scheduled Jobs" grid
    And I should see "AppEngine_Scheduler_Group_11A" record in the "Groups" grid
    When I select AppEngine_Scheduler_Group_11A record from Groups grid
    And I see less than or equal to "1" "AppEngine_Scheduler_Job_11A" records in the "Scheduled Jobs" grid
    When I click on "Reload Grid" button
    And I should see "AppEngine_Scheduler_Group_11B" record in the "Groups" grid
    When I select AppEngine_Scheduler_Group_11B record from Groups grid
    And I see less than or equal to "1" "AppEngine_Scheduler_Job_11B" records in the "Scheduled Jobs" grid
    When I click on "Reload Grid" button
    When I select AppEngine_Scheduler_Group_11B record from Groups grid and click on Delete selected row button
    When I click on "Reload Grid" button
    Then I should not see "AppEngine_Scheduler_Job_11B" record in the "Groups" grid
    Then I should not see "AppEngine_Scheduler_Job_11B" record in the "Scheduled Jobs" grid
    When I select AppEngine_Scheduler_Group_11A record from Groups grid and click on Delete selected row button
    When I click on "Reload Grid" button
    Then I should not see "AppEngine_Scheduler_Job_11A" record in the "Groups" grid
    Then I should not see "AppEngine_Scheduler_Job_11A" record in the "Scheduled Jobs" grid

  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_12
  Scenario: Scheduled Jobs Operations
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_12 record from Scheduled Jobs grid and delete if record exists
    When I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I populate the popup with "AppEngine_Scheduler_JobOperations" data and save
    Then I should see "AppEngine_Scheduler_Job_12" record in the "Scheduled Jobs" grid
    When I select AppEngine_Scheduler_Job_12 record from Scheduled Jobs grid and click on Pause Job button
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_12" record with "PAUSED" status in the "Scheduled Jobs" grid
    When I search for "AppEngine_Scheduler_Job_12" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    And I see less than or equal to "1" "AppEngine_Scheduler_Job_12" records in the "Scheduler Log" grid
    When I select AppEngine_Scheduler_Job_12 record from Scheduled Jobs grid and click on Trigger Job button
    When I click on "Reload Grid" button
    When I search for "AppEngine_Scheduler_Job_12" using the "jobName" search field
    And I search for "AppEngine_Scheduled_Job_start_time" using the "jobExecutionDate" search field
    And I see less than or equal to "2" "AppEngine_Scheduler_Job_12" records in the "Scheduler Log" grid
    Then I should see "AppEngine_Scheduler_Job_12" record with "PAUSED" status in the "Scheduled Jobs" grid
    When I select AppEngine_Scheduler_Job_12 record from Scheduled Jobs grid and click on Resume Job button
    When I click on "Reload Grid" button
    Then I should see "AppEngine_Scheduler_Job_12" record with "SCHEDULED" status in the "Scheduled Jobs" grid
    When I select AppEngine_Scheduler_Job_12 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_12" record in the "Scheduled Jobs" grid


  @AppEngine_SchedulerManagement
  @Studio_SchedulerManagement
  @Portal_SchedulerManagement
  @AppEngine_SchedulerManager_13
  Scenario: Form validation for Scheduler Jobs grid
    Given I log into AppEngine/Studio/Portal/AppExt application with valid credentials
    And I navigate to "Scheduler Management" page
    Then I should be displayed with the "Scheduled Jobs" grid
    When I check for existent AppEngine_Scheduler_Job_13 record from Scheduled Jobs grid and delete if record exists
    And I click on "Add Scheduled Job" button
    Then I should be displayed with the "Add Scheduled Job" popup
    When I click "Save" button
    Then I should see One or more required fields are blank. Please correct the highlighted fields and try again. message on a growler
    When I enter with "text" "AppEngine_Scheduler_Job_13" in the "SCHEDULE NAME" field and save
    Then I should see One or more required fields are blank. Please correct the highlighted fields and try again. message on a growler
    When I enter with "text" "AppEngine_Scheduler_Group_13" in the "GROUP" field and save
    Then I should see One or more required fields are blank. Please correct the highlighted fields and try again. message on a growler
    When I enter with "text" "URN::fail" in the "END POINT" field and save
    Then I should see One or more required fields are blank. Please correct the highlighted fields and try again. message on a growler
    When I enter with "text" "5" in the "EXECUTION INTERVAL" field and save
    Then I should see One or more required fields are blank. Please correct the highlighted fields and try again. message on a growler
    When I enter with "date/time" "20 seconds more than the current time" in the "END TIME" field and save
    And I enter with "date/time" "current time" in the "START TIME" field and save
    Then I should see "AppEngine_Scheduler_Job_13" record in the "Scheduled Jobs" grid
    When I select AppEngine_Scheduler_Job_13 record from Scheduled Jobs grid and click on Delete selected row button
    Then I should not see "AppEngine_Scheduler_Job_13" record in the "Scheduled Jobs" grid

  @wip
  Scenario: Validate grid filtering functionality for Scheduler Log grid

  @wip
  Scenario: Scheduler Groups deletion should also delete related Scheduled Jobs


