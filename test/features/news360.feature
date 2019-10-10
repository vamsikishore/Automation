Feature: To validate the news360 landing page

  @news_360_1
  Scenario: Verify that user gets navigated to news360 when he enters valid url
    Given I hit news360 url
    Then I should be navigated to news360 page
    And I should verify the start reading button in the page

  @news_360_2
  Scenario: Verify the start reading button functionality
    Given I hit news360 url
    Then I should be navigated to news360 page
    And I should verify the start reading button in the page
    When I click on start reading button
    Then I should be navigated to news360 home page

  @news_360_3
  Scenario: Check different menu options in the page
    Given I hit news360 url
    Then I should be navigated to news360 page
    Then I should fetch the menu values

  @news_360_4
  Scenario: Verify the menu options in the page
    Given I hit news360 url
    Then I should be navigated to news360 page
    And I verify the below menu items:
      | Publishers |
      | Brands     |
      | Enterprise |
      | Blog       |

  @news_360_5
  Scenario Outline: Verify that user is displayed with right url and title when he clicks on different menus in landing page
    Given I hit news360 url
    Then I should be navigated to news360 page
    When I clickStart reading whats matters to you on <menu>
    Then I should check the <url>
    And I should verify the <page_title>
    Examples:
      | menu       | url         | page_title |
      | Publishers | publishers/ | Publishers |
      | Brands     | brands/     | Brands     |
      | Enterprise | enterprise/ | Enterprise |

  @news_360_6
Scenario: To verify the menu navigation in data table
  Given I hit news360 url
  Then I should be navigated to news360 page
  When I Naviagate and check the page tile and url for the below menus :
    | Publishers |
    | Brands     |
    | Enterprise |
    | Blog       |

  @news_360_7
    Scenario: To verify " News360 is now part of PressReader!" text
      Given I hit news360 url
      Then I should be navigated to news360 page
      And I should see "News360 is now part of PressReader! Learn more"


  @news_360_8
  Scenario: To click "Start reading whats matters to you" button
    Given I hit news360 url
    Then I should be navigated to news360 page
    And I click on Start reading whats matters to you



