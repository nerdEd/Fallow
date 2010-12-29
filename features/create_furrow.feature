Feature: Creating a furrow
  In order to follow and unfollow twitter users
  As a twitter user
  I want to create furrows

  Scenario: Creating a furrow with a blank form while logged in
    Given the following user:
      | attribute | value   |
      | name      | Ed      |
      | nickname  | nerdEd  |
    And   I am logged in
    And   I am on the home page
    When  I press "Create!"
    Then  show me the page
    Then  I should see "Seed user must be a valid twitter user"
    And   I should see "Duration must be present"
