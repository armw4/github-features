Feature: Pull request
    In order to contribute to a project
    As a user
    I want to be able to submit new features, enhancements, and bug fixes.

    Scenario: View pull request
        Given I view pull request #13639 in "rails/rails"
        Then I should see the number of files I changed in the "Files Changed" tab
        And I should see a message containing the number of files I changed
        And I should see a diff for each file I changed
