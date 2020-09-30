@UserService @Torus
Feature:  Using this service, Gets the details of a single instance of a permisson.

    Background:
        * def createPermission = read('classpath:common/CreatePermission.json')

    Scenario: The process has been finished successfully.

        * def result = call read('CreatePermission.feature@PermissionCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def permissionID = new java.math.BigDecimal(serviceId)

        Given url UserServiceURL
        When request createPermission
        And path 'permissions/' + permissionID
        And method put
        Then status 200

    Scenario: Returns permission not found if the given id does not exist.

        Given url UserServiceURL
        When request createPermission
        And path 'permissions/-1'
        And method put
        Then status 404
        And match $response.description == 'PERMISSION_NOT_FOUND'

    Scenario: Returns permission not found if merchant id is unidentifed.

        Given url UserServiceURL
        When request createPermission
        And path 'permissions/11111111'
        And method put
        Then status 404

    Scenario: Returns Bad Request if the given id is string

        Given url UserServiceURL
        When request createPermission
        And path 'permissions/abc'
        And method put
        Then status 500
