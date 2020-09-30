@UserService @Torus
Feature: Create a new instance of a Role

    Background:

        * def createRole = read('classpath:common/CreateRole.json')
        * def result = call read('CreatePermission.feature@PermissionCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def permissionID = new java.math.BigDecimal(serviceId)

    @RoleCreate @Smoke
    Scenario: The process has been finished successfully.

        Given request createRole
        And set createRole.permissionIdList[0] = permissionID
        And path 'roles'
        When url UserServiceURL
        And header Content-Type = 'application/json'
        And method post
        Then status 201

