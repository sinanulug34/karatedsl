@UserService @Torus
Feature: Merge Role with Permission

    Background:

        * def rolePermission = read('classpath:common/RolesAndPermission.json')
        * def readJavaClass = Java.type('Utility')
        * def result = call read('CreateRole.feature@RoleCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def roleId = new java.math.BigDecimal(serviceId)
        * def resultPermission = call read('CreatePermission.feature@PermissionCreate')
        * def locationPermission = resultPermission.responseHeaders['Location'][0]
        * def permId = locationPermission.substring(locationPermission.lastIndexOf('/')+1)
        * def permissionId = new java.math.BigDecimal(permId)

    @RolePermission
    Scenario: The process has been finished successfully.

        Given request rolePermission
        When url UserServiceURL
        And path 'roles-permissions'
        And set rolePermission.roleId = roleId
        And set rolePermission.permissionId = permissionId
        And header Content-Type = 'application/json'
        And method post
        Then status 201
