@MerchantTerminalService @Torus @Alper
Feature: Create Vpos Terminal to Merchant.

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def createUser = read('classpath:common/CreateUsersRequestBody.json')
        * def createVposTerminalToMerchant = read('classpath:common/CreateVposTerminalToMerchant.json')
        * def convertToString = function(numberVal){ return "\'" + numberVal.toString() + "\'"; }

    @CreateMerchantVpos @Smoke
    Scenario: The process has been finished successfully.

        * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')

        Given request createMerchant
        When url MerchantServiceURL
        And path 'merchants'
        And header Content-Type = 'application/json'
        And method post
        Then status 201

        * def location = responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def merchantId = serviceId
        * def createVposTerminal = read('classpath:common/CreateVposTerminal.json')
        * def acquirerMerchantId = readJavaClass.getRandomNumber(6)
        * def acquirerTerminalId = readJavaClass.getRandomNumber(6)

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals'
        And set createVposTerminal.acquirerMerchantId = '00' + acquirerMerchantId
        And set createVposTerminal.acquirerVposTerminalId = '00' + acquirerTerminalId
        And method post
        Then status 201

        * def vposLocation = responseHeaders['Location'][0]
        * def getVposId = vposLocation.substring(vposLocation.lastIndexOf('/')+1)
        * def vposTerminalId = new java.math.BigDecimal(getVposId)

        Given url MerchantServiceURL
        When request createVposTerminalToMerchant
        And set createVposTerminalToMerchant.merchantId = merchantId
        And set createVposTerminalToMerchant.vposTerminalId = getVposId
        And path 'merchants-vpos-terminals'
        And method post
        Then status 200

        * def vposTerminalQuery = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
        * def executeQuery = db.readRows(vposTerminalQuery)
        * def getVposUIDOnTable = executeQuery[0].VPOS_TERMINAL_ID

        And match getVposUIDOnTable == vposTerminalId

        Given request createUser
        When url UserServiceURL
        And path 'users'
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

     @CreateTestMerchant
     Scenario: The process has been finished successfully.

         * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')

         Given request createMerchant
         When url MerchantServiceURL
         And path 'merchants'
         And header Content-Type = 'application/json'
         And method post
         Then status 201

         * def location = responseHeaders['Location'][0]
         * def serviceId = location.substring(location.lastIndexOf('/')+1)
         * def merchantId = serviceId
         * def createVposTerminal = read('classpath:common/CreateVposTerminal.json')
         * def acquirerMerchantId = readJavaClass.getRandomNumber(6)
         * def acquirerTerminalId = readJavaClass.getRandomNumber(6)

         Given url MerchantServiceURL
         When request createVposTerminal
         And path 'vpos-terminals'
         And set createVposTerminal.acquirerMerchantId = '00' + acquirerMerchantId
         And set createVposTerminal.acquirerVposTerminalId = '00' + acquirerTerminalId
         And method post
         Then status 201

         * def vposLocation = responseHeaders['Location'][0]
         * def getVposId = vposLocation.substring(vposLocation.lastIndexOf('/')+1)
         * def vposTerminalId = new java.math.BigDecimal(getVposId)

         Given url MerchantServiceURL
         When request createVposTerminalToMerchant
         And set createVposTerminalToMerchant.merchantId = merchantId
         And set createVposTerminalToMerchant.vposTerminalId = getVposId
         And path 'merchants-vpos-terminals'
         And method post
         Then status 200

         * def vposTerminalQuery = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
         * def executeQuery = db.readRows(vposTerminalQuery)
         * def getVposUIDOnTable = executeQuery[0].VPOS_TERMINAL_ID

         And match getVposUIDOnTable == vposTerminalId

         Given request createUser
         When url UserServiceURL
         And path 'users'
         And set createUser.merchantId = merchantId
         And header Content-Type = 'application/json'
         And method post
         Then status 201

    @CreateTestMerchantMultipleTerminal
    Scenario: The process has been finished successfully.

        * def createMerchant = read('classpath:common/CreateMerchantRequestBody.json')

        Given request createMerchant
        When url MerchantServiceURL
        And path 'merchants'
        And header Content-Type = 'application/json'
        And method post
        Then status 201

        * def location = responseHeaders['Location'][0]
        * def serviceId = location.substring(location.lastIndexOf('/')+1)
        * def merchantId = serviceId
        * def createVposTerminal = read('classpath:common/CreateVposTerminal.json')
        * def acquirerMerchantId = readJavaClass.getRandomNumber(6)
        * def acquirerTerminalId = readJavaClass.getRandomNumber(6)

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals'
        And set createVposTerminal.acquirerMerchantId = '00' + acquirerMerchantId
        And set createVposTerminal.acquirerVposTerminalId = '00' + acquirerTerminalId
        And method post
        Then status 201

        * def vposLocation = responseHeaders['Location'][0]
        * def getVposId = vposLocation.substring(vposLocation.lastIndexOf('/')+1)
        * def vposTerminalId = new java.math.BigDecimal(getVposId)

        Given url MerchantServiceURL
        When request createVposTerminalToMerchant
        And set createVposTerminalToMerchant.merchantId = merchantId
        And set createVposTerminalToMerchant.vposTerminalId = getVposId
        And path 'merchants-vpos-terminals'
        And method post
        Then status 200

        * def vposTerminalQuery = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(vposTerminalQuery)
        * def getVposUIDOnTable = executeQuery[0].VPOS_TERMINAL_ID

        And match getVposUIDOnTable == vposTerminalId

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals'
        And set createVposTerminal.acquirerMerchantId = '00' + acquirerMerchantId
        And set createVposTerminal.acquirerVposTerminalId = '00' + acquirerTerminalId
        And method post
        Then status 201

        * def vposLocation = responseHeaders['Location'][0]
        * def getVposId = vposLocation.substring(vposLocation.lastIndexOf('/')+1)
        * def vposTerminalId = new java.math.BigDecimal(getVposId)

        Given url MerchantServiceURL
        When request createVposTerminalToMerchant
        And set createVposTerminalToMerchant.merchantId = merchantId
        And set createVposTerminalToMerchant.vposTerminalId = getVposId
        And path 'merchants-vpos-terminals'
        And method post
        Then status 200

        * def vposTerminalQuery = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(vposTerminalQuery)
        * def getVposUIDOnTable = executeQuery[0].VPOS_TERMINAL_ID

        And match getVposUIDOnTable == vposTerminalId

        Given url MerchantServiceURL
        When request createVposTerminal
        And path 'vpos-terminals'
        And set createVposTerminal.acquirerMerchantId = '00' + acquirerMerchantId
        And set createVposTerminal.acquirerVposTerminalId = '00' + acquirerTerminalId
        And method post
        Then status 201

        * def vposLocation = responseHeaders['Location'][0]
        * def getVposId = vposLocation.substring(vposLocation.lastIndexOf('/')+1)
        * def vposTerminalId = new java.math.BigDecimal(getVposId)

        Given url MerchantServiceURL
        When request createVposTerminalToMerchant
        And set createVposTerminalToMerchant.merchantId = merchantId
        And set createVposTerminalToMerchant.vposTerminalId = getVposId
        And path 'merchants-vpos-terminals'
        And method post
        Then status 200

        * def vposTerminalQuery = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(vposTerminalQuery)
        * def getVposUIDOnTable = executeQuery[0].VPOS_TERMINAL_ID

        And match getVposUIDOnTable == vposTerminalId

        Given request createUser
        When url UserServiceURL
        And path 'users'
        And set createUser.merchantId = merchantId
        And header Content-Type = 'application/json'
        And method post
        Then status 201

    Scenario: acquirerMerchantId must be mandatory

        Given url MerchantServiceURL
        When request createVposTerminalToMerchant
        And remove createVposTerminalToMerchant.merchantId
        And path 'merchants-vpos-terminals'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'merchantId must not be null'

    Scenario: acquirerMerchantId must be mandatory

        Given url MerchantServiceURL
        When request createVposTerminalToMerchant
        And remove createVposTerminalToMerchant.vposTerminalId
        And path 'merchants-vpos-terminals'
        And method post
        Then status 400
        And match $response.code == '12'
        And match $response.description == 'vposTerminalId must not be null'

