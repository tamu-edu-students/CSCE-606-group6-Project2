Feature: Authorization for user management
  As an authenticated user
  I must not be able to perform restricted user actions unless I am a sysadmin

  Background:
    Given the database is seeded

  @dev
  Scenario: Non-admin cannot access user creation
    Given I am logged in as the support agent
    When I visit "/users/new"
    Then I should be redirected with "Not authorized."

  @dev
  Scenario: Requester cannot access user edit
    Given I am logged in as the requester
    And a user exists with email "support.agent@example.com"
    When I visit the edit page for user "support.agent@example.com"
    Then I should be redirected with "Not authorized."
