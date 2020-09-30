@XMLApiService  @Torus @apigateway
Feature: Settlement EOD

    Background:

        * def xmlApiConverter = read('classpath:common/CC5RequestBody.xml')
        * def settlementXml = read('classpath:common/SettlementXml.xml')
        * def readJavaClass = Java.type('Utility')
        * def OrderId = readJavaClass.getRandomNumber(10)
        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    @SuccessSettlement
    Scenario: Sale Transaction Settlement

        * def saleTransaction = call read('SaleTransactions.feature@SuccessXmlAuth')
        * def merchantId = saleTransaction.xmlApiConverter.CC5Request.ClientId
        * def amount = new java.math.BigDecimal(saleTransaction.xmlApiConverter.CC5Request.Total)

        * def merchants_vpos = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
        * def executeQuery = db.readRows(merchants_vpos)
        * def vpos_terminal_id = executeQuery[0].VPOS_TERMINAL_ID

        * def total_batch = "SELECT * FROM TOTAL_BATCHES WHERE VPOSUID ='" + vpos_terminal_id +"' ORDER BY CREATED_DATE DESC"
        * def executeTotalBatch = db.readRows(total_batch)
        * def refundCount = executeTotalBatch[0].REFUND_COUNT
        * def refundTotal = executeTotalBatch[0].REFUND_TOTAL
        * def saleCount = executeTotalBatch[0].SALE_COUNT
        * def saleTotal = executeTotalBatch[0].SALE_TOTAL

        And match refundCount == 0
        And match refundTotal == 0
        And match saleCount == 1
        And match saleTotal == amount

        Given request settlementXml
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set settlementXml//ClientId = merchantId
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //ErrMsg == 'Settlement Started'

        * call sleep 10

        * def terminal_batch = "SELECT * FROM TERMINAL_BATCH WHERE VPOSUID ='" + vpos_terminal_id +"'"
        * def executeTerminalBatch = db.readRows(terminal_batch)
        * def terminalBatchStatus = executeTerminalBatch[0].STATUS

        And match terminalBatchStatus == 'NO'

        * def merchant_batch = "SELECT * FROM MERCHANT_BATCHES WHERE DIMUID ='" + merchantId +"'"
        * def executeMerchantBatch = db.readRows(merchant_batch)
        * def merchantBatchStatus0 = executeMerchantBatch[0].STATUS
        * def merchantBatchStatus1 = executeMerchantBatch[1].STATUS
        * def dimBatchId0 = executeMerchantBatch[0].DIMBATCHID
        * def dimBatchId1 = executeMerchantBatch[1].DIMBATCHID

        And match merchantBatchStatus0 == 'NO'
        And match merchantBatchStatus1 == 'OK'
        And match dimBatchId0 == 0
        And match dimBatchId1 == 1

    @PostAuthSettlement
    Scenario: PostAuth Transaction Settlement

        * def postAuthTransaction = call read('PostAuthTransactions.feature@SuccessXmlPostAuth')
        * def merchantId = postAuthTransaction.xmlApiConverter.CC5Request.ClientId
        * def preAuthAmount = postAuthTransaction.result.PreAuth.CC5Request.Total
        * def amount = new java.math.BigDecimal(preAuthAmount)
        * def merchants_vpos = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
        * def executeQuery = db.readRows(merchants_vpos)
        * def vpos_terminal_id = executeQuery[0].VPOS_TERMINAL_ID

        * def total_batch = "SELECT * FROM TOTAL_BATCHES WHERE VPOSUID ='" + vpos_terminal_id +"' ORDER BY CREATED_DATE DESC"
        * def executeTotalBatch = db.readRows(total_batch)
        * def refundCount = executeTotalBatch[0].REFUND_COUNT
        * def refundTotal = executeTotalBatch[0].REFUND_TOTAL
        * def saleCount = executeTotalBatch[0].SALE_COUNT
        * def saleTotal = executeTotalBatch[0].SALE_TOTAL

        And match refundCount == 0
        And match refundTotal == 0
        And match saleCount == 1
        And match saleTotal == amount

        Given request settlementXml
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set settlementXml//ClientId = merchantId
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //ErrMsg == 'Settlement Started'

        * call sleep 10

        * def terminal_batch = "SELECT * FROM TERMINAL_BATCH WHERE VPOSUID ='" + vpos_terminal_id +"'"
        * def executeTerminalBatch = db.readRows(terminal_batch)
        * def terminalBatchStatus = executeTerminalBatch[0].STATUS

        And match terminalBatchStatus == 'NO'

        * def merchant_batch = "SELECT * FROM MERCHANT_BATCHES WHERE DIMUID ='" + merchantId +"'"
        * def executeMerchantBatch = db.readRows(merchant_batch)
        * def merchantBatchStatus0 = executeMerchantBatch[0].STATUS
        * def merchantBatchStatus1 = executeMerchantBatch[1].STATUS
        * def dimBatchId0 = executeMerchantBatch[0].DIMBATCHID
        * def dimBatchId1 = executeMerchantBatch[1].DIMBATCHID

        And match merchantBatchStatus0 == 'NO'
        And match merchantBatchStatus1 == 'OK'
        And match dimBatchId0 == 0
        And match dimBatchId1 == 1

    @PreAuthSettlement
    Scenario: PreAuth Transaction Settlement

        * def preAuthTransaction = call read('PreAuthTransactions.feature@SuccessXmlPreAuth')
        * def merchantId = preAuthTransaction.result.PreAuth.CC5Request.ClientId
        * def preAuthAmount = preAuthTransaction.result.PreAuth.CC5Request.Total
        * def amount = new java.math.BigDecimal(preAuthAmount)

        * def merchants_vpos = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
        * def executeQuery = db.readRows(merchants_vpos)
        * def vpos_terminal_id = executeQuery[0].VPOS_TERMINAL_ID

        * def total_batch = "SELECT * FROM TOTAL_BATCHES WHERE VPOSUID ='" + vpos_terminal_id +"' ORDER BY CREATED_DATE DESC"
        * def executeTotalBatch = db.readRows(total_batch)
        * def refundCount = executeTotalBatch[0].REFUND_COUNT
        * def refundTotal = executeTotalBatch[0].REFUND_TOTAL
        * def saleCount = executeTotalBatch[0].SALE_COUNT
        * def saleTotal = executeTotalBatch[0].SALE_TOTAL

        And match refundCount == 0
        And match refundTotal == 0
        And match saleCount == 0
        And match saleTotal == 0

        Given request settlementXml
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set settlementXml//ClientId = merchantId
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //ErrMsg == 'Settlement Started'

        * call sleep 10

        * def terminal_batch = "SELECT * FROM TERMINAL_BATCH WHERE VPOSUID ='" + vpos_terminal_id +"'"
        * def executeTerminalBatch = db.readRows(terminal_batch)
        * def terminalBatchStatus = executeTerminalBatch[0].STATUS

        And match terminalBatchStatus == 'NO'

        * def merchant_batch = "SELECT * FROM MERCHANT_BATCHES WHERE DIMUID ='" + merchantId +"'"
        * def executeMerchantBatch = db.readRows(merchant_batch)
        * def merchantBatchStatus0 = executeMerchantBatch[0].STATUS
        * def merchantBatchStatus1 = executeMerchantBatch[1].STATUS
        * def dimBatchId0 = executeMerchantBatch[0].DIMBATCHID
        * def dimBatchId1 = executeMerchantBatch[1].DIMBATCHID

        And match merchantBatchStatus0 == 'NO'
        And match merchantBatchStatus1 == 'OK'
        And match dimBatchId0 == 0
        And match dimBatchId1 == 1

    @RefundSettlement
    Scenario: Refund Transaction Settlement

        * def refundTransaction = call read('RefundTransactions.feature@SuccessRefundTransaction')
        * def merchantId = refundTransaction.xmlApiConverter.CC5Request.ClientId
        * def saleAmount = refundTransaction.result.xmlApiConverter.CC5Request.Total
        * def amount = new java.math.BigDecimal(saleAmount)
        * def merchants_vpos = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
        * def executeQuery = db.readRows(merchants_vpos)
        * def vpos_terminal_id = executeQuery[0].VPOS_TERMINAL_ID

        * def total_batch = "SELECT * FROM TOTAL_BATCHES WHERE VPOSUID ='" + vpos_terminal_id +"' ORDER BY CREATED_DATE DESC"
        * def executeTotalBatch = db.readRows(total_batch)
        * def refundCount = executeTotalBatch[0].REFUND_COUNT
        * def refundTotal = executeTotalBatch[0].REFUND_TOTAL
        * def saleCount = executeTotalBatch[0].SALE_COUNT
        * def saleTotal = executeTotalBatch[0].SALE_TOTAL

        And match refundCount == 1
        And match refundTotal == amount
        And match saleCount == 1
        And match saleTotal == amount

        Given request settlementXml
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set settlementXml//ClientId = merchantId
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //ErrMsg == 'Settlement Started'

        * call sleep 10

        * def terminal_batch = "SELECT * FROM TERMINAL_BATCH WHERE VPOSUID ='" + vpos_terminal_id +"'"
        * def executeTerminalBatch = db.readRows(terminal_batch)
        * def terminalBatchStatus = executeTerminalBatch[0].STATUS

        And match terminalBatchStatus == 'NO'

        * def merchant_batch = "SELECT * FROM MERCHANT_BATCHES WHERE DIMUID ='" + merchantId +"'"
        * def executeMerchantBatch = db.readRows(merchant_batch)
        * def merchantBatchStatus0 = executeMerchantBatch[0].STATUS
        * def merchantBatchStatus1 = executeMerchantBatch[1].STATUS
        * def dimBatchId0 = executeMerchantBatch[0].DIMBATCHID
        * def dimBatchId1 = executeMerchantBatch[1].DIMBATCHID

        And match merchantBatchStatus0 == 'NO'
        And match merchantBatchStatus1 == 'OK'
        And match dimBatchId0 == 0
        And match dimBatchId1 == 1

    @VoidSettlement
    Scenario: Void Transaction Settlement

        * def refundTransaction = call read('VoidTransactions.feature@SuccessVoidTransaction')
        * def merchantId = refundTransaction.xmlApiConverter.CC5Request.ClientId
        * def saleAmount = refundTransaction.result.xmlApiConverter.CC5Request.Total
        * def amount = new java.math.BigDecimal(saleAmount)
        * def merchants_vpos = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
        * def executeQuery = db.readRows(merchants_vpos)
        * def vpos_terminal_id = executeQuery[0].VPOS_TERMINAL_ID

        * def total_batch = "SELECT * FROM TOTAL_BATCHES WHERE VPOSUID ='" + vpos_terminal_id +"' ORDER BY CREATED_DATE DESC"
        * def executeTotalBatch = db.readRows(total_batch)
        * def refundCount = executeTotalBatch[0].REFUND_COUNT
        * def refundTotal = executeTotalBatch[0].REFUND_TOTAL
        * def saleCount = executeTotalBatch[0].SALE_COUNT
        * def saleTotal = executeTotalBatch[0].SALE_TOTAL

        And match refundCount == 0
        And match refundTotal == 0
        And match saleCount == 0
        And match saleTotal == 0

        Given request settlementXml
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set settlementXml//ClientId = merchantId
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //ErrMsg == 'Settlement Started'

        * call sleep 10

        * def terminal_batch = "SELECT * FROM TERMINAL_BATCH WHERE VPOSUID ='" + vpos_terminal_id +"'"
        * def executeTerminalBatch = db.readRows(terminal_batch)
        * def terminalBatchStatus = executeTerminalBatch[0].STATUS

        And match terminalBatchStatus == 'NO'

        * def merchant_batch = "SELECT * FROM MERCHANT_BATCHES WHERE DIMUID ='" + merchantId +"'"
        * def executeMerchantBatch = db.readRows(merchant_batch)
        * def merchantBatchStatus0 = executeMerchantBatch[0].STATUS
        * def merchantBatchStatus1 = executeMerchantBatch[1].STATUS
        * def dimBatchId0 = executeMerchantBatch[0].DIMBATCHID
        * def dimBatchId1 = executeMerchantBatch[1].DIMBATCHID

        And match merchantBatchStatus0 == 'NO'
        And match merchantBatchStatus1 == 'OK'
        And match dimBatchId0 == 0
        And match dimBatchId1 == 1

    Scenario: When more than one sales request is made, the transactions passing through all terminals of Merchant should be calculated separately.

        * def result = call read('../merchants/CreateMerchantVposTerminal.feature@CreateTestMerchantMultipleTerminal')
        * def merchantId = result.merchantId
        * def OrderId2 = readJavaClass.getRandomNumber(10)
        * def OrderId3 = readJavaClass.getRandomNumber(10)

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '5454545454545454'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '5454545454545454'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId2
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'

        Given request xmlApiConverter
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set xmlApiConverter//Number = '5454545454545454'
        And set xmlApiConverter//Type = 'Auth'
        And set xmlApiConverter//OrderId = OrderId3
        And set xmlApiConverter//ClientId = merchantId
        And set xmlApiConverter//Expires = '12.2025'
        And set xmlApiConverter//Cvv2Val = '000'
        And set xmlApiConverter//Total = '10'
        And set xmlApiConverter//Currency = '949'
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //Response == 'APPROVED'

        * def amount = xmlApiConverter.CC5Request.Total

        * def merchants_vpos = "SELECT * FROM MERCHANTS_VPOS_TERMINALS WHERE MERCHANT_ID ='" + merchantId +"'"
        * def executeQuery = db.readRows(merchants_vpos)
        * def total_batch = "SELECT * FROM TOTAL_BATCHES WHERE DIMUID = '" + merchantId +"' ORDER BY CREATED_DATE DESC"
        * def executeTotalBatch = db.readRows(total_batch)

        And match each executeTotalBatch[*].REFUND_COUNT == 0
        And match each executeTotalBatch[*].REFUND_TOTAL == 0
        And match each executeTotalBatch[*].SALE_COUNT == 1
        And match each executeTotalBatch[*].STAN == 1
        And match each executeTotalBatch[*].ACTIVETRXCOUNT == 0
        And match each executeTotalBatch[*].SALE_TOTAL ==  new java.math.BigDecimal(amount)

        Given request settlementXml
        When url ApiGateWayServiceURL
        And path 'fim/api'
        And set settlementXml//ClientId = merchantId
        And method post
        Then status 200
        Then match //ProcReturnCode  == '00'
        Then match //ErrMsg == 'Settlement Started'

        * def terminal_batches = "SELECT * FROM TERMINAL_BATCH WHERE DIMUID ='" + merchantId +"'"
        * def executeTerminalQuery = db.readRows(terminal_batches)

        And match each executeTotalBatch[*].STATUS == 'NO'
        And match each executeTotalBatch[*].VPOSBATCHID == 1
        And match each executeTotalBatch[*].ERRORDETAIL == null


