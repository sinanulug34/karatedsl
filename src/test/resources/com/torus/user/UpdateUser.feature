@UserService @Torus
Feature:  Using this service, Updates an existing Users..

    Background:

        * def readJavaClass = Java.type('Utility')
        * def createUsers = read('classpath:common/CreateUsersRequestBody.json')

    Scenario: The process has been finished successfully.

        * def result = call read('CreateUser.feature@UserCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def userId = new java.math.BigDecimal(serviceId)
        * def merchantId = result.createUser.merchantId

        Given url UserServiceURL
        When request createUsers
        And set createUsers.merchantId = merchantId
        And path 'users/' + userId
        And header Content-Type = 'application/json'
        And method put
        Then status 200

    Scenario: Returns User not found if the given id does not exist.

        Given url UserServiceURL
        When request createUsers
        And header Content-Type = 'application/json'
        And path 'users/-1'
        And method put
        Then status 404


    Scenario: Returns Bad Request if the given id is string

        Given url UserServiceURL
        When request createUsers
        And header Content-Type = 'application/json'
        And path 'users/abc'
        And method put
        Then status 500

