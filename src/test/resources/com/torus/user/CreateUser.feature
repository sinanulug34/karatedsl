@UserService @Torus
Feature: Create a new instance of a User

    Background:

        * def createUser = read('classpath:common/CreateUsersRequestBody.json')
        * def readJavaClass = Java.type('Utility')
        * def result = call read('../merchants/CreateMerchant.feature@MerchantCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def merchantId = new java.math.BigDecimal(serviceId)

        Given request createUser
        When url UserServiceURL
        And path 'users'

    @UserCreate @Smoke
    Scenario: The process has been finished successfully.

        Given request createUser
        When url UserServiceURL
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: username param must be mandatory field.

        * remove createUser.username

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'username must not be null'

    Scenario: groupId param must be optional field.

        * remove createUser.groupId
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: roleId param must be optional field.

        * remove createUser.roleId
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: password param must be mandatory field.

        * remove createUser.password

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'password must not be null'

    Scenario: email param must be mandatory field.

        * remove createUser.email

        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'email must not be null'

    Scenario: name param must be Alphanumeric max 65 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createUser.username = getAlphanumericCharacter
        And method post
        Then status 400
        And match $response.description == 'username size must be between 0 and 64'

    Scenario: password param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createUser.password = getAlphanumericCharacter
        And method post
        Then status 400
        And match $response.description == 'password size must be between 0 and 64'

    Scenario: email param must be Alphanumeric max 64 characters.
        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createUser.email = getAlphanumericCharacter
        And method post
        Then status 400
        And match $response.description == 'email size must be between 0 and 64'

    Scenario: phoneCountryCode param must be optional field.

        * remove createUser.phoneCountryCode
        When url UserServiceURL
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: phoneCountryCode param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createUser.phoneCountryCode = getAlphanumericCharacter
        And method post
        Then status 400
        And match $response.description == 'phoneCountryCode size must be between 0 and 64'

    Scenario: mobileNumber param must be optional field.

        * remove createUser.mobileNumber
        Given request createUser
        When url UserServiceURL
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: description param must be optional field.

        * remove createUser.description
        Given request createUser
        When url UserServiceURL
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: description param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createUser.description = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.description == 'description size must be between 0 and 64'

    Scenario: country param must be optional field.

        * remove createUser.country
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post


    Scenario: country param must be Alphanumeric max 64 characters.

        * def getAlphanumericCharacter = readJavaClass.getAlphaNumericString(65)
        * set createUser.country = getAlphanumericCharacter

        And method post
        Then status 400
        And match $response.description == 'country size must be between 0 and 64'
