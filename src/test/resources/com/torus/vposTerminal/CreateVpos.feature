@MerchantTerminalService @Torus

Feature: Gets the details of a single instance of a Terminal.

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def createVposTerminal = read('classpath:common/CreateVposTerminal.json')
        * def acquirerMerchantId = readJavaClass.getRandomNumber(6)
        * def acquirerTerminalId = readJavaClass.getRandomNumber(6)

    @CreateVposTerminal @Smoke
    Scenario: The process has been finished successfully.

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals'
        And set createVposTerminal.acquirerMerchantId = '00' + acquirerMerchantId
        And set createVposTerminal.acquirerVposTerminalId = '00' + acquirerTerminalId
        And method post
        Then status 201

        * def location = responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def vposTerminalId = new java.math.BigDecimal(serviceId)
        * def vposTerminalQuery = "SELECT * FROM VPOS_TERMINALS WHERE VPOSUID ='" + vposTerminalId +"'"
        * def executeQuery = db.readRows(vposTerminalQuery)
        * def getVposUIDOnTable = executeQuery[0].VPOSUID
        * def getAcqMerchIdOnTable = executeQuery[0].ACQ_MERCID
        * def getAcqTermIdOnTable = executeQuery[0].ACQ_TERMID

        And match getAcqMerchIdOnTable == '00' + acquirerMerchantId
        And match getAcqTermIdOnTable == '00' + acquirerTerminalId

    Scenario: acquirerMerchantId field must be mandatory.

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals'
        And remove createVposTerminal.acquirerMerchantId
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'acquirerMerchantId must not be null'

    Scenario: acquirerVposTerminalId field must be mandatory.

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals'
        And remove createVposTerminal.acquirerVposTerminalId
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'acquirerVposTerminalId must not be null'
