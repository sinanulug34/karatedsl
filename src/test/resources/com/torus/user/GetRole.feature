@UserService @Torus @Alper

Feature:  Using this service, Gets the details of a single instance of a role.
    @Smoke
    Scenario: The process has been finished successfully.

        * def result = call read('CreateRole.feature@RoleCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def roleID = new java.math.BigDecimal(serviceId)

        Given url UserServiceURL
        And path 'roles/' + roleID
        And method get
        Then status 200

    Scenario: Returns roles not found if the given id does not exist.

        Given url UserServiceURL
        And path 'roles/-1'
        And method get
        Then status 404
        And match $response.description == 'ROLE_NOT_FOUND'

    Scenario: Returns role not found if merchant id is unidentifed.

        Given url UserServiceURL
        And path 'roles/11111111'
        And method get
        Then status 404

    Scenario: Returns Bad Request if the given id is string

        Given url UserServiceURL
        And path 'roles/abc'
        And method get
        Then status 500
