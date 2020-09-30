@PaymentProcessService  @Torus
Feature: Non secure postAuth transactions

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def cassandraJavaClass = Java.type('CassandraConnection')
        * def PostAuthTransactionRequestBody = read('classpath:common/StartTransaction.json')
        * def CompleteTransactionRequestBody = read('classpath:common/CompleteTransaction.json')
        * def OrderNumber = readJavaClass.getRandomNumber(10)

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    @SuccessPostAuth
    Scenario: Success PostAuth Transactions

        * def result = call read('PreAuthTransaction.feature@SuccessPreAuth')
        * def getPreAuthRequestBody = result.PreAuthTransactionRequestBody
        * def orderId = getPreAuthRequestBody.orderId
        * def orderNumber = getPreAuthRequestBody.orderId
        * def merchantId = getPreAuthRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderNumber
        * def cardNumber = getPreAuthRequestBody.creditCard.cardNumber
        * def amount = getPreAuthRequestBody.amount
        * def currency = getPreAuthRequestBody.currency

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = orderId
        And set PostAuthTransactionRequestBody.transactionId = orderId
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And remove PostAuthTransactionRequestBody.creditCard
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'POST'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And set CompleteTransactionRequestBody.transactionId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionExecutedSuccessEvent]'
        * match version[3] == 'Row[4]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderNumber +"' AND PAN='" + cardNumber +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def transactionStatus = executeQuery[0].TRANSTATUS
        * def transactionAmount = executeQuery[0].AMOUNT
        * def transactionCurrency = executeQuery[0].CURRENCY
        * def transactionType = executeQuery[0].TRANTYPE

        * def orderTableQuery = "SELECT * FROM ORDERS WHERE ORDERID = '" + orderNumber +"' ORDER BY CREATED_DATE DESC"
        * def execOrderTableQuery = db.readRows(orderTableQuery)
        * def firstAmount = execOrderTableQuery[0].FIRSTAMOUNT
        * def netAmount = execOrderTableQuery[0].NETAMOUNT
        * def orderStatus = execOrderTableQuery[0].ORDERFINALSTATUS
        * def orderType = execOrderTableQuery[0].ORDER_TYPE

        And match transactionStatus == 'OK'
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'POST'
        And match firstAmount == amount
        And match netAmount == amount
        And match orderStatus == 'POST'
        And match orderType == 'S'

    Scenario: No postAuth can be made for more than the preAuth amount.

        * def result = call read('PreAuthTransaction.feature@SuccessPreAuth')
        * def getPreAuthRequestBody = result.PreAuthTransactionRequestBody
        * def orderId = getPreAuthRequestBody.orderId
        * def merchantId = getPreAuthRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderId
        * def amount = getPreAuthRequestBody.amount

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = orderId
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And set PostAuthTransactionRequestBody.amount = amount + 10
        And remove PostAuthTransactionRequestBody.creditCard
        And method post
        Then status 400
        Then match $response.description == 'AMOUNT_IS_MORE_THAN_REMAINING_AMOUNT'

    Scenario: No postAuth can be made without the preAuth.

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = OrderNumber
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And set PostAuthTransactionRequestBody.amount = 100
        And remove PostAuthTransactionRequestBody.creditCard
        And method post
        Then status 404
        Then match $response.description == 'ORDER_NOT_FOUND'

    Scenario: Partial PostAuth.

        * def result = call read('PreAuthTransaction.feature@SuccessPreAuth')
        * def getPreAuthRequestBody = result.PreAuthTransactionRequestBody
        * def orderId = getPreAuthRequestBody.orderId
        * def merchantId = getPreAuthRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderId
        * def amount = getPreAuthRequestBody.amount
        * def cardNumber = getPreAuthRequestBody.creditCard.cardNumber
        * def currency = getPreAuthRequestBody.currency

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = orderId
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And set PostAuthTransactionRequestBody.amount = amount / 2
        And remove PostAuthTransactionRequestBody.creditCard
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'POST'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionExecutedSuccessEvent]'
        * match version[3] == 'Row[4]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' AND PAN='" + cardNumber +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def transactionStatus = executeQuery[0].TRANSTATUS
        * def transactionAmount = executeQuery[0].AMOUNT
        * def transactionCurrency = executeQuery[0].CURRENCY
        * def transactionType = executeQuery[0].TRANTYPE

        * def orderTableQuery = "SELECT * FROM ORDERS WHERE ORDERID = '" + orderId +"' ORDER BY CREATED_DATE DESC"
        * def execOrderTableQuery = db.readRows(orderTableQuery)
        * def firstAmount = execOrderTableQuery[0].FIRSTAMOUNT
        * def netAmount = execOrderTableQuery[0].NETAMOUNT
        * def orderStatus = execOrderTableQuery[0].ORDERFINALSTATUS
        * def orderType = execOrderTableQuery[0].ORDER_TYPE

        And match transactionStatus == 'OK'
        And match transactionAmount == amount / 2
        And match transactionCurrency == currency
        And match transactionType == 'POST'
        And match firstAmount == amount
        And match netAmount == amount / 2
        And match orderStatus == 'POST'
        And match orderType == 'S'

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = orderId
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And set PostAuthTransactionRequestBody.amount = amount / 2
        And remove PostAuthTransactionRequestBody.creditCard
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[4] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionStartedEvent]'
        * match version[4] == 'Row[5]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'POST'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[5] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionExecutedSuccessEvent]'
        * match version[5] == 'Row[6]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' AND PAN='" + cardNumber +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def transactionStatus = executeQuery[0].TRANSTATUS
        * def transactionAmount = executeQuery[0].AMOUNT
        * def transactionCurrency = executeQuery[0].CURRENCY
        * def transactionType = executeQuery[0].TRANTYPE

        * def orderTableQuery = "SELECT * FROM ORDERS WHERE ORDERID = '" + orderId +"' ORDER BY CREATED_DATE DESC"
        * def execOrderTableQuery = db.readRows(orderTableQuery)
        * def firstAmount = execOrderTableQuery[0].FIRSTAMOUNT
        * def netAmount = execOrderTableQuery[0].NETAMOUNT
        * def orderStatus = execOrderTableQuery[0].ORDERFINALSTATUS
        * def orderType = execOrderTableQuery[0].ORDER_TYPE

        And match transactionStatus == 'OK'
        And match transactionAmount == amount / 2
        And match transactionCurrency == currency
        And match transactionType == 'POST'
        And match firstAmount == amount
        And match netAmount == amount
        And match orderStatus == 'POST'
        And match orderType == 'S'

    Scenario: When the transaction comes with the same orderId, The response must be REMAINING_AMOUNT_IS_ZERO error message (If the postAuth process is completed)

        * def result = call read('PreAuthTransaction.feature@SuccessPreAuth')
        * def getPreAuthRequestBody = result.PreAuthTransactionRequestBody
        * def orderId = getPreAuthRequestBody.orderId
        * def merchantId = getPreAuthRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderId
        * def amount = getPreAuthRequestBody.amount

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = orderId
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And set PostAuthTransactionRequestBody.amount = amount
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'POST'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionExecutedSuccessEvent]'
        * match version[3] == 'Row[4]'

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = orderId
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And set PostAuthTransactionRequestBody.amount = amount
        And method post
        Then status 400
        Then match $response.description == 'REMAINING_AMOUNT_IS_ZERO'

    Scenario: Fail PostAuth Transactions

        * def result = call read('PreAuthTransaction.feature@SuccessPreAuth')
        * def getPreAuthRequestBody = result.PreAuthTransactionRequestBody
        * def orderId = getPreAuthRequestBody.orderId
        * def orderNumber = getPreAuthRequestBody.orderId
        * def merchantId = getPreAuthRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderNumber
        * def cardNumber = getPreAuthRequestBody.creditCard.cardNumber
        * def amount = getPreAuthRequestBody.amount
        * def currency = getPreAuthRequestBody.currency

        Given url PaymentProcessingServiceURL
        When request  PostAuthTransactionRequestBody
        And path 'transactions/start'
        And set PostAuthTransactionRequestBody.orderId = orderId
        And set PostAuthTransactionRequestBody.transactionType = 'POST'
        And remove PostAuthTransactionRequestBody.creditCard
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'POST'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '99'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'FAILED'
        And set CompleteTransactionRequestBody.orderId = orderId
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.PostAuthTransactionExecutedFailEvent]'
        * match version[3] == 'Row[4]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderNumber +"' AND PAN='" + cardNumber +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def transactionStatus = executeQuery[0].TRANSTATUS
        * def transactionAmount = executeQuery[0].AMOUNT
        * def transactionCurrency = executeQuery[0].CURRENCY
        * def transactionType = executeQuery[0].TRANTYPE

        * def orderTableQuery = "SELECT * FROM ORDERS WHERE ORDERID = '" + orderNumber +"' ORDER BY CREATED_DATE DESC"
        * def execOrderTableQuery = db.readRows(orderTableQuery)
        * def firstAmount = execOrderTableQuery[0].FIRSTAMOUNT
        * def netAmount = execOrderTableQuery[0].NETAMOUNT
        * def orderStatus = execOrderTableQuery[0].ORDERFINALSTATUS
        * def orderType = execOrderTableQuery[0].ORDER_TYPE

        And match transactionStatus == 'NO'
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'POST'
        And match firstAmount == amount
        And match netAmount == 0
        And match orderStatus == 'PRE'
        And match orderType == 'S'
