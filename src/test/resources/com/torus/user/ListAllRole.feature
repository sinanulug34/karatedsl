@UserService @Torus

Feature:  Using this service, Roles informations can be accessed in given display role.

    Scenario: The process has been finished successfully.

        Given url UserServiceURL
        And path 'roles'
        And method get
        Then status 200
        And match each response[*].id == '#number'
        And match each response[*].createdBy == '#number'
        And match each response[*].lastModifiedBy == '#number'
        And match each response[*].name == '##string'
        And match each response[*].description == '##string'


