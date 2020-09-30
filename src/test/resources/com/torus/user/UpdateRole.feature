@UserService @Torus
Feature:  Using this service, Gets the details of a single instance of a permisson.

    Background:
        * def createRole = read('classpath:common/CreateRole.json')

    Scenario: The process has been finished successfully.

        * def result = call read('CreateRole.feature@RoleCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def roleID = new java.math.BigDecimal(serviceId)

        Given url UserServiceURL
        When request createRole
        And path 'roles/' + roleID
        And method put
        Then status 200

    Scenario: Returns role not found if the given id does not exist.

        Given url UserServiceURL
        When request createRole
        And path 'roles/-1'
        And method put
        Then status 404
        And match $response.description == 'ROLE_NOT_FOUND'

    Scenario: Returns role not found if merchant id is unidentifed.

        Given url UserServiceURL
        When request createRole
        And path 'roles/11111111'
        And method put
        Then status 404

    Scenario: Returns Bad Request if the given id is string

        Given url UserServiceURL
        When request createRole
        And path 'roles/abc'
        And method put
        Then status 500
