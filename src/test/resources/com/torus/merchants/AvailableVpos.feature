
Feature: Request a vposTerminal for a merchant.

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    @PerformanceVposTerminal    @Smoke
    Scenario: Available Terminal Performance Test

        * def query = "SELECT VPOSUID FROM VPOS_TERMINALS WHERE VPOSUID IN(SELECT VPOS_TERMINAL_ID FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID = '1053') AND ACTIVETRXCOUNT = 0 ORDER BY LAST_MODIFIED_DATE ASC"
        * def executeQuery = db.readRows(query)
        * def terminalID = executeQuery[0].VPOSUID

        Given url MerchantServiceURL
        When request ''
        And path 'merchants/1053/available-terminals'
        And method post
        Then status 200
        And print terminalID
        And print response
        And match $response.id == terminalID

    @MerchantTerminalService    @Torus
    Scenario: The process has been finished successfully.

        * def result = call read('CreateMerchantVposTerminal.feature@CreateMerchantVpos')
        * def getRequestBody = result.createVposTerminalToMerchant
        * def acquirerMerchantId = getRequestBody.merchantId
        * def acquirerTerminalId = getRequestBody.vposTerminalId
        * def vposTerminalId = new java.math.BigDecimal(acquirerTerminalId)

        Given url MerchantServiceURL
        When request ''
        And path 'merchants/' + acquirerMerchantId + '/available-terminals'
        And method post
        Then status 200
        And match $response.id == vposTerminalId
        And match $response.status == 'AVAILABLE'

