@UserService @Torus

Feature:  Using this service, Gets the details of a single instance of a user.

    Scenario: The process has been finished successfully.

        * def result = call read('CreateUser.feature@UserCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def userId = new java.math.BigDecimal(serviceId)

        Given url UserServiceURL
        And path 'users/' + userId
        And method get
        Then status 200

        And match $response.id == userId

    Scenario: Returns Users not found if the given id does not exist.

        Given url UserServiceURL
        And path 'users/-1'
        And method get
        Then status 404
        And match $response.description == 'USER_NOT_FOUND'

        #https://jira.est.com.tr/jira/browse/NPC-654
    Scenario: Returns merchant not found if merchant id is unidentifed.

        Given url UserServiceURL
        And path 'users/11111111'
        And method get
        Then status 404
        #And match $response.description == 'MERCHANT_NOT_FOUND'

      #https://jira.est.com.tr/jira/browse/NPC-656
    Scenario: Returns Bad Request if the given id is string

        Given url UserServiceURL
        And path 'users/abc'
        And method get
        Then status 500
