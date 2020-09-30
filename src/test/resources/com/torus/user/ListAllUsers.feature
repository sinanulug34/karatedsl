@UserService @Torus

Feature:  Using this service, Users informations can be accessed in given display order.

    Scenario: The process has been finished successfully.

        Given url UserServiceURL
        And path 'users'
        And method get
        Then status 200

        And match each response[*].id == '#number'
        And match each response[*].name == '#string'
        And match each response[*].merchantId == '##number'
        And match each response[*].password == '#string'
        And match each response[*].email == '#string'
        And match each response[*].phoneCountryCode == '##string'
        And match each response[*].mobileNumber == '##string'
        And match each response[*].description == '##string'
        And match each response[*].type == '##string'



