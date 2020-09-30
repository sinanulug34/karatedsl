@PaymentProcessService  @Torus
Feature: Non secure sale transactions

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def cassandraJavaClass = Java.type('CassandraConnection')
        * def SaleTransactionRequestBody = read('classpath:common/StartTransaction.json')
        * def CompleteTransactionRequestBody = read('classpath:common/CompleteTransaction.json')
        * def OrderNumber = readJavaClass.getRandomNumber(10)

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    @SuccessSale    @Smoke
    Scenario: Success Sale Transactions

        Given url PaymentProcessingServiceURL
        When request  SaleTransactionRequestBody
        And path 'transactions/start'
        And set SaleTransactionRequestBody.orderId = OrderNumber
        And set SaleTransactionRequestBody.transactionType = 'SALE'
        And set SaleTransactionRequestBody.amount = 100
        And set SaleTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def orderNumber = SaleTransactionRequestBody.orderId
        * def merchantId = SaleTransactionRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderNumber
        * def cardNumber = SaleTransactionRequestBody.creditCard.cardNumber
        * def amount = SaleTransactionRequestBody.amount
        * def currency = SaleTransactionRequestBody.currency

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[0] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionStartedEvent]'
        * match version[0] == 'Row[1]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'SALE'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderNumber
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[1] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionExecutedSuccessEvent]'
        * match version[1] == 'Row[2]'

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
        And match transactionType == 'SALE'
        And match firstAmount == amount
        And match netAmount == amount
        And match orderStatus == 'SALE'
        And match orderType == 'S'

    Scenario: When the transaction comes with the same orderId, it should be version 2 in cassandra (If the sale process isn't complete)

        Given url PaymentProcessingServiceURL
        When request  SaleTransactionRequestBody
        And path 'transactions/start'
        And set SaleTransactionRequestBody.orderId = OrderNumber
        And set SaleTransactionRequestBody.transactionType = 'SALE'
        And method post
        Then status 200

        * def orderNumber = SaleTransactionRequestBody.orderId
        * def merchantId = SaleTransactionRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderNumber
        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[0] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionStartedEvent]'
        * match version[0] == 'Row[1]'

        Given url PaymentProcessingServiceURL
        When request  SaleTransactionRequestBody
        And path 'transactions/start'
        And set SaleTransactionRequestBody.orderId = orderNumber
        And set SaleTransactionRequestBody.transactionType = 'SALE'
        And method post
        Then status 200

        * def orderNumber = SaleTransactionRequestBody.orderId
        * def merchantId = SaleTransactionRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderNumber
        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[0] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionStartedEvent]'
        * match version[1] == 'Row[2]'

    Scenario: When the transaction comes with the same orderId, The response must be ORDER_ALREADY_EXIST error message (If the sale process is completed)

        Given url PaymentProcessingServiceURL
        When request  SaleTransactionRequestBody
        And path 'transactions/start'
        And set SaleTransactionRequestBody.orderId = OrderNumber
        And set SaleTransactionRequestBody.transactionType = 'SALE'
        And set SaleTransactionRequestBody.amount = 100
        And method post
        Then status 200

        * def orderNumber = SaleTransactionRequestBody.orderId
        * def merchantId = SaleTransactionRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderNumber
        * def cardNumber = SaleTransactionRequestBody.creditCard.cardNumber
        * def amount = SaleTransactionRequestBody.amount
        * def currency = SaleTransactionRequestBody.currency

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[0] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionStartedEvent]'
        * match version[0] == 'Row[1]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'SALE'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderNumber
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[1] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionExecutedSuccessEvent]'
        * match version[1] == 'Row[2]'

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
        And match transactionType == 'SALE'
        And match firstAmount == amount
        And match netAmount == amount
        And match orderStatus == 'SALE'
        And match orderType == 'S'

        Given url PaymentProcessingServiceURL
        When request  SaleTransactionRequestBody
        And path 'transactions/start'
        And set SaleTransactionRequestBody.orderId = orderNumber
        And set SaleTransactionRequestBody.transactionType = 'PRE'
        And set SaleTransactionRequestBody.amount = 100
        And method post
        Then status 400
        Then match $response.description == 'ORDER_ALREADY_EXISTS'

    Scenario: Fail Sale Transactions

        Given url PaymentProcessingServiceURL
        When request  SaleTransactionRequestBody
        And path 'transactions/start'
        And set SaleTransactionRequestBody.orderId = OrderNumber
        And set SaleTransactionRequestBody.transactionType = 'SALE'
        And set SaleTransactionRequestBody.amount = 100
        And set SaleTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def orderNumber = SaleTransactionRequestBody.orderId
        * def merchantId = SaleTransactionRequestBody.merchantId
        * def aggregateId = merchantId + '.' + orderNumber
        * def cardNumber = SaleTransactionRequestBody.creditCard.cardNumber
        * def amount = SaleTransactionRequestBody.amount
        * def currency = SaleTransactionRequestBody.currency

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[0] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionStartedEvent]'
        * match version[0] == 'Row[1]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'SALE'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '99'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'FAILED'
        And set CompleteTransactionRequestBody.orderId = orderNumber
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[1] contains 'Row[com.torus.paymentprocessingservice.dto.event.SaleTransactionExecutedFailEvent]'
        * match version[1] == 'Row[2]'

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
        And match transactionType == 'SALE'
        And match firstAmount == amount
        And match netAmount == 0
        And match orderStatus == 'FAIL'
        And match orderType == 'S'
