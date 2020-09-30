@MerchantTerminalService @Torus
Feature: Gets the details of a single instance of a Terminal.

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')
        * def createVposTerminalToMerchant = read('classpath:common/CreateVposTerminalToMerchant.json')

    @AvailableTerminalsWithVpos
    Scenario: The process has been finished successfully.

        Given request createMerchant
        When url MerchantServiceURL
        And path 'merchants'
        And header Content-Type = 'application/json'
        And method post
        Then status 201

        * def location = responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def merchantId = new java.math.BigDecimal(serviceId)
        * def vposCreate = call read('../vposTerminal/CreateVpos.feature@CreateVposTerminal')
        * def vposLocation = vposCreate.responseHeaders['Location'][0]
        * def getVposId = vposLocation.substring(vposLocation.lastIndexOf('/')+1)
        * def vposTerminalId = new java.math.BigDecimal(getVposId)

        Given url MerchantServiceURL
        When request createVposTerminalToMerchant
        And set createVposTerminalToMerchant.merchantId = merchantId
        And set createVposTerminalToMerchant.vposTerminalId = getVposId
        And path 'merchants-vpos-terminals'
        And method post
        Then status 200

        Given url MerchantServiceURL
        When request ''
        And path 'vpos-terminals/' + vposTerminalId + '/available-terminals'
        And method post
        Then status 200
        And match $response.status == 'AVAILABLE'
        And match $response.activeTransactionCount == 0
        And match $response.id == vposTerminalId

    Scenario: Using terminal id as 0

        Given url MerchantServiceURL
        When request ''
        And path 'vpos-terminals/0/available-terminals'
        And method post
        Then status 404
        And match $response.description == 'AVAILABLE_VPOS_TERMINAL_NOT_FOUND'



