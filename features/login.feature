Feature: Login
  In order to log in
  A visitor
  Should login using login form
  And depending on his role
  The visitor will see different items in the menu

  Background:
    Given the following users exist
      | id | login   | email               | is_admin | is_manager | is_deleted |
      |  1 | admin   | admin@example.com   | true     | false      | false      |
      |  2 | manager | manager@example.com | false    | true       | false      |
      |  3 | bob     | bob@example.com     | false    | false      | false      |
      |  4 | alice   | alice@example.com   | false    | false      | false      |
      |  5 | charlie | charlie@example.com | false    | false      | false      |
    Given the following employers exist
      | id | name       | is_deleted |
      |  1 | Employer A | false      |
      |  2 | Employer B | false      |
      |  3 | Employer C | true       |
    Given the following employees exist
      | user_id | employer_id | is_manager |
      |       3 |           1 | false      |
      |       3 |           2 | false      |
      |       3 |           3 | false      |
      |       4 |           1 | false      |
      |       5 |           2 | false      |
      |       5 |           3 | false      |


  Scenario: Login
    Given I am on the login page
      And I fill in "Login" with "bob"
    When I press "Login"
    Then I should successfully log in

  Scenario: Login as user without selecting an employer
    Given I log in as "bob"
    And No employer was selected
    Then I should see "Home" menu item
    And I should see "Account" menu item
    And I should see "Account -> Profile" menu item
    And I should see "Account -> Time table" menu item
    And I should not see "Manage" menu item
    And I should not see "Manage -> Employers" menu item
    And I should not see "Manage -> Edit employer" menu item
    And I should not see "Manage -> Users" menu item
    And I should not see "Manage -> Teams" menu item
    And I should not see "Manage -> Projects" menu item
    And I should not see "Manage -> Tasks" menu item
    And I should not see "Manage -> Holidays" menu item
    And I should see "Logout" menu item

  Scenario: Login as administrator without selecting an employer
    Given I log in as "admin"
    And No employer was selected
    Then I should see "Home" menu item
    And I should see "Account" menu item
    And I should see "Account -> Profile" menu item
    And I should see "Account -> Time table" menu item
    And I should see "Manage" menu item
    And I should see "Manage -> Employers" menu item
    And I should not see "Manage -> Edit employer" menu item
    And I should see "Manage -> Users" menu item
    And I should not see "Manage -> Teams" menu item
    And I should not see "Manage -> Projects" menu item
    And I should see "Manage -> Tasks" menu item
    And I should not see "Manage -> Holidays" menu item
    And I should see "Logout" menu item

  Scenario: Login as manager without selecting an employer
    Given I am logged in as manager "richard"
    And No employer was selected
    Then I should see "Home" menu item
    And I should see "Account" menu item
    And I should see "Account -> Profile" menu item
    And I should see "Account -> Time table" menu item
    And I should see "Manage" menu item
    And I should see "Manage -> Employers" menu item
    And I should not see "Manage -> Edit employer" menu item
    And I should not see "Manage -> Users" menu item
    And I should not see "Manage -> Teams" menu item
    And I should not see "Manage -> Projects" menu item
    And I should see "Manage -> Tasks" menu item
    And I should not see "Manage -> Holidays" menu item
    And I should see "Logout" menu item
