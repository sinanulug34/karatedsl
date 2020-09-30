@MerchantTerminalService @Torus

Feature: Gets the details of a single instance of a Merchant.

    Scenario: The process has been finished successfully.

        * def result = call read('CreateMerchant.feature@MerchantCreate')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def merchantId = new java.math.BigDecimal(serviceId)

        Given url MerchantServiceURL
        And path 'merchants/' + merchantId
        And method get
        Then status 200
        And match $response.id == merchantId

    Scenario: Returns Merchant not found if the given id does not exist.

        Given url MerchantServiceURL
        And path 'merchants/-1'
        And method get
        Then status 404
        And match $response.code == '1001'
        And match $response.description == 'MERCHANT_NOT_FOUND'

    Scenario: Returns Bad Request if the given id is string

        Given url MerchantServiceURL
        And path 'merchants/abc'
        And method get
        Then status 500
        And match $response.code == '0'

