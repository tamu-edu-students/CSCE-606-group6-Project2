Feature: Authentication via OmniAuth (development mock)
  Background:
    Given the database is seeded

  @dev @auth
  Scenario: Log in as the dummy requester
    When I visit "/dev_login/requester"
    Then I should be logged in
    And I should see "Signed in" on the page
    When I visit "/tickets"
    Then I should see a list of tickets

  @dev @auth
  Scenario: Log in as the support agent
    When I visit "/dev_login/agent"
    Then I should be logged in
    And I should see "Signed in" on the page
    When I visit "/tickets"
    Then I should see a list of tickets
