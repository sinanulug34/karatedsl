@SettlementService  @Torus
Feature: Start settlement which related merchant

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def StartSettlementRequestBody = read('classpath:common/StartSettlementRequestBody.json')
        * def terminalNumber = readJavaClass.getRandomNumber(10)

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    @StartSettlement    @Smoke
    Scenario: Start Settlement transaction

        Given url SettlementServiceURL
        When request StartSettlementRequestBody
        And set StartSettlementRequestBody.terminalId = terminalNumber
        And path 'settlement/start'
        And method post
        Then status 200

        * def acquirerId = StartSettlementRequestBody.acquirerId
        * def openvposcount = StartSettlementRequestBody.openVPosCount
        * def merchantId = StartSettlementRequestBody.merchantId

        * def query = "SELECT * FROM MERCHANT_BATCHES WHERE DIMUID ='" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def acqId = executeQuery[0].ACQUID
        * def openVpos = executeQuery[0].OPENVPOSCOUNT
        * def status = executeQuery[0].STATUS

        And match acquirerId == acqId
        And match openvposcount == openVpos

        * call sleep 10

        * def query = "SELECT * FROM TERMINAL_BATCH WHERE DIMUID ='" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def status = executeQuery[0].STATUS

        And match status == 'OK'

    Scenario: When settlement transaction request comes with same terminal id, only one record must be included in terminal batch table

        Given url SettlementServiceURL
        When request StartSettlementRequestBody
        And set StartSettlementRequestBody.terminalId = terminalNumber
        And path 'settlement/start'
        And method post
        Then status 200

        * def acquirerId = StartSettlementRequestBody.acquirerId
        * def openvposcount = StartSettlementRequestBody.openVPosCount
        * def merchantId = StartSettlementRequestBody.merchantId

        * def query = "SELECT * FROM MERCHANT_BATCHES WHERE DIMUID ='" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def acqId = executeQuery[0].ACQUID
        * def openVpos = executeQuery[0].OPENVPOSCOUNT
        * def status = executeQuery[0].STATUS

        And match acquirerId == acqId
        And match openvposcount == openVpos

        * call sleep 10

        * def query = "SELECT * FROM TERMINAL_BATCH WHERE DIMUID ='" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def status = executeQuery[0].STATUS
        * def terminal = StartSettlementRequestBody.terminalId

        Given url SettlementServiceURL
        When request StartSettlementRequestBody
        And set StartSettlementRequestBody.terminalId = terminal
        And path 'settlement/start'
        And method post
        Then status 200

        * call sleep 5

        * def query = "SELECT * FROM TERMINAL_BATCH WHERE DIMUID ='" + merchantId +"' AND VPOSUID='" + terminal +"' ORDER BY CREATED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def recordCount = executeQuery.length
        And match recordCount == 1
