@UserService @Torus
Feature: Create a new instance of a Permission

    Background:

        * def createPermission = read('classpath:common/CreatePermission.json')

    @PermissionCreate   @Smoke
    Scenario: The process has been finished successfully.

        Given request createPermission
        And path 'permissions'
        When url UserServiceURL
        And header Content-Type = 'application/json'
        And method post
        Then status 201
