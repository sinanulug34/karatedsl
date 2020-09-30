@MerchantTerminalService @Torus
Feature: Gets the details of a single instance of a Terminal.

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def createVposTerminal = read('classpath:common/CreateVposTerminal.json')
        * def getRandomAcquirerMerchantId = readJavaClass.generateNumeric(5)
        * def getRandomAcquirerTerminalId = readJavaClass.generateNumeric(5)

    Scenario: The process has been finished successfully.

        * def result = call read('CreateVpos.feature@CreateVposTerminal')
        * def location = result.responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def terminalId = new java.math.BigDecimal(serviceId)

        * def getAcquirerMerchantIdFromCreateMerchant = result.acquirerMerchantId
        * def getAcquirerTerminalFromCreateMerchant = result.acquirerVposTerminalId

        Given url MerchantServiceURL
        When request createVposTerminal
        * print getMerchantIdFromCreateMerchant
        And set createVposTerminal.acquirerMerchantId = getRandomAcquirerMerchantId
        And set createVposTerminal.acquirerVposTerminalId = getRandomAcquirerTerminalId
        And path 'vpos-terminals/' + terminalId
        And method put
        Then status 200

    Scenario: Returns Terminal not found if the given id does not exist.

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals/-1'
        And method put
        Then status 404
        And match $response.code == '4001'
        And match $response.description == 'VPOS_TERMINAL_NOT_FOUND'

