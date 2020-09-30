@PaymentProcessService  @Torus
Feature: Non secure refund transactions

    Background:

        * def DbUtils = Java.type('DbUtils')
        * def db = new DbUtils()
        * def readJavaClass = Java.type('Utility')
        * def cassandraJavaClass = Java.type('CassandraConnection')
        * def RefundTransactionRequestBody = read('classpath:common/StartTransaction.json')
        * def CompleteTransactionRequestBody = read('classpath:common/CompleteTransaction.json')
        * def OrderNumber = readJavaClass.getRandomNumber(10)

        * def sleep =
        """
        function(seconds){
        for(i=0;i<=seconds;i++){
        java.lang.Thread.sleep(1*1000);}
        }
        """

    Scenario: Successful refund of the sale transaction

        * def result = call read('SaleTransaction.feature@SuccessSale')
        * def getSaleRequestBody = result.SaleTransactionRequestBody
        * def orderId = getSaleRequestBody.orderId
        * def cardNumber = getSaleRequestBody.creditCard.cardNumber
        * def currency = getSaleRequestBody.currency
        * def merchantId = getSaleRequestBody.merchantId
        * def amount = getSaleRequestBody.amount
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.transactionId = orderId
        And remove RefundTransactionRequestBody.creditCard
        And remove RefundTransactionRequestBody.amount
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'RFND'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.transactionId = orderId
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionExecutedSuccessEvent]'
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
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'RFND'
        And match firstAmount == amount
        And match netAmount == 0
        And match orderStatus == 'RFND'
        And match orderType == 'S'

    Scenario: Successful refund of the PostAuth transaction

        * def result = call read('PostAuthTransaction.feature@SuccessPostAuth')
        * def getPostAuthRequestBody = result.PostAuthTransactionRequestBody
        * def orderId = getPostAuthRequestBody.orderId
        * def merchantId = getPostAuthRequestBody.merchantId
        * def amount = getPostAuthRequestBody.amount
        * def currency = getPostAuthRequestBody.currency
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And remove RefundTransactionRequestBody.creditCard
        And remove RefundTransactionRequestBody.amount
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[4] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionStartedEvent]'
        * match version[4] == 'Row[5]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'RFND'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.transactionId = orderId
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[5] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionExecutedSuccessEvent]'
        * match version[5] == 'Row[6]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' ORDER BY LAST_MODIFIED_DATE DESC"
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
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'RFND'
        And match firstAmount == amount
        And match netAmount == 0
        And match orderStatus == 'RFND'
        And match orderType == 'S'

    Scenario: No refund can be made for more than the postAuth amount.

        * def result = call read('PostAuthTransaction.feature@SuccessPostAuth')
        * def getPostAuthRequestBody = result.PostAuthTransactionRequestBody
        * def orderId = getPostAuthRequestBody.orderId
        * def merchantId = getPostAuthRequestBody.merchantId
        * def amount = getPostAuthRequestBody.amount
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.amount = amount + 10
        And remove RefundTransactionRequestBody.creditCard
        And method post
        Then status 400
        Then match $response.description == 'AMOUNT_IS_MORE_THAN_NET_AMOUNT'

    Scenario: No refund can be made for more than the sale amount.

        * def result = call read('SaleTransaction.feature@SuccessSale')
        * def getSaleRequestBody = result.SaleTransactionRequestBody
        * def orderId = getSaleRequestBody.orderId
        * def merchantId = getSaleRequestBody.merchantId
        * def amount = getSaleRequestBody.amount
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.amount = amount + 10
        And remove RefundTransactionRequestBody.creditCard
        And method post
        Then status 400
        Then match $response.description == 'AMOUNT_IS_MORE_THAN_NET_AMOUNT'

    Scenario: If the credit card information, amount, expiration date is sent, the refund transaction must be successful.

        * def result = call read('SaleTransaction.feature@SuccessSale')
        * def getSaleRequestBody = result.SaleTransactionRequestBody
        * def orderId = getSaleRequestBody.orderId
        * def merchantId = getSaleRequestBody.merchantId
        * def amount = getSaleRequestBody.amount
        * def currency = getSaleRequestBody.currency
        * def cardNumber = getSaleRequestBody.creditCard.cardNumber
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.amount = amount
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'RFND'
        And set CompleteTransactionRequestBody.transactionId = orderId
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionExecutedSuccessEvent]'
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
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'RFND'
        And match firstAmount == amount
        And match netAmount == 0
        And match orderStatus == 'RFND'
        And match orderType == 'S'

    Scenario: Fail refund of the sale transaction

        * def result = call read('SaleTransaction.feature@SuccessSale')
        * def getSaleRequestBody = result.SaleTransactionRequestBody
        * def orderId = getSaleRequestBody.orderId
        * def cardNumber = getSaleRequestBody.creditCard.cardNumber
        * def currency = getSaleRequestBody.currency
        * def merchantId = getSaleRequestBody.merchantId
        * def amount = getSaleRequestBody.amount
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And remove RefundTransactionRequestBody.creditCard
        And remove RefundTransactionRequestBody.amount
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'RFND'
        And set CompleteTransactionRequestBody.transactionId = orderId
        And set CompleteTransactionRequestBody.acquirerResponseCode = '99'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'FAILED'
        And set CompleteTransactionRequestBody.orderId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionExecutedFailEvent]'
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

        And match transactionStatus == 'NO'
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'RFND'
        And match firstAmount == amount
        And match netAmount == amount
        And match orderStatus == 'SALE'
        And match orderType == 'S'

    Scenario: Successful Credit

        * def merchantId = RefundTransactionRequestBody.merchantId
        * def aggregateId = merchantId + '.' + OrderNumber
        * def amount = RefundTransactionRequestBody.amount
        * def currency = RefundTransactionRequestBody.currency

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = OrderNumber
        And set RefundTransactionRequestBody.transactionType = 'CRED'
        And set RefundTransactionRequestBody.transactionId = OrderNumber
        And method post
        Then status 200

        * call sleep 10

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[0] contains 'Row[com.torus.paymentprocessingservice.dto.event.CreditTransactionStartedEvent]'
        * match version[0] == 'Row[1]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'CRED'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And set CompleteTransactionRequestBody.orderId = OrderNumber
        And method post
        Then status 200

        * call sleep 10

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[1] contains 'Row[com.torus.paymentprocessingservice.dto.event.CreditTransactionExecutedSuccessEvent]'
        * match version[1] == 'Row[2]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + OrderNumber +"' ORDER BY LAST_MODIFIED_DATE DESC"
        * def executeQuery = db.readRows(query)
        * def transactionStatus = executeQuery[0].TRANSTATUS
        * def transactionAmount = executeQuery[0].AMOUNT
        * def transactionCurrency = executeQuery[0].CURRENCY
        * def transactionType = executeQuery[0].TRANTYPE

        * def orderTableQuery = "SELECT * FROM ORDERS WHERE ORDERID = '" + OrderNumber +"' ORDER BY CREATED_DATE DESC"
        * def execOrderTableQuery = db.readRows(orderTableQuery)
        * def firstAmount = execOrderTableQuery[0].FIRSTAMOUNT
        * def netAmount = execOrderTableQuery[0].NETAMOUNT
        * def orderStatus = execOrderTableQuery[0].ORDERFINALSTATUS
        * def orderType = execOrderTableQuery[0].ORDER_TYPE

        And match transactionStatus == 'OK'
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'CRED'
        And match firstAmount == amount
        And match netAmount == - amount
        And match orderStatus == 'CRED'
        And match orderType == 'S'

    Scenario: If the refund is already given for the Sale, the second credit should be rejected.

        * def result = call read('SaleTransaction.feature@SuccessSale')
        * def getSaleRequestBody = result.SaleTransactionRequestBody
        * def orderId = getSaleRequestBody.orderId
        * def cardNumber = getSaleRequestBody.creditCard.cardNumber
        * def currency = getSaleRequestBody.currency
        * def merchantId = getSaleRequestBody.merchantId
        * def amount = getSaleRequestBody.amount
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.transactionId = orderId
        And remove RefundTransactionRequestBody.creditCard
        And remove RefundTransactionRequestBody.amount
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'RFND'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.transactionId = orderId
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionExecutedSuccessEvent]'
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
        And match transactionAmount == amount
        And match transactionCurrency == currency
        And match transactionType == 'RFND'
        And match firstAmount == amount
        And match netAmount == 0
        And match orderStatus == 'RFND'
        And match orderType == 'S'

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.transactionId = orderId
        And remove RefundTransactionRequestBody.creditCard
        And remove RefundTransactionRequestBody.amount
        And method post
        Then status 400

    Scenario: No refund to preAuth transaction.

        * def result = call read('PreAuthTransaction.feature@SuccessPreAuth')
        * def getPreAuthRequestBody = result.PreAuthTransactionRequestBody
        * def orderId = getPreAuthRequestBody.orderId
        * def cardNumber = getPreAuthRequestBody.creditCard.cardNumber
        * def currency = getPreAuthRequestBody.currency
        * def merchantId = getPreAuthRequestBody.merchantId
        * def amount = getPreAuthRequestBody.amount
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.transactionId = orderId
        And remove RefundTransactionRequestBody.creditCard
        And remove RefundTransactionRequestBody.amount
        And method post
        Then status 400
        Then match $response.description == 'NET_AMOUNT_IS_ZERO'

    Scenario: Partial refund of the sale transaction

        * def result = call read('SaleTransaction.feature@SuccessSale')
        * def getSaleRequestBody = result.SaleTransactionRequestBody
        * def orderId = getSaleRequestBody.orderId
        * def cardNumber = getSaleRequestBody.creditCard.cardNumber
        * def currency = getSaleRequestBody.currency
        * def merchantId = getSaleRequestBody.merchantId
        * def amount = getSaleRequestBody.amount
        * def aggregateId = merchantId + '.' + orderId

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.transactionId = OrderNumber
        And set RefundTransactionRequestBody.amount = amount / 2
        And remove RefundTransactionRequestBody.creditCard
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[2] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionStartedEvent]'
        * match version[2] == 'Row[3]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'RFND'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[3] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionExecutedSuccessEvent]'
        * match version[3] == 'Row[4]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' AND PAN='" + cardNumber +"' ORDER BY CREATED_DATE DESC"
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
        And match transactionType == 'RFND'
        And match firstAmount == amount
        And match netAmount == amount / 2
        And match orderStatus == 'RFND'
        And match orderType == 'S'

        Given url PaymentProcessingServiceURL
        When request  RefundTransactionRequestBody
        And path 'transactions/start'
        And set RefundTransactionRequestBody.orderId = orderId
        And set RefundTransactionRequestBody.transactionType = 'RFND'
        And set RefundTransactionRequestBody.transactionId = OrderNumber
        And set RefundTransactionRequestBody.amount = amount / 2
        And remove RefundTransactionRequestBody.creditCard
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[4] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionStartedEvent]'
        * match version[4] == 'Row[5]'

        Given url PaymentProcessingServiceURL
        When request  CompleteTransactionRequestBody
        And path 'transactions/complete'
        And set CompleteTransactionRequestBody.transactionType = 'RFND'
        And set CompleteTransactionRequestBody.acquirerResponseCode = '00'
        And set CompleteTransactionRequestBody.transactionId = OrderNumber
        And set CompleteTransactionRequestBody.acquirerResponseDetail = 'SUCCESS'
        And set CompleteTransactionRequestBody.orderId = orderId
        And method post
        Then status 200

        * def payloadType = cassandraJavaClass.queryParam("SELECT PAYLOADTYPE FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * def version = cassandraJavaClass.queryParam("SELECT VERSION FROM TRANSACTION WHERE AGGREGATEID ='" + aggregateId +"'")
        * match payloadType[5] contains 'Row[com.torus.paymentprocessingservice.dto.event.RefundTransactionExecutedSuccessEvent]'
        * match version[5] == 'Row[6]'

        * call sleep 20

        * def query = "SELECT * FROM TRANSACTIONS WHERE ORDERID ='" + orderId +"' AND PAN='" + cardNumber +"' ORDER BY CREATED_DATE DESC"
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
        And match transactionType == 'RFND'
        And match firstAmount == amount
        And match netAmount == 0
        And match orderStatus == 'RFND'
        And match orderType == 'S'
