Feature: Employers
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

  Scenario: Create a employer by an administrator
    Given I log in as "admin"
    When I go to the employers page
    And I click "New Employer"
    And I fill in "Name" with "A testing employer"
    And I press "Create Employer"
    And I go to the employers page
    #Then I should be redirected to the employers page
    Then I should see "A testing employer" in the 1st column of the main table

  Scenario: Only one relevant employer should not display employer selection box
    When I log in as "charlie"
    Then I should not see the employer selection box

  Scenario: More than one relevant employer should display employer selection box
    When I log in as "bob"
    Then I should see the employer selection box
    And the employer selection box should contain "Employer A"
    And the employer selection box should contain "Employer B"

  Scenario: Adding a new employer as administrator should not be to not employees
    When I log in as "admin"
    And I go to the employers page
    And I click "New Employer"
    And I fill in "Name" with "Employer D"
    And I press "Create Employer"
    And I log in as "bob"
    Then the employer selection box should not contain "Employer D"

  Scenario: Adding a new employer as administrator should be to employees
    When I log in as "admin"
    And I go to the employers page
    And I click "New Employer"
    And I fill in "Name" with "Employer E"
    And I include the user "bob"
    And I press "Create Employer"
    And I log in as "bob"
    Then the employer selection box should contain "Employer E"
