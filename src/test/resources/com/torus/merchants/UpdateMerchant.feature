@MerchantTerminalService @Torus
Feature: Updates an existing Merchant.

    Background:

        * def readJavaClass = Java.type('Utility')

    Scenario: The process has been finished successfully.

        * def result = call read('CreateMerchant.feature@MerchantCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def merchantId = new java.math.BigDecimal(serviceId)
        * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')
        * def getCreatedMerchantRequestBody = result.createMerchant
        * def acquirerId = getCreatedMerchantRequestBody.acquirerId
        * def getNumericCharacter = readJavaClass.generateNumeric(5)

        Given request getCreatedMerchantRequestBody
        When url MerchantServiceURL
        And set getCreatedMerchantRequestBody.acquirerId = getNumericCharacter
        And path 'merchants/' + merchantId
        And method put
        Then status 200

    Scenario: Returns Merchant not found if the given id does not exist.

        * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')

        Given url MerchantServiceURL
        When request createMerchant
        And header Content-Type = 'application/json'
        And path 'merchants/-1'
        And method put
        Then status 404
        And match $response.code == '1001'
        And match $response.description == 'MERCHANT_NOT_FOUND'

    Scenario: Returns Bad Request if the given id is string

        * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')

        Given url MerchantServiceURL
        When request createMerchant
        And header Content-Type = 'application/json'
        And path 'merchants/abc'
        And method put
        Then status 500
        And match $response.code == '0'
